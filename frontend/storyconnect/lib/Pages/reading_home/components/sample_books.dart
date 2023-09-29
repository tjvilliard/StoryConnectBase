import 'dart:collection';

import 'package:storyconnect/Models/models.dart';

class sampleBooksData {
  static Map<String, List<Book>> build() {
    Map<String, List<Book>> taggedBooks = new HashMap<String, List<Book>>();

    List<Book> sampleRomanceBooks = <Book>[
      new Book(
          id: 1000,
          title: "The Princess Bride",
          created: DateTime.now(),
          modified: DateTime.now()),
      new Book(
          id: 1001,
          title: "The Age of Innocence",
          created: DateTime.now(),
          modified: DateTime.now()),
      new Book(
          id: 1002,
          title: "Little Women",
          created: DateTime.now(),
          modified: DateTime.now()),
      new Book(
          id: 1003,
          title: "The Notebook",
          created: DateTime.now(),
          modified: DateTime.now()),
      new Book(
          id: 1004,
          title: "Pride and Prejudice",
          created: DateTime.now(),
          modified: DateTime.now()),
      new Book(
        id: 1005,
        title: "Emma",
        created: DateTime.now(),
        modified: DateTime.now(),
      ),
      new Book(
          id: 1006,
          title: "Wuthering Heights",
          created: DateTime.now(),
          modified: DateTime.now()),
    ];
    MapEntry<String, List<Book>> romanceEntries =
        new MapEntry(SampleBookTags.Romance.name, sampleRomanceBooks);

    taggedBooks.addEntries([romanceEntries]);

    return taggedBooks;
  }
}

enum SampleBookTags {
  Romance("Romance"),
  Sci_fi("Sci-Fi"),
  Historical_Fiction("Historical Fiction"),
  Fantasy(""),
  Non_Fiction(""),
  ;

  const SampleBookTags(this.name);
  final String name;
}
