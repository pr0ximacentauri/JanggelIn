class Sensor {
  final int? id;
  final double? temperature;
  final double? humidity;
  final DateTime? timestamp;


  Sensor(
      {this.id,
      this.temperature,
      this.humidity,
      this.timestamp
      });


  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] as int?,
      temperature: json['temperature'] as double?,
      timestamp: json['timestamp'] as DateTime?,
      humidity: json['humidity'] as double?,
    );
  }
}