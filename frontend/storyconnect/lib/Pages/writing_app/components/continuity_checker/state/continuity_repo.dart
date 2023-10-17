part of 'continuity_bloc.dart';

// populate with dummy data for now
class ContinuityCheckerApi {
  const ContinuityCheckerApi();
  Future<ContinuityResponse> getContinuities(int chapterId) async {
    // final url = UrlContants.continuities();
    // String authToken =
    //     (await FirebaseAuth.instance.currentUser!.getIdToken(true)) as String;
    // final result = await http.get(url, headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    //   'Authorization': 'Token $authToken'
    // });
    // return ContinuityResponse.fromJson(jsonDecode(result.body));

    return ContinuityResponse(
      suggestions: [
        ContinuitySuggestion(
          description: 'This is a suggestion',
          chapterId: chapterId,
          uuid: '1234',
          suggestionType: 'suggestion',
        ),
        ContinuitySuggestion(
          description: 'This is a warning',
          uuid: '1234',
          suggestionType: 'warning',
          chapterId: chapterId,
        ),
        ContinuitySuggestion(
          description: 'This is an error',
          uuid: '1234',
          suggestionType: 'error',
          chapterId: chapterId,
        ),
      ],
    );
  }
}

class ContinuityRepo {
  final ContinuityCheckerApi api;
  ContinuityRepo({this.api = const ContinuityCheckerApi()});

  Future<ContinuityResponse?> getContinuities(int chapterId) async {
    return api.getContinuities(chapterId);
  }
}
