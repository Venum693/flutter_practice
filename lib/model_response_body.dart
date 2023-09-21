// // To parse this JSON data, do
// //
// //     final welcome = welcomeFromJson(jsonString);
//
// import 'dart:convert';
//
// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
//
// String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Route>? routes;
  List<Waypoint>? waypoints;
  String? code;
  String? uuid;

  Welcome({
     this.routes,
     this.waypoints,
     this.code,
     this.uuid,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))) ?? [],
    waypoints: List<Waypoint>.from(json["waypoints"].map((x) => Waypoint.fromJson(x)))??[],
    code: json["code"] ?? '',
    uuid: json["uuid"]?? '',
  );

  Map<String, dynamic> toJson() => {
    "routes": List<dynamic>.from(routes!.map((x) => x.toJson())) ?? [],
    "waypoints": List<dynamic>.from(waypoints!.map((x) => x.toJson())) ?? [],
    "code": code,
    "uuid": uuid,
  };
}

class Route {
  String? weightName;
  double? weight;
  double? duration;
  double? distance;
  List<Leg>? legs;
  String? geometry;

  Route({
     this.weightName,
     this.weight,
     this.duration,
     this.distance,
     this.legs,
     this.geometry,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    weightName: json["weight_name"]??'',
    weight: json["weight"]?.toDouble() ?? 0.0,
    duration: json["duration"]?.toDouble() ?? 0.0,
    distance: json["distance"]?.toDouble() ?? 0.0,
    legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))) ?? [],
    geometry: json["geometry"],
  );

  Map<String, dynamic> toJson() => {
    "weight_name": weightName??'' ,
    "weight": weight ?? 0.0,
    "duration": duration ?? 0.0,
    "distance": distance ?? 0.0,
    "legs": List<dynamic>.from(legs!.map((x) => x.toJson())) ?? [],
    "geometry": geometry ?? '',
  };
}

class Leg {
  List<dynamic>? viaWaypoints;
  List<Admin>? admins;
  double? weight;
  double? duration;
  List<dynamic>? steps;
  double? distance;
  String? summary;

  Leg({
     this.viaWaypoints,
     this.admins,
     this.weight,
     this.duration,
     this.steps,
     this.distance,
     this.summary,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    viaWaypoints: List<dynamic>.from(json["via_waypoints"].map((x) => x)) ?? [] ,
    admins: List<Admin>.from(json["admins"].map((x) => Admin.fromJson(x))) ?? [],
    weight: json["weight"]?.toDouble() ?? 0.0,
    duration: json["duration"]?.toDouble() ?? 0.0,
    steps: List<dynamic>.from(json["steps"].map((x) => x)) ?? [],
    distance: json["distance"]?.toDouble() ?? 0.0,
    summary: json["summary"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "via_waypoints": List<dynamic>.from(viaWaypoints!.map((x) => x)) ?? [],
    "admins": List<dynamic>.from(admins!.map((x) => x.toJson())) ?? [],
    "weight": weight ?? 0.0,
    "duration": duration ?? 0.0,
    "steps": List<dynamic>.from(steps!.map((x) => x)) ?? [],
    "distance": distance ?? 0.0,
    "summary": summary ?? '',
  };
}

class Admin {
  String? iso31661Alpha3;
  String? iso31661;

  Admin({
     this.iso31661Alpha3,
     this.iso31661,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    iso31661Alpha3: json["iso_3166_1_alpha3"] ?? '',
    iso31661: json["iso_3166_1"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "iso_3166_1_alpha3": iso31661Alpha3 ?? '',
    "iso_3166_1": iso31661  ?? '',
  };
}

class Waypoint {
  double? distance;
  String? name;
  List<double>? location;

  Waypoint({
     this.distance,
     this.name,
     this.location,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
    distance: json["distance"]?.toDouble() ?? 0.0,
    name: json["name"] ?? '',
    location: List<double>.from(json["location"].map((x) => x?.toDouble())) ?? [],
  );

  Map<String, dynamic> toJson() => {
    "distance": distance ?? 0.0,
    "name": name ?? '',
    "location": List<dynamic>.from(location!.map((x) => x)) ?? [],
  };
}
