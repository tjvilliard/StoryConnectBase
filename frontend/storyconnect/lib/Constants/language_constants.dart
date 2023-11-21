enum LanguageConstant {
  english('English'),
  french('French'),
  spanish('Spanish'),
  german('German'),
  indonesian('Indonesian');

  const LanguageConstant(this.label);
  final String label;
}

LanguageConstant languageConstantFromString(String value) {
  switch (value) {
    case 'English':
      return LanguageConstant.english;
    case 'French':
      return LanguageConstant.french;
    case 'Spanish':
      return LanguageConstant.spanish;
    case 'German':
      return LanguageConstant.german;
    case 'Indonesian':
      return LanguageConstant.indonesian;
    default:
      return LanguageConstant.english;
  }
}
