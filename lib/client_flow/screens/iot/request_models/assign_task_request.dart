class AssignTaskRequest {
  final int clientId;
  final String shiftTime;
  // final List<int?> taskIds;
  // final String estimatedTime;
  final List<Map<String, dynamic>> taskTimes;
  final int janitorId;
  final String facilityRef;
  final String? facilityId;
  // final List<String>? days;

  AssignTaskRequest({
    required this.clientId,
    required this.shiftTime,
    // required this.taskIds,
    // required this.estimatedTime,
    required this.taskTimes,
    required this.janitorId,
    required this.facilityRef,
    this.facilityId,
    // this.days,
  });

  Map<String, dynamic> toJson() {
    return {
      "client_id": clientId,
      "shift_time": shiftTime,
      "task_times": taskTimes,
      "janitor_id": janitorId,
      if (facilityId != null) "facility_id": facilityId,
      "facility_ref": facilityRef,
    };
  }

  bool get isSupervisorCall => true; // always true for this API
}
