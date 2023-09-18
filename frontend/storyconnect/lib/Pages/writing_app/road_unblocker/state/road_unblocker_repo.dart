part of 'road_unblocker_bloc.dart';

// populate with dummy data for now
class RoadUnblockerApi {
  const RoadUnblockerApi();
  Future<RoadUnblockerResponse> submitUnblock(
      RoadUnblockerRequest request) async {
    return RoadUnblockerResponse(
        message:
            "Ok, got it. So it looks like you're stuck on Chapter 1. Lets take a look at what we can do:",
        suggestions: [
          RoadUnblockerSuggestion(
              offsetStart: 50,
              offsetEnd: 100,
              suggestion:
                  "You could talk more about the character's motivations here.",
              replacement:
                  "Jonathan isn't sure why he's doing this. He's just following orders.",
              original: ""),
          RoadUnblockerSuggestion(
              offsetStart: 150,
              offsetEnd: 200,
              suggestion:
                  "It looks like you're heading to planet Earth. Perhaps your character is banned from Earth?",
              replacement:
                  "Jonathan, although banned from Earth, needed to go home, if only to this one last time.",
              original: ""),
          RoadUnblockerSuggestion(
              offsetStart: 50,
              offsetEnd: 80,
              suggestion:
                  "You set your character up as a rebel, but he's not acting like one.",
              original:
                  "Jonathan isn't sure why he's doing this. He's just following orders.",
              replacement:
                  "Jonathan spits in the face of his commanding officer and defiantly says, 'Sir, yes sir'"),
        ]);
  }
}

class RoadUnblockerRepo {
  final RoadUnblockerApi api;
  RoadUnblockerRepo({this.api = const RoadUnblockerApi()});

  Future<RoadUnblockerResponse> submitUnblock(
      RoadUnblockerRequest request) async {
    return await api.submitUnblock(request);
  }
}
