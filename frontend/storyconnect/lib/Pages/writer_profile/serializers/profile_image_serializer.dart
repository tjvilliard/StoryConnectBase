part of 'writer_profile_serializers.dart';

@freezed
class ProfileImageSerializer with _$ProfileImageSerializer {
  const factory ProfileImageSerializer({
    required String image, // base64 encoded image
  }) = _ProfileImageSerializer;

  factory ProfileImageSerializer.fromJson(Map<String, dynamic> json) => _$ProfileImageSerializerFromJson(json);
}
