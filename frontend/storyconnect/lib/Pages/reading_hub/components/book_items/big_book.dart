import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/book_cover.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/clickable.dart';

const String dummySynopsis =
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,";
const String dummyAuthor = "The illustrius joeseph joestar....";

class BigBook extends StatelessBookItem {
  final Book book;

  BigBook({required this.book});

  String yyMMddDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd();
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200.0,
        width: 400.0,
        child: Card(
            elevation: 3,
            child: Clickable(
                onPressed: () {
                  final uri = PageUrls.readBook(book.id);
                  Beamer.of(context).beamToNamed(uri, data: {"book": book});
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.book,
                          size: 175,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Text Widget
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    EdgeInsets.only(top: 12.0, bottom: 0.0),
                                constraints: BoxConstraints(
                                  maxHeight: 40.0,
                                  maxWidth: 190.0,
                                ),
                                child: Text(
                                  this.book.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                              // Title Text Widget

                              //Author Text Widget
                              Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                  constraints: BoxConstraints(
                                    maxHeight: 30.0,
                                    maxWidth: 190.0,
                                  ),
                                  child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(right: 4.0),
                                          child: Icon(Icons.person_outline,
                                              size: 16),
                                        )),
                                        TextSpan(
                                          text: dummyAuthor,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      ]))),
                              // Author Text Widget

                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 190.0,
                                  maxHeight: 20.0,
                                ),
                                child: Row(
                                  children: [
                                    // Chapter Info Text Widget
                                    RichText(
                                        text: TextSpan(children: [
                                      WidgetSpan(
                                        child: Icon(
                                          size: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .fontSize! +
                                              3,
                                          FontAwesomeIcons.list,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " 15",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ])),
                                    // Chapter Info Text Widget

                                    VerticalDivider(
                                      width: 20,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                          child: Icon(
                                            size: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .fontSize! +
                                                3,
                                            FontAwesomeIcons.pen,
                                          ),
                                        ),
                                        TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            text:
                                                " ${this.yyMMddDateTime(this.book.modified).toString()}"),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),

                              // Synopsis Text Widget
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: 190.0, maxHeight: 190.0),
                                        child: Text(dummySynopsis,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12)),
                                      ))),
                              // Synopsis Text Widget
                            ]),
                      ],
                    ),
                  ],
                ))));
  }
}
