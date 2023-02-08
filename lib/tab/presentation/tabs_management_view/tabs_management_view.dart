import 'package:curiosite/general_bloc/general_bloc.dart';
import 'package:curiosite/tab/domain/tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class TabsManagementView extends StatelessWidget {
  const TabsManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    double spacing = 20.0;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.plus_one),
          onPressed: () {
            context.read<GeneralBloc>().add(const NewTabEvent());
          },
        ),
      ),
      body: BlocBuilder<GeneralBloc, GeneralState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReorderableGridView.builder(
              itemCount: state.tabs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: 9 / 14,
              ),
              onReorder: (oldIndex, newIndex) {
                context
                    .read<GeneralBloc>()
                    .add(ReorderTabsEvent(oldIndex, newIndex));
              },
              itemBuilder: (context, index) {
                MyTab tab = state.tabs[index];
                int currentTabIndex =
                    context.read<GeneralBloc>().state.currentTabIndex;
                Color currentTabTopColor =
                    index == currentTabIndex ? Colors.white : Colors.black;

                return GestureDetector(
                  key: ValueKey(index),
                  onTap: () {
                    context
                        .read<GeneralBloc>()
                        .add(UpdateCurrentTabEvent(index));
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      color: index == currentTabIndex
                          ? Colors.blue[400]
                          : Colors.grey[400],
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Row(
                                children: [
                                  tab.currentFavicon
                                      .getImage(color: currentTabTopColor),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        tab.currentAddress.title ??
                                            "title beaucoup trop long pour lafficher",
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                            color: currentTabTopColor),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<GeneralBloc>()
                                        .add(DeleteTabEvent(index));
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: currentTabTopColor,
                                  )),
                            ],
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: tab.screenshot != null
                                      ? Image.memory(tab.screenshot!)
                                      : Container(color: Colors.grey[200])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      }),
    );
  }
}
