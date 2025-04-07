// kolom sementara

class DeviceSettings {
  final double targetTemperature;
  final double targetHumidity;

  DeviceSettings({
    required this.targetTemperature,
    required this.targetHumidity,
  });

  Map<String, dynamic> toJson() {
    return {
      "target_temperature": targetTemperature,
      "target_humidity": targetHumidity,
    };
  }

  factory DeviceSettings.fromJson(Map<String, dynamic> json) {
    return DeviceSettings(
      targetTemperature: json["target_temperature"]?.toDouble() ?? 0.0,
      targetHumidity: json["target_humidity"]?.toDouble() ?? 0.0,
    );
  }
}
