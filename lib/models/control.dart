import 'package:JanggelIn/models/device.dart';

class Control {
  final int id;
  final String status;
  final int? deviceId;
  final Device? device;

  Control({
    required this.id,
    required this.status,
    this.deviceId,
    this.device,
  });

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json['id_kontrol'],
      status: json['status'],
      deviceId: json['fk_perangkat'],
      device: Device.fromJson(json['perangkat']),
    );
  }

    Control copyWith({
    int? id,
    String? status,
    int? deviceId,
    Device? device,
  }) {
    return Control(
      id: id ?? this.id,
      status: status ?? this.status,
      deviceId: deviceId ?? this.deviceId,
      device: device ?? this.device,
    );
  }
}
