// entity sementara
class Device {
  final String id;
  bool status;
  double temperature;
  double humidity;

  Device({required this.id, this.status = false, this.temperature = 0.0, this.humidity = 0.0});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'temperature': temperature,
      'humidity': humidity
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      status: json['status'] as bool,
      temperature: json['temperature'] as double,
      humidity: json['humidity'] as double,
    );
  }
}