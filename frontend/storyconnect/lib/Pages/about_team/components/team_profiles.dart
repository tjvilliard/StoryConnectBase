import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/about_team/components/team_picture.dart';
import 'package:storyconnect/Widgets/profile_card/view.dart';

class TeamProfilesWidget extends StatelessWidget {
  static const String dallinUid = "nyzEhr9I2hOigmkpbjaf47Gvc4C2";
  static const String davidUid = "mJjGhxkCzkYhap6YI9eWENxf7bz1";
  static const String tannerUid = "kkajneP6kiPaWhJGrhiwkUrgeZs1";
  static const String novellaUid = "W4RLw9vENAeb50YK9WT9ig481vu2";
  static const Size imageSize = Size(150, 150);
  const TeamProfilesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            TeamPictureWidget(),
            ProfileCardWidget(
              uid: dallinUid,
              forceNoEdit: true,
              imageSize: imageSize,
            ),
            ProfileCardWidget(
              uid: davidUid,
              forceNoEdit: true,
              imageSize: imageSize,
            ),
            ProfileCardWidget(
              uid: tannerUid,
              forceNoEdit: true,
              imageSize: imageSize,
            ),
            ProfileCardWidget(
              uid: novellaUid,
              forceNoEdit: true,
              imageSize: imageSize,
            ),
          ],
        ));
  }
}
