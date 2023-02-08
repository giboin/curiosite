import 'package:curiosite/tools/file_explorer/view.dart';
import 'package:curiosite/tools/home/home_view.dart';
import 'package:curiosite/tools/web_browser/presentation/view.dart';
import 'package:flutter/cupertino.dart';

enum Tool { home, browser, explorer }

abstract class ToolWidget extends StatelessWidget {
  const ToolWidget({super.key});
}

class SwitchTool extends ToolWidget {
  final Tool tool;
  const SwitchTool(this.tool, {super.key});

  @override
  Widget build(BuildContext context) {
    switch (tool) {
      case Tool.home:
        return const HomeView();
      case Tool.browser:
        return const BrowserView();
      case Tool.explorer:
        return const ExplorerView();
      default:
        return const HomeView();
    }
  }
}
