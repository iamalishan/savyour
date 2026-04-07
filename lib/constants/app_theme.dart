import 'package:ecommerce_web/constants/app_imports.dart';

class EcommerceTheme {
  // Theme for light mode
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      cardColor: Colors.white,
      fontFamily: GoogleFonts.urbanist().fontFamily,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Theme for dark mode
  // static ThemeData darkThemeData(BuildContext context) {
  //   return ThemeData(
  //     brightness: Brightness.dark,
  //     colorScheme: ColorScheme.dark(
  //       background: Colors.black,
  //       secondary: Colors.white,
  //     ),
  //     primaryColor: primaryColor,
  //     cardColor: Colors.white,
  //     fontFamily: GoogleFonts.urbanist().fontFamily,
  //     textTheme: GoogleFonts.urbanistTextTheme(),
  //     useMaterial3: true,
  //     appBarTheme: AppBarTheme(
  //       color: Colors.white,
  //       elevation: 0.0,
  //       iconTheme: const IconThemeData(color: Colors.black),
  //       titleTextStyle: TextStyle(
  //         color: Colors.white,
  //         fontSize: 18,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  // ColorsR
  static Color primaryColor = const Color.fromRGBO(235, 235, 239, 1);
  static Color mainColor = const Color.fromRGBO(202, 89, 47, 1);
  static Color secondaryColor = const Color.fromRGBO(200, 204, 208, 1);
}
