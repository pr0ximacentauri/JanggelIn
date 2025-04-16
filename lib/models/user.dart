class User {
  final int id;
  String username;
  String password;

  User({required this.id, required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }
}