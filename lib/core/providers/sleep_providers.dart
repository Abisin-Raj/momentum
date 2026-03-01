import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import 'database_providers.dart';
import '../utils/sleep_utils.dart';

part 'sleep_providers.g.dart';

class SleepSummary {
  final SleepLog? lastNight;
  final double avgHours7d;
  final double avgHours30d;
  final double avgQuality7d;
  final int recoveryScore;

  SleepSummary({
    this.lastNight,
    this.avgHours7d = 0.0,
    this.avgHours30d = 0.0,
    this.avgQuality7d = 0.0,
    this.recoveryScore = 0,
  });
}

@riverpod
Stream<SleepSummary> sleepSummary(Ref ref) async* {
  final logsStream = ref.watch(sleepLogsProvider(days: 30));
  
  await for (final logs in logsStream) {
    if (logs.isEmpty) {
      yield SleepSummary();
      continue;
    }

    final lastNight = logs.first;
    
    // Average 7 days
    final logs7d = logs.take(7).toList();
    final total7d = logs7d.fold<int>(0, (sum, l) => sum + l.durationMinutes);
    final avg7d = (total7d / logs7d.length) / 60.0;
    
    // Average 30 days
    final total30d = logs.fold<int>(0, (sum, l) => sum + l.durationMinutes);
    final avg30d = (total30d / logs.length) / 60.0;
    
    // Average Quality 7 days (only logs with quality > 0)
    final qualityLogs7d = logs7d.where((l) => l.quality > 0).toList();
    final avgQuality7d = qualityLogs7d.isEmpty 
        ? 0.0 
        : qualityLogs7d.fold<int>(0, (sum, l) => sum + l.quality) / qualityLogs7d.length;

    // Use centralized recovery score from last night
    final recoveryScore = SleepUtils.calculateRecoveryScore(lastNight.durationMinutes);

    yield SleepSummary(
      lastNight: lastNight,
      avgHours7d: avg7d,
      avgHours30d: avg30d,
      avgQuality7d: avgQuality7d,
      recoveryScore: recoveryScore,
    );
  }
}
