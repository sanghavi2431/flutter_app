class DummyReportData {
  final String facilityName;
  final String generatedBy;
  final DateTime generatedAt;
  final String executiveSummary;

  final KpiData kpi;

  final List<OdorLevelData> odorLevels;
  final List<TaskAuditData> tasks;
  final List<AlertData> alerts;
  final List<JanitorPerformanceData> janitors;
  final List<String> recommendations;

  DummyReportData({
    required this.facilityName,
    required this.generatedBy,
    required this.generatedAt,
    required this.executiveSummary,
    required this.kpi,
    required this.odorLevels,
    required this.tasks,
    required this.alerts,
    required this.janitors,
    required this.recommendations,
  });

  /// Factory to return hardcoded dummy data
  factory DummyReportData.sample() {
    return DummyReportData(
      facilityName: "Cult-Fit Facilities",
      generatedBy: "TasqMaster System",
      generatedAt: DateTime.now(),

      executiveSummary:
          "This report provides a comprehensive overview of facility performance. "
          "Key metrics show strong task completion rates with some air quality concerns.",

      kpi: KpiData(
        tasksCompleted: 12,
        tasksChangePercent: 20,
        alertsReceived: 17,
        alertsChangePercent: 2,
        avgAqi: 69.5,
        avgAqiChangePercent: -20,
        avgUsage: 59,
        avgUsageChangePercent: 8,
      ),

      odorLevels: [
        OdorLevelData("12 AM - 6 AM", 0, 0, "Healthy"),
        OdorLevelData("6 AM - 12 PM", 20, 57, "Healthy"),
        OdorLevelData("12 PM - 6 PM", 76, 20, "Unhealthy"),
        OdorLevelData("6 PM - 12 AM", 42, 20, "Moderate"),
      ],

      tasks: [
        TaskAuditData(
          task: "Floor 3 - Restroom Deep Clean",
          assignedTo: "Sunita Patel",
          status: "Completed",
        ),
        TaskAuditData(
          task: "Conference Room Sanitization",
          assignedTo: "Sunita Patel",
          status: "On Going",
        ),
        TaskAuditData(
          task: "Lobby & Reception Area",
          assignedTo: "Ramesh Jha",
          status: "On Going",
        ),
      ],

      alerts: [
        AlertData(
          description: "Odor Detected - 6.2 (High)",
          time: "02:15 PM",
        ),
        AlertData(
          description: "Odor Detected - 7.8 (High)",
          time: "10:42 AM",
        ),
        AlertData(
          description: "Poor Air Quality Detected - 165 (Unhealthy)",
          time: "08:32 AM",
        ),
      ],

      janitors: [
        JanitorPerformanceData(
          name: "Sunita Patel",
          tasksCompleted: 8,
          totalTasks: 10,
        ),
        JanitorPerformanceData(
          name: "Ramesh Jha",
          tasksCompleted: 2,
          totalTasks: 10,
        ),
        JanitorPerformanceData(
          name: "Ganesh Raj",
          tasksCompleted: 2,
          totalTasks: 10,
        ),
      ],

      recommendations: [
        "Improve ventilation during afternoon hours.",
        "Provide training to low-performing janitors.",
        "Implement rapid alert response protocol.",
      ],
    );
  }
}


class KpiData {
  final int tasksCompleted;
  final int tasksChangePercent;

  final int alertsReceived;
  final int alertsChangePercent;

  final double avgAqi;
  final int avgAqiChangePercent;

  final int avgUsage;
  final int avgUsageChangePercent;

  KpiData({
    required this.tasksCompleted,
    required this.tasksChangePercent,
    required this.alertsReceived,
    required this.alertsChangePercent,
    required this.avgAqi,
    required this.avgAqiChangePercent,
    required this.avgUsage,
    required this.avgUsageChangePercent,
  });
}

class OdorLevelData {
  final String timePeriod;
  final double odorLevel;
  final int usage;
  final String status;

  OdorLevelData(
    this.timePeriod,
    this.odorLevel,
    this.usage,
    this.status,
  );
}

class TaskAuditData {
  final String task;
  final String assignedTo;
  final String status;

  TaskAuditData({
    required this.task,
    required this.assignedTo,
    required this.status,
  });
}

class AlertData {
  final String description;
  final String time;

  AlertData({
    required this.description,
    required this.time,
  });
}

class JanitorPerformanceData {
  final String name;
  final int tasksCompleted;
  final int totalTasks;

  JanitorPerformanceData({
    required this.name,
    required this.tasksCompleted,
    required this.totalTasks,
  });

  double get completionRate =>
      (tasksCompleted / totalTasks) * 100;
}
