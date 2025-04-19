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
      'id_bataa': id,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'minHumidity': minHumidity,
      'maxHumidity': maxHumidity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory OptimalLimit.fromJson(Map<String, dynamic> json) {
    return OptimalLimit(
      id: json['id_batas'],
      minTemperature: json['minTemperature'] as double,
      maxTemperature: json['maxTemperature'] as double,
      minHumidity: json['minHumidity'] as double,
      maxHumidity: json['maxHumidity'] as double,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}