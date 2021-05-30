import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/redux/reducers.dart';
import 'package:flutter_ecommerce/redux/action.dart';
import 'pages/cart_page.dart';
import 'pages/login_page.dart';
import 'pages/product_page.dart';
import 'pages/register_page.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware, LoggingMiddleware.printer()]);
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Store<AppState> store;
  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Ecommerce App',
        routes: {
          '/': (BuildContext context) => ProductPage(
                onInit: () {
                  // dispatch a action 'getUserAction' to grab user data .
                  StoreProvider.of<AppState>(context).dispatch(getUserAction);
                  // dispatch a action 'getProductsAction' to grab products data .
                  StoreProvider.of<AppState>(context)
                      .dispatch(getProductsAction);
                  // dispatch a action 'getCartProductsAction' to grab products data .
                  StoreProvider.of<AppState>(context)
                      .dispatch(getCartProductsAction);
                },
              ),
          '/register': (BuildContext context) => RegisterPage(),
          '/login': (BuildContext context) => LoginPage(),
          '/cart': (BuildContext context) => CartPage(
                onInit: () {
                  // dispatch a action 'getCardsAction' to grab Cards data .
                  StoreProvider.of<AppState>(context).dispatch(getCardsAction);
                },
              ),
        },
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          brightness: Brightness.dark,
          accentColor: Colors.deepOrange[200],
          fontFamily: "Ubuntu",
          textTheme: TextTheme(
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              headline: TextStyle(
                  fontSize: 72.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
              body1: Theme.of(context).textTheme.body1.merge(
                    const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Ubuntu',
                    ),
                  )),
          // visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
