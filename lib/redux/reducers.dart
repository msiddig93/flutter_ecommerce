import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';

import 'action.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    products: productsReducer(state.products, action),
    cartProducts: cartProductsReducer(state.cartProducts, action),
  );
}

User userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    return action.user;
  } else if (action is LogoutUserAction) {
    return action.user;
  }
  return user;
}

List<Product> productsReducer(List<Product> products, dynamic action) {
  if (action is GetProductsAction) {
    return action.products;
  }
  return products;
}

List<Product> cartProductsReducer(List<Product> cartProducts, dynamic action) {
  if (action is GetCartProductsAction) {
    return action.cartProducts;
  } else if (action is ToggleCartProductAction) {
    return action.cartProducts;
  }
  return cartProducts;
}
