const String tableLyrics = 'lyrics';

class LyricFields {
  static final List<String> values = [
    /// Add all fields
    id, title, content, contentChangeTone, guide,
    tone, createdTime, idAuthor, rating, singer,
    view, numberOfVotes, beat, genres, linkSong, titleSearch,
  ];

  static const String id = 'id';
  static const String title = 'title';
  static const String content = 'content';
  static const String contentChangeTone = 'contentChangeTone';
  static const String guide = 'guide';
  static const String tone = 'tone';
  static const String createdTime = 'createdTime';
  static const String idAuthor = 'idAuthor';
  static const String rating = 'rating';
  static const String singer = 'singer';
  static const String view = 'view';
  static const String numberOfVotes = 'numberOfVotes';
  static const String genres = 'genres';
  static const String linkSong = 'linkSong';
  static const String beat = 'beat';
  static const String titleSearch = 'title_search';
}

class Lyric {
  final int? id;
  final String title;
  String content;
  final String? guide;
  final String tone;
  final DateTime? createdTime;
  final String? idAuthor;
  final double rating;
  final String singer;
  final int view;
  final int numberOfVotes;
  final String? beat;
  final String? linkSong;
  final String? genres;
  String contentChangeTone;
  final String? titleSearch;

  Lyric({
    this.id,
    required this.title,
    required this.content,
    required this.tone,
    this.guide = "",
    this.createdTime,
    this.idAuthor = "",
    this.rating = 0,
    this.singer = "",
    this.view = 0,
    this.numberOfVotes = 0,
    this.contentChangeTone = "",
    this.beat = "",
    this.linkSong = "",
    this.genres = "",
    this.titleSearch = "",
  });

  Lyric copy({
    int? id,
    String? title,
    String? content,
    String? guide,
    String? tone,
    DateTime? createdTime,
    String? idAuthor,
    double? rating,
    String? singer,
    int? view,
    int? numberOfVotes,
    String? beat,
    String? linkSong,
    String? genres,
    String? contentChangeTone,
    String? titleSearch,
  }) =>
      Lyric(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        guide: guide ?? this.guide,
        tone: tone ?? this.tone,
        createdTime: createdTime ?? this.createdTime,
        idAuthor: idAuthor ?? this.idAuthor,
        rating: rating ?? this.rating,
        singer: singer ?? this.singer,
        view: view ?? this.view,
        numberOfVotes: numberOfVotes ?? this.numberOfVotes,
        beat: beat ?? this.beat,
        linkSong: linkSong ?? this.linkSong,
        genres: genres ?? this.genres,
        contentChangeTone: contentChangeTone ?? this.contentChangeTone,
        titleSearch: titleSearch ?? this.titleSearch,
      );

  static Lyric fromJson(Map<String, dynamic> json) => Lyric(
        id: json[LyricFields.id] as int,
        title: json[LyricFields.title] as String,
        tone: json[LyricFields.tone] as String,
        content: json[LyricFields.content] as String,
        contentChangeTone: json[LyricFields.contentChangeTone] as String,
        guide: json[LyricFields.guide] as String,
        createdTime: DateTime.parse(json[LyricFields.createdTime] as String),
        idAuthor: json[LyricFields.idAuthor] as String,
        rating: double.parse(json[LyricFields.rating].toString()),
        singer: json[LyricFields.singer] as String,
        view: json[LyricFields.view] as int,
        beat: json[LyricFields.beat] as String,
        genres: json[LyricFields.genres] as String,
        linkSong: json[LyricFields.linkSong] as String,
        numberOfVotes: (json[LyricFields.numberOfVotes] ?? 0) as int,
        titleSearch: json[LyricFields.titleSearch] as String,
      );

  Map<String, Object?> toJson() => {
        LyricFields.id: id,
        LyricFields.content: content,
        LyricFields.title: title,
        LyricFields.tone: tone,
        LyricFields.guide: guide,
        LyricFields.contentChangeTone: contentChangeTone,
        LyricFields.createdTime: createdTime!.toString(),
        LyricFields.idAuthor: idAuthor,
        LyricFields.rating: rating,
        LyricFields.singer: singer,
        LyricFields.view: view,
        LyricFields.beat: beat,
        LyricFields.genres: genres,
        LyricFields.linkSong: linkSong,
        LyricFields.numberOfVotes: numberOfVotes,
        LyricFields.titleSearch: titleSearch,
      };
}
