import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Blocs/user/user_bloc.dart';

class ProfileCard extends StatelessWidget {
  final int? userId;
  const ProfileCard({super.key, this.userId});

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
                  Text(
                      userId != null
                          ? context.read<UserBloc>().state.user!.displayName ??
                              "No display name"
                          : "To implement",
                      style: Theme.of(context).textTheme.titleMedium),
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
