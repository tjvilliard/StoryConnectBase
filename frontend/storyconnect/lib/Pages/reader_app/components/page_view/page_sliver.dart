import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RenderPageSliver extends RenderSliverFixedExtentList {
  static double pageHeight = 1000.0;
  static double pageWidth = 800.0;

  RenderPageSliver({
    required super.childManager,
    required super.itemExtent,
  });

  @override
  SliverConstraints get constraints {
    return super.constraints.copyWith(crossAxisExtent: pageWidth);
  }
}

class PageSliver extends SliverMultiBoxAdaptorWidget {
  final double itemExtent;

  const PageSliver({
    super.key,
    required super.delegate,
    required this.itemExtent,
  });

  @override
  RenderSliverFixedExtentList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderPageSliver(childManager: element, itemExtent: itemExtent);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverFixedExtentList renderObject) {
    renderObject.itemExtent = itemExtent;
  }
}
