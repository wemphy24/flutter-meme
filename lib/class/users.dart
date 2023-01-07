class Users {
  int id;
  String username;
  String first_name;
  String last_name;
  String registration_date;
  String avatar;
  int privacy;

  Users({
    required this.id,
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.registration_date,
    required this.avatar,
    required this.privacy,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['user_id'] as int,
      username: json['username'] as String,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      registration_date: json['registration_date'] as String,
      avatar: json['avatar'] as String,
      privacy: json['privacy'] as int,

    );
  }
}
