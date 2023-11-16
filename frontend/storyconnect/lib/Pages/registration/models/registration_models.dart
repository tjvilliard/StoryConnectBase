import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_models.freezed.dart';
part 'registration_models.g.dart';

@freezed
class DisplayNameSerializer with _$DisplayNameSerializer {
  const factory DisplayNameSerializer({
    @JsonKey(name: 'display_name') required String displayName,
  }) = _DisplayNameSerializer;

  factory DisplayNameSerializer.fromJson(Map<String, dynamic> json) =>
      _$DisplayNameSerializerFromJson(json);
}
