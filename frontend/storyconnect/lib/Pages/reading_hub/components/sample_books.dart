import 'dart:collection';

import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Models/models.dart';

class sampleBooksData {
  static List<Book> sample() {
    List<Book> sampleBooks = <Book>[
      new Book(
          id: 1000,
          title: "The Princess Bride",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          targetAudience: TargetAudience.youngAdult.index,
          copyright: CopyrightOption.allRightsReserved.index,
          modified: DateTime.now()),
      new Book(
          id: 1001,
          title: "The Age of Innocence",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          copyright: CopyrightOption.allRightsReserved.index,
          targetAudience: TargetAudience.youngAdult.index,
          modified: DateTime.now()),
      new Book(
          id: 1002,
          title: "Little Women",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          targetAudience: TargetAudience.youngAdult.index,
          copyright: CopyrightOption.allRightsReserved.index,
          modified: DateTime.now()),
      new Book(
          id: 1003,
          title: "The Notebook",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          copyright: CopyrightOption.allRightsReserved.index,
          targetAudience: TargetAudience.youngAdult.index,
          modified: DateTime.now()),
      new Book(
          id: 1004,
          title: "Pride and Prejudice",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          copyright: CopyrightOption.allRightsReserved.index,
          targetAudience: TargetAudience.youngAdult.index,
          modified: DateTime.now()),
      new Book(
        id: 1005,
        title: "Emma",
        created: DateTime.now(),
        language: LanguageConstant.english.label,
        copyright: CopyrightOption.allRightsReserved.index,
        targetAudience: TargetAudience.youngAdult.index,
        modified: DateTime.now(),
      ),
      new Book(
          id: 1006,
          title: "Wuthering Heights",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          copyright: CopyrightOption.allRightsReserved.index,
          targetAudience: TargetAudience.youngAdult.index,
          modified: DateTime.now()),
    ];

    return sampleBooks;
  }

  static Map<String, List<Book>> tagged() {
    Map<String, List<Book>> taggedBooks = new HashMap<String, List<Book>>();

    List<Book> sampleRomanceBooks = <Book>[
      new Book(
        id: 1000,
        title: "The Princess Bride",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      new Book(
        id: 1001,
        title: "The Age of Innocence",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      new Book(
        id: 1002,
        title: "Little Women",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      new Book(
        id: 1003,
        title: "The Notebook",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      new Book(
        id: 1004,
        title: "Pride and Prejudice",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      new Book(
        id: 1005,
        title: "Emma",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      new Book(
        id: 1006,
        title: "Wuthering Heights",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
    ];
    MapEntry<String, List<Book>> romanceEntries = new MapEntry(SampleBookTags.Romance.name, sampleRomanceBooks);

    MapEntry<String, List<Book>> sciFiEntries = new MapEntry<String, List<Book>>(SampleBookTags.Sci_fi.name, <Book>[]);

    MapEntry<String, List<Book>> historicalFiction =
        new MapEntry<String, List<Book>>(SampleBookTags.Historical_Fiction.name, <Book>[]);

    MapEntry<String, List<Book>> fantasyEntries =
        new MapEntry<String, List<Book>>(SampleBookTags.Fantasy.name, <Book>[]);

    MapEntry<String, List<Book>> nonFictionEntries =
        new MapEntry<String, List<Book>>(SampleBookTags.Non_Fiction.name, <Book>[]);

    taggedBooks.addEntries([romanceEntries, sciFiEntries, historicalFiction, fantasyEntries, nonFictionEntries]);

    return taggedBooks;
  }
}

enum SampleBookTags {
  Romance("Romance"),
  Sci_fi("Sci-Fi"),
  Historical_Fiction("Historical Fiction"),
  Fantasy("Fantasy"),
  Non_Fiction("Non-Fiction");

  const SampleBookTags(this.name);
  final String name;
}
