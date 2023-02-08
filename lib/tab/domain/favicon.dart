// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:curiosite/tools/tool_widget.dart';

class Favicon extends Equatable {
  final Tool tool;
  final Uint8List? cachedImage;
  const Favicon({required this.tool, this.cachedImage})
      : assert(tool != Tool.browser || cachedImage != null);

  /// Argument tool will be used no matter what to determinate the favicon,
  /// but the url is only used if tool==Tool.browser
  static Future<Favicon> faviconFromAddress(
      Tool tool, String faviconUrl) async {
    switch (tool) {
      case Tool.home:
        return Favicon.homeFav();
      case Tool.explorer:
        return Favicon.explorerFav();
      case Tool.browser:
        return Favicon.browserFav(faviconUrl);
    }
  }

// examples for tests: https://www.google.com/favicon.ico or https://www.traveltothetop.fr/img/favicon.ico?1675345077
  static Future<Favicon> browserFav(String url) async {
    var response = await http.get(Uri.parse(url));
    var bytes = response.bodyBytes;
    return Favicon(tool: Tool.browser, cachedImage: bytes);
  }

  static Favicon explorerFav() {
    return Favicon(
      tool: Tool.explorer,
    );
  }

  static Favicon homeFav() {
    return Favicon(
      tool: Tool.home,
    );
  }

  Widget getImage(
      {double? width,
      double? height,
      double maxWidth = double.infinity,
      Color color = Colors.black}) {
    if (tool == Tool.home) {
      return Icon(
        Icons.home,
        color: color,
      );
    }
    if (tool == Tool.explorer) {
      return Icon(Icons.file_copy, color: color);
    }
    if (tool == Tool.browser && cachedImage != null) {
      Uint8List bytes = cachedImage!;
      return Image.memory(
        bytes,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.broken_image,
          size: width ?? height ?? maxWidth,
        ),
      );
    }
    return Icon(
      Icons.broken_image,
      size: width ?? height ?? maxWidth,
      color: color,
    );
  }

  @override
  List<Object> get props => [tool, cachedImage ?? []];

  Favicon copyWith({
    Tool? tool,
    Uint8List? cachedImage,
  }) {
    return Favicon(
      tool: tool ?? this.tool,
      cachedImage: cachedImage ?? this.cachedImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tool': Tool.values.indexOf(tool),
      'cachedImage': cachedImage?.map((e) => e.toInt()).toList(),
    };
  }

  factory Favicon.fromMap(Map<String, dynamic> map) {
    return Favicon(
      tool: Tool.values[map["tool"]],
      cachedImage: map['cachedImage'] != null
          ? Uint8List.fromList(map['cachedImage'].cast<int>().toList())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Favicon.fromJson(String source) =>
      Favicon.fromMap(json.decode(source) as Map<String, dynamic>);
}



// List<Favicon>? favicons = await faviconsFuture;
//         if (favicons != null && favicons.isNotEmpty) {
//           for (var fav in favicons) {
//             if (widget.webViewModel.favicon == null) {
//               widget.webViewModel.favicon = fav;
//             } else {
//               if ((widget.webViewModel.favicon!.width == null &&
//                       !widget.webViewModel.favicon!.url
//                           .toString()
//                           .endsWith("favicon.ico")) ||
//                   (fav.width != null &&
//                       widget.webViewModel.favicon!.width != null &&
//                       fav.width! > widget.webViewModel.favicon!.width!)) {
//                 widget.webViewModel.favicon = fav;
//               }
//             }
//           }
//         }
