import 'package:note_app/constants/note_fields.dart';

class NoteModel {
  int? id;
  final int? number;
  final String? title;
  final String? content;
  final bool? isFavorite;
  final DateTime? createdTime;
  final bool? isDeleted;
  NoteModel({
    this.id,
    this.number,
    this.title,
    this.content,
    this.isFavorite,
    this.createdTime,
    this.isDeleted,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json[NoteFields.id] as int?,
        number: json[NoteFields.number] as int?,
        title: json[NoteFields.title] as String,
        content: json[NoteFields.content] as String,
        isFavorite: json[NoteFields.isFavorite] == 1,
        createdTime: DateTime.tryParse(
          json[NoteFields.createdTime] as String,
        ),
        isDeleted: json[NoteFields.isDeleted] ==1,
      );

  Map<String, dynamic> toJson() => {
        NoteFields.id: id,
        NoteFields.number: number,
        NoteFields.title: title,
        NoteFields.content: content,
        NoteFields.isFavorite: isFavorite! ? 1 : 0,
        NoteFields.createdTime: createdTime?.toIso8601String(),
        NoteFields.isDeleted: isDeleted?? false ? 1 : 0 
      };

  NoteModel copy({
    int? id,
    int? number,
    String? title,
    String? content,
    bool? isFavorite,
    DateTime? createdTime,
    bool? isDeleted,
  }) =>
      NoteModel(
        id: id ?? this.id,
        number: number ?? this.number,
        title: title ?? this.title,
        content: content ?? this.content,
        isFavorite: isFavorite ?? this.isFavorite,
        createdTime: createdTime ?? this.createdTime,
        isDeleted: isDeleted ?? this.isDeleted,
      );
}
