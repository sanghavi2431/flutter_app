// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
    Results? results;
    bool? success;

    ClientModel({
         this.results,
         this.success,
    });

    factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    Client? client;
    Checkpoints? checkpoints;
    bool? isOnboardComplete;

    Results({
         this.client,
         this.checkpoints,
         this.isOnboardComplete,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        client: Client.fromJson(json["client"]),
        checkpoints: Checkpoints.fromJson(json["checkpoints"]),
        isOnboardComplete: json["isOnboardComplete"],
    );

    Map<String, dynamic> toJson() => {
        "client": client!.toJson(),
        "checkpoints": checkpoints!.toJson(),
        "isOnboardComplete": isOnboardComplete,
    };
}

class Checkpoints {
    bool? block;
    bool? shift;
    bool? cluster;
    bool? janitor;
    bool? facility;
    bool? location;
    bool? supervisor;
    bool? templateMap;
    bool? taskTemplate;

    Checkpoints({
      this.block,
      this.shift,
      this.cluster,
      this.janitor,
      this.facility,
      this.location,
      this.supervisor,
      this.templateMap,
      this.taskTemplate,
    });

    factory Checkpoints.fromJson(Map<String, dynamic> json) => Checkpoints(
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

class Client {
    String label;
    int value;

    Client({
        required this.label,
        required this.value,
    });

    factory Client.fromJson(Map<String, dynamic> json) => Client(
        label: json["label"] ?? "",
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}
