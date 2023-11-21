import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/empty_content.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/road_unblock_response.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/state/road_unblocker_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class RoadUnblockerContent extends StatelessWidget {
  const RoadUnblockerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadUnblockerBloc, RoadUnblockerState>(
      builder: (context, state) {
        if (state.loadingStruct.isLoading && state.responses.isEmpty) {
          return LoadingWidget(loadingStruct: state.loadingStruct);
        }
        if (state.responses.isEmpty) {
          return const Column(
              mainAxisSize: MainAxisSize.min, children: [EmptyContent()]);
        }

        // if there is already a response and we are loading, add the loading widget to the end of the list
        final responses = state.loadingStruct.isLoading
            ? [...state.responses, null]
            : state.responses;

        return ListView.builder(
            itemCount: responses.length,
            itemBuilder: (context, index) {
              final response = responses[index];

              if (response == null) {
                return LoadingWidget(loadingStruct: state.loadingStruct);
              } else {
                return RoadUnblockResponseWidget(
                  response: response,
                );
              }
            });
      },
    );
  }
}
