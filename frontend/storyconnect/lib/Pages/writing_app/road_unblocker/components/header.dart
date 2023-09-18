part of '../view.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Road Unblocker",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
            onPressed: () {
              context.read<WritingUIBloc>().add(ToggleRoadUnblockerEvent());
            },
            icon: Icon(Icons.close))
      ],
    );
  }
}
