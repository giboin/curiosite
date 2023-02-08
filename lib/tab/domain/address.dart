import 'package:curiosite/tab/domain/favicon.dart';
import 'package:curiosite/tools/tool_widget.dart';
import 'package:equatable/equatable.dart';

class Address extends Equatable {
  // TODO Address is abstract and each class extending Address is for a different tool ?
  final Tool tool;
  final String path;
  final String? title;
  final Favicon favicon;
  final DateTime date;

  Address(
      {required this.tool,
      required this.path,
      Favicon? favicon,
      this.title,
      DateTime? date})
      : date = date ?? DateTime.now(),
        favicon = favicon ?? Favicon(tool: tool);

  @override
  List<Object?> get props => [tool, path];

  static Future<Address> withBrowserFavicon(
      {required Tool tool,
      required String path,
      required String faviconUrl,
      String? title,
      DateTime? date}) async {
    return Address(
        tool: tool,
        path: path,
        favicon: await Favicon.browserFav(faviconUrl),
        title: title,
        date: date);
  }

  Map<String, dynamic> toJson() {
    return {
      'tool': Tool.values.indexOf(tool),
      'path': path,
      'title': title,
      'favicon': favicon.toJson(),
      'date': date.toString(),
    };
  }

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
        tool: Tool.values[json['tool']],
        path: json['path'],
        title: json['title'],
        favicon: Favicon.fromJson(json['favicon']),
        date: DateTime.parse(json['date']));
  }
}
