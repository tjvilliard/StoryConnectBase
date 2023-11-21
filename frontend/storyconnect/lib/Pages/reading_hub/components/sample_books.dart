import 'dart:collection';

import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Models/models.dart';

class SampleBooksData {
  static List<Book> sample() {
    List<Book> sampleBooks = <Book>[
      Book(
          id: 1000,
          title: "The Princess Bride",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          targetAudience: TargetAudience.youngAdult.index,
          copyright: CopyrightOption.allRightsReserved.index,
          modified: DateTime.now()),
      Book(
          id: 1001,
          title: "The Age of Innocence",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          copyright: CopyrightOption.allRightsReserved.index,
          targetAudience: TargetAudience.youngAdult.index,
          modified: DateTime.now()),
      Book(
          id: 1002,
          title: "Little Women",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          targetAudience: TargetAudience.youngAdult.index,
          copyright: CopyrightOption.allRightsReserved.index,
          modified: DateTime.now()),
      Book(
          id: 1003,
          title: "The Notebook",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          copyright: CopyrightOption.allRightsReserved.index,
          targetAudience: TargetAudience.youngAdult.index,
          modified: DateTime.now()),
      Book(
          id: 1004,
          title: "Pride and Prejudice",
          created: DateTime.now(),
          language: LanguageConstant.english.label,
          copyright: CopyrightOption.allRightsReserved.index,
          targetAudience: TargetAudience.youngAdult.index,
          modified: DateTime.now()),
      Book(
        id: 1005,
        title: "Emma",
        created: DateTime.now(),
        language: LanguageConstant.english.label,
        copyright: CopyrightOption.allRightsReserved.index,
        targetAudience: TargetAudience.youngAdult.index,
        modified: DateTime.now(),
      ),
      Book(
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
    Map<String, List<Book>> taggedBooks = HashMap<String, List<Book>>();

    List<Book> sampleRomanceBooks = <Book>[
      Book(
        id: 1000,
        title: "The Princess Bride",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      Book(
        id: 1001,
        title: "The Age of Innocence",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      Book(
        id: 1002,
        title: "Little Women",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      Book(
        id: 1003,
        title: "The Notebook",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      Book(
        id: 1004,
        title: "Pride and Prejudice",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      Book(
        id: 1005,
        title: "Emma",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
      Book(
        id: 1006,
        title: "Wuthering Heights",
        created: DateTime.now(),
        modified: DateTime.now(),
        language: LanguageConstant.english.label,
        targetAudience: TargetAudience.youngAdult.index,
        copyright: CopyrightOption.allRightsReserved.index,
      ),
    ];
    MapEntry<String, List<Book>> romanceEntries = MapEntry(SampleBookTags.romance.name, sampleRomanceBooks);

    MapEntry<String, List<Book>> sciFiEntries = MapEntry<String, List<Book>>(SampleBookTags.sciFi.name, <Book>[]);

    MapEntry<String, List<Book>> historicalFiction =
        MapEntry<String, List<Book>>(SampleBookTags.historicalFiction.name, <Book>[]);

    MapEntry<String, List<Book>> fantasyEntries = MapEntry<String, List<Book>>(SampleBookTags.fantasy.name, <Book>[]);

    MapEntry<String, List<Book>> nonFictionEntries =
        MapEntry<String, List<Book>>(SampleBookTags.nonFiction.name, <Book>[]);

    taggedBooks.addEntries([romanceEntries, sciFiEntries, historicalFiction, fantasyEntries, nonFictionEntries]);

    return taggedBooks;
  }
}

enum SampleBookTags {
  romance("Romance"),
  sciFi("Sci-Fi"),
  historicalFiction("Historical Fiction"),
  fantasy("Fantasy"),
  nonFiction("Non-Fiction");

  const SampleBookTags(this.name);
  final String name;
}
