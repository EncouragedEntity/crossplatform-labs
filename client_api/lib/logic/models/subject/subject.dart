import 'package:json_annotation/json_annotation.dart';

part 'subject.g.dart';

@JsonSerializable()
class Subject {
  int? id;
  String name;

  Subject({
    this.id,
    required this.name,
  });

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);

  Subject copyWith({
    int? id,
    String? name,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
