import 'package:flutter/material.dart';

class ResponsiveHelper {
  final BuildContext context;

  // Constructor to initialize the context
  ResponsiveHelper(this.context);

  // Get the screen width
  double get screenWidth => MediaQuery.of(context).size.width;

  // Get the screen height
  double get screenHeight => MediaQuery.of(context).size.height;

  // Calculate width based on a percentage of the screen width
  double widthPercentage(double percentage) {
    return screenWidth * (percentage / 100);
  }

  // Calculate height based on a percentage of the screen height
  double heightPercentage(double percentage) {
    return screenHeight * (percentage / 100);
  }

  // Calculate padding based on percentage of screen dimensions
  EdgeInsets getPadding({double vertical = 0, double horizontal = 0}) {
    return EdgeInsets.symmetric(
      vertical: heightPercentage(vertical),
      horizontal: widthPercentage(horizontal),
    );
  }

  // Calculate margin based on percentage of screen dimensions
  EdgeInsets getMargin({double vertical = 0, double horizontal = 0}) {
    return EdgeInsets.symmetric(
      vertical: heightPercentage(vertical),
      horizontal: widthPercentage(horizontal),
    );
  }

  // Calculate text size based on a percentage of screen width
  double textSize(double percentage) {
    return widthPercentage(percentage);
  }
}
