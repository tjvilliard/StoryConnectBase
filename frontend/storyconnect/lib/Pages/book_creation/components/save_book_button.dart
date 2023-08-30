import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class SaveBookButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookCreateBloc, BookCreateState>(
        builder: (context, state) {
      return Column(
        children: [
          if (state.loadingStruct.isLoading)
            LoadingWidget(loadingStruct: state.loadingStruct),
          if (state.loadingStruct.message != null &&
              state.loadingStruct.message!.isNotEmpty)
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(state.loadingStruct.message!)),
          if (state.loadingStruct.isLoading == false)
            Padding(
                padding: EdgeInsets.all(10),
                child: FilledButton(
                  child: Text(
                    "Create Book",
                  ),
                  onPressed: () {
                    context.read<BookCreateBloc>().add(SaveBookEvent());
                  },
                ))
        ],
      );
    });
  }
}
