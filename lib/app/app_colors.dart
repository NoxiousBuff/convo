// class AppColors extends ChangeNotifier {
//   updateAppColors() {
//     blueAccent();
//     yellow();
//     yellowAccent();
//     green();
//     greenAccent();
//     purple();
//     purpleAccent();
//     red();
//     redAccent();
//     grey();
//     lightGrey();
//     darkGrey();
//     black();
//     lightBlack();
//     mediumBlack();
//     scaffoldColor();
//     log('Colors updated');
//     // log(isDarkTheme.toString());
//   }

//   static const blue = Color.fromRGBO(0, 132, 255, 1);
//   // static const blueAccent = Color.fromRGBO(192, 229, 255, 1);
//   // static const green = Color.fromRGBO(52,199,89, 1);
//   // static const greenAccent = Color.fromRGBO(187, 245, 213, 1);
//   // static const red = Color.fromRGBO(255, 78, 78, 1);
//   // static const redAccent = Color.fromRGBO(255 ,216, 215, 1);
//   // static const yellow = Color.fromRGBO(255,193,102, 1);
//   // static const yellowAccent = Color.fromRGBO(255,234,203, 1);
//   // static const purple = Color.fromRGBO(150, 147, 230, 1);
//   // static const purpleAccent = Color.fromRGBO(213,212,245, 1);
//   // static const lightGrey = Color.fromRGBO(243,244,246, 1);
//   // static const grey = Color.fromRGBO(238,239,242, 1);
//   // static const darkGrey = Color.fromRGBO(215,217,224, 1);
//   // static const black = Colors.black;
//   // static const lightBlack =Colors.black38;
//   // static const mediumBlack =Colors.black54;
//   static const white = Color.fromRGBO(255, 255, 255, 1);
//   static const taintedBackground = Color.fromRGBO(254, 250, 240, 1);
//   static const transparent = Colors.transparent;
//   // static const scaffoldColor = Colors.white;

//   // Color white() {
//   //   return isDarkTheme ? Colors.grey.shade900 : Colors.white;
//   // }

//   Color blueAccent() {
//     return isDarkTheme
//         ? const Color.fromRGBO(6, 64, 111, 1)
//         : const Color.fromRGBO(192, 229, 255, 1);
//   }

//   Color redAccent() {
//     return isDarkTheme
//         ? const Color.fromRGBO(62, 14, 13, 1)
//         : const Color.fromRGBO(255, 216, 215, 1);
//   }

//   Color red() {
//     return isDarkTheme
//         ? const Color.fromRGBO(255, 122, 122, 1)
//         : const Color.fromRGBO(255, 78, 78, 1);
//   }

//   Color green() {
//     return isDarkTheme
//         ? const Color.fromRGBO(52, 199, 89, 1)
//         : const Color.fromRGBO(52, 199, 89, 1);
//   }

//   Color greenAccent() {
//     return isDarkTheme
//         ? const Color.fromRGBO(13, 85, 55, 1)
//         : const Color.fromRGBO(187, 245, 213, 1);
//   }

//   Color yellow() {
//     return isDarkTheme
//         ? const Color.fromRGBO(255, 193, 102, 1)
//         : const Color.fromRGBO(255, 193, 102, 1);
//   }

//   Color yellowAccent() {
//     return isDarkTheme
//         ? const Color.fromRGBO(82, 49, 0, 1)
//         : const Color.fromRGBO(255, 234, 203, 1);
//   }

//   Color purpleAccent() {
//     return isDarkTheme
//         ? const Color.fromRGBO(39, 42, 44, 1)
//         : const Color.fromRGBO(213, 212, 245, 1);
//   }

//   Color purple() {
//     return isDarkTheme
//         ? const Color.fromRGBO(150, 147, 230, 1)
//         : const Color.fromRGBO(150, 147, 230, 1);
//   }

//   Color darkGrey() {
//     return isDarkTheme
//         ? Colors.grey.shade500
//         : const Color.fromRGBO(215, 217, 224, 1);
//   }

//   Color lightBlack() {
//     return isDarkTheme ? Colors.white24 : Colors.black38;
//   }

//   Color grey() {
//     return isDarkTheme
//         ? Colors.grey.shade700
//         : const Color.fromRGBO(238, 239, 242, 1);
//   }

//   Color lightGrey() {
//     return isDarkTheme
//         ? Colors.grey.shade800
//         : const Color.fromRGBO(243, 244, 246, 1);
//   }

//   Color mediumBlack() {
//     return isDarkTheme ? Colors.white54 : Colors.black54;
//   }

//   Color black() {
//     return isDarkTheme ? Colors.white.withAlpha(200) : Colors.black87;
//   }

//   Color scaffoldColor() {
//     final localScaffoldColor = isDarkTheme ? const Color(0xff121212) : Colors.white;
//     return localScaffoldColor;
//   }
// }

// class AppTheme {
//   ThemeData lightTheme = ThemeData.light().copyWith(
//     brightness: Brightness.light,
//     primaryColor: const Color.fromRGBO(0, 132, 255, 1),
//     primaryColorBrightness: Brightness.light,
//     scaffoldBackgroundColor: Colors.white,
//     bottomAppBarColor: Colors.white,

//   );
// }

class MaterialColorsCode {
  static const red800 = 0xffC62828; //Red
  static const red600 = 0xffE53935; // Light Red
  static const blue300 = 0xff64B5F6; // Blue
  static const lightBlue200 = 0xff81D4FA; //Light Blue
  static const pink400 = 0xffEC407A; //Pink
  static const pink200 = 0xffF48FB1; //Light Pink
  static const purple500 = 0xff9C27B0; //Purple
  static const purple400 = 0xffAB47BC; // Light Purple
  static const deepPurple500 = 0xff673AB7; //Deep purple
  static const deepPurple400 = 0xff7E57C2; //Light Purple
  static const indigo500 = 0xff3F51B5; //Indigo
  static const indigo400 = 0xff5C6BC0; //Light Indigo
  static const cyan500 = 0xff00BCD4; //Cyan
  static const cyan200 = 0xff80DEEA; //Light Cyan
  static const teal500 = 0xff009688; //Teal
  static const teal300 = 0xff4DB6AC; //Light Teal
  static const green500 = 0xff4CAF50; //Green
  static const green300 = 0xff81C784; //Green Light
  static const orange700 = 0xffF57C00; //Orange
  static const orange400 = 0xffFFA726; //Light Orange
  static const yellow600 = 0xffFDD835; //Yellow
  static const yellowA200 = 0xffFFFF00; //Yellow Light
}
