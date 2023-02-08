import 'package:bloc_test/bloc_test.dart';
import 'package:curiosite/general_bloc/general_bloc.dart';
import 'package:curiosite/tab/domain/address.dart';
import 'package:curiosite/tab/domain/tab.dart';
import 'package:curiosite/tools/tool_widget.dart';
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

    blocTest<GeneralBloc, GeneralState>(
      'GeneralUpdateHistoryEvent : remplace old general history',
      build: () => bloc,
      act: (bloc) {
        bloc.add(GeneralUpdateHistoryEvent([
          Address(tool: Tool.explorer, path: "/Downloads"),
          Address(tool: Tool.home, path: "www.google.com", title: "google")
        ]));
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [MyTab.newTab()],
            currentTabIndex: 0,
            history: [
              Address(tool: Tool.explorer, path: "/Downloads"),
              Address(tool: Tool.home, path: "www.google.com", title: "google")
            ],
            favorites: const [])
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'GeneralAppendHistoryEvent : appends a new address to general history',
      build: () => bloc,
      act: (bloc) => bloc.add(GeneralAppendHistoryEvent(
          Address(tool: Tool.explorer, path: "/Downloads"))),
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [MyTab.newTab()],
            currentTabIndex: 0,
            history: [
              Address(tool: Tool.explorer, path: "/Downloads"),
            ],
            favorites: const [])
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'UpdateFavoritesEvent : remplace old favorites list',
      build: () => bloc,
      act: (bloc) async => bloc.add(UpdateFavoritesEvent([
        Address(tool: Tool.explorer, path: "/Downloads"),
        Address(tool: Tool.home, path: "www.google.com", title: "google")
      ])),
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [MyTab.newTab()],
            currentTabIndex: 0,
            history: const [],
            favorites: [
              Address(tool: Tool.explorer, path: "/Downloads"),
              Address(tool: Tool.home, path: "www.google.com", title: "google")
            ])
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'AppendFavoritesEvent : appends a new address to general history',
      build: () => bloc,
      act: (bloc) {
        bloc.add(AppendFavoritesEvent(
            Address(tool: Tool.explorer, path: "/Downloads")));
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [MyTab.newTab()],
            currentTabIndex: 0,
            history: const [],
            favorites: [
              Address(tool: Tool.explorer, path: "/Downloads"),
            ])
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'PushAddressEvent : appends a new address to currentTab history and general history, and changes currentTab currentHistoryIndex',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/Downloads")),
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab(history: [
                Address(tool: Tool.home, path: ""),
                Address(tool: Tool.explorer, path: "/Downloads"),
              ], incognito: false, pcVersion: false, currentAddressIndex: 1)
            ],
            currentTabIndex: 0,
            history: const [],
            favorites: const []),
        GeneralState(
            tabs: [
              MyTab(history: [
                Address(tool: Tool.home, path: ""),
                Address(tool: Tool.explorer, path: "/Downloads"),
              ], incognito: false, pcVersion: false, currentAddressIndex: 1)
            ],
            currentTabIndex: 0,
            history: [
              Address(tool: Tool.explorer, path: "/Downloads"),
            ],
            favorites: const []),
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'GoBackEvent : appends a new address to general history',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const GoBackEvent());
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/Downloads"));
        bloc.add(const GoBackEvent());
      },
      skip: 2,
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab(history: [
                Address(tool: Tool.home, path: ""),
                Address(tool: Tool.explorer, path: "/Downloads"),
              ], incognito: false, pcVersion: false, currentAddressIndex: 0)
            ],
            currentTabIndex: 0,
            history: [
              Address(tool: Tool.explorer, path: "/Downloads"),
            ],
            favorites: const []),
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'GoForwardEvent : appends a new address to general history',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const GoForwardEvent());
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/Downloads"));
        bloc.add(const GoBackEvent());
        bloc.add(const GoForwardEvent());
      },
      skip: 3,
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab(history: [
                Address(tool: Tool.home, path: ""),
                Address(tool: Tool.explorer, path: "/Downloads"),
              ], incognito: false, pcVersion: false, currentAddressIndex: 1)
            ],
            currentTabIndex: 0,
            history: [
              Address(tool: Tool.explorer, path: "/Downloads"),
            ],
            favorites: const []),
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'PushAddressEvent : rewrites tab history if it can go forward',
      build: () => bloc,
      act: (bloc) {
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/other"));
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/Downloads"));
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/Downloads"));
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/other2"));
        bloc.add(const GoBackEvent());
        bloc.add(const GoBackEvent());
        bloc.add(const GoBackEvent());
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/other"));
      },
      skip: 10,
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab(history: [
                Address(tool: Tool.home, path: ""),
                Address(tool: Tool.explorer, path: "/other"),
              ], incognito: false, pcVersion: false, currentAddressIndex: 1)
            ],
            currentTabIndex: 0,
            history: [
              Address(tool: Tool.explorer, path: "/other"),
              Address(tool: Tool.explorer, path: "/Downloads"),
              Address(tool: Tool.explorer, path: "/other2"),
              Address(tool: Tool.explorer, path: "/other"),
            ],
            favorites: const []),
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'PushAddressEvent : do nothing if you push two times the same address',
      build: () => bloc,
      act: (bloc) {
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/Downloads"));
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/Downloads"));
      },
      skip: 2,
      expect: () => <GeneralState>[],
    );

    blocTest<GeneralBloc, GeneralState>(
      'PushAddressEvent : dont add home to general history',
      build: () => bloc,
      act: (bloc) {
        bloc.add(PushAddressEvent(tool: Tool.explorer, path: "/Downloads"));
        bloc.add(PushAddressEvent(tool: Tool.home, path: ""));
      },
      skip: 2,
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab(history: [
                Address(tool: Tool.home, path: ""),
                Address(tool: Tool.explorer, path: "/Downloads"),
                Address(tool: Tool.home, path: ""),
              ], incognito: false, pcVersion: false, currentAddressIndex: 2)
            ],
            currentTabIndex: 0,
            history: [
              Address(tool: Tool.explorer, path: "/Downloads"),
            ],
            favorites: const []),
      ],
    );
  });
}
