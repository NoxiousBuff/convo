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

  
  static const royalBlueSender = 0xff234e70;
  static const paleYellowReceiver = 0xfffaf8bf;

  static const classicBlueSender = 0xff2F3C7E;
  static  const classicPinkReceiver = 0xffFBEAEB;

  static const hotPinkSender = 0xffFF69B4; //Purple
  static const hotCyanReceiver = 0xff00FFFF; 
  
  static const forestGreenSender = 0xff3A6B35; //Purple
  static const butterReceiver = 0xffFFFFD2;// Light Purple

  static const redSender = 0xffff2d3d; //Red
  static const redReceiver = 0xffffe1e2; // Light Red

  static const pinkSender = 0xffff61a9;
  static const pinkReceiver = 0xfffec6e0;

  static const cyanSender = 0xff00c9d5; //Cyan
  static const cyanReceiver = 0xffB7F2F3; //Light Cyan

  static const orangeSender = 0xffee4e34; //Orange
  static const orangeReceiver = 0xffFCEDDA; //Light Orange

  static const systemblueSender = 0xff0184FF; // Blue
  static const systemBlueReceiver = 0xffF6F5FF; //Light Blue

  static const indigoSender = 0xff3F51B5; //Indigo
  static const indigoReceiver = 0xffB9C0E6; //Light Indigo

  static const tealSender = 0xff009688; //Teal
  static const tealReceiver = 0xffB3E0DB; //Light Teal

  static const greenSender = 0xff4CAF50; //Green
  static const greenReceiver = 0xffD8EED9; //Green Light  
}
