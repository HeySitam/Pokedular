import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/global_theme_data.dart';
import 'package:pokedex/pokedex_viewmodel.dart';
import 'package:pokedex/ui/pokelist_screen.dart';
import 'package:provider/provider.dart';

import 'core/routes/pokedex_route.dart';

import 'core/routes/pokedex_route.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokeDexViewModel())
      ],
      child: MaterialApp.router(
        title: 'PokeDex',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: GlobalThemeData.lightThemeData,
        darkTheme: GlobalThemeData.darkThemeData,
        routerConfig: pokeDexRouter,
      ),
    );
  }
}