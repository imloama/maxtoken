import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import './redux/AppState.dart';
import './theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './i18n/i18n_delegate.dart';
import './i18n/i18n.dart';
import './routes.dart';
import './page/welcome.dart';
import './page/home.dart';

class MaxTokenApp extends StatelessWidget{

  final store = new Store<AppState>(
    appReducer,
    initialState: AppState(
      wallets: List(),
      themeData: new ThemeData(
            primarySwatch: MTTheme.LightTheme,
            platform: TargetPlatform.android,//fix #192
        ),
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
            Routes.MyWallet: (context){

            },
            Routes.Home: (context){
              return HomePage();
            }
          },
        );
      },),
    );
  }



}