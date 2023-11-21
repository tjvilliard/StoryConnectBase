part of 'book_create_bloc.dart';

abstract class BookCreateEvent {
  const BookCreateEvent();
}

class TitleChangedEvent extends BookCreateEvent {
  final String title;
  const TitleChangedEvent({required this.title});
}

class LanguageChangedEvent extends BookCreateEvent {
  final String language;
  const LanguageChangedEvent({required this.language});
}

class TargetAudienceChangedEvent extends BookCreateEvent {
  final int targetAudience;
  TargetAudienceChangedEvent({required TargetAudience targetAudience}) : this.targetAudience = targetAudience.index;
}

class UploadImageEvent extends BookCreateEvent {
  const UploadImageEvent();
}

class SynopsisChangedEvent extends BookCreateEvent {
  final String? synopsis;
  SynopsisChangedEvent({required String? this.synopsis});
}

class CopyrightChangedEvent extends BookCreateEvent {
  final int copyright;
  CopyrightChangedEvent({required CopyrightOption copyrightOption}) : this.copyright = copyrightOption.index;
}

class SaveBookEvent extends BookCreateEvent {
  const SaveBookEvent();
}

class ResetEvent extends BookCreateEvent {
  const ResetEvent();
}
