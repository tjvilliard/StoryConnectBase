import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/tutorial/components/page_descriptor_card.dart';
import 'package:storyconnect/Pages/tutorial/components/tutorial_title_card.dart';
import 'package:storyconnect/Pages/tutorial/data.dart';

class TutorialPopupWidget extends StatelessWidget {
  const TutorialPopupWidget({super.key});

  static List<TutorialPageData> pages = [
    TutorialPageData(
        title: "Writer Home",
        description:
            "The Writer Home Page is where you can view your stories, and add new ones. To create a new book, click the 'Add New Book' button.",
        imageUrl: null),
    TutorialPageData(
        title: "Book Creation",
        description:
            "The Book Creation Page is where you can add a new book. You can add a title, description, and cover image, among other important details. Once you're done, click the 'Create Book' button.",
        imageUrl: null),
    TutorialPageData(
        title: "Writing Page",
        description:
            "The Writing Page is where you can view your book's details, edit the book, and add new chapters. Also be sure to play with our suite of AI-assisted writing tools, including the 'Continuity Checker' and 'Road-UnBlocker'!",
        imageUrl: null),
    TutorialPageData(
        title: "Reader Home",
        description:
            "After exiting the Writing Page, in the app bar you'll notice in the app bar a link to the Reader Home Page. There, you can view all of the books available on StoryConnect. You can also search for books by title, author, or genre.",
        imageUrl: null),
    TutorialPageData(
        title: "Reading Page",
        description:
            "When you click on a book. you'll be taken to the reading page for a book. There you can read through a book, and leave meaningful feedback for the author with optional text annotations. If feel as if you might enjoy a book your reading, be sure to add it to your personal library.",
        imageUrl: null),
    TutorialPageData(
        title: "Library Page",
        description:
            "You will also notice in the app bar, another link to the Library Page. The library page will list all the stories currently in your personal library. From here you can easily read a book or remove it from your library. ",
        imageUrl: null),
    TutorialPageData(
        title: "RoadUnblocker",
        description:
            "The RoadUnblocker is a tool that helps you get past writer's block. It uses OpenAI's GPT-3 to answer questions and generate suggestions for your story. It even remembers what youve written in previous chapters!",
        imageUrl: null),
    TutorialPageData(
        title: "Continuity Checker",
        description:
            "The Continuity Checker is a tool that helps you keep track of your story's continuity. It can identify contradictions in descriptions of characters, locations, and items in your story.",
        imageUrl: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(children: [
        Positioned(
            top: 10,
            right: 20,
            child: IconButton.filledTonal(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(FontAwesomeIcons.x))),
        Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TutorialTitleCard(),
                  Expanded(
                      child: ListView.separated(
                          itemCount: pages.length,
                          separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Divider()),
                          itemBuilder: (context, index) {
                            return PageDescriptorCard(data: pages[index]);
                          },
                          shrinkWrap: true))
                ])),
      ]),
    );
  }
}
