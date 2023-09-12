enum CopyrightOption {
  allRightsReserved("All Rights Reserved: No part of this publication ..."),
  publicDomain("Public Domain: This story is open source ..."),
  creativeCommons("Creative Commons (CC) Attribution: Author of the story ...");

  const CopyrightOption(this.description);
  final String description;
}
