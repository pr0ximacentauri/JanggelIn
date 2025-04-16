// entity sementara
class SensorData {
  final int id;
  double temperature;
  double humidity;
  DateTime createdAt;
  DateTime updatedAt;

  SensorData({required this.id, this.temperature = 0.0, this.humidity = 0.0, createdAt, updatedAt}) : this.createdAt = createdAt, this.updatedAt = updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temperature': temperature,
      'humidity': humidity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'],
      temperature: json['temperature'] as double,
      humidity: json['humidity'] as double,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']), 
    );
  }
}