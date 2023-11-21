import 'package:freezed_annotation/freezed_annotation.dart';

part 'loading_struct.freezed.dart';

@freezed
class LoadingStruct with _$LoadingStruct {
  const factory LoadingStruct({
    @Default(false) bool isLoading,
    String? message,
  }) = _LoadingStruct;

  factory LoadingStruct.loading(bool isLoading) {
    return LoadingStruct(isLoading: isLoading);
  }

  factory LoadingStruct.message(String message) {
    return LoadingStruct(isLoading: true, message: message);
  }

  factory LoadingStruct.errorMessage(String message) {
    return LoadingStruct(isLoading: false, message: message);
  }

  @override
  String toString() {
    return 'LoadingStruct(isLoading: $isLoading, message: $message)';
  }
}
