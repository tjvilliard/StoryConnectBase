class LoadingStruct {
  final bool isLoading;
  final String? message;

  LoadingStruct({required this.isLoading, this.message});

  factory LoadingStruct.loading(bool isLoading) {
    return LoadingStruct(isLoading: isLoading);
  }

  factory LoadingStruct.message(String message) {
    return LoadingStruct(isLoading: true, message: message);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadingStruct &&
        other.isLoading == isLoading &&
        other.message == message;
  }

  @override
  int get hashCode => isLoading.hashCode ^ message.hashCode;

  @override
  String toString() {
    return 'LoadingStruct(isLoading: $isLoading, message: $message)';
  }
}
