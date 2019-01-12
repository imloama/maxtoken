import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/**
 * 语言Redux
 * 代码来自： https://github.com/CarGuo/GSYGithubAppFlutter/blob/master/lib/common/redux/LocaleRedux.dart
 */

final LocaleReducer = combineReducers<Locale>([
  TypedReducer<Locale, RefreshLocaleAction>(_refresh),
]);

Locale _refresh(Locale locale, RefreshLocaleAction action) {
  locale = action.locale;
  return locale;
}

class RefreshLocaleAction {
  final Locale locale;

  RefreshLocaleAction(this.locale);
}