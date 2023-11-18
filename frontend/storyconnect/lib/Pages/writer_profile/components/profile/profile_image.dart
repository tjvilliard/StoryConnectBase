import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writer_profile/components/profile/image_upload_dialog.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Widgets/hover_button.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  ProfileImageState createState() => ProfileImageState();
}

class ProfileImageState extends State<ProfileImage> {
  bool _loadingImage = true;
  bool _hasLoadedImage = false;
  Image? _image;

  Future<void> loadProfileImage(String imageUrl) async {
    final image = Image.network(imageUrl);
    await precacheImage(image.image, context);
    setState(() {
      _image = image;
      _loadingImage = false;
      _hasLoadedImage = true;
    });
  }

  bool shouldLoadImage(WriterProfileState state) {
    return state.profile.imageUrl != null && _loadingImage == false && _hasLoadedImage == false;
  }

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

    return BlocConsumer<WriterProfileBloc, WriterProfileState>(
      listenWhen: (previous, current) =>
          previous.loadingStructs.profileLoadingStruct.isLoading !=
          current.loadingStructs.profileLoadingStruct.isLoading,
      listener: (context, state) {
        if (shouldLoadImage(state)) {
          setState(() {
            _loadingImage = true;
          });
          loadProfileImage(state.profile.imageUrl!);
        } else {
          setState(() {
            _loadingImage = false;
          });
        }
      },
      builder: (context, state) {
        Widget toReturn;
        if (state.loadingStructs.profileLoadingStruct.isLoading == true) {
          toReturn = _loadingImageWidget(context, iconColor: iconColor, backgroundColor: backgroundColor);
        } else if (state.profile.imageUrl != null) {
          toReturn = _image!;
        } else if (_loadingImage == true) {
          toReturn = _loadingImageWidget(context, iconColor: iconColor, backgroundColor: backgroundColor);
        } else {
          toReturn = _noImageWidget(context);
        }

        // Wrapping the display with a Stack and an edit button if isEditing is true
        if (state.isEditingBio &&
            state.loadingStructs.profileLoadingStruct.isLoading == false &&
            _loadingImage == false) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(duration: Duration(milliseconds: 500), child: toReturn),
              Center(
                child: HoverButton(
                    onPressed: () => showDialog(
                        barrierDismissible: false, context: context, builder: (context) => EditProfileImageDialog()),
                    label: Text("Edit", style: Theme.of(context).textTheme.labelMedium),
                    icon: Icon(
                      size: 10,
                      FontAwesomeIcons.pencil,
                      color: Colors.white,
                    )),
              ),
            ],
          );
        } else {
          return AnimatedSwitcher(duration: Duration(milliseconds: 500), child: toReturn);
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
      child: Icon(FontAwesomeIcons.person, color: iconColor ?? Colors.black),
    );
  }
}
