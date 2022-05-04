import 'dart:convert';

class SesviceSQLite {
  final int? sqliteid;
  final String serId;
  final String serName;
  final String serDetails;
  final String serImage;
  final String serPrice;
  final String serbusId;
  final String serbusName;
  final String serRaftId;
  SesviceSQLite({
    this.sqliteid,
    required this.serId,
    required this.serName,
    required this.serDetails,
    required this.serImage,
    required this.serPrice,
    required this.serbusId,
    required this.serbusName,
    required this.serRaftId,
  });

  SesviceSQLite copyWith({
    int? sqliteid,
    String? serId,
    String? serName,
    String? serDetails,
    String? serImage,
    String? serPrice,
    String? serbusId,
    String? serbusName,
    String? serRaftId,
  }) {
    return SesviceSQLite(
      sqliteid: sqliteid ?? this.sqliteid,
      serId: serId ?? this.serId,
      serName: serName ?? this.serName,
      serDetails: serDetails ?? this.serDetails,
      serImage: serImage ?? this.serImage,
      serPrice: serPrice ?? this.serPrice,
      serbusId: serbusId ?? this.serbusId,
      serbusName: serbusName ?? this.serbusName,
      serRaftId: serRaftId ?? this.serRaftId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sqliteid': sqliteid,
      'serId': serId,
      'serName': serName,
      'serDetails': serDetails,
      'serImage': serImage,
      'serPrice': serPrice,
      'serbusId': serbusId,
      'serbusName': serbusName,
      'serRaftId': serRaftId,
    };
  }

  factory SesviceSQLite.fromMap(Map<String, dynamic> map) {
    return SesviceSQLite(
      sqliteid: map['sqliteid'],
      serId: map['serId'],
      serName: map['serName'],
      serDetails: map['serDetails'],
      serImage: map['serImage'],
      serPrice: map['serPrice'],
      serbusId: map['serbusId'],
      serbusName: map['serbusName'],
      serRaftId: map['serRaftId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SesviceSQLite.fromJson(String source) =>
      SesviceSQLite.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SesviceSQLite(sqliteid: $sqliteid, serId: $serId, serName: $serName, serDetails: $serDetails, serImage: $serImage, serPrice: $serPrice, serbusId: $serbusId, serbusName: $serbusName, serRaftId: $serRaftId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SesviceSQLite &&
        other.sqliteid == sqliteid &&
        other.serId == serId &&
        other.serName == serName &&
        other.serDetails == serDetails &&
        other.serImage == serImage &&
        other.serPrice == serPrice &&
        other.serbusId == serbusId &&
        other.serbusName == serbusName &&
        other.serRaftId == serRaftId;
  }

  @override
  int get hashCode {
    return sqliteid.hashCode ^
        serId.hashCode ^
        serName.hashCode ^
        serDetails.hashCode ^
        serImage.hashCode ^
        serPrice.hashCode ^
        serbusId.hashCode ^
        serbusName.hashCode ^
        serRaftId.hashCode;
  }
}
