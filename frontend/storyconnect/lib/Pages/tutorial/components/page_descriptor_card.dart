import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/tutorial/data.dart';

class PageDescriptorCard extends StatelessWidget {
  final TutorialPageData data;

  const PageDescriptorCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 15),
                if (data.imageUrl != null)
                  Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                      child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(data.imageUrl!))),
                const SizedBox(height: 15),
                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )));
  }
}
