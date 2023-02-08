import 'package:flutter_bloc/flutter_bloc.dart';
part 'browser_event.dart';
part 'browser_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NavigatorState> {
  NavigatorBloc() : super(NavigatorInitial()) {
    on<NavigatorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
