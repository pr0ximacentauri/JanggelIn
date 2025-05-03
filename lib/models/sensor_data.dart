class SensorData {
  final int id;
  double temperature;
  double humidity;
  String statusPompa;
  String statusKipas;
  String statusLampu;
  DateTime? createdAt;
  DateTime updatedAt;
  int? fkOptimalLimit;

  SensorData({
    required this.id,
    this.temperature = 0.0,
    this.humidity = 0.0,
    this.statusPompa = "OFF",
    this.statusKipas = "OFF",
    this.statusLampu = "OFF",
    this.createdAt,
    required this.updatedAt,
    this.fkOptimalLimit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_sensor': id,
      'suhu': temperature,
      'kelembapan': humidity,
      'status_pompa': statusPompa,
      'status_kipas': statusKipas,
      'status_lampu': statusLampu,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'fk_batas': fkOptimalLimit,
    };
  }

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id_sensor'],
      temperature: (json['suhu'] as num).toDouble(),
      humidity: (json['kelembapan'] as num).toDouble(),
      statusPompa: json['status_pompa'] as String,
      statusKipas: json['status_kipas'] as String,
      statusLampu: json['status_lampu'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      fkOptimalLimit: json['fk_batas'],
    );
  }
}