class OptimalLimit {
  final int id;
  double minSuhu;
  double maksSuhu;
  double minKelembapan;
  double maksKelembapan;
  DateTime createdAt;
  DateTime updatedAt;

  OptimalLimit({
    required this.id,
    this.minSuhu = 0.0,
    this.maksSuhu = 0.0,
    this.minKelembapan = 0.0,
    this.maksKelembapan = 0.0,
    createdAt,
    updatedAt,
  }) : this.createdAt = createdAt, this.updatedAt = updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'minSuhu': minSuhu,
      'maksSuhu': maksSuhu,
      'minKelembapan': minKelembapan,
      'maksKelembapan': maksKelembapan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory OptimalLimit.fromJson(Map<String, dynamic> json) {
    return OptimalLimit(
      id: json['id'],
      minSuhu: json['minSuhu'] as double,
      maksSuhu: json['maksSuhu'] as double,
      minKelembapan: json['minKelembapan'] as double,
      maksKelembapan: json['maksKelembapan'] as double,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}