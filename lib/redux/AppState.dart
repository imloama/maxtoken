import 'package:flutter/material.dart';
import '../model/Wallet.dart';
import './LocaleRedux.dart';
import './ThemeRedux.dart';
import './WalletRedux.dart';

class AppState {

  // theme
  ThemeData themeData;

   // choosed locale
  Locale locale;
   // current locale on phone
  Locale platformLocale;
  
  // all wallets
  List<Wallet> wallets;

  // selected wallet
  int selected;

  AppState({this.themeData, this.locale, this.platformLocale, this.wallets, this.selected});



}


AppState appReducer(AppState state, action){
  return AppState(
    themeData: ThemeDataReducer(state.themeData, action),
    locale: LocaleReducer(state.locale, action),
    wallets: WalletReducer(state.wallets, action),

  );
}