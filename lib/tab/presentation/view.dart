import 'package:curiosite/general_bloc/general_bloc.dart';
import 'package:curiosite/tab/domain/tab.dart';
import 'package:curiosite/tools/tool_widget.dart';
import 'package:curiosite/tab/presentation/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenshotController controller = ScreenshotController();
    return BlocBuilder<GeneralBloc, GeneralState>(
      builder: (context, state) {
        MyTab currentTab = state.currentTab;

        return Scaffold(
          appBar:
              appBar(context, currentTab.currentAddressIndex != 0, controller),
          body: Screenshot(
              controller: controller,
              child: SwitchTool(currentTab.currentTool)),
        );
      },
    );
  }
}
