class SensorModel {
  final int id;
  final double temperature;
  final double humidity;
  final DateTime timestamp;

  SensorModel({
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['id'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temperature': temperature,
      'humidity': humidity,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
