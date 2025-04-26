class Control {
  final int id;
  final String name;
  final String status;

  Control({required this.id, required this.name, required this.status});

  Map<String, dynamic> toJson() {
    return {
      'id_kontrol': id,
      'nama': name,
      'status': status,
    };
  }

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json['id_kontrol'],
      name: json['nama'],
      status: json['status'],
    );
  }
}
