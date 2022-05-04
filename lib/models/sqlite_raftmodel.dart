import 'dart:convert';

class RaftSQLite {
  final int? id;
  final String raftId;
  final String raftName;
  final String raftDetails;
  final String raftPrice;
  final String raftImage;
  final String busId;
  final String busName;
  RaftSQLite({
    this.id,
    required this.raftId,
    required this.raftName,
    required this.raftDetails,
    required this.raftPrice,
    required this.raftImage,
    required this.busId,
    required this.busName,
  });

  RaftSQLite copyWith({
    int? id,
    String? raftId,
    String? raftName,
    String? raftDetails,
    String? raftPrice,
    String? raftImage,
    String? busId,
    String? busName,
  }) {
    return RaftSQLite(
      id: id ?? this.id,
      raftId: raftId ?? this.raftId,
      raftName: raftName ?? this.raftName,
      raftDetails: raftDetails ?? this.raftDetails,
      raftPrice: raftPrice ?? this.raftPrice,
      raftImage: raftImage ?? this.raftImage,
      busId: busId ?? this.busId,
      busName: busName ?? this.busName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raftId': raftId,
      'raftName': raftName,
      'raftDetails': raftDetails,
      'raftPrice': raftPrice,
      'raftImage': raftImage,
      'busId': busId,
      'busName': busName,
    };
  }

  factory RaftSQLite.fromMap(Map<String, dynamic> map) {
    return RaftSQLite(
      id: map['id'],
      raftId: map['raftId'],
      raftName: map['raftName'],
      raftDetails: map['raftDetails'],
      raftPrice: map['raftPrice'],
      raftImage: map['raftImage'],
      busId: map['busId'],
      busName: map['busName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RaftSQLite.fromJson(String source) =>
      RaftSQLite.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RaftSQLite(id: $id, raftId: $raftId, raftName: $raftName, raftDetails: $raftDetails, raftPrice: $raftPrice, raftImage: $raftImage, busId: $busId, busName: $busName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RaftSQLite &&
        other.id == id &&
        other.raftId == raftId &&
        other.raftName == raftName &&
        other.raftDetails == raftDetails &&
        other.raftPrice == raftPrice &&
        other.raftImage == raftImage &&
        other.busId == busId &&
        other.busName == busName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        raftId.hashCode ^
        raftName.hashCode ^
        raftDetails.hashCode ^
        raftPrice.hashCode ^
        raftImage.hashCode ^
        busId.hashCode ^
        busName.hashCode;
  }
}
