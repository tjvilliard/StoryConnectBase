part of 'writer_profile_bloc.dart';

abstract class WriterProfileEvent {
  const WriterProfileEvent();
}

class WriterProfileLoadEvent extends WriterProfileEvent {
  final String uid;
  const WriterProfileLoadEvent({required this.uid});
}

class MakeAnnouncementEvent extends WriterProfileEvent {
  final String title;
  final String content;
  const MakeAnnouncementEvent({required this.title, required this.content});
}

class RecievedProfileEvent extends WriterProfileEvent {
  final Profile profile;

  const RecievedProfileEvent({required this.profile});
}

class RecievedBooks extends WriterProfileEvent {
  final List<Book> books;

  const RecievedBooks({required this.books});
}

class RecievedAnnouncementsEvent extends WriterProfileEvent {
  final List<Announcement> announcements;

  const RecievedAnnouncementsEvent({required this.announcements});
}

class RecievedResponseEvent extends WriterProfileEvent {
  final String responseMessage;
  const RecievedResponseEvent({required this.responseMessage});
}

class RecievedActivitiesEvent extends WriterProfileEvent {
  final List<Activity> activities;
  const RecievedActivitiesEvent({required this.activities});
}

class WriterProfileEventClearEvent extends WriterProfileEvent {
  const WriterProfileEventClearEvent();
}

class ClearLastResponseEvent extends WriterProfileEvent {
  const ClearLastResponseEvent();
}

class EditBioEvent extends WriterProfileEvent {
  const EditBioEvent();
}

class EditBioStateEvent extends WriterProfileEvent {
  final String bio;
  const EditBioStateEvent({required this.bio});
}

class SaveBioEvent extends WriterProfileEvent {
  const SaveBioEvent();
}

class CancelBioEvent extends WriterProfileEvent {
  const CancelBioEvent();
}
