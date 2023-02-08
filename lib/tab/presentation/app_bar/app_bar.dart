import 'package:curiosite/general_bloc/general_bloc.dart';
import 'package:curiosite/tab/presentation/app_bar/menu.dart';
import 'package:curiosite/tab/presentation/app_bar/search_bar.dart';
import 'package:curiosite/tab/presentation/view.dart';
import 'package:curiosite/tools/tool_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

PreferredSizeWidget appBar(BuildContext context, bool backButton,
    ScreenshotController screenshotController) {
  return AppBar(
      leading: backButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<GeneralBloc>().add(const GoBackEvent());
              },
            )
          : Container(),
      title: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: searchBar(),
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: (() {
            context
                .read<GeneralBloc>()
                .add(ChangeScreenshotEvent(screenshotController));
            Navigator.pushNamed(context, "tabs_management_view");
          }),
          child: Center(
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white, width: 2.5)),
              child: Center(
                child: Text(
                    context.read<GeneralBloc>().state.tabs.length.toString()),
              ),
            ),
          ),
        ),
        appbarMenu(context),
      ]);
}
