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
          primary: Color(0xFF4DDEAB),
          onPrimary: Color(0xFF003827),
          primaryContainer: Color(0xFF00513A),
          onPrimaryContainer: Color(0xFF6EFBC6),
          secondary: Color(0xFFB3CCBE),
          onSecondary: Color(0xFF1F352B),
          secondaryContainer: Color(0xFF354B41),
          onSecondaryContainer: Color(0xFFCFE9DA),
          tertiary: Color(0xFFA6CCDF),
          onTertiary: Color(0xFF083544),
          tertiaryContainer: Color(0xFF254B5B),
          onTertiaryContainer: Color(0xFFC1E8FC),
          error: Color(0xFFFFB4AB),
          errorContainer: Color(0xFF93000A),
          onError: Color(0xFF690005),
          onErrorContainer: Color(0xFFFFDAD6),
          background: Color(0xFF191C1A),
          onBackground: Color(0xFFE1E3DF),
          surface: Color(0xFF191C1A),
          onSurface: Color(0xFFE1E3DF),
          surfaceVariant: Color(0xFF404944),
          onSurfaceVariant: Color(0xFFBFC9C2),
          outline: Color(0xFF89938D),
          onInverseSurface: Color(0xFF191C1A),
          inverseSurface: Color(0xFFE1E3DF),
          inversePrimary: Color(0xFF006C4E),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFF4DDEAB),
          outlineVariant: Color(0xFF404944),
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
