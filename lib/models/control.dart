class Control {
  final String id;
  bool status;

  Control({
    required this.id,
    this.status = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json['id'],
      status: json['status'] as bool,
    );
  }
}