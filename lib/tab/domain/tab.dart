import 'dart:typed_data';

import 'package:curiosite/tab/domain/address.dart';
import 'package:curiosite/tab/domain/favicon.dart';
import 'package:curiosite/tools/tool_widget.dart';
import 'package:equatable/equatable.dart';

class MyTab extends Equatable {
  final Uint8List? screenshot;
  final List<Address>
      history; //will be used only for backend navigation purpose
  final int currentAddressIndex;
  final bool incognito;
  final bool pcVersion; //will be used only for the browser tool
  const MyTab({
    required this.history,
    required this.incognito,
    required this.pcVersion,
    int? currentAddressIndex,
    this.screenshot,
  }) : currentAddressIndex = currentAddressIndex ?? history.length - 1;

  Address get currentAddress => history[currentAddressIndex];
  Tool get currentTool => currentAddress.tool;
  String get currentPath => currentAddress.path;
  Favicon get currentFavicon => currentAddress.favicon;

  bool get canGoBack => currentAddressIndex > 0;
  bool get canGoForward => currentAddressIndex < history.length - 1;

  static MyTab newTab({bool incognito = false, bool pcVersion = false}) =>
      MyTab(
          screenshot: null,
          history: [Address(tool: Tool.home, path: "")],
          incognito: incognito,
          pcVersion: pcVersion);

  MyTab copyWith(
      {Uint8List? screenshot,
      List<Address>? history,
      int? currentAddressIndex,
      bool? incognito,
      bool? pcVersion}) {
    int index;
    if (currentAddressIndex != null) {
      index = currentAddressIndex;
    } else if (history != null) {
      index = history.length - 1;
    } else {
      index = this.currentAddressIndex;
    }
    return MyTab(
        screenshot: screenshot ?? this.screenshot,
        currentAddressIndex: index,
        history: history ?? this.history,
        incognito: incognito ?? this.incognito,
        pcVersion: pcVersion ?? this.pcVersion);
  }

  MyTab removeScreenshot() {
    return MyTab(
        screenshot: null,
        history: history,
        incognito: incognito,
        pcVersion: pcVersion);
  }

  @override
  List<Object?> get props =>
      [screenshot, history, incognito, pcVersion, currentAddressIndex];

  static MyTab fromJson(Map<String, dynamic> json) {
    return MyTab(
        currentAddressIndex: json['currentAddressIndex'],
        screenshot: json['screenshot'],
        history: (json['history'] as List<dynamic>)
            .map((address) => Address.fromJson(address))
            .toList(),
        incognito: json['incognito'],
        pcVersion: json['pcVersion']);
  }

  Map<String, dynamic> toJson() {
    return {
      'currentAddressIndex': currentAddressIndex,
      'screenshot': screenshot,
      'history': history.map((address) => address.toJson()).toList(),
      'incognito': incognito,
      'pcVersion': pcVersion,
    };
  }
}
