import 'package:flutter/material.dart';
import '../model/wallet.dart';
import '../model/site.dart';
import './locale_redux.dart';
import './theme_redux.dart';
import './wallet_redux.dart';
import './site_redux.dart';

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