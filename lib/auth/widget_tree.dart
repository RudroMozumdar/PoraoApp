import 'package:porao_app/common/all_import.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, sanpshot) {
        if (sanpshot.hasData) {
          return const Dashboard();
        } else {
          return const Login();
        }
      },
    );
  }
}
