part of 'book_create_bloc.dart';

@freezed
class BookCreateState with _$BookCreateState {
  const factory BookCreateState({
    required BookCreationSerializer serializer,
    required LoadingStruct loadingStruct,
    String? imageTitle,
    Uint8List? imageFile,
    int? createdBookId,
  }) = _BookCreateState;

  factory BookCreateState.initial() {
    return BookCreateState(
        serializer: BookCreationSerializer.initial(),
        imageTitle: null,
        loadingStruct: LoadingStruct.loading(false));
  }
}
