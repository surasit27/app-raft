import 'dart:convert';

class MapModel {
  String? mapLatitude;
  String? mapLongitude;
  MapModel({
    this.mapLatitude,
    this.mapLongitude,
  });

  MapModel copyWith({
    String? mapLatitude,
    String? mapLongitude,
  }) {
    return MapModel(
      mapLatitude: mapLatitude ?? this.mapLatitude,
      mapLongitude: mapLongitude ?? this.mapLongitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mapLatitude': mapLatitude,
      'mapLongitude': mapLongitude,
    };
  }

  factory MapModel.fromMap(Map<String, dynamic> map) {
    return MapModel(
      mapLatitude: map['mapLatitude'] != null ? map['mapLatitude'] : null,
      mapLongitude: map['mapLongitude'] != null ? map['mapLongitude'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MapModel.fromJson(String source) =>
      MapModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'MapModel(mapLatitude: $mapLatitude, mapLongitude: $mapLongitude)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MapModel &&
        other.mapLatitude == mapLatitude &&
        other.mapLongitude == mapLongitude;
  }

  @override
  int get hashCode => mapLatitude.hashCode ^ mapLongitude.hashCode;
}
