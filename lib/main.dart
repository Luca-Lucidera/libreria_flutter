import 'package:flutter/material.dart';
import 'package:libreria_flutter/model/filter.dart';
import 'package:libreria_flutter/model/library.dart';
import 'package:libreria_flutter/views/home.dart';
import 'package:libreria_flutter/views/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Library()),
        ChangeNotifierProvider(create: (context) => Filters()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF006C4E),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF87F8C9),
          onPrimaryContainer: Color(0xFF002115),
          secondary: Color(0xFF4C6358),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFCFE9DA),
          onSecondaryContainer: Color(0xFF092017),
          tertiary: Color(0xFF006687),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFC1E8FF),
          onTertiaryContainer: Color(0xFF001E2B),
          error: Color(0xFFBA1A1A),
          errorContainer: Color(0xFFFFDAD6),
          onError: Color(0xFFFFFFFF),
          onErrorContainer: Color(0xFF410002),
          background: Color(0xFFFBFDF9),
          onBackground: Color(0xFF191C1A),
          surface: Color(0xFFFBFDF9),
          onSurface: Color(0xFF191C1A),
          surfaceVariant: Color(0xFFDBE5DE),
          onSurfaceVariant: Color(0xFF404944),
          outline: Color(0xFF707973),
          onInverseSurface: Color(0xFFEFF1ED),
          inverseSurface: Color(0xFF2E312F),
          inversePrimary: Color(0xFF6ADBAE),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFF006C4E),
          outlineVariant: Color(0xFFBFC9C2),
          scrim: Color(0xFF000000),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFFB693),
          onPrimary: Color(0xFF561F00),
          primaryContainer: Color(0xFF7A3001),
          onPrimaryContainer: Color(0xFFFFDBCC),
          secondary: Color(0xFFE6BEAC),
          onSecondary: Color(0xFF432A1E),
          secondaryContainer: Color(0xFF5C4033),
          onSecondaryContainer: Color(0xFFFFDBCC),
          tertiary: Color(0xFFD0C88F),
          onTertiary: Color(0xFF363107),
          tertiaryContainer: Color(0xFF4D481C),
          onTertiaryContainer: Color(0xFFEDE4A9),
          error: Color(0xFFFFB4AB),
          errorContainer: Color(0xFF93000A),
          onError: Color(0xFF690005),
          onErrorContainer: Color(0xFFFFDAD6),
          background: Color(0xFF201A18),
          onBackground: Color(0xFFEDE0DB),
          surface: Color(0xFF201A18),
          onSurface: Color(0xFFEDE0DB),
          surfaceVariant: Color(0xFF52443D),
          onSurfaceVariant: Color(0xFFD7C2B9),
          outline: Color(0xFFA08D85),
          onInverseSurface: Color(0xFF201A18),
          inverseSurface: Color(0xFFEDE0DB),
          inversePrimary: Color(0xFF984719),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFFFFB693),
          outlineVariant: Color(0xFF52443D),
          scrim: Color(0xFF000000),
        ),
      ),
      themeMode: ThemeMode.dark,
      title: "Your library",
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/test': (BuildContext context) => const TestPage(),
      },
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Library>(builder: (context, library, child) {
      return Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                library.fetchBooks();
                print(library.list.length);
              },
              child: const Text("premi"),
            ),
            SizedBox(
              child: Text('${library.list.length}'),
            ),
          ],
        ),
      );
    });
  }
}
