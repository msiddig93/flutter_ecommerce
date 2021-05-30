// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/redux/action.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:badges/badges.dart';

final gradientBackground = BoxDecoration(
    color: Colors.white,
    gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [
          0.1,
          0.3,
          0.5,
          0.7,
          0.9
        ],
        colors: [
          Colors.deepPurple[300],
          Colors.deepPurple[400],
          Colors.deepPurple[500],
          Colors.deepPurple[600],
          Colors.deepPurple[700]
        ]));

class ProductPage extends StatefulWidget {
  final void Function() onInit;
  ProductPage({this.onInit});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  void initState() {
    super.initState();
    widget.onInit();
  }

  final Widget _appBar = PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AppBar(
          centerTitle: true,
          backgroundColor: Colors.cyan,
          title: SizedBox(
              child: state.user != null
                  ? Text(state.user.username)
                  : FlatButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: Text(
                        "Regiser here",
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Colors.white),
                      ))),
          leading: state.user != null
              // ? IconButton(
              //     icon: Badge(
              //       shape: BadgeShape.square,
              //       borderRadius: BorderRadius.circular(100),
              //       child: Icon(Icons.settings),
              //       badgeContent: Container(
              //         height: 5,
              //         width: 5,
              //         child: Text('4'),
              //       ),
              //     ),
              //     onPressed: () => Navigator.pushNamed(context, '/cart'),
              //   )
              ? Badge(
                  shape: BadgeShape.circle,
                  badgeColor: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(5),
                  position: BadgePosition.topEnd(top: 6.0, end: 5.0),
                  padding: EdgeInsets.all(6.0),
                  showBadge: state.cartProducts.length != 0,
                  badgeContent: Text(
                    state.cartProducts.length.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.shopping_basket_outlined),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ))
              : Text(''),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(logoutUserAction);
                  },
                  builder: (_, callback) {
                    return state.user != null
                        ? IconButton(
                            icon: Icon(Icons.exit_to_app), onPressed: callback)
                        : Text('');
                  },
                ))
          ],
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: _appBar,
      body: Container(
          decoration: gradientBackground,
          child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              return Column(
                children: [
                  Expanded(
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: GridView.builder(
                        itemCount: state.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                        itemBuilder: (context, i) =>
                            ProductItem(state.products[i]),
                      ),
                    ),
                  )
                ],
              );
            },
          )),
    );
  }
}
