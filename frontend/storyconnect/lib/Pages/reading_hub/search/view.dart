import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/search/components/dialog.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 500, minWidth: 250, maxHeight: 50),
        child: SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Search',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (builderContext) {
                    return const SearchDialog();
                  });
            }));
  }
}
