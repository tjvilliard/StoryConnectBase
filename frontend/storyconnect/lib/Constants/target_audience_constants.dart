enum TargetAudience {
  children("Children"),
  youngAdult("Young Adult"),
  adult("Adult (18+)");

  const TargetAudience(this.label);
  final String label;
}

TargetAudience targetAudienceFromIndex(int index) {
  switch (index) {
    case 0:
      return TargetAudience.children;
    case 1:
      return TargetAudience.youngAdult;
    case 2:
      return TargetAudience.adult;
    default:
      return TargetAudience.children;
  }
}
