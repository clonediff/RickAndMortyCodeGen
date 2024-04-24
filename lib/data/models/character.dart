import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';

part 'character.g.dart';

@freezed
class Character with _$Character {
  const factory Character({
    required int id,
    required String name,
    required String status,
    required String species,
    required String gender,
    required String image,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}

@freezed
class Info with _$Info {
  const factory Info({
    required int count,
    required int pages,
    String? next,
    String? prev,
  }) = _Info;

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
}

@freezed
class CharactersResponse with _$CharactersResponse {
  const factory CharactersResponse({
    required List<Character> results,
    required Info info,
  }) = _CharactersResponse;

  factory CharactersResponse.fromJson(Map<String, dynamic> json) =>
      _$CharactersResponseFromJson(json);
}
