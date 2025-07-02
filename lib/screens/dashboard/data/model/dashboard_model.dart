class DashboardModel {
  final int id;
  final String description;
  final String name;
  final String location;
  final String booths;
  final String totalTask;
  final String pendingTask;
  final String time;
  final String status;
  final String type;
  final String date;
  final String timeSlot;

  const DashboardModel({
    required this.id,
    required this.description,
    required this.name,
    required this.location,
    required this.date,
    required this.booths,
    required this.totalTask,
    required this.pendingTask,
    required this.time,
    required this.status,
    required this.type,
    required this.timeSlot,
  });
}
