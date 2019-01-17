import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:maxtoken/routes.dart';
import 'package:maxtoken/page/full_web_view.dart';


class Navigators {
 ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

   ///主页
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.Index);
  }


   ///全屏Web页面
  static Future<Null> goWebView(BuildContext context, String url, String title) {
    return Navigator.push(
      context,
      new CupertinoPageRoute(
        builder: (context) => new FullWebView(url, title),
      ),
    );
  }


}