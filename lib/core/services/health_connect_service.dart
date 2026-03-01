import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for interacting with Google Health Connect.
class HealthConnectService {
  final Health _health = Health();
  
  /// Data types we want to read from Health Connect.
  static const List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.WEIGHT,
    HealthDataType.WORKOUT,
  ];
  
  /// Check if Health Connect is available on this device.
  static Future<HealthConnectSdkStatus> checkAvailability() async {
    // Check if Health Connect is available
    final status = await Health().getHealthConnectSdkStatus();
    return status ?? HealthConnectSdkStatus.sdkUnavailable;
  }
  
  /// Request permissions for activity recognition (required for steps).
  Future<bool> requestActivityRecognition() async {
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }
  
  /// Request Health Connect permissions for all data types.
  Future<bool> requestPermissions() async {
    // First request activity recognition
    await requestActivityRecognition();
    
    // Then request Health Connect permissions
    final permissions = _dataTypes.map((type) => HealthDataAccess.READ).toList();
    
    final granted = await _health.requestAuthorization(
      _dataTypes,
      permissions: permissions,
    );
    
    return granted;
  }
  
  /// Check if we have all required permissions.
  Future<bool> hasPermissions() async {
    final permissions = _dataTypes.map((type) => HealthDataAccess.READ).toList();
    return await _health.hasPermissions(_dataTypes, permissions: permissions) ?? false;
  }
  
  /// Fetch step count for a given date range.
  Future<int> fetchSteps(DateTime start, DateTime end) async {
    try {
      final steps = await _health.getTotalStepsInInterval(start, end);
      return steps ?? 0;
    } catch (e) {
      return 0;
    }
  }
  
  
  /// Fetch sleep data for a given date range.
  Future<List<HealthDataPoint>> fetchSleep(DateTime start, DateTime end) async {
    try {
      return await _health.getHealthDataFromTypes(
        types: [
          HealthDataType.SLEEP_ASLEEP, 
          HealthDataType.SLEEP_AWAKE,
          HealthDataType.SLEEP_SESSION,
          HealthDataType.SLEEP_DEEP,
          HealthDataType.SLEEP_REM,
          HealthDataType.SLEEP_LIGHT,
        ],
        startTime: start,
        endTime: end,
      );
    } catch (e) {
      return [];
    }
  }
  
  /// Fetch weight data for a given date range.
  Future<List<HealthDataPoint>> fetchWeight(DateTime start, DateTime end) async {
    try {
      return await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: start,
        endTime: end,
      );
    } catch (e) {
      return [];
    }
  }
  
  /// Unify sleep aggregation logic to avoid overcounting overlapping segments.
  /// Prefers [SLEEP_SESSION] if available, otherwise sums up distinct [SLEEP_ASLEEP], [SLEEP_LIGHT], [SLEEP_DEEP], [SLEEP_REM] segments.
  static int calculateTotalSleepMinutes(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;

    int sessionDuration = 0;
    int stagesDuration = 0;

    for (final point in data) {
      final duration = point.dateTo.difference(point.dateFrom).inMinutes;

      if (point.type == HealthDataType.SLEEP_SESSION) {
        sessionDuration += duration;
      } else if (point.type == HealthDataType.SLEEP_ASLEEP ||
          point.type == HealthDataType.SLEEP_LIGHT ||
          point.type == HealthDataType.SLEEP_DEEP ||
          point.type == HealthDataType.SLEEP_REM) {
        stagesDuration += duration;
      }
    }

    return sessionDuration > 0 ? sessionDuration : stagesDuration;
  }

  /// Fetch workout data for a given date range.
  Future<List<HealthDataPoint>> fetchWorkouts(DateTime start, DateTime end) async {
    try {
      return await _health.getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: start,
        endTime: end,
      );
    } catch (e) {
      return [];
    }
  }
  
  /// Fetch all health data for a given date range.
  Future<List<HealthDataPoint>> fetchAllData(DateTime start, DateTime end) async {
    try {
      return await _health.getHealthDataFromTypes(
        types: _dataTypes,
        startTime: start,
        endTime: end,
      );
    } catch (e) {
      return [];
    }
  }
}
