import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './i18n.dart';

class I18NDelegate extends LocalizationsDelegate<I18N>{
  I18NDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<I18N> load(Locale locale) {
     return new SynchronousFuture<I18N>(new I18N(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<I18N> old) {
    return false;
  }

  ///全局静态的代理
  static I18NDelegate delegate = new I18NDelegate();

}