class Memes {
  int id;
  String url;
  String top_text;
  String bottom_text;
  String date;
  int likes;
  int user_id;
  List? comments;


  Memes({required this.id, required this.url, required this.top_text, required this.bottom_text, required this.date, required this.likes,  required this.user_id, this.comments});
  factory Memes.fromJson(Map<String, dynamic> json) {
    return Memes(
      id: json['meme_id'] as int,
      url: json['url'] as String,
      top_text: json['top_text'] as String,
      bottom_text: json['bottom_text'] as String,
      date: json['date'] as String,
      likes: json['likes'] as int,
      user_id: json['users_id'] as int,
      comments: json['comments'],
    );
  }

}
