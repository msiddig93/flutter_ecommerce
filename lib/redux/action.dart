import 'dart:convert';

import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';
// import 'package:flutter_ecommerce/widgets/product_details_page.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_ecommerce/models/app_state.dart';

// user actions .
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user =
      storedUser != null ? User.formJson(json.decode(storedUser)) : null;
  // print("#++++++++++++++++++++++++++++++++++++++++++#");
  // print('JWT Token: ${user.jwt}');
  // print("#++++++++++++++++++++++++++++++++++++++++++#");
  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;

  User get user => this._user;

  GetUserAction(this._user);
}

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;
  store.dispatch(LogoutUserAction(user));
};

class LogoutUserAction {
  final User _user;

  User get user => this._user;

  LogoutUserAction(this._user);
}

// products action .
ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  http.Response response =
      await http.get('http://192.168.43.169:1337/products');

  final List<dynamic> responseData = json.decode(response.body);
  List<Product> products = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    products.add(product);
  });
  store.dispatch(GetProductsAction(products));
};

class GetProductsAction {
  final List<Product> _products;
  List<Product> get products => this._products;
  GetProductsAction(this._products);
}

// cartProduct Action actions .
ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return (Store<AppState> store) async {
    // get user from sharedPreph to get hes cart products .
    final prefs = await SharedPreferences.getInstance();
    final String storedUser = prefs.getString('user');
    User user = User.formJson(json.decode(storedUser));

    final List<Product> cartProducts = store.state.cartProducts;
    final int index =
        cartProducts.indexWhere((product) => product.id == cartProduct.id);

    bool isInCart = index > -1 == true;
    List<Product> updatedCartProducts = List.from(cartProducts);
    if (isInCart) {
      updatedCartProducts.removeAt(index);
    } else {
      updatedCartProducts.add(cartProduct);
    }

    final List<String> products =
        updatedCartProducts.map((product) => product.id).toList();
    http.Response response = await http.put(
        'http://192.168.43.169:1337/carts/${user.cartId}',
        body: {"products": json.encode(products)},
        headers: {"Authorization": "Bearer ${user.jwt}"});
    store.dispatch(ToggleCartProductAction(updatedCartProducts));
  };
}

class ToggleCartProductAction {
  final List<Product> _cartProducts;
  List<Product> get cartProducts => this._cartProducts;
  ToggleCartProductAction(this._cartProducts);
}

ThunkAction<AppState> getCartProductsAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  if (storedUser == null) {
    return;
  }

  User user = User.formJson(json.decode(storedUser));

  http.Response response = await http
      .get('http://192.168.43.169:1337/carts/${user.cartId}', headers: {
    "Authorization": "Bearer ${user.jwt}",
  });

  final responseData = json.decode(response.body)['products'];
  List<Product> products = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    products.add(product);
  });
  store.dispatch(GetCartProductsAction(products));
};

class GetCartProductsAction {
  final List<Product> _cartProducts;
  List<Product> get cartProducts => this._cartProducts;
  GetCartProductsAction(this._cartProducts);
}

// getCardsAction

ThunkAction<AppState> getCardsAction = (Store<AppState> store) async {
  final String customerId = store.state.user.customerID;
  final http.Response response =
      await http.get('http://192.168.43.169:1337/card?$customerId');
  final responseData = json.decode(response.body);
  print('Cart Data: ${responseData}');
};
