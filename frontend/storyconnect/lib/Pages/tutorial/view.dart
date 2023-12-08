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
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2FScreenshot%202023-11-28%20at%207.43.43%E2%80%AFPM.png?alt=media&token=666a4e01-6ad4-4cd0-8b60-779bfbf5045a"),
    TutorialPageData(
        title: "Book Creation",
        description:
            "The Book Creation Page is where you can add a new book. You can add a title, description, and cover image, among other important details. Once you're done, click the 'Create Book' button.",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2FScreenshot%202023-11-28%20at%207.44.47%E2%80%AFPM.png?alt=media&token=5bb3baf4-1989-44c6-b1b9-ce4d3fe1c7c0"),
    TutorialPageData(
        title: "Writing Page",
        description:
            "The Writing Page is where you can view your book's details, edit the book, and add new chapters. Also be sure to play with our suite of AI-assisted writing tools, including the 'Continuity Checker' and 'Road-UnBlocker'!",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2FScreenshot%202023-11-28%20at%207.46.07%E2%80%AFPM.png?alt=media&token=56844c4b-bb13-40b0-a4e4-12623b8d9189"),
    TutorialPageData(
        title: "Reader Home",
        description:
            "After exiting the Writing Page, in the app bar you'll notice in the app bar a link to the Reader Home Page. There, you can view all of the books available on StoryConnect. You can also search for books by title, author, or genre.",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2FHome%20Page%20Screenshot.png?alt=media&token=cbeb8ec1-63e8-4e74-b662-9ae18fdeaaef"),
    TutorialPageData(
        title: "Book Search",
        description:
            "From the Reader's Home, you will notice a search bar, clicking on this will bring you the search function, where you can search for books with a few filters. ",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2FSearch%20Page.png?alt=media&token=8fe3b752-a737-43f5-8a9d-baba577e84c4"),
    TutorialPageData(
        title: "Reading Page",
        description:
            "When you click on a book. you'll be taken to the reading page for a book. There you can read through a book, and leave meaningful feedback for the author with optional text annotations. If feel as if you might enjoy a book your reading, be sure to add it to your personal library.",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2FReading%20Page.png?alt=media&token=9edfc42f-da52-4b01-ab76-25343bd7b99c"),
    TutorialPageData(
        title: "Library Page",
        description:
            "You will also notice in the app bar, another link to the Library Page. The library page will list all the stories currently in your personal library. From here you can easily read a book or remove it from your library. ",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2FUpdated%20Library%20Screenshot.png?alt=media&token=6904b96a-7dc4-4f6a-a696-5e9b6eef8cf3"),
    TutorialPageData(
        title: "RoadUnblocker",
        description:
            "The RoadUnblocker is a tool that helps you get past writer's block. It uses OpenAI's GPT-3 to answer questions and generate suggestions for your story. It even remembers what youve written in previous chapters!",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2Fru_fullscreen.png?alt=media&token=90d91564-f500-4111-ab63-b5e98d30fff1"),
    TutorialPageData(
        title: "Continuity Checker",
        description:
            "The Continuity Checker is a tool that helps you keep track of your story's continuity. It can identify contradictions in descriptions of characters, locations, and items in your story.",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/storyconnect-9c7dd.appspot.com/o/about_images%2Fcontinuity_fullscreen.png?alt=media&token=f6d75add-b220-40cd-a5f8-0643d8b6d581"),
    TutorialPageData(
        title: "Content Tagging",
        description:
            "Content tagging is a machine learning based - specifically for text analysis - feature tool to help generate recommended genres of a book by assessing the content of each chapter of the book.",
        imageUrl: null),
    TutorialPageData(
        title: "User-Based Book Recommendation ",
        description:
            "When user lands on the reader's home page, you can see the list of books recommended by the system using machine learning model based on the user's recorded preferences, specifically based on the book rating aspect.",
        imageUrl: null),
    TutorialPageData(
        title: "Content-Based Book Recommendation ",
        description:
            "In addition to the user-based book recommendation, users are also provided with recommendation assessed based on the text analysis of the similarities of the content of the books.",
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
