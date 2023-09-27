import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_events.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

typedef UserEmitter = Emitter<UserState>;

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(User user) : super(UserState(user: user)) {}
}
