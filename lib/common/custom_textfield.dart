import 'package:porao_app/common/all_import.dart';

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
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 5),
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
          fillColor: Theme.of(context).colorScheme.secondary,
          hintStyle: TextStyle(
            fontFamily: primaryFont,
            fontSize: 15,
          ),
        ),
        obscureText: showHideText,
      ),
    );
  }
}
