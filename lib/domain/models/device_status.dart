class DeviceStatus {
  final int id;
  final bool isOn;

  DeviceStatus({required this.id, required this.isOn});

  factory DeviceStatus.fromJson(Map<String, dynamic> json) {
    return DeviceStatus(
      id: json['id'],
      isOn: json['status'] == 1, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': isOn ? 1 : 0,
    };
  }
}
