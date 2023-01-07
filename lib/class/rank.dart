class Rank {
  String avatar;
  String first_name;
  String last_name;
  String total_likes;
  int privacy;

  Rank(
      {required this.avatar,
      required this.first_name,
      required this.last_name,
      required this.total_likes,
      required this.privacy});

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      avatar: json['avatar'] as String,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      total_likes: json['total_like'] as String,
      privacy: json['privacy'] as int,
    );
  }
}
