// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:curiosite/general_bloc/general_bloc.dart';
import 'package:curiosite/tab/domain/address.dart';
import 'package:curiosite/tab/domain/tab.dart';
import 'package:curiosite/tools/tool_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('json and hydrated bloc', () {
    late GeneralBloc bloc;
    late Storage storage;
    setUp(() async {
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
      bloc = GeneralBloc();
    });
    tearDown(() {
      bloc.close();
    });
    test('GeneralBloc HydratedBloc save test (toJson and fromJson)', () async {
      // Build our app and trigger a frame.
      //await tester.pumpWidget(const MyApp());

      // Verify that our counter starts at 0.
      // expect(find.text('0'), findsOneWidget);
      // expect(find.text('1'), findsNothing);

      // // Tap the '+' icon and trigger a frame.
      // await tester.tap(find.byIcon(Icons.add));
      // await tester.pump();

      // // Verify that our counter has incremented.
      // expect(find.text('0'), findsNothing);
      // expect(find.text('1'), findsOneWidget);

      final MyTab tab = MyTab(
          screenshot: Uint8List(1),
          history: [
            await Address.withBrowserFavicon(
                tool: Tool.browser,
                path: "path",
                faviconUrl: "https://www.google.com/favicon.ico")
          ],
          incognito: true,
          pcVersion: false);

      final MyTab tab2 = MyTab(
          screenshot: Uint8List(0),
          history: [Address(tool: Tool.explorer, path: "path2")],
          incognito: false,
          pcVersion: true);

      final GeneralState state = GeneralState(
          tabs: [tab, tab2],
          currentTabIndex: 1,
          history: [
            await Address.withBrowserFavicon(
                tool: Tool.browser,
                faviconUrl: "https://www.google.com/favicon.ico",
                path: "path"),
            Address(tool: Tool.explorer, path: "path2")
          ],
          favorites: [Address(tool: Tool.explorer, path: "path2")]);

      final GeneralBloc general = GeneralBloc();
      general.emit(state);

      expect(general.fromJson(general.toJson(state) ?? {}), state);
    });
  });
}
