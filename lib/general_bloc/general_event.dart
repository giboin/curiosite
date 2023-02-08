part of 'general_bloc.dart';

abstract class GeneralEvent extends Equatable {
  const GeneralEvent();
  @override
  List<Object> get props => [];
}

class NewTabEvent extends GeneralEvent {
  final bool incognito;
  final bool pcVersion;
  const NewTabEvent({this.incognito = false, this.pcVersion = false});
}

class NewCustomTabEvent extends GeneralEvent {
  final Tool tool;
  final String path;
  final String? faviconUrl;
  final bool incognito;
  final bool pcVersion;
  final bool updateCurrentTabIndex;
  const NewCustomTabEvent(
      {required this.tool,
      required this.path,
      this.faviconUrl,
      this.incognito = false,
      this.pcVersion = false,
      this.updateCurrentTabIndex = true})
      : assert(tool != Tool.browser || faviconUrl != null);

  @override
  List<Object> get props => [tool, updateCurrentTabIndex];
}

class DeleteTabEvent extends GeneralEvent {
  final int indexToDelete;
  const DeleteTabEvent(this.indexToDelete);

  @override
  List<Object> get props => [indexToDelete];
}

class ReorderTabsEvent extends GeneralEvent {
  final int initialIndex;
  final int targetIndex;
  const ReorderTabsEvent(this.initialIndex, this.targetIndex);

  @override
  List<Object> get props => [initialIndex, targetIndex];
}

class UpdateTabsEvent extends GeneralEvent {
  final List<MyTab> tabs;
  const UpdateTabsEvent({required this.tabs});

  @override
  List<Object> get props => [tabs];
}

class UpdateCurrentTabEvent extends GeneralEvent {
  final int currentTab;
  const UpdateCurrentTabEvent(this.currentTab);

  @override
  List<Object> get props => [currentTab];
}

class GeneralUpdateHistoryEvent extends GeneralEvent {
  final List<Address> history;
  const GeneralUpdateHistoryEvent(this.history);

  @override
  List<Object> get props => [history];
}

class GeneralAppendHistoryEvent extends GeneralEvent {
  final Address address;
  const GeneralAppendHistoryEvent(this.address);

  @override
  List<Object> get props => [address];
}

class UpdateFavoritesEvent extends GeneralEvent {
  final List<Address> favorites;
  const UpdateFavoritesEvent(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class AppendFavoritesEvent extends GeneralEvent {
  final Address address;
  const AppendFavoritesEvent(this.address);

  @override
  List<Object> get props => [address];
}

class PushAddressEvent extends GeneralEvent {
  final Tool tool;
  final String path;
  final Address? address;
  final String? faviconUrl;
  const PushAddressEvent(
      {required this.tool, required this.path, this.address, this.faviconUrl})
      : assert(tool != Tool.browser || faviconUrl != null);

  @override
  List<Object> get props => [tool, path];
}

class GoBackEvent extends GeneralEvent {
  const GoBackEvent();
}

class GoForwardEvent extends GeneralEvent {
  const GoForwardEvent();
}

class ChangeScreenshotEvent extends GeneralEvent {
  final ScreenshotController controller;
  const ChangeScreenshotEvent(this.controller);
}

//should be useless
class TabUpdateHistoryEvent extends GeneralEvent {
  final List<Address> history;
  const TabUpdateHistoryEvent(this.history);

  @override
  List<Object> get props => [history];
}

//should be useless
class ChangeIncognitoEvent extends GeneralEvent {
  final bool incognito;
  const ChangeIncognitoEvent(this.incognito);

  @override
  List<Object> get props => [incognito];
}

class ChangePcVersionEvent extends GeneralEvent {
  final bool pcVersion;
  const ChangePcVersionEvent(this.pcVersion);

  @override
  List<Object> get props => [pcVersion];
}
