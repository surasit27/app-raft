import 'dart:convert';

class PromotionSQLite {
  final int? sqliteProid;
  final String proId;
  final String proName;
  final String proImage;
  final String proDetaits;
  final String proDiscoun;
  final String proStartdate;
  final String proLastdate;
  final String proStatusId;
  final String proStatusName;
  final String proBusId;
  PromotionSQLite({
    this.sqliteProid,
    required this.proId,
    required this.proName,
    required this.proImage,
    required this.proDetaits,
    required this.proDiscoun,
    required this.proStartdate,
    required this.proLastdate,
    required this.proStatusId,
    required this.proStatusName,
    required this.proBusId,
  });

  PromotionSQLite copyWith({
    int? sqliteProid,
    String? proId,
    String? proName,
    String? proImage,
    String? proDetaits,
    String? proDiscoun,
    String? proStartdate,
    String? proLastdate,
    String? proStatusId,
    String? proStatusName,
    String? proBusId,
  }) {
    return PromotionSQLite(
      sqliteProid: sqliteProid ?? this.sqliteProid,
      proId: proId ?? this.proId,
      proName: proName ?? this.proName,
      proImage: proImage ?? this.proImage,
      proDetaits: proDetaits ?? this.proDetaits,
      proDiscoun: proDiscoun ?? this.proDiscoun,
      proStartdate: proStartdate ?? this.proStartdate,
      proLastdate: proLastdate ?? this.proLastdate,
      proStatusId: proStatusId ?? this.proStatusId,
      proStatusName: proStatusName ?? this.proStatusName,
      proBusId: proBusId ?? this.proBusId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sqliteProid': sqliteProid,
      'proId': proId,
      'proName': proName,
      'proImage': proImage,
      'proDetaits': proDetaits,
      'proDiscoun': proDiscoun,
      'proStartdate': proStartdate,
      'proLastdate': proLastdate,
      'proStatusId': proStatusId,
      'proStatusName': proStatusName,
      'proBusId': proBusId,
    };
  }

  factory PromotionSQLite.fromMap(Map<String, dynamic> map) {
    return PromotionSQLite(
      sqliteProid: map['sqliteProid'],
      proId: map['proId'],
      proName: map['proName'],
      proImage: map['proImage'],
      proDetaits: map['proDetaits'],
      proDiscoun: map['proDiscoun'],
      proStartdate: map['proStartdate'],
      proLastdate: map['proLastdate'],
      proStatusId: map['proStatusId'],
      proStatusName: map['proStatusName'],
      proBusId: map['proBusId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionSQLite.fromJson(String source) =>
      PromotionSQLite.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PromotionSQLite(sqliteProid: $sqliteProid, proId: $proId, proName: $proName, proImage: $proImage, proDetaits: $proDetaits, proDiscoun: $proDiscoun, proStartdate: $proStartdate, proLastdate: $proLastdate, proStatusId: $proStatusId, proStatusName: $proStatusName, proBusId: $proBusId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PromotionSQLite &&
        other.sqliteProid == sqliteProid &&
        other.proId == proId &&
        other.proName == proName &&
        other.proImage == proImage &&
        other.proDetaits == proDetaits &&
        other.proDiscoun == proDiscoun &&
        other.proStartdate == proStartdate &&
        other.proLastdate == proLastdate &&
        other.proStatusId == proStatusId &&
        other.proStatusName == proStatusName &&
        other.proBusId == proBusId;
  }

  @override
  int get hashCode {
    return sqliteProid.hashCode ^
        proId.hashCode ^
        proName.hashCode ^
        proImage.hashCode ^
        proDetaits.hashCode ^
        proDiscoun.hashCode ^
        proStartdate.hashCode ^
        proLastdate.hashCode ^
        proStatusId.hashCode ^
        proStatusName.hashCode ^
        proBusId.hashCode;
  }
}
