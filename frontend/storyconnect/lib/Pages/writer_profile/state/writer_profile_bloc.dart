import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'writer_profile_events.dart';
part 'writer_profile_state.dart';
part 'writer_profile_bloc.freezed.dart';

typedef WriterProfileEmitter = Emitter<WriterProfileState>;

class WriterProfileBloc extends Bloc<WriterProfileEvent, WriterProfileState> {
  WriterProfileBloc() : super(WriterProfileState.initial()) {
    on<WriterProfileEvent>((event, emit) => update(event, emit));
  }

  void update(WriterProfileEvent event, WriterProfileEmitter emit) async {
    emit(state.copyWith(
      name: 'name',
      bio: 'bio',
      avatar: 'avatar',
    ));
  }
}
