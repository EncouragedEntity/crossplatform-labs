import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  int? id;
  int studentId;
  int subjectId;

  Session({
    this.id,
    required this.studentId,
    required this.subjectId,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  Session copyWith({
    int? id,
    int? studentId,
    int? subjectId,
  }) {
    return Session(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectId: subjectId ?? this.subjectId,
    );
  }
}
