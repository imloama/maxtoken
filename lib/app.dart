import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:maxtoken/redux/app_state.dart';
import 'package:maxtoken/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maxtoken/i18n/i18n_delegate.dart';
import 'package:maxtoken/i18n/i18n.dart';
import 'package:maxtoken/routes.dart';
import 'package:maxtoken/page/welcome.dart';
import 'package:maxtoken/page/home.dart';
import 'package:maxtoken/page/index.dart';

class MaxTokenApp extends StatelessWidget{

  final store = new Store<AppState>(
    appReducer,
    initialState: AppState(
      wallets: List(),
      themeData: kDarkMTTheme.data,
      locale: Locale('zh', 'CH')
      ),
  );

  MaxTokenApp({Key key}):super(key: key);


  @override
  Widget build(BuildContext context) {
    // 通过 StoreProvider 应用 store
    return new StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(builder: (context,store){
        return MaterialApp(
          // 多语言
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            I18NDelegate.delegate
          ],
          locale: store.state.locale,
          supportedLocales: [store.state.locale],
          theme: store.state.themeData,
          routes: {
            Routes.Welcome: (context){
              store.state.platformLocale = Localizations.localeOf(context);
              return WelcomePage();
            },
            Routes.Index: (context){
              return IndexPage();
            }
          },
        );
      },),
    );
  }



}