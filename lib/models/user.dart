import 'package:meta/meta.dart';

class User {
  String id;
  String username;
  String email;
  String jwt;
  String cartId;
  String customerID;

  User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.jwt,
    @required this.cartId,
    @required this.customerID,
  });

  factory User.formJson(Map<String, dynamic> json) {
    return User(
        id: json['id'].toString(),
        username: json['username'],
        email: json['email'],
        jwt: json['jwt'],
        cartId: json['cart_id'].toString(),
        customerID: json['customer']['customer_id'].toString());
  }
}
