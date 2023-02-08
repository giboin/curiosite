import 'package:flutter/material.dart';

Widget appbarMenu(BuildContext context) {
  return PopupMenuButton(
    onSelected: (result) async {},
    itemBuilder: (context) => [
      const PopupMenuItem(
        child: Text("item"),
      ),
    ],
  );
}
