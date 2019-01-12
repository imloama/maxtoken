import 'package:flutter/material.dart';
import '../model/Wallet.dart';

class AppState {

  ///主题数据
  ThemeData themeData;

   ///语言
  Locale locale;
   ///当前手机平台默认语言
  Locale platformLocale;
  
  List<Wallet> wallets;

  int selected;

  AppState({this.themeData, this.locale, this.platformLocale, this.wallets, this.selected});



}


AppState appReducer(AppState state, action){
  return AppState({
    
  });
}