
class SensorData {
  final int id;
  double temperature;
  double humidity;
  DateTime createdAt;
  DateTime updatedAt;
  int? fkOptimalLimit;

  SensorData({
    required this.id,
    this.temperature = 0.0,
    this.humidity = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.fkOptimalLimit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_sensor': id,
      'suhu': temperature,
      'kelembapan': humidity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'fk_batas': fkOptimalLimit,
    };
  }

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id_sensor'],
      temperature: (json['suhu'] as num).toDouble(),
      humidity: (json['kelembapan'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      fkOptimalLimit: json['fk_batas'],
    );
  }
}