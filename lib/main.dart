import 'dart:io';

import 'package:curiosite/general_bloc/general_bloc.dart';
import 'package:curiosite/tab/presentation/tabs_management_view/tabs_management_view.dart';
import 'package:curiosite/tab/presentation/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String appStorageDirectory =
      (await getApplicationDocumentsDirectory()).absolute.path;
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory:
          Directory("$appStorageDirectory/hydrated_bloc_storage"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GeneralBloc(),
        child: MaterialApp(
            title: 'Curiosite',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: {
              '/': (context) => const TabView(),
              'tabs_management_view': (context) => const TabsManagementView(),
            }));
  }
}
