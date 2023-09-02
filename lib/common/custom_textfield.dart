import 'all_import.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  String hintText;
  Icon prefixIcon;
  IconButton? sufffixIcon;
  double borderRadius;
  TextEditingController controller;
  TextInputType? textInpputType;
  Color? color;
  bool showHideText;
  CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.borderRadius,
    required this.controller,
    this.textInpputType,
    this.color,
    this.sufffixIcon,
    this.showHideText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 90, 90, 90).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextField(
        controller: controller,
        keyboardType: textInpputType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: sufffixIcon,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          hintText: hintText,
          filled: true,
          fillColor: color,
        ),
        obscureText: showHideText,
      ),
    );
  }
}
