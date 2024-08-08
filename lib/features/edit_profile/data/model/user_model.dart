class User {
  final String? name;
  final String? username;

  User({ this.name,  this.username});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'], username: json['user']);
  }
}
