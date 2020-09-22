import 'package:flutter/material.dart';

extension NavigatorExt on BuildContext {
  navigateTo(Widget destination) {
    return Navigator.of(this)
        .push(MaterialPageRoute(builder: (context) => destination));
  }
}
