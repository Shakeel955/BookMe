import 'package:flutter/material.dart';
import 'app_state.dart';
import 'router.dart';
import 'theme.dart';

void main() => runApp(const BookMeApp());

class BookMeApp extends StatelessWidget {
  const BookMeApp({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final s = AppState.i;
        return MaterialApp.router(
          key: ValueKey(s.urdu),
          title: 'BookMe',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: s.theme,
          routerConfig: appRouter,
          builder: (ctx, child) => Directionality(textDirection: s.urdu ? TextDirection.rtl : TextDirection.ltr, child: child!),
        );
      });
}
