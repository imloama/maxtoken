import 'package:flutter/material.dart';
import 'package:maxtoken/model/wallet.dart';
import 'package:maxtoken/model/site.dart';
import 'package:maxtoken/redux/locale_redux.dart';
import 'package:maxtoken/redux/theme_redux.dart';
import 'package:maxtoken/redux/wallet_redux.dart';
import 'package:maxtoken/redux/site_redux.dart';

class AppState {

  Site site;
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

  AppState({this.site,this.themeData, this.locale, this.platformLocale, this.wallets, this.selected});



}


AppState appReducer(AppState state, action){
  return AppState(
    themeData: ThemeDataReducer(state.themeData, action),
    locale: LocaleReducer(state.locale, action),
    wallets: WalletReducer(state.wallets, action),
    site: SiteReducer(state.site, action),

  );
}