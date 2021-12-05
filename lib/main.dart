import 'package:flutter/material.dart';
import 'package:guitar_chords_web/routes.dart';
import 'package:guitar_chords_web/src/pages/genre_page/genre_screen.dart';
import 'package:guitar_chords_web/src/pages/page_typography.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      initialRoute: Routes.home,
      onGenerateRoute: (RouteSettings settings) {
        return Routes.fadeThrough(settings, (context) {
          switch (settings.name) {
            case Routes.home:
              return ListPage();
            case Routes.post:
              return TypographyPage();
            case Routes.style:
              return TypographyPage();
            default:
              return SizedBox.shrink();
          }
        });
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
