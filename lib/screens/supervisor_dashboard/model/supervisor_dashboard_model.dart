class SupervisorDashboardModel {
  final int id;
  final String description;
  final String name;
  final String location;
  final String booths;
  final String total_task;
  final String pending_task;
  final String time;
  final String status;
  final String type;
  final String date;
  final String timeSlot;
  final String janitorName;

  const SupervisorDashboardModel(
      {required this.id,
      required this.description,
      required this.name,
      required this.location,
      required this.date,
      required this.booths,
      required this.total_task,
      required this.pending_task,
      required this.time,
      required this.status,
      required this.type,
      required this.timeSlot,
      required this.janitorName});
}
