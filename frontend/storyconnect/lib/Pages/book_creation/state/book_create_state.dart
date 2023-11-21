part of 'book_create_bloc.dart';

@freezed
class BookCreateState with _$BookCreateState {
  const factory BookCreateState({
    required BookFormSerializer serializer,
    required LoadingStruct loadingStruct,
    String? imageTitle,
    Uint8List? imageFile,
    int? createdBookId,
  }) = _BookCreateState;

  factory BookCreateState.initial() {
    return BookCreateState(
        serializer: BookFormSerializer.initial(), imageTitle: null, loadingStruct: LoadingStruct.loading(false));
  }
}
