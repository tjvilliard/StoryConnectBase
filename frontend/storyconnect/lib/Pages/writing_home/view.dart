import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class WritingHomeView extends StatefulWidget {
  const WritingHomeView({Key? key}) : super(key: key);

  @override
  WritingHomeState createState() => WritingHomeState();
}

class WritingHomeState extends State<WritingHomeView> {
  final TextEditingController textController = TextEditingController();
  bool initialLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialLoad) {
        initialLoad = false;
        final writingHomeBloc = context.read<WritingHomeBloc>();
        writingHomeBloc.add(GetBooksEvent());
      }
    });
  }

  void create(BuildContext context) {
    final writingHomeBloc = context.read<WritingHomeBloc>();
    writingHomeBloc.add(
      CreateBookEvent(title: textController.text.trim()),
    );
    textController.text = "";
  }

  void openBook(WritingHomeBloc state) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WritingHomeBloc, WritingHomeStruct>(
        listener: (context, state) {
          if (state.bookToNavigate != null) {
            final url = "/writer/${state.bookToNavigate!.id}";
            Beamer.of(context).beamToNamed(url, data: {
              "book": state.bookToNavigate,
            });
          }
        },
        buildWhen: (previous, current) {
          final loadingDiff = previous.loadingStruct != current.loadingStruct;
          final bookDiff = previous.books != current.books;
          return bookDiff || loadingDiff;
        },
        builder: (context, state) {
          int addLoading = 0;
          if (state.loadingStruct.isLoading) {
            addLoading++;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    //Add Book Widget
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onSubmitted: (_) => state.loadingStruct.isLoading
                            ? null
                            : create(context),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: FilledButton.icon(
                        onPressed: () => state.loadingStruct.isLoading
                            ? null
                            : create(context),
                        icon: Icon(FontAwesomeIcons.plus),
                        label: Text("CreateBook"),
                      ),
                    ),
                  ],
                ),
              ),
              //GridView of Books
              Flexible(
                  child: Container(
                      padding: EdgeInsets.only(left: 100, right: 100),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: 10, maxCrossAxisExtent: 150),

                        itemCount: state.books.length + addLoading,

                        //Fills out the books in book state
                        itemBuilder: (context, index) {
                          if (index == state.books.length) {
                            return Center(
                                child: LoadingWidget(
                              loadingStruct: state.loadingStruct,
                            ));
                          }

                          Book book = state.books[index];
                          return Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(),
                              child: FilledButton(
                                onPressed: () {
                                  final writingHomeBloc =
                                      context.read<WritingHomeBloc>();
                                  writingHomeBloc
                                      .add(OpenBookEvent(book: book));
                                },
                                child: Text(book.title),
                              ));
                        },
                      ))),
            ],
          );
        },
      ),
    );
  }
}
