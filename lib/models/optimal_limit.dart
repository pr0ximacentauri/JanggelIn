class OptimalLimit {
  final int id;
  double minTemperature;
  double maxTemperature;
  double minHumidity;
  double maxHumidity;
  DateTime createdAt;
  DateTime updatedAt;

  OptimalLimit({
    required this.id,
    this.minTemperature = 0.0,
    this.maxTemperature = 0.0,
    this.minHumidity = 0.0,
    this.maxHumidity = 0.0,
    createdAt,
    updatedAt,
  }) : this.createdAt = createdAt, this.updatedAt = updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id_batas': id,
      'min_suhu': minTemperature,
      'maks_suhu': maxTemperature,
      'min_kelembapan': minHumidity,
      'maks_kelembapan': maxHumidity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory OptimalLimit.fromJson(Map<String, dynamic> json) {
    return OptimalLimit(
      id: json['id_batas'],
      minTemperature: (json['min_suhu'] as num).toDouble(),
      maxTemperature: (json['maks_suhu'] as num).toDouble(),
      minHumidity: (json['min_kelembapan'] as num).toDouble(),
      maxHumidity: (json['maks_kelembapan'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}