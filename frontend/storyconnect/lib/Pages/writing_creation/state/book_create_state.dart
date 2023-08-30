part of 'book_create_bloc.dart';

@freezed
class BookCreateState with _$BookCreateState {
  const factory BookCreateState({
    required BookCreationSerializer serializer,
    required LoadingStruct loadingStruct,
  }) = _BookCreateState;

  factory BookCreateState.initial() {
    return BookCreateState(
        serializer: BookCreationSerializer.initial(),
        loadingStruct: LoadingStruct.loading(false));
  }
}
