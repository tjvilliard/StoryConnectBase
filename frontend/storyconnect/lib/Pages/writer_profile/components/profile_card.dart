import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/display_name_loader.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 700,
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns children at the start
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    // placeholder for now
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  DisplayNameLoaderWidget(
                      uid: FirebaseAuth.instance.currentUser!.uid)
                ],
              ),
              SizedBox(width: 20), // some spacing between columns
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bio", style: Theme.of(context).textTheme.titleLarge),
                    Text("Lorem ipsum // 100 characters"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
