part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    User? user,
  }) = _UserState;
  const UserState._();
}
