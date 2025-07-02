// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

// import 'dart:convert';

// LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

// String loginModelToJson(LoginModel data) => json.encode(data.toJson());

// class LoginModel {
//     bool? success;
//     Results? results;

//     LoginModel({
//          this.success,
//          this.results,
//     });

//     factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
//         success: json["success"],
//         results: Results.fromJson(json["results"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "results": results!.toJson(),
//     };
// }

// class Results {
//     int? id;
//     String? name;
//     int? roleId;
//     String? email;
//     String? rolesAccess;
//     String? permissions;
//     String? token;

//     Results({
//          this.id,
//          this.name,
//          this.roleId,
//          this.email,
//          this.rolesAccess,
//          this.permissions,
//          this.token,
//     });

//     factory Results.fromJson(Map<String, dynamic> json) => Results(
//         id: json["id"],
//         name: json["name"],
//         roleId: json["role_id"],
//         email: json["email"],
//         rolesAccess: json["rolesAccess"],
//         permissions: json["permissions"],
//         token: json["token"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "role_id": roleId,
//         "email": email,
//         "rolesAccess": rolesAccess,
//         "permissions": permissions,
//         "token": token,
//     };
// }


// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    bool? success;
    Results? results;

    LoginModel({
         this.success,
         this.results,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        results: Results.fromJson(json["results"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "results": results!.toJson(),
    };
}

class Results {
    int? id;
    String? name;
    int? roleId;
    String? email;
    String? mobile;
    String? pincode;
    String? city;
    String? address;
    String? rolesAccess;
    String? permissions;
    String? token;

    Results({
         this.id,
         this.name,
         this.roleId,
         this.email,
         this.mobile,
         this.pincode,
         this.city,
         this.address,
         this.rolesAccess,
         this.permissions,
         this.token,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json["id"],
        name: json["name"],
        roleId: json["role_id"],
        email: json["email"],
        mobile: json["mobile"],
        pincode: json["pincode"],
        city: json["city"],
        address: json["address"],
        rolesAccess: json["rolesAccess"],
        permissions: json["permissions"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role_id": roleId,
        "email": email,
        "mobile": mobile,
        "pincode": pincode,
        "city": city,
        "address": address,
        "rolesAccess": rolesAccess,
        "permissions": permissions,
        "token": token,
    };
}
