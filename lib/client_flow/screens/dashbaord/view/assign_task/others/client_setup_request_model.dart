class ClientFullSetupRequest {
  final bool isFacilityCreation;
  final int clientId;
  final int? clusterId;
  final int? facilityId;
  final String location;
  final String facilityName;
  final String facilityType;
  final bool isSupervisorCreation;
  final SupervisorRequest? supervisor;
  final bool isJanitorCreation;
  final bool isTaskCreation;
  final TemplateRequest? template;

  ClientFullSetupRequest({
    required this.isFacilityCreation,
    required this.clientId,
    this.clusterId,
    this.facilityId,
    required this.location,
    required this.facilityName,
    required this.facilityType,
    required this.isSupervisorCreation,
    this.supervisor,
    required this.isJanitorCreation,
    required this.isTaskCreation,
    this.template,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "isFacilityCreation": isFacilityCreation,
      "client_id": clientId,
      "location": location,
      "facility_name": facilityName,
      "facility_type": facilityType,
      "isSupervisorCreation": isSupervisorCreation,
      "isJanitorCreation": isJanitorCreation,
      "isTaskCreation": isTaskCreation,
    };
    if (clusterId != null) {
      json["cluster_id"] = clusterId;
    }
    if (!isFacilityCreation && facilityId != null) {
      json["facility_id"] = facilityId;
    }

    if (isSupervisorCreation && supervisor != null) {
      json["supervisor"] = supervisor!.toJson();
    }
    if ((isJanitorCreation || isTaskCreation) && template != null) {
      json["template"] = template!.toJson();
    }
    return json;
  }
}

class SupervisorRequest {
  final int roleId;
  final String firstName;
  final int mobile;
  final String gender;
  final bool isSelfAssign;

  SupervisorRequest({
    required this.roleId,
    required this.firstName,
    required this.mobile,
    required this.gender,
    required this.isSelfAssign,
  });

  Map<String, dynamic> toJson() {
    return {
      "role_id": roleId,
      "first_name": firstName,
      "mobile": mobile,
      "gender": gender,
      "isSelfAssign": isSelfAssign,
    };
  }
}

class TemplateRequest {
  final List<JanitorRequest> janitors;
  final List<TemplateTaskRequest> tasks;
  final List<AssignmentRequest> assignments;
  final String shiftTime;
  final String? facilityRef;

  TemplateRequest({
    required this.janitors,
    required this.tasks,
    required this.assignments,
    required this.shiftTime,
    this.facilityRef,
  });

  Map<String, dynamic> toJson() {
    return {
      "janitors": janitors.map((e) => e.toJson()).toList(),
      "tasks": tasks.map((e) => e.toJson()).toList(),
      "assignments": assignments.map((e) => e.toJson()).toList(),
      "shift_time": shiftTime,
      "facility_ref": facilityRef,
    };
  }
}

class JanitorRequest {
  final String tempId;
  final String type;
  final int? janitorId;
  final JanitorDataRequest? data;

  JanitorRequest({
    required this.tempId,
    required this.type,
    this.janitorId,
    this.data,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "temp_id": tempId,
      "type": type,
    };
    if (type == "existing") {
      json["janitor_id"] = janitorId;
    } else {
      json["data"] = data?.toJson();
    }
    return json;
  }
}

class JanitorDataRequest {
  final String firstName;
  final String mobile;
  final String gender;
  final List<String> languageCodes;

  JanitorDataRequest({
    required this.firstName,
    required this.mobile,
    required this.gender,
    required this.languageCodes,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "mobile": mobile,
      "gender": gender,
      "language_codes": languageCodes,
    };
  }
}

class TemplateTaskRequest {
  final String templateId;
  final List<int> taskIds;
  final List<String> days;
  final String startTime;
  final String endTime;
  final String estimatedTime;

  TemplateTaskRequest({
    required this.templateId,
    required this.taskIds,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.estimatedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "template_id": templateId,
      "task_ids": taskIds,
      "days": days,
      "start_time": startTime,
      "end_time": endTime,
      "estimated_time": estimatedTime,
    };
  }
}

class AssignmentRequest {
  final String janitorRef;
  final List<String> templateRef;

  AssignmentRequest({
    required this.janitorRef,
    required this.templateRef,
  });

  Map<String, dynamic> toJson() {
    return {
      "janitor_ref": janitorRef,
      "template_ref": templateRef,
    };
  }
}
