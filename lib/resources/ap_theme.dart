import 'package:flutter/material.dart';

import 'ap_colors.dart';

class ApTheme extends InheritedWidget {
  final ThemeMode themeMode;

  ApTheme(this.themeMode, {Widget child}) : super(child: child);

  static ApTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(ApTheme oldWidget) {
    return true;
  }

  static const String DARK = 'dark';
  static const String LIGHT = 'light';
  static const String SYSTEM = 'system';

  static String code = ApTheme.LIGHT;

  Brightness get _brightness {
    switch (themeMode) {
      case ThemeMode.system:
        return WidgetsBinding.instance.window.platformBrightness;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
      default:
        return Brightness.dark;
    }
  }

  Color get blue {
    switch (_brightness) {
      case Brightness.light:
        return ApColors.blue500;
        break;
      case Brightness.dark:
      default:
        return ApColors.blueDark;
        break;
    }
  }

  Color get blueText {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.grey100;
      case Brightness.light:
      default:
        return ApColors.blue500;
    }
  }

  get blueAccent {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.blue300;
      case Brightness.light:
      default:
        return ApColors.blue500;
    }
  }

  get semesterText {
    switch (_brightness) {
      case Brightness.dark:
        return Color(0xffffffff);
      case Brightness.light:
      default:
        return ApColors.blue500;
    }
  }

  Color get grey {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.grey200;
      case Brightness.light:
      default:
        return ApColors.grey500;
    }
  }

  Color get greyText {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.grey200;
      case Brightness.light:
      default:
        return ApColors.grey500;
    }
  }

  get disabled {
    switch (_brightness) {
      case Brightness.dark:
        return Color(0xFF424242);
      case Brightness.light:
      default:
        return Color(0xFFBDBDBD);
    }
  }

  Color get calendarTileSelect {
    switch (_brightness) {
      case Brightness.dark:
        return Color(0xff000000);
      case Brightness.light:
      default:
        return Color(0xffffffff);
    }
  }

  Color get yellow {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.yellow200;
      case Brightness.light:
      default:
        return ApColors.yellow500;
    }
  }

  Color get red {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.red200;
      case Brightness.light:
      default:
        return ApColors.red500;
    }
  }

  Color get bottomNavigationSelect {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.grey100;
      case Brightness.light:
      default:
        return Color(0xff737373);
    }
  }

  Color get segmentControlUnSelect {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.onyx;
      case Brightness.light:
      default:
        return Color(0xffffffff);
    }
  }

  get snackBarActionTextColor {
    switch (_brightness) {
      case Brightness.dark:
        return ApColors.yellow500;
      case Brightness.light:
      default:
        return ApColors.yellow500;
    }
  }

  double get drawerIconOpacity {
    switch (_brightness) {
      case Brightness.light:
        return 0.75;

      case Brightness.dark:
      default:
        return 1.0;
    }
  }

  static ThemeData get light => ThemeData(
        //platform: TargetPlatform.iOS,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: ApColors.blue500,
        ),
        accentColor: ApColors.blueText,
        unselectedWidgetColor: ApColors.grey,
        backgroundColor: Colors.black12,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        //platform: TargetPlatform.iOS,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ApColors.onyx,
        accentColor: ApColors.blueAccent,
        unselectedWidgetColor: ApColors.grey,
        backgroundColor: Colors.black12,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      );
}
