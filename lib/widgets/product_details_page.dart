import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/pages/product_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product item;

  ProductDetailPage({this.item});
  @override
  Widget build(BuildContext context) {
    final String pictureUrl =
        'http://192.168.43.169:1337${item.picture['url']}';
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(item.name),
          backgroundColor: Colors.cyan),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Hero(
                tag: item,
                child: Image.network(
                  pictureUrl,
                  fit: BoxFit.cover,
                  width: orientation == Orientation.portrait ? 500 : 250,
                  height: orientation == Orientation.portrait ? 300 : 200,
                  colorBlendMode: BlendMode.dstOver,
                  // width: Double(MediaQuery.of(context).size),
                ),
              ),
            ),
            Text(
              item.name,
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              item.price.toString(),
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  child: Text(item.description),
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
