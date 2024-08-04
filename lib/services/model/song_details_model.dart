class SongDetailsModel {
  final int songId;
  final String userId;
  final String songName;
  final String songUrl;
  final String imageUrl;
  final int likes;
  final int views;
  final String lyrics;
  final List tags;
  final DateTime dateTime;

  SongDetailsModel({
    required this.songId,
    required this.userId,
    required this.songName,
    required this.songUrl,
    required this.imageUrl,
    required this.likes,
    required this.views,
    required this.lyrics,
    required this.tags,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'song_id': songId,
      'user_id': userId,
      'song_name': songName,
      'song_url': songUrl,
      'image_url': imageUrl,
      'likes': likes,
      'views': views,
      'lyrics': lyrics,
      'tags': tags,
      'date_time': dateTime.toString(),
    };
  }

  factory SongDetailsModel.fromMap(Map<String, dynamic> map) {
    return SongDetailsModel(
      songId: map['song_id'],
      userId: map['user_id'],
      songName: map['song_name'],
      songUrl: map['song_url'],
      imageUrl: map['image_url'],
      likes: map['likes'],
      views: map['views'],
      lyrics: map['lyrics'],
      tags: map['tags'],
      dateTime: DateTime.parse(map['date_time']),
    );
  }
}
