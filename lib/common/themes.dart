import 'package:porao_app/common/all_import.dart';

// Light Theme------------------------------------------------------------------
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    background: const Color.fromARGB(255, 36, 36, 36),
    primary: Colors.deepPurple,
    secondary: const Color.fromARGB(255, 255, 255, 255),
    shadow: const Color.fromARGB(166, 182, 182, 182),
    onPrimaryContainer: Colors.amber,
  ),
  useMaterial3: true,
);

// Dark Theme-------------------------------------------------------------------
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    background: const Color.fromARGB(255, 36, 36, 36),
    primary: Colors.deepPurple,
    secondary: const Color.fromARGB(255, 255, 255, 255),
    shadow: const Color.fromARGB(255, 129, 129, 129),
    onPrimaryContainer: Colors.amber,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);
