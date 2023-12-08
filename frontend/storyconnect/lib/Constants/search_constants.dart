enum SearchModeConstant {
  story("Story"),
  title('Title'),
  synopsis('Synopsis'),
  author('Author');

  const SearchModeConstant(this.label);
  final String label;
}

SearchModeConstant searchModeConstantFromString(String value) {
  switch (value) {
    case "Story":
      return SearchModeConstant.story;
    case "Title":
      return SearchModeConstant.title;
    case "Synopsis":
      return SearchModeConstant.synopsis;
    case "Author":
      return SearchModeConstant.author;
    default:
      return SearchModeConstant.story;
  }
}
