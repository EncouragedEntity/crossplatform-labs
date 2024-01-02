import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@JsonSerializable()
class Student {
  int? id;
  String firstName;
  String lastName;
  String? photo;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    this.photo,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  Student copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? photo,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photo: photo ?? this.photo,
    );
  }
}
