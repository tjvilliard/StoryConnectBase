import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';

class WritingHomeView extends StatelessWidget {
  const WritingHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<WritingHomeBloc, WritingHomeStruct>(
            buildWhen: (previous, current) {
      return previous.books != current.books;
    }, builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: FilledButton.icon(
                onPressed: () {
                  final writingHomeBloc = context.read<WritingHomeBloc>();
                  writingHomeBloc.add(CreateBookEvent());
                },
                icon: Icon(FontAwesomeIcons.plus),
                label: Text("CreateBook")),
          ),
          Flexible(
              child: ListView.separated(
                  itemCount: state.books.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    Book book = state.books[index];
                    return FilledButton(
                      onPressed: () {
                        Beamer.of(context).beamToNamed("writer/$index");
                      },
                      child: Text(book.title),
                    );
                  }))
        ],
      );
    }));
  }
}
