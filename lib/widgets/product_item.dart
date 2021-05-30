import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/redux/action.dart';
import 'package:flutter_ecommerce/widgets/product_details_page.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductItem extends StatefulWidget {
  @override
  final Product item;
  ProductItem(this.item);
  _ProductItemState createState() => _ProductItemState(this.item);
}

class _ProductItemState extends State<ProductItem> {
  final Product item; // = widget.item;
  _ProductItemState(this.item);
  bool _isSubmitting = false;

  bool _isInCart(AppState state, String id) {
    final List<Product> cartProducts = state.cartProducts;
    return cartProducts.indexWhere((product) => product.id == id) > -1;
  }

  @override
  Widget build(BuildContext context) {
    final String pictureUrl =
        'http://192.168.43.169:1337${item.picture['url']}';
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ProductDetailPage(item: item);
        },
      )),
      child: GridTile(
        footer: GridTileBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          subtitle: Text(
            "\$${item.price}",
            style: TextStyle(fontSize: 16.0),
          ),
          trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              if (state.user != null) {
                return _isSubmitting == true
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: _isInCart(state, item.id)
                            ? Icon(Icons.remove_shopping_cart_outlined)
                            : Icon(Icons.add_shopping_cart),
                        color: _isInCart(state, item.id)
                            ? Colors.deepOrange[200]
                            : Colors.white,
                        onPressed: () {
                          setState(() {
                            _isSubmitting = true;
                          });
                          StoreProvider.of<AppState>(context)
                              .dispatch(toggleCartProductAction(item));
                          setState(() {
                            _isSubmitting = false;
                          });
                        });
              } else {
                return Text('');
              }
            },
          ),
          backgroundColor: Color(0xBB000000),
        ),
        child: Hero(
          tag: item,
          child: Image.network(
            pictureUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
