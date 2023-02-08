import 'package:bloc_test/bloc_test.dart';
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
  group("history and favorites (navigation, ...))", () {
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

    /* blocTest<GeneralBloc, GeneralState>(
      'ChangeScreenshotEvent : updates the screenshot from currentTab',
      build: () => bloc,
      act: (bloc) {
        bloc.add(ChangeScreenshotEvent(ScreenshotController));
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab(history: [
                Address(tool: Tool.home, path: ""),
              ], incognito: false, pcVersion: false, screenshot: Uint8List(10))
            ],
            currentTabIndex: 0,
            history: const [],
            favorites: const []),
      ],
    );
*/
    blocTest<GeneralBloc, GeneralState>(
      'TabUpdateHistoryEvent : remplaces the navigation history from currentTab',
      build: () => bloc,
      act: (bloc) {
        bloc.add(TabUpdateHistoryEvent([
          Address(tool: Tool.explorer, path: "/Downloads"),
          Address(tool: Tool.explorer, path: "/Downloads/truc"),
        ]));
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab(history: [
                Address(tool: Tool.explorer, path: "/Downloads"),
                Address(tool: Tool.explorer, path: "/Downloads/truc"),
              ], incognito: false, pcVersion: false)
            ],
            currentTabIndex: 0,
            history: const [],
            favorites: const []),
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'ChangeIncognitoEvent : switch incognito mode',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const ChangeIncognitoEvent(true));
        bloc.add(const ChangeIncognitoEvent(false));
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab.newTab(incognito: true),
            ],
            currentTabIndex: 0,
            history: const [],
            favorites: const []),
        GeneralState(
            tabs: [
              MyTab.newTab(),
            ],
            currentTabIndex: 0,
            history: const [],
            favorites: const []),
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'ChangePcVersionEvent : switch pcVersion mode',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const ChangePcVersionEvent(true));
        bloc.add(const ChangePcVersionEvent(false));
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab.newTab(pcVersion: true),
            ],
            currentTabIndex: 0,
            history: const [],
            favorites: const []),
        GeneralState(
            tabs: [
              MyTab.newTab(),
            ],
            currentTabIndex: 0,
            history: const [],
            favorites: const []),
      ],
    );
  });
}
