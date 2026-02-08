import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class CampusLeagueApp extends StatelessWidget {
  const CampusLeagueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ynov Campus League',
      theme: CampusLeagueTheme.lightTheme,
      darkTheme: CampusLeagueTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: campusRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
