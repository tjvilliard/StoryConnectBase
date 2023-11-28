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
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                if (data.imageUrl == null)
                  const Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: 200,
                  ),
                if (data.imageUrl != null) Image.network(data.imageUrl!),
                const SizedBox(height: 8),
                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )));
  }
}
