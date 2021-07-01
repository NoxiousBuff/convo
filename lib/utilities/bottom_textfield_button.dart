import 'package:flutter/material.dart';

class BottomTextFieldButton extends StatelessWidget {
  final BuildContext context;
  final IconData iconData;
  final String iconName;
  final VoidCallback onTap;
  final bool optionOpened;
  const BottomTextFieldButton({
    Key? key,
    required this.context,
    required this.iconData,
    required this.iconName,
    required this.onTap,
    required this.optionOpened,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0.0;

    double optionHeight() {
      if (optionOpened && isKeyboardVisible) {
        return 84.0;
      } else {
        return 0;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: isKeyboardVisible ? 1.0 : 0.0,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onTap,
          child: Container(
            width: optionHeight(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.black26, width: 0.0),
            ),
            child: Column(
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    iconData,
                    color: Colors.black54,
                  ),
                  iconSize: optionOpened ? 34.0 : 0.0,
                ),
                Text(
                  iconName,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: optionOpened ? 12.0 : 0.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
