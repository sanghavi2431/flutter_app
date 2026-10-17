class CheckTaskTimeRequest {
  final int janitorId;
  final String startTime;
  final String endTime;

  CheckTaskTimeRequest({
    required this.janitorId,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "janitor_id": janitorId,
      "start_time": startTime,
      "end_time": endTime,
    };
  }
}
