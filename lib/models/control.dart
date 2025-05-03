class Control {
  final int id;
  final String name;
  final String status;
  DateTime? createdAt;
  DateTime updatedAt;

  Control({required this.id, required this.name, required this.status, this.createdAt, required this.updatedAt});

  Map<String, dynamic> toJson() {
    return {
      'id_kontrol': id,
      'nama': name,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json['id_kontrol'],
      name: json['nama'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
