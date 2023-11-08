import 'dart:convert';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:http/http.dart' as http;
import 'package:storyconnect/Services/url_service.dart';

class LibraryApiProvider {
  Future<String> getAuthToken() async {
    return (await FirebaseAuth.instance.currentUser!.getIdToken(true))
        as String;
  }

  Stream<MapEntry<Library, Book>> getLibraryBooks() async* {
    try {
      final url = UrlContants.getUserLibrary();

      final result = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${await getAuthToken()}',
      });

      for (var map in jsonDecode(result.body)) {
        print(map);
        LibraryBook decode = LibraryBook.fromJson(map);

        yield new MapEntry<Library, Book>(
          new Library(
            id: decode.id,
            status: decode.status,
          ),
          decode.book,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  /// API endpoint for adding a new entry to a user's library.
  Future<void> addBooktoLibrary(LibraryEntrySerializer serializer) async {
    try {
      final url = UrlContants.addLibraryBook();

      await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${await getAuthToken()}'
          },
          body: (jsonEncode(serializer.toJson())));
    } catch (e) {
      print(e);
    }
  }

  /// API endpoint for removing an entry from a user's library.
  Future<void> removeBookFromLibrary(LibraryEntrySerializer serializer) async {
    try {
      final url = UrlContants.removeLibraryBook(serializer.id!);

      await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${await getAuthToken()}'
        },
      );
    } catch (e) {
      print(e);
    }
  }
}

class LibraryRepository {
  Map<Library, Book> libraryBookMap = {};
  LibraryApiProvider _api = LibraryApiProvider();

  void getLibraryBooks() async {
    this.libraryBookMap.clear();
    await for (MapEntry<Library, Book> entry in this._api.getLibraryBooks()) {
      this.libraryBookMap.addEntries([entry]);
    }
  }

  void removeLibraryBook(LibraryEntrySerializer serialzier) async {
    await this._api.removeBookFromLibrary(serialzier);
    this.getLibraryBooks();
  }

  void addLibraryBook(LibraryEntrySerializer serialzier) async {
    await this._api.addBooktoLibrary(serialzier);
    this.getLibraryBooks();
  }
}
