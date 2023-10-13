import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'providers/bottom_sheet.dart';
import 'providers/database.dart';
import 'providers/l_d_mode.dart';
import 'providers/language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'task.dart';
import 'widgets/bottom_bar.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox('tasks');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomSheetProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider()..loadTasks(),
        ),
      ],
      child: const ToDoApp(),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: languageProvider.appLocale,
      debugShowCheckedModeBanner: false,
      theme: themeProvider.mode,
      initialRoute: BottomBarScreen.routeName,
      routes: {
        BottomBarScreen.routeName: (context) => const BottomBarScreen(),
      },
    );
  }
}
