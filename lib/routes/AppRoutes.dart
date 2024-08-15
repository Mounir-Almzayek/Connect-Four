import 'package:flutter/material.dart';
import 'package:connectfour/presentation/SignInPage.dart';
import 'package:connectfour/presentation/SignUpPage.dart';
import 'package:connectfour/presentation/HomePage.dart';
import 'package:connectfour/presentation/GamePage.dart';
import 'package:connectfour/presentation/AccountPage.dart';

class AppRoutes {
  static const String signInPage = '/sign_in';
  static const String signUpPage = '/sign_up';
  static const String homePage = '/home';
  static const String gamePage = '/game';
  static const String accountPage = '/account';

  static Map<String, WidgetBuilder> get routes => {
    signInPage: (context) => SignInPage(),
    signUpPage: (context) => SignUpPage(),
    homePage: (context) => HomePage(),
    accountPage: (context) => AccountPage(),
  };
}
