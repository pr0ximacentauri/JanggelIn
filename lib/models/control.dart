import 'package:c3_ppl_agro/models/device.dart';

class Control {
  final int id;
  final String status;
  final int? perangkatId;
  final Device? perangkat;

  Control({
    required this.id,
    required this.status,
    this.perangkatId,
    this.perangkat,
  });

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json['id_kontrol'],
      status: json['status'],
      perangkatId: json['fk_perangkat'],
      perangkat: Device.fromJson(json['perangkat']),
    );
  }

    Control copyWith({
    int? id,
    String? status,
    int? perangkatId,
    Device? perangkat,
  }) {
    return Control(
      id: id ?? this.id,
      status: status ?? this.status,
      perangkatId: perangkatId ?? this.perangkatId,
      perangkat: perangkat ?? this.perangkat,
    );
  }
}
