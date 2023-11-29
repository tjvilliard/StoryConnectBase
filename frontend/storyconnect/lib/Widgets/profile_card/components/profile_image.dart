import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Widgets/hover_button.dart';
import 'package:storyconnect/Widgets/image_loader.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:storyconnect/Widgets/profile_card/components/image_upload_dialog.dart';
import 'package:storyconnect/Widgets/profile_card/state/profile_card_bloc.dart';

class ProfileImage extends StatefulWidget {
  final Size? imageSize;
  const ProfileImage({super.key, this.imageSize});

  @override
  ProfileImageState createState() => ProfileImageState();
}

class ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    Color iconColor;
    Color backgroundColor;
    if (Theme.of(context).brightness == Brightness.dark) {
      iconColor = Colors.white;
      backgroundColor = Colors.grey[900]!;
    } else {
      iconColor = Colors.black;
      backgroundColor = Colors.grey[300]!;
    }

    return BlocBuilder<ProfileCardBloc, ProfileCardState>(
      builder: (context, state) {
        Widget toReturn;
        if (state.loadingStruct.isLoading == true) {
          toReturn = _loadingImageWidget(context, iconColor: iconColor, backgroundColor: backgroundColor);
        } else if (state.profile.imageUrl != null) {
          toReturn = Container(
              width: widget.imageSize?.width ?? 100,
              height: widget.imageSize?.height ?? 100,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(child: ImageLoader(url: state.profile.imageUrl!)));
        } else {
          toReturn = _noImageWidget(context);
        }

        // Wrapping the display with a Stack and an edit button if isEditing is true
        if (state.isEditing && state.loadingStruct.isLoading == false) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn),
              Center(
                child: HoverButton(
                    onPressed: () {
                      final bloc = context.read<ProfileCardBloc>();
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => EditProfileImageDialog(
                                bloc: bloc,
                              ));
                    },
                    label: const Text(
                      "Edit",
                    ),
                    icon: const Icon(
                      size: 10,
                      FontAwesomeIcons.pencil,
                      color: Colors.white,
                    )),
              ),
            ],
          );
        } else {
          return AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn);
        }
      },
    );
  }

  Widget _loadingImageWidget(BuildContext context, {Color? iconColor, Color? backgroundColor}) {
    return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey[300]!,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingWidget(
              loadingStruct: LoadingStruct.loading(true),
            ),
          ],
        ));
  }

  Widget _noImageWidget(BuildContext context, {Color? iconColor, Color? backgroundColor}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300]!,
        shape: BoxShape.circle,
      ),
      child: Icon(size: 50, FontAwesomeIcons.user, color: iconColor ?? Colors.black),
    );
  }
}
