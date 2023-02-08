import 'package:curiosite/general_bloc/general_bloc.dart';
import 'package:curiosite/tools/tool_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget searchBar() {
  return BlocBuilder<GeneralBloc, GeneralState>(builder: (context, state) {
    return TextField(
      keyboardType: TextInputType.url,
      controller: TextEditingController(text: state.currentTab.currentPath),
      onSubmitted: (text) {
        //ModelProvider.of(context).search(text.trim());
      },
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              context.read<GeneralBloc>().add(
                  PushAddressEvent(tool: Tool.explorer, path: "/Downloads"));

              // ModelProvider.of(context).searchBarTextController.text = "";
              // ModelProvider.of(context).searchBarFocusNode.requestFocus();
            },
          ),
          hintText: 'Search...',
          border: InputBorder.none),
    );
  });
}
