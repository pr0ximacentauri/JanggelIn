class Control {
  final int id;
  final String status;

  Control({required this.id, required this.status});

  Map<String, dynamic> toJson() {
    return {
      'id_kontrol': id,
      'status': status,
    };
  }

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json['id_kontrol'],
      status: json['status'],
    );
  }
}
