import 'package:porao_app/common/all_import.dart';
import 'package:porao_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PORAO',
      theme: lightTheme,
      // darkTheme: darkTheme,
      home: const MyHomePage(title: 'Porate Chai Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const WidgetTree();
    // return const Devolopment(); // Temporary
    // return const AnimatedContainerPopup(); // Temporary
  }
}
