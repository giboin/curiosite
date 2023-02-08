import 'package:curiosite/tab/domain/address.dart';
import 'package:curiosite/tab/domain/tab.dart';
import 'package:curiosite/tools/tool_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:screenshot/screenshot.dart';

part 'general_event.dart';
part 'general_state.dart';

class GeneralBloc extends HydratedBloc<GeneralEvent, GeneralState> {
  GeneralBloc() : super(GeneralInitialState()) {
    on<NewTabEvent>((event, emit) {
      List<MyTab> newTabs = List.from(state.tabs);
      int index = state.tabs.length;
      newTabs.add(
          MyTab.newTab(incognito: event.incognito, pcVersion: event.pcVersion));
      emit(state.copyWith(
        tabs: newTabs,
        currentTabIndex: index,
      ));
    });

    on<NewCustomTabEvent>((event, emit) async {
      List<MyTab> newTabs = List.from(state.tabs);
      Address address;
      if (event.faviconUrl == null) {
        address = Address(tool: event.tool, path: event.path);
      } else {
        address = await Address.withBrowserFavicon(
            tool: event.tool, path: event.path, faviconUrl: event.faviconUrl!);
      }
      newTabs.add(MyTab(
          history: [address],
          incognito: event.incognito,
          pcVersion: event.pcVersion));
      emit(state.copyWith(
        tabs: newTabs,
        currentTabIndex: event.updateCurrentTabIndex
            ? state.tabs.length
            : state.currentTabIndex,
      ));
    });

    on<DeleteTabEvent>((event, emit) {
      List<MyTab> newTabs = List.from(state.tabs);
      int curTabInd = state.currentTabIndex;
      if (curTabInd >= event.indexToDelete) {
        curTabInd--;
      }
      newTabs.removeAt(event.indexToDelete);

      emit(state.copyWith(
        tabs: newTabs,
        currentTabIndex: curTabInd,
      ));
    });

    on<ReorderTabsEvent>((event, emit) {
      List<MyTab> newTabs = List.from(state.tabs);
      int index = state.currentTabIndex;
      if (index == event.initialIndex) {
        index = event.targetIndex;
      } else if (index < event.initialIndex && index > event.targetIndex) {
        index++;
      } else if (index < event.targetIndex && index > event.initialIndex) {
        index--;
      }
      MyTab tab = newTabs.removeAt(event.initialIndex);
      newTabs.insert(event.targetIndex, tab);
      emit(state.copyWith(tabs: newTabs, currentTabIndex: index));
    });

    on<UpdateTabsEvent>((event, emit) {
      if (state.currentTabIndex < event.tabs.length) {
        emit(state.copyWith(
          tabs: event.tabs,
        ));
      } else {
        emit(state.copyWith(
          tabs: event.tabs,
          currentTabIndex: event.tabs.length - 1,
        ));
      }
    });

    on<UpdateCurrentTabEvent>((event, emit) {
      if (event.currentTab != state.currentTabIndex &&
          event.currentTab < state.tabs.length) {
        emit(state.copyWith(
          currentTabIndex: event.currentTab,
        ));
      }
    });

    on<GeneralUpdateHistoryEvent>((event, emit) {
      emit(state.copyWith(
        history: event.history,
      ));
    });

    on<GeneralAppendHistoryEvent>((event, emit) {
      List<Address> newHistory = List.from(state.history);
      newHistory.add(event.address);
      emit(state.copyWith(
        history: newHistory,
      ));
    });

    on<UpdateFavoritesEvent>((event, emit) {
      emit(state.copyWith(favorites: event.favorites));
    });

    on<AppendFavoritesEvent>((event, emit) {
      List<Address> newFavorites = List.from(state.favorites);
      newFavorites.add(event.address);
      emit(state.copyWith(
        favorites: newFavorites,
      ));
    });

    on<PushAddressEvent>((event, emit) async {
      Address address;
      if (event.faviconUrl == null) {
        address = Address(tool: event.tool, path: event.path);
      } else {
        address = await Address.withBrowserFavicon(
            tool: event.tool, path: event.path, faviconUrl: event.faviconUrl!);
      }
      if (address == state.currentTab.currentAddress) {
        return;
      }
      if (address.tool != Tool.home) {
        add(GeneralAppendHistoryEvent(address));
      }

      List<Address> tabHistory = List.from(state.currentTab.history);
      if (state.currentTab.canGoForward) {
        int len = tabHistory.length;
        for (int i = state.currentTab.currentAddressIndex + 1; i < len; i++) {
          tabHistory.removeLast();
        }
      }
      tabHistory.add(address);
      MyTab newTab = state.currentTab.copyWith(history: tabHistory);
      List<MyTab> tabs = List.from(state.tabs);
      tabs[state.currentTabIndex] = newTab;
      emit(state.copyWith(
        tabs: tabs,
      ));
    });

    on<GoBackEvent>(((event, emit) {
      if (state.currentTab.canGoBack) {
        List<MyTab> tabs = List.from(state.tabs);
        MyTab newTab = state.currentTab.copyWith(
            currentAddressIndex: state.currentTab.currentAddressIndex - 1);
        tabs[state.currentTabIndex] = newTab;
        emit(state.copyWith(
          tabs: tabs,
        ));
      }
    }));

    on<GoForwardEvent>(((event, emit) {
      if (state.currentTab.canGoForward) {
        List<MyTab> tabs = List.from(state.tabs);
        MyTab newTab = state.currentTab
            .copyWith(currentAddressIndex: state.currentTabIndex + 1);
        tabs[state.currentTabIndex] = newTab;
        emit(state.copyWith(
          tabs: tabs,
        ));
      }
    }));

    on<ChangeScreenshotEvent>((event, emit) async {
      List<MyTab> tabs = List.from(state.tabs);
      MyTab newTab;

      Uint8List? bytes = await event.controller.capture();
      newTab = state.currentTab.copyWith(screenshot: bytes);

      tabs[state.currentTabIndex] = newTab;
      emit(state.copyWith(
        tabs: tabs,
      ));
    });

    on<TabUpdateHistoryEvent>((event, emit) {
      List<MyTab> tabs = List.from(state.tabs);
      MyTab newTab = state.currentTab.copyWith(history: event.history);
      tabs[state.currentTabIndex] = newTab;
      emit(state.copyWith(
        tabs: tabs,
      ));
    });

    on<ChangeIncognitoEvent>((event, emit) {
      List<MyTab> tabs = List.from(state.tabs);
      MyTab newTab = state.currentTab.copyWith(incognito: event.incognito);
      tabs[state.currentTabIndex] = newTab;
      emit(state.copyWith(
        tabs: tabs,
      ));
    });

    on<ChangePcVersionEvent>((event, emit) {
      List<MyTab> tabs = List.from(state.tabs);
      MyTab newTab = state.currentTab.copyWith(pcVersion: event.pcVersion);
      tabs[state.currentTabIndex] = newTab;
      emit(state.copyWith(
        tabs: tabs,
      ));
    });
  }

  @override
  void onChange(Change<GeneralState> change) {
    // Always call super.onChange with the current change
    //print(change.nextState.currentTab.history);
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    if (kDebugMode) {
      print(error);
    }
  }

  @override
  GeneralState? fromJson(Map<String, dynamic> json) {
    return GeneralState(
        tabs: (json['tabs'] as List<dynamic>)
            .map((tab) => MyTab.fromJson(tab))
            .toList(),
        currentTabIndex: json['currentTab'],
        history: (json['history'] as List<dynamic>)
            .map((address) => Address.fromJson(address))
            .toList(),
        favorites: (json['favorites'] as List<dynamic>)
            .map((address) => Address.fromJson(address))
            .toList());
  }

  @override
  Map<String, dynamic>? toJson(GeneralState state) {
    Map<String, dynamic>? json = {
      'tabs': state.tabs.map((tab) => tab.toJson()).toList(),
      'currentTab': state.currentTabIndex,
      'history': state.history.map((address) => address.toJson()).toList(),
      'favorites': state.favorites.map((address) => address.toJson()).toList()
    };
    return json;
  }
}
