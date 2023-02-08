part of 'general_bloc.dart';

class GeneralState extends Equatable {
  final List<MyTab> tabs;
  final int currentTabIndex;
  final List<Address> history;
  final List<Address> favorites;

  const GeneralState(
      {required this.tabs,
      required this.currentTabIndex,
      required this.history,
      required this.favorites});

  MyTab get currentTab {
    if (tabs.isNotEmpty) {
      return tabs[currentTabIndex];
    } else {
      MyTab tab = MyTab.newTab();
      tabs.add(tab);
      return tab;
    }
  }

  @override
  List<Object?> get props => [tabs, currentTabIndex, history, favorites];

  GeneralState copyWith(
      {List<MyTab>? tabs,
      int? currentTabIndex,
      List<Address>? history,
      List<Address>? favorites}) {
    return GeneralState(
        tabs: tabs ?? this.tabs,
        currentTabIndex: currentTabIndex ?? this.currentTabIndex,
        history: history ?? this.history,
        favorites: favorites ?? this.favorites);
  }
}

class GeneralInitialState extends GeneralState {
  GeneralInitialState()
      : super(
            tabs: [MyTab.newTab()],
            currentTabIndex: 0,
            history: [],
            favorites: []);
}
