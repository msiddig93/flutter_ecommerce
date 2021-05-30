import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartPage extends StatefulWidget {
  final void Function() onInit;
  CartPage({this.onInit});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void initState() {
    super.initState();
    widget.onInit();
  }

  Widget _cartTab() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return Column(
          children: [
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: GridView.builder(
                  itemCount: state.cartProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0),
                  itemBuilder: (context, i) =>
                      ProductItem(state.cartProducts[i]),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _cardsTab() {
    return Text('cards page');
  }

  Widget _ordersTab() {
    return Text('Order Tab');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Cart Page'),
          backgroundColor: Colors.cyan,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.shopping_basket_outlined),
              ),
              Tab(
                icon: Icon(Icons.credit_card_outlined),
              ),
              Tab(
                icon: Icon(Icons.receipt_long_outlined),
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          _cartTab(),
          _cardsTab(),
          _ordersTab(),
        ]),
      ),
    );
  }
}
