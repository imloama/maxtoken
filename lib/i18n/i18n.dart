import 'dart:ui';
import 'package:flutter/material.dart';

import '../locales/base.dart';
import '../locales/en.dart';
import '../locales/zh_cn.dart';

class I18N{
  final Locale locale;

  I18N(this.locale);

  static Map<String,BaseString>  _locales = {
    'en': new EnString(),
    'zh': new ZhCNString(),
  };


  BaseString get currentLocale{
    return _locales[locale.languageCode];
  }


  static I18N of(BuildContext context){
    return Localizations.of(context, I18N);
  }


}