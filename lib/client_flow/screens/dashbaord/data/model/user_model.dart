

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    Results? results;
    bool? success;

    UserModel({
         this.results,
         this.success,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    Data? data;
    Checkpoint? checkpoint;
    String? message;

    Results({
         this.data,
         this.checkpoint,
         this.message,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        data: Data.fromJson(json["data"]),
        checkpoint: Checkpoint.fromJson(json["checkpoint"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "checkpoint": checkpoint!.toJson(),
        "message": message,
    };
}

class Checkpoint {
    bool block;
    bool shift;
    bool cluster;
    bool janitor;
    bool facility;
    bool location;
    bool supervisor;
    bool templateMap;
    bool taskTemplate;

    Checkpoint({
        required this.block,
        required this.shift,
        required this.cluster,
        required this.janitor,
        required this.facility,
        required this.location,
        required this.supervisor,
        required this.templateMap,
        required this.taskTemplate,
    });

    factory Checkpoint.fromJson(Map<String, dynamic> json) => Checkpoint(
        block: json["block"],
        shift: json["shift"],
        cluster: json["cluster"],
        janitor: json["janitor"],
        facility: json["facility"],
        location: json["location"],
        supervisor: json["supervisor"],
        templateMap: json["templateMap"],
        taskTemplate: json["task_template"],
    );

    Map<String, dynamic> toJson() => {
        "block": block,
        "shift": shift,
        "cluster": cluster,
        "janitor": janitor,
        "facility": facility,
        "location": location,
        "supervisor": supervisor,
        "templateMap": templateMap,
        "task_template": taskTemplate,
    };
}

class Data {
    String label;
    int value;

    Data({
        required this.label,
        required this.value,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}
