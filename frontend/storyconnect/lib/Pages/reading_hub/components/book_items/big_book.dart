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
  static const double sizeFactor = 1.1;
  static const double height = 200.0 * BigBook.sizeFactor;
  static const double width = 400.0 * BigBook.sizeFactor;
  static const double iconSize = 175.0 * BigBook.sizeFactor;
  static const double cardElevation = 3;
  static const double maxColumnWidth = width / 2.0;
  static const double synopsisBoxHeight = height / 2.0;
  final Book book;

  BigBook({required this.book});

  String yyMMddDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd();
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    double smallIconSize = Theme.of(context).textTheme.bodySmall!.fontSize! + 3;

    return Container(
        height: BigBook.height,
        width: BigBook.width,
        child: Card(
            elevation: BigBook.cardElevation,
            child: Clickable(
              onPressed: () {
                final uri = PageUrls.readBook(book.id);
                Beamer.of(context).beamToNamed(uri, data: {"book": book});
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.book,
                    size: BigBook.iconSize,
                  ),
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: BigBook.maxColumnWidth),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Text Widget
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 12.0, bottom: 0.0),
                            constraints: BoxConstraints(
                              maxHeight: 40.0,
                            ),
                            child: Text(
                              this.book.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          // Title Text Widget

                          //Author Text Widget
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              constraints: BoxConstraints(
                                maxHeight: 30.0,
                              ),
                              child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                      child: Icon(
                                        size: smallIconSize,
                                        Icons.person_outline,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " ${dummyAuthor}",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                  ]))),
                          // Author Text Widget

                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 30.0,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                // Chapter Info Text Widget
                                RichText(
                                    text: TextSpan(children: [
                                  WidgetSpan(
                                    child: Icon(
                                      size: smallIconSize,
                                      FontAwesomeIcons.list,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " 15",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ])),
                                // Chapter Info Text Widget

                                VerticalDivider(
                                  indent: 2.5,
                                  endIndent: 2.5,
                                  width: 20,
                                ),

                                // Date Widget
                                RichText(
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                      child: Icon(
                                        size: smallIconSize,
                                        FontAwesomeIcons.pen,
                                      ),
                                    ),
                                    TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        text:
                                            " ${this.yyMMddDateTime(this.book.modified)}"),
                                  ]),
                                ),
                                // Date Widget
                              ],
                            ),
                          ),

                          // Synopsis Text Widget
                          Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              constraints: BoxConstraints(
                                  maxHeight: BigBook.synopsisBoxHeight),
                              child: Text(dummySynopsis,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.bodySmall)),
                          // Synopsis Text Widget
                        ]),
                  ),
                ],
              ),
            )));
  }
}
