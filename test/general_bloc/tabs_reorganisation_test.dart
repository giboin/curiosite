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
  group("tabs reorganisation (adding, deleting, changing order...)", () {
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

    test("bloc initialisation", () {
      expect(bloc.state, GeneralInitialState());
    });

    blocTest<GeneralBloc, GeneralState>(
      'NewTabEvent : adds a tab and changes the currentTabIndex when Event is called.',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const NewTabEvent());
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [MyTab.newTab(), MyTab.newTab()],
            currentTabIndex: 1,
            history: const [],
            favorites: const [])
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'NewTabEvent : try adding several identical tabs',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const NewTabEvent());
        bloc.add(const NewTabEvent());
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [MyTab.newTab(), MyTab.newTab()],
            currentTabIndex: 1,
            history: const [],
            favorites: const []),
        GeneralState(
            tabs: [
              MyTab.newTab(),
              MyTab.newTab(),
              MyTab.newTab(),
            ],
            currentTabIndex: 2,
            history: const [],
            favorites: const [])
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
      'NewIncognitoTabEvent : try adding several identical tabs',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const NewTabEvent(incognito: true));
        bloc.add(const NewTabEvent(incognito: true));
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [MyTab.newTab(), MyTab.newTab(incognito: true)],
            currentTabIndex: 1,
            history: const [],
            favorites: const []),
        GeneralState(
            tabs: [
              MyTab.newTab(),
              MyTab.newTab(incognito: true),
              MyTab.newTab(incognito: true)
            ],
            currentTabIndex: 2,
            history: const [],
            favorites: const [])
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
        'AddCustomTabEvent : adds a tab when Event is called and can change the currentTabIndex if asked.',
        build: () => bloc,
        act: (bloc) {
          bloc.add(NewCustomTabEvent(
            tool: Tool.home,
            path: "www.google.com",
            incognito: true,
          ));
          bloc.add(NewCustomTabEvent(
            tool: Tool.explorer,
            path: "/Downloads",
            pcVersion: true,
          ));
          bloc.add(NewCustomTabEvent(
            updateCurrentTabIndex: false,
            tool: Tool.explorer,
            path: "/Downloads",
            pcVersion: true,
          ));
        },
        expect: () {
          return <GeneralState>[
            GeneralState(
                tabs: [
                  MyTab.newTab(),
                  MyTab(history: [
                    Address(
                      path: "www.google.com",
                      tool: Tool.home,
                    )
                  ], incognito: true, pcVersion: false)
                ],
                currentTabIndex: 1,
                history: const [],
                favorites: const []),
            GeneralState(
                tabs: [
                  MyTab.newTab(),
                  MyTab(history: [
                    Address(
                      path: "www.google.com",
                      tool: Tool.home,
                    )
                  ], incognito: true, pcVersion: false),
                  MyTab(history: [
                    Address(
                      path: "/Downloads",
                      tool: Tool.explorer,
                    )
                  ], incognito: false, pcVersion: true)
                ],
                currentTabIndex: 2,
                history: const [],
                favorites: const []),
            GeneralState(
                tabs: [
                  MyTab.newTab(),
                  MyTab(history: [
                    Address(
                      path: "www.google.com",
                      tool: Tool.home,
                    )
                  ], incognito: true, pcVersion: false),
                  MyTab(history: [
                    Address(
                      path: "/Downloads",
                      tool: Tool.explorer,
                    )
                  ], incognito: false, pcVersion: true),
                  MyTab(history: [
                    Address(
                      path: "/Downloads",
                      tool: Tool.explorer,
                    )
                  ], incognito: false, pcVersion: true)
                ],
                currentTabIndex: 2,
                history: const [],
                favorites: const [])
          ];
        });

    blocTest<GeneralBloc, GeneralState>(
      'DeleteTabEvent: deletes a tab and changes the currentTabIndex when Event is called.',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const NewTabEvent());
        bloc.add(const DeleteTabEvent(1));
      },
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [MyTab.newTab(), MyTab.newTab()],
            currentTabIndex: 1,
            history: const [],
            favorites: const []),
        GeneralState(
            tabs: [MyTab.newTab()],
            currentTabIndex: 0,
            history: const [],
            favorites: const [])
      ],
    );

    blocTest<GeneralBloc, GeneralState>(
        'DeleteTabEvent : tabs are properly reorganized',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const NewTabEvent());
          bloc.add(const NewTabEvent(incognito: true));
          bloc.add(const DeleteTabEvent(1));
          bloc.add(NewCustomTabEvent(
              tool: Tool.explorer,
              path: "/Downloads",
              updateCurrentTabIndex: false));
          bloc.add(const DeleteTabEvent(2));
        },
        expect: () => <GeneralState>[
              GeneralState(
                  tabs: [MyTab.newTab(), MyTab.newTab()],
                  currentTabIndex: 1,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab.newTab(),
                    MyTab.newTab(incognito: true)
                  ],
                  currentTabIndex: 2,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [MyTab.newTab(), MyTab.newTab(incognito: true)],
                  currentTabIndex: 1,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab.newTab(incognito: true),
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false)
                  ],
                  currentTabIndex: 1,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [MyTab.newTab(), MyTab.newTab(incognito: true)],
                  currentTabIndex: 1,
                  history: const [],
                  favorites: const []),
            ]);

    blocTest<GeneralBloc, GeneralState>(
        'ReorderTabsEvent : reorder tabs when Event is called (currentTabIndex should also move if the index of the aimed tab moves)',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const NewTabEvent(incognito: true));
          bloc.add(const NewTabEvent());
          bloc.add(NewCustomTabEvent(tool: Tool.explorer, path: "/Downloads"));
          bloc.add(const ReorderTabsEvent(3, 1));
          bloc.add(const ReorderTabsEvent(0, 2));
          bloc.add(const UpdateCurrentTabEvent(2));
          bloc.add(const ReorderTabsEvent(3, 1));
          bloc.add(const ReorderTabsEvent(1, 0));
          bloc.add(const ReorderTabsEvent(1, 1));
          bloc.add(const ReorderTabsEvent(1, 1));
          bloc.add(const ReorderTabsEvent(1, 1));
          bloc.add(const ReorderTabsEvent(1, 1));
        },
        expect: () => <GeneralState>[
              GeneralState(
                  tabs: [MyTab.newTab(), MyTab.newTab(incognito: true)],
                  currentTabIndex: 1,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab()
                  ],
                  currentTabIndex: 2,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab(),
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false)
                  ],
                  currentTabIndex: 3,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab(),
                  ],
                  currentTabIndex: 1,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab(),
                    MyTab.newTab(),
                  ],
                  currentTabIndex: 0,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab(),
                    MyTab.newTab(),
                  ],
                  currentTabIndex: 2,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false),
                    MyTab.newTab(),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab(),
                  ],
                  currentTabIndex: 3,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab(),
                  ],
                  currentTabIndex: 3,
                  history: const [],
                  favorites: const []),
            ]);

    blocTest<GeneralBloc, GeneralState>(
      'UpdateTabsEvent',
      build: () => GeneralBloc(),
      act: (bloc) => bloc.add(UpdateTabsEvent(tabs: [
        MyTab.newTab(incognito: true),
        MyTab.newTab(pcVersion: true)
      ])),
      expect: () => <GeneralState>[
        GeneralState(
            tabs: [
              MyTab.newTab(incognito: true),
              MyTab.newTab(pcVersion: true)
            ],
            currentTabIndex: 0,
            history: const [],
            favorites: const []),
      ],
    );

    blocTest<GeneralBloc, GeneralState>('UpdateCurrentTabEvent',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const NewTabEvent(incognito: true));
          bloc.add(const NewTabEvent());
          bloc.add(NewCustomTabEvent(tool: Tool.explorer, path: "/Downloads"));
          bloc.add(const UpdateCurrentTabEvent(1));
        },
        expect: () => <GeneralState>[
              GeneralState(
                  tabs: [MyTab.newTab(), MyTab.newTab(incognito: true)],
                  currentTabIndex: 1,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab()
                  ],
                  currentTabIndex: 2,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab(),
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false)
                  ],
                  currentTabIndex: 3,
                  history: const [],
                  favorites: const []),
              GeneralState(
                  tabs: [
                    MyTab.newTab(),
                    MyTab.newTab(incognito: true),
                    MyTab.newTab(),
                    MyTab(history: [
                      Address(
                        path: "/Downloads",
                        tool: Tool.explorer,
                      )
                    ], incognito: false, pcVersion: false)
                  ],
                  currentTabIndex: 1,
                  history: const [],
                  favorites: const []),
            ]);
  });
}
