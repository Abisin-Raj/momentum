import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/providers/dashboard_providers.dart';
import 'package:momentum/core/providers/database_providers.dart';
import 'package:momentum/core/providers/health_connect_provider.dart';
import 'package:momentum/core/providers/sleep_providers.dart';
import 'package:momentum/core/services/settings_service.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../app/router.dart';
import 'themed_card.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ThemedCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'MOMENTUM ANALYTICS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                '30D SUMMARY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _AnalyticsRecoverySection(),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          const _AnalyticsMetricsSection(),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),
          const _AnalyticsMuscleRecoverySection(),
        ],
      ),
    );
  }
}

class _AnalyticsRecoverySection extends ConsumerWidget {
  const _AnalyticsRecoverySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsData = ref.watch(analyticsSummaryProvider).value;
    final sleepSummaryAsync = ref.watch(sleepSummaryProvider);

    return sleepSummaryAsync.when(
      data: (summary) => _buildTopRow(context, analyticsData, summary),
      loading: () => const Center(child: LinearProgressIndicator()),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildTopRow(
    BuildContext context,
    Map<String, dynamic>? analyticsData,
    SleepSummary sleepSummary,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasSleepData = sleepSummary.lastNight != null;
    final sleepHours = (sleepSummary.lastNight?.durationMinutes ?? 420) / 60.0;

    var score = sleepSummary.recoveryScore.toDouble();
    final workoutsLast3Days = analyticsData?['workoutsLast3Days'] as int? ?? 0;

    if (workoutsLast3Days >= 3) score -= 20;
    score = score.clamp(0, 100);

    final isGood = score > 70;

    return Row(
      children: [
        CircularPercentIndicator(
          radius: 38.0,
          lineWidth: 8.0,
          percent: score / 100,
          center: Text(
            '${score.toInt()}',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          progressColor: isGood ? colorScheme.primary : Colors.orange,
          backgroundColor: colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          ),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECOVERY SCORE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isGood ? 'Optimize for Intensity' : 'Prioritize Recovery',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hasSleepData
                    ? 'Based on ${sleepHours}h sleep stats.'
                    : 'Connect Health for accuracy.',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnalyticsMetricsSection extends ConsumerWidget {
  const _AnalyticsMetricsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsSummaryProvider);
    final user = ref.watch(currentUserProvider).value;
    final healthState = ref.watch(healthProvider);
    final weightUnit = ref.watch(weightUnitProvider).value ?? 'kg';
    final colorScheme = Theme.of(context).colorScheme;

    return analyticsAsync.when(
      data: (data) =>
          _buildMetricsGrid(context, data, user, healthState, weightUnit),
      loading: () => const Center(child: LinearProgressIndicator()),
      error: (_, _) => Text(
        'Error loading metrics',
        style: TextStyle(color: colorScheme.error),
      ),
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    Map<String, dynamic> data,
    User? user,
    HealthState healthState,
    String weightUnit,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final avgIntensity = data['avgIntensity'] as double;
    final calories = data['calories'] as int;
    final totalMinutes = data['totalMinutes'] as int;
    final activeMinutes = (data['activeMinutes'] as int?) ?? 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildMetric(
                context,
                'INTENSITY',
                avgIntensity.toStringAsFixed(1),
                'RPE',
                Icons.bolt,
                colorScheme.primary,
              ),
            ),
            Expanded(
              child: _buildMetric(
                context,
                'CALORIES',
                calories.toString(),
                'kcal',
                Icons.local_fire_department,
                Colors.orangeAccent,
              ),
            ),
            Expanded(
              child: _buildMetric(
                context,
                activeMinutes > 0 ? 'LIFT TIME' : 'WORKOUT TIME',
                (activeMinutes > 0 ? activeMinutes : totalMinutes).toString(),
                'min',
                Icons.timer,
                colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildMetric(
                context,
                'STEP COUNT',
                _formatSteps(healthState.todaySteps),
                'steps',
                Icons.directions_walk_rounded,
                colorScheme.primary,
              ),
            ),
            Expanded(
              child: _buildMetric(
                context,
                'WEIGHT',
                _formatWeight(
                  healthState.latestWeight ?? user?.weightKg,
                  weightUnit,
                ),
                weightUnit,
                Icons.monitor_weight_rounded,
                colorScheme.tertiary,
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildMetric(
    BuildContext context,
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }

    return steps.toString();
  }

  String _formatWeight(double? weight, String weightUnit) {
    if (weight == null) return '--';
    if (weightUnit == 'lbs') {
      return (weight * 2.20462).toStringAsFixed(1);
    }

    return weight.toStringAsFixed(1);
  }
}

class _AnalyticsMuscleRecoverySection extends ConsumerWidget {
  const _AnalyticsMuscleRecoverySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workloadAsync = ref.watch(muscleWorkloadProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MUSCLE RECOVERY STATUS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push(AppRoute.recovery3d.path),
              icon: Icon(
                Icons.view_in_ar_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
              label: Text(
                'VIEW 3D',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        workloadAsync.when(
          data: (workload) {
            if (workload.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No workout data for recovery tracking',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            final activeMuscles =
                workload.entries.where((e) => e.value > 0).toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

            if (activeMuscles.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'All muscles fully recovered',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: activeMuscles.take(6).map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildRecoveryBar(
                    context,
                    e.key.toUpperCase(),
                    e.value,
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: LinearProgressIndicator()),
          error: (_, _) => Text(
            'Error loading recovery',
            style: TextStyle(color: colorScheme.error, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveryBar(BuildContext context, String label, int intensity) {
    final colorScheme = Theme.of(context).colorScheme;
    late final Color barColor;
    late final String status;

    if (intensity < 2) {
      barColor = Colors.green;
      status = 'Ready';
    } else if (intensity <= 5) {
      barColor = Colors.orangeAccent;
      status = 'Recovering';
    } else {
      barColor = colorScheme.error;
      status = 'Sore';
    }

    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (intensity / 10).clamp(0.1, 1.0),
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: Text(
            status,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: barColor,
            ),
          ),
        ),
      ],
    );
  }
}
