import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';

class RenderPageSliver extends RenderSliverFixedExtentList {
  RenderPageSliver({
    required super.itemExtent,
    required super.childManager,
  });

  @override
  SliverConstraints get constraints {
    return super.constraints.copyWith(crossAxisExtent: PageBloc.pageWidth);
  }
}

class PageSliver extends SliverMultiBoxAdaptorWidget {
  /// Creates a sliver that places box children with the same main axis extent
  /// in a linear array.
  const PageSliver({
    super.key,
    required super.delegate,
    required this.itemExtent,
  });

  /// The extent the children are forced to have in the main axis.
  final double itemExtent;

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
