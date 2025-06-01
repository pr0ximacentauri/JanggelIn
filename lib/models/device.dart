class Device {
  final int id;
  final String name;

  Device({
    required this.id,
    required this.name,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id_perangkat'],
      name: json['nama'],
    );
  }
}
