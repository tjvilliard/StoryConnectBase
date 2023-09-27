import 'dart:collection';

import 'package:storyconnect/Models/models.dart';

class sampleBooksData {
  static Map<String, List<Book>> buildSampleBooks() {
    List<String> tags = ["Romance, Mystery, Adventure"];

    List<Book> romanceBooks = [];
    List<Book> mysteryBooks = [];
    List<Book> adventureBooks = [
      Book(
          id: 501,
          title: "Heir to the Empire",
          created: DateTime.now(),
          modified: DateTime.now())
    ];

    HashMap<String, List<Book>> tagged_books =
        new HashMap<String, List<Book>>();

    Iterable<MapEntry<String, List<Book>>> entries = [
      MapEntry(tags[0], romanceBooks),
      MapEntry(tags[1], mysteryBooks),
      MapEntry(tags[2], adventureBooks)
    ];

    tagged_books.addEntries(entries);

    return tagged_books;
  }
}
