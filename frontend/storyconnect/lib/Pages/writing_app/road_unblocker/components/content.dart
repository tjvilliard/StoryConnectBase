import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/road_unblocker/components/empty_content.dart';
import 'package:storyconnect/Pages/writing_app/road_unblocker/components/road_unblock_response.dart';
import 'package:storyconnect/Pages/writing_app/road_unblocker/state/road_unblocker_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class RoadUnblockerContent extends StatelessWidget {
  const RoadUnblockerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadUnblockerBloc, RoadUnblockerState>(
      builder: (context, state) {
        if (state.loadingStruct.isLoading)
          return LoadingWidget(loadingStruct: state.loadingStruct);
        if (state.responses.isEmpty) return EmptyContent();

        return ListView.builder(
            itemCount: state.responses.length,
            itemBuilder: (context, index) {
              return RoadUnblockResponseWidget(
                response: state.responses[index],
              );
            });
      },
    );
  }
}
