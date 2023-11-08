import 'package:flutter/material.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';

class ThemeColor {
  static ThemeData mThemeData(BuildContext context, {bool isDark = false}) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: AppColors.lightGrey,
      scaffoldBackgroundColor: isDark ? Colors.black : const Color(0xffF3F4F9),
      applyElevationOverlayColor: true,
      bannerTheme: MaterialBannerTheme.of(context),
      bottomAppBarTheme: BottomAppBarTheme.of(context),
      canvasColor: isDark ? Colors.white : Colors.grey[50]!,
      cardColor: isDark ? Colors.black : Colors.white,
      cardTheme: CardTheme(
        color: isDark ? Colors.black : Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryColor,
      ),
      checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(AppColors.primaryColor),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      dialogBackgroundColor: Colors.white,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        contentTextStyle: Theme.of(context).textTheme.bodyLarge,
      ),
      dividerColor: Colors.grey[500],
      dividerTheme: DividerThemeData(
          color: Colors.grey[500], indent: 8.0, endIndent: 8.0, space: 8.0),
      focusColor: Colors.pink[50],
      fontFamily: AppFont.fontRegular,
      hintColor: Colors.grey,
      indicatorColor: AppColors.primaryColor,
      outlinedButtonTheme: OutlinedButtonThemeData(style: textButtonStyle),
      primaryTextTheme: textTheme(isDark, context),
      // datePickerTheme: DatePickerThemeData(
      //   backgroundColor: AppColors.white,
      //   headerBackgroundColor: AppColors.primaryColor,
      //   headerForegroundColor: AppColors.white,
      //   rangePickerBackgroundColor: AppColors.primaryColor,
      //   inputDecorationTheme: InputDecorationTheme()
      // ),
      textButtonTheme: TextButtonThemeData(style: textButtonStyle),
      timePickerTheme: TimePickerThemeData(
          backgroundColor: Colors.white,
          hourMinuteColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.tilePrimaryColor
                  : AppColors.decsGrey),
          hourMinuteTextColor: MaterialStateColor.resolveWith(
              (states) => AppColors.primaryColor),
          dialHandColor: AppColors.primaryColor,
          dialBackgroundColor: AppColors.tilePrimaryColor,
          dayPeriodColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.primaryColor
                  : AppColors.decsGrey),
          dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.tilePrimaryColor
                  : AppColors.primaryColor),
          dayPeriodBorderSide: BorderSide(color: AppColors.white),
          dialTextColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected) ? Colors.white : Colors.black),
          entryModeIconColor: AppColors.primaryColor),
      buttonTheme: ButtonThemeData(
        height: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // buttonColor: pink,
        textTheme: ButtonTextTheme.normal,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: AppColors.primaryColor,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        hintStyle: TextStyle(
          fontSize: 14, // 35
          fontFamily: AppFont.fontRegular,
          color: AppColors.primaryColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xffF3F4F9),
        elevation: 0,
        actionsIconTheme: IconThemeData(color: AppColors.primaryColor),
        toolbarTextStyle: TextTheme(
                bodyLarge: TextStyle(
                  fontSize: 29, // 35
                  fontFamily: AppFont.fontRegular,
                  color: isDark ? Colors.white : Colors.black,
                ),
                bodyMedium: TextStyle(
                    fontSize: 29, // 35
                    fontFamily: AppFont.fontRegular,
                    color: Colors.grey))
            .bodyMedium,
        titleTextStyle: TextTheme(
                bodyLarge: TextStyle(
                  fontSize: 29, // 35
                  fontFamily: AppFont.fontRegular,
                  color: isDark ? Colors.white : Colors.black,
                ),
                bodyMedium: TextStyle(
                    fontSize: 29, // 35
                    fontFamily: AppFont.fontRegular,
                    color: Colors.grey))
            .titleLarge,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: TextStyle(
          fontSize: 22,
          fontFamily: AppFont.fontRegular,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 22,
          fontFamily: AppFont.fontRegular,
        ),
      ),
      textTheme: textTheme(isDark, context),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.white,
        backgroundColor: isDark ? Colors.white : Colors.black,
        behavior: SnackBarBehavior.floating,
        elevation: 3,
      ),
      colorScheme: ColorScheme(
        primary: AppColors.lightGrey,
        secondary: AppColors.lightGrey,
        brightness: Brightness.light,
        background: isDark ? Colors.black : Colors.white,
        error: Colors.red,
        onBackground: AppColors.lightGrey,
        onError: Colors.red,
        onPrimary: AppColors.lightGrey,
        onSecondary: AppColors.lightGrey,
        onSurface: AppColors.lightGrey,
        surface: AppColors.lightGrey,
      ).copyWith(background: AppColors.lightGrey).copyWith(error: Colors.red),
    );
  }

  static ButtonStyle get textButtonStyle {
    return TextButton.styleFrom(
      // backgroundColor: primaryColor,
      textStyle: TextStyle(
        color: Colors.white,
        fontFamily: AppFont.fontRegular,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static TextTheme textTheme(isDark, context) {
    return TextTheme(
      displayLarge: TextStyle(
          fontSize: 25,
          fontFamily: AppFont.fontBold,
          color: AppColors.darkPrimaryColor),
      displaySmall: TextStyle(
          fontSize: 13,
          fontFamily: AppFont.fontRegular,
          color: AppColors.txtGrey),
      displayMedium: TextStyle(
          fontSize: 15,
          fontFamily: AppFont.fontRegular,
          color: AppColors.white),
      titleSmall: TextStyle(
          fontSize: 12,
          fontFamily: AppFont.fontRegular,
          color: AppColors.darkPrimaryColor),
      titleMedium: TextStyle(
          fontSize: 15,
          fontFamily: AppFont.fontRegular,
          color: AppColors.darkPrimaryColor),
      titleLarge: TextStyle(
          fontSize: 16.5,
          fontFamily: AppFont.fontMedium,
          color: AppColors.darkPrimaryColor),
    );
  }
}
