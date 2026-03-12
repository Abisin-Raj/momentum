import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/workout_providers.dart';
import '../../../core/providers/database_providers.dart'; // Import for exercises
import '../../../core/database/app_database.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/services/settings_service.dart';

/// Active workout screen
/// Supports two views:
/// 1. Checklist View (Manual logging)
/// 2. Timer View (Clock focus)
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final ActiveSession session;

  const ActiveWorkoutScreen({super.key, required this.session});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration _remaining = Duration.zero;
  final ValueNotifier<int> _timerTick = ValueNotifier<int>(0);

  late final Ticker _tick;

  // Rest Timer State
  DateTime? _restStartTime;
  int? _restingExerciseId;
  int _restRemaining = 0;
  int _totalRestSeconds = 60;

  // Cooldown Timer State
  DateTime? _cooldownStartTime;
  int? _cooldownExerciseId;
  int _cooldownRemaining = 0;

  bool _isRunning = true;
  bool _timerCompleted = false;

  late PageController _pageController;
  int _currentPage = 0;

  // Checklist state
  // Key: Exercise ID, Value: Completed sets count
  final Map<int, int> _completedSets = {};

  // Key: Exercise ID, Value: Note/Actual reps (transient)
  final Map<int, String> _exerciseNotes = {};

  // Stopwatch State
  // _activeSetExerciseId is now "inferred" or "auto-detected"
  int? _currentWorkExerciseId;
  Timer? _workTimer;
  Duration _currentWorkElapsed = Duration.zero;
  final Map<int, int> _accumulatedDurations =
      {}; // Exercise ID -> Total Seconds

  // Cached list to determine active exercise efficiently
  List<Exercise> _cachedExercises = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _tick = createTicker(_onTick);

    _initializeClock();
    _startWorkTimer();
  }

  void _onTick(Duration elapsed) {
    var didChange = false;

    if (_restingExerciseId != null && _restStartTime != null) {
      final diff = DateTime.now().difference(_restStartTime!);
      final totalMs = _totalRestSeconds * 1000;
      final remainingMs = totalMs - diff.inMilliseconds;

      if (remainingMs <= 0) {
        if (_restRemaining != 0 || _restingExerciseId != null) {
          _restRemaining = 0;
          _restingExerciseId = null;
          didChange = true;
        }
        HapticFeedback.mediumImpact();
      } else {
        final nextRemaining = (remainingMs / 1000).ceil();
        if (_restRemaining != nextRemaining) {
          _restRemaining = nextRemaining;
          didChange = true;
        }
      }
    }

    if (_cooldownExerciseId != null && _cooldownStartTime != null) {
      final diff = DateTime.now().difference(_cooldownStartTime!);
      const totalMs = 300 * 1000;
      final remainingMs = totalMs - diff.inMilliseconds;

      if (remainingMs <= 0) {
        if (_cooldownRemaining != 0 || _cooldownExerciseId != null) {
          _cooldownRemaining = 0;
          _cooldownExerciseId = null;
          didChange = true;
        }
      } else {
        final nextRemaining = (remainingMs / 1000).ceil();
        if (_cooldownRemaining != nextRemaining) {
          _cooldownRemaining = nextRemaining;
          didChange = true;
        }
      }
    }

    if (_restingExerciseId == null &&
        _cooldownExerciseId == null &&
        _tick.isActive) {
      _tick.stop();
    }

    if (didChange) {
      _notifyTimerListeners();
    }
  }

  void _initializeClock() {
    switch (widget.session.clockType) {
      case ClockType.none:
      case ClockType.stopwatch:
      case ClockType.alarm:
        _startElapsedTimer();
        break;
      case ClockType.timer:
        _remaining =
            widget.session.timerDuration ?? const Duration(minutes: 30);
        _startCountdownTimer();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _pageController.jumpToPage(1);
        });
        break;
    }
  }

  void _startElapsedTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning && mounted) {
        _elapsed = DateTime.now().difference(widget.session.startedAt);
        _notifyTimerListeners();
      }
    });
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning && mounted) {
        _elapsed = DateTime.now().difference(widget.session.startedAt);
        final targetDuration =
            widget.session.timerDuration ?? const Duration(minutes: 30);
        _remaining = targetDuration - _elapsed;

        if (_remaining.isNegative) {
          _remaining = Duration.zero;
          if (!_timerCompleted) {
            _timerCompleted = true;
            _onTimerComplete();
          }
        }

        _notifyTimerListeners();
      }
    });
  }

  // New Global Work Timer (Automated)
  void _startWorkTimer() {
    _workTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_isRunning) return;

      // Safety check: Do we have exercises loaded?
      if (_cachedExercises.isEmpty) return;

      // Determine Active Exercise (First incomplete one)
      int? activeId;
      for (final ex in _cachedExercises) {
        final completed = _completedSets[ex.id] ?? 0;
        if (completed < ex.sets) {
          activeId = ex.id;
          break;
        }
      }

      // If we found an active exercise, and we ARE NOT resting or cooling down
      if (activeId != null) {
        if (_restingExerciseId == null && _cooldownExerciseId == null) {
          _currentWorkExerciseId = activeId;
          _currentWorkElapsed += const Duration(seconds: 1);
          _notifyTimerListeners();
        }
      } else {
        // All done?
        if (_currentWorkExerciseId != null) {
          _currentWorkExerciseId = null;
          _notifyTimerListeners();
        }
      }
    });
  }

  void _notifyTimerListeners() {
    if (!mounted) return;
    _timerTick.value++;
  }

  Duration get _displayDuration =>
      widget.session.clockType == ClockType.timer ? _remaining : _elapsed;

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  // Handle "Check" tap (Set Complete)
  Future<void> _incrementSet(
    int exerciseId,
    int targetSets,
    AsyncValue<List<Exercise>> exercisesAsync,
  ) async {
    // Capture Duration!
    if (_currentWorkExerciseId == exerciseId) {
      final seconds = _currentWorkElapsed.inSeconds;
      setState(() {
        _accumulatedDurations[exerciseId] =
            (_accumulatedDurations[exerciseId] ?? 0) + seconds;
        _currentWorkElapsed = Duration.zero; // Reset for next set
      });
    }

    final current = _completedSets[exerciseId] ?? 0;
    final next = (current + 1) % (targetSets + 1);

    setState(() {
      _completedSets[exerciseId] = next;
    });
    HapticFeedback.lightImpact();

    final newIsFullyDone = next >= targetSets;

    if (newIsFullyDone) {
      _startCooldown(exerciseId);
      // _restTimer cancellation implicit by overwrite
      setState(() => _restingExerciseId = null);

      // Check all done
      final exercisesList = exercisesAsync.valueOrNull ?? [];
      final allDone = exercisesList.every((e) {
        final sets = e.id == exerciseId ? next : (_completedSets[e.id] ?? 0);
        return sets >= e.sets;
      });

      if (allDone) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _confirmAndCompleteWorkout();
        }
      }
    } else if (next > current) {
      // Only start rest if we haven't just finished the last set
      _startRestTimer(exerciseId);
      // _cooldownTimer cancellation implicit
      setState(() => _cooldownExerciseId = null);
    }
  }

  void _onTimerComplete() {
    HapticFeedback.heavyImpact();
  }

  void _togglePause() {
    setState(() {
      _isRunning = !_isRunning;
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _confirmAndCompleteWorkout() async {
    int intensity = 5; // Default moderate

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final colorScheme = Theme.of(context).colorScheme;
          return AlertDialog(
            backgroundColor: colorScheme.surface,
            title: Text(
              'Finish Workout?',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Great job! How intense was this session?',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RPE: $intensity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      _getIntensityLabel(intensity),
                      style: TextStyle(
                        fontSize: 14,
                        color: _getIntensityColor(intensity),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: intensity.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: intensity.toString(),
                  onChanged: (value) {
                    setDialogState(() => intensity = value.round());
                  },
                ),
                Text(
                  '1 (Easy) - 10 (Max Effort)',
                  style: TextStyle(fontSize: 12, color: colorScheme.outline),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Finish'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == true) {
      await _completeWorkout(intensity);
    }
  }

  String _getIntensityLabel(int rpe) {
    if (rpe <= 3) return 'Easy Recovery';
    if (rpe <= 6) return 'Moderate';
    if (rpe <= 8) return 'Hard';
    return 'Max Effort';
  }

  Color _getIntensityColor(int rpe) {
    if (rpe <= 3) return Colors.green;
    if (rpe <= 6) return Colors.amber;
    if (rpe <= 8) return Colors.orange;
    return Colors.red;
  }

  bool _isCompleting = false;

  Future<void> _completeWorkout(int intensity) async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);

    try {
      _timer?.cancel();
      _workTimer?.cancel();

      // Gather exercise data
      final exercises = <SessionExercisesCompanion>[];

      // We record ALL exercises in the workout to ensure complete data
      for (final ex in _cachedExercises) {
        final id = ex.id;
        // Total duration = Accumulated + Current (if active and not finished)
        int totalSeconds = _accumulatedDurations[id] ?? 0;
        if (_currentWorkExerciseId == id) {
          totalSeconds += _currentWorkElapsed.inSeconds;
        }

        // Parse reps from note if possible
        final note = _exerciseNotes[id];
        int? actualReps;
        if (note != null && note.contains('reps')) {
          actualReps = int.tryParse(note.split(' ').first);
        }

        // Issue 2 Fix: Default reps to (target reps * completed sets) if manual reps not entered
        final setsDone = _completedSets[id] ?? 0;
        if (actualReps == null && setsDone > 0) {
          actualReps = ex.reps * setsDone;
        }

        exercises.add(
          SessionExercisesCompanion.insert(
            sessionId: widget.session.sessionId,
            exerciseId: id,
            completedSets: Value(setsDone),
            completedReps: Value(actualReps ?? 0),
            weightKg: Value(_exerciseWeights[id] ?? ex.targetWeight),
            notes: Value(note),
            durationSeconds: Value(totalSeconds),
          ),
        );
      }

      await ref
          .read(activeWorkoutSessionProvider.notifier)
          .completeWorkout(intensity: intensity, exercises: exercises);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Workout Completion Error: $e');
      if (mounted) {
        setState(() => _isCompleting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error finishing workout: $e')));
      }
    }
  }

  void _cancelWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Workout?'),
        content: const Text('Progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Resume'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Dialog
              _timer?.cancel();
              _workTimer?.cancel();
              ref.read(activeWorkoutSessionProvider.notifier).cancelWorkout();
              Navigator.pop(this.context); // Screen
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _workTimer?.cancel();
    _timerTick.dispose();
    _tick.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercisesAsync = ref.watch(
      exercisesForWorkoutProvider(widget.session.workoutId),
    );

    // Update cache for work timer
    if (exercisesAsync.hasValue) {
      _cachedExercises = exercisesAsync.value!;

      // Sort matching UI logic so 'active' calculation matches visual order
      _cachedExercises.sort((a, b) {
        final aDone = (_completedSets[a.id] ?? 0) >= a.sets;
        final bDone = (_completedSets[b.id] ?? 0) >= b.sets;
        if (aDone == bDone) return a.orderIndex.compareTo(b.orderIndex);
        return aDone ? 1 : -1;
      });
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(theme),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabIndicator(0, 'Checklist', theme),
                const SizedBox(width: 16),
                _buildTabIndicator(1, 'Timer', theme),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildChecklistPage(exercisesAsync, theme),
                  _buildTimerPage(theme),
                ],
              ),
            ),

            _buildControls(theme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTabIndicator(int index, String label, ThemeData theme) {
    final isActive = _currentPage == index;
    return GestureDetector(
      onTap: () => _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.close), onPressed: _cancelWorkout),
          Column(
            children: [
              Text(
                widget.session.workoutName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _timerTick,
                builder: (context, _, __) => Text(
                  _formatDuration(_displayDuration),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color:
                        widget.session.clockType == ClockType.timer &&
                            _remaining.inSeconds < 60
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 48), // Balance for icon
        ],
      ),
    );
  }

  Future<void> _startRestTimer(int exerciseId) async {
    final service = ref.read(settingsServiceProvider);
    final restSeconds = await service.getRestTimer();

    if (mounted) {
      setState(() {
        _restingExerciseId = exerciseId;
        _totalRestSeconds = restSeconds > 0 ? restSeconds : 1;
        _restRemaining = _totalRestSeconds;
        _restStartTime = DateTime.now(); // Mark start time
      });

      if (!_tick.isActive) _tick.start();
    }
  }

  Future<void> _startCooldown(int exerciseId) async {
    if (mounted) {
      setState(() {
        _cooldownExerciseId = exerciseId;
        _cooldownRemaining = 300; // 5 minutes
        _cooldownStartTime = DateTime.now();
      });

      if (!_tick.isActive) _tick.start();
    }
  }

  Widget _buildChecklistPage(
    AsyncValue<List<Exercise>> exercisesAsync,
    ThemeData theme,
  ) {
    return exercisesAsync.when(
      data: (exercisesList) {
        if (exercisesList.isEmpty) {
          return Center(
            child: Text(
              'No exercises configured',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          );
        }

        // Sort: Incomplete first, then Fully Completed
        final sortedExercises = List<Exercise>.from(exercisesList);
        sortedExercises.sort((a, b) {
          final aDone = (_completedSets[a.id] ?? 0) >= a.sets;
          final bDone = (_completedSets[b.id] ?? 0) >= b.sets;
          if (aDone == bDone) return a.orderIndex.compareTo(b.orderIndex);
          return aDone ? 1 : -1; // Done goes to bottom
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedExercises.length,
          itemBuilder: (context, index) {
            final ex = sortedExercises[index];
            final completed = _completedSets[ex.id] ?? 0;
            final targetSets = ex.sets;
            final isFullyDone = completed >= targetSets;
            final note = _exerciseNotes[ex.id];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              color: isFullyDone
                  ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
                  : theme.colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isFullyDone
                    ? BorderSide.none
                    : BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _incrementSet(ex.id, targetSets, exercisesAsync),

                onLongPress: () => _showRepInputDialog(ex),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Set Progress Circular
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: completed / targetSets,
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                  color: isFullyDone
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.tertiary,
                                  strokeWidth: 4,
                                ),
                                if (isFullyDone)
                                  Icon(
                                    Icons.check,
                                    size: 24,
                                    color: theme.colorScheme.primary,
                                  )
                                else
                                  Text(
                                    '$completed',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isFullyDone
                                        ? theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6)
                                        : theme.colorScheme.onSurface,
                                    decoration: isFullyDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AnimatedBuilder(
                                        animation: _timerTick,
                                        builder: (context, child) {
                                          final isActive =
                                              _currentWorkExerciseId == ex.id;
                                          final isRestingNow =
                                              _restingExerciseId == ex.id;
                                          final isCoolingDownNow =
                                              _cooldownExerciseId == ex.id;
                                          var totalSeconds =
                                              _accumulatedDurations[ex.id] ?? 0;

                                          if (isActive) {
                                            totalSeconds +=
                                                _currentWorkElapsed.inSeconds;
                                          }

                                          final details =
                                              '${ex.targetWeight > 0 ? '${ex.targetWeight}kg × ' : ''}$targetSets Sets × ${ex.reps} Reps';

                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  details,
                                                  style: TextStyle(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              if (!isFullyDone &&
                                                  (totalSeconds > 0 ||
                                                      isActive)) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: isActive
                                                        ? theme
                                                              .colorScheme
                                                              .primaryContainer
                                                        : theme
                                                              .colorScheme
                                                              .surfaceContainerHighest,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: totalSeconds > 0
                                                      ? Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.timer,
                                                              size: 14,
                                                              color: isActive
                                                                  ? theme
                                                                        .colorScheme
                                                                        .primary
                                                                  : theme
                                                                        .colorScheme
                                                                        .onSurfaceVariant,
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              '${totalSeconds ~/ 60}:${(totalSeconds % 60).toString().padLeft(2, '0')}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'monospace',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: isActive
                                                                    ? theme
                                                                          .colorScheme
                                                                          .primary
                                                                    : theme
                                                                          .colorScheme
                                                                          .onSurfaceVariant,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Text(
                                                          'Active',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: theme
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        ),
                                                ),
                                              ],
                                              if (isRestingNow) ...[
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Rest: $_restRemaining s',
                                                  style: TextStyle(
                                                    color: theme
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                              if (isCoolingDownNow) ...[
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Cooldown: ${_cooldownRemaining ~/ 60}:${(_cooldownRemaining % 60).toString().padLeft(2, '0')}',
                                                  style: const TextStyle(
                                                    color: Colors.cyanAccent,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                if (note != null && note.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Log: $note',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Rest Timer Progress Bar (Smooth)
                    AnimatedBuilder(
                      animation: _timerTick,
                      builder: (context, child) {
                        final isRestingNow = _restingExerciseId == ex.id;
                        final isCoolingDownNow = _cooldownExerciseId == ex.id;

                        if (isRestingNow && _restStartTime != null) {
                          final elapsedMs = DateTime.now()
                              .difference(_restStartTime!)
                              .inMilliseconds;
                          final totalMs = _totalRestSeconds * 1000;
                          final progress =
                              1.0 - (elapsedMs / totalMs).clamp(0.0, 1.0);

                          return LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            color: Color.lerp(
                              Colors.red,
                              Colors.green,
                              progress,
                            ),
                            minHeight: 6,
                          );
                        }

                        if (isCoolingDownNow && _cooldownStartTime != null) {
                          final elapsedMs = DateTime.now()
                              .difference(_cooldownStartTime!)
                              .inMilliseconds;
                          const totalMs = 300 * 1000;
                          final progress =
                              1.0 - (elapsedMs / totalMs).clamp(0.0, 1.0);

                          return LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            color: Color.lerp(
                              Colors.blue,
                              Colors.cyanAccent,
                              progress,
                            ),
                            minHeight: 6,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      error: (e, st) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  // Tracking local actuals per session (not yet in DB until completion)
  final Map<int, double> _exerciseWeights = {};

  void _showRepInputDialog(Exercise ex) {
    final repController = TextEditingController(
      text: _exerciseNotes[ex.id]?.split(' ').first ?? '${ex.reps}',
    );
    final weightController = TextEditingController(
      text: _exerciseWeights[ex.id]?.toString() ?? '${ex.targetWeight}',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Data for ${ex.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: repController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Actual Reps performed',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.reorder),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _exerciseNotes[ex.id] = '${repController.text} reps';
                _exerciseWeights[ex.id] =
                    double.tryParse(weightController.text) ?? ex.targetWeight;
              });
              Navigator.pop(context);
            },
            child: const Text('Save Data'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerPage(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.session.clockType == ClockType.none
                ? 'Manual Mode'
                : (widget.session.clockType == ClockType.timer
                      ? 'Remaining'
                      : 'Elapsed'),
            style: TextStyle(
              letterSpacing: 2,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<int>(
            valueListenable: _timerTick,
            builder: (context, _, __) => Text(
              _formatDuration(_displayDuration),
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w200,
                color: theme.colorScheme.onSurface,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pause/Resume button
          FloatingActionButton(
            heroTag: 'pause',
            onPressed: _togglePause,
            backgroundColor: theme.colorScheme.secondaryContainer,
            child: Icon(
              _isRunning ? Icons.pause : Icons.play_arrow,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),

          // Complete button
          SizedBox(
            width: 160,
            height: 56,
            child: FilledButton.icon(
              onPressed: _isCompleting ? null : _confirmAndCompleteWorkout,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: _isCompleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check),
              label: Text(
                _isCompleting ? 'SAVING...' : 'FINISH',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
