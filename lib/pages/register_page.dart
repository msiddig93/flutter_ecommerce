import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting, _obscureText = true;
  String _username, _email, _password;

  final FocusNode _userFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  Widget _showTitle() {
    return Text(
      "Register",
      style: Theme.of(context).textTheme.headline3,
    );
  }

  Widget _showUsernameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _username = val.trim(),
        validator: (val) => val.length < 6 ? 'username is too short' : null,
        focusNode: _userFocus,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Username',
            hintText: 'Enter username, min length 6',
            icon: new Icon(Icons.person)),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _email = val.trim(),
        validator: (val) => !val.contains('@') || !val.contains('.')
            ? 'email is not valid'
            : null,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
            hintText: 'Enter a valid email',
            icon: new Icon(Icons.email_outlined)),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _password = val,
        validator: (val) => val.length < 6 ? 'password is too short' : null,
        obscureText: _obscureText,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() => _obscureText = !_obscureText);
                },
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off)),
            border: OutlineInputBorder(),
            labelText: 'Password',
            hintText: 'Enter password, min length 6',
            icon: new Icon(Icons.lock)),
      ),
    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          _isSubmitting == true
              ? CircularProgressIndicator()
              : RaisedButton(
                  child: Text(
                    "Register",
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Colors.black),
                  ),
                  elevation: 8.0,
                  color: Colors.deepOrange[200],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: _submit),
          FlatButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: Text("Existing user ? login"))
        ],
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response1 =
        await http.post('http://192.168.43.169:1337/carts');
    final response1Data = json.decode(response1.body);
    http.Response response = await http
        .post('http://192.168.43.169:1337/auth/local/register', body: {
      "username": _username,
      "email": _email,
      "password": _password,
      "cart_id": response1Data['id'].toString()
    });

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      // create customer data .
      await http.post('http://192.168.43.169:1337/customers', body: {
        "email": responseData['user']['email'].toString(),
        "user": responseData['user']['id'].toString()
      });
      setState(() {
        _isSubmitting = false;
      });
      _storeUserData(responseData);
      _showSuccessSnak();
      _redirectUser();
    } else {
      setState(() {
        _isSubmitting = false;
      });
      await http.delete(
          'http://192.168.43.169:1337/carts/${response1Data['id'].toString()}');
      final String erorrMsg = responseData['data'][0]['messages'][0]['message'];
      // print(response.body);
      print(responseData['data'][0]['messages'][0]['message']);
      // print(responseData['data'].toString());
      _showErrorSnak(erorrMsg);
    }
  }

  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
  }

  void _showSuccessSnak() {
    final snakBar = new SnackBar(
        content: Text('User $_username Successfuly created !',
            style: TextStyle(color: Colors.green)));

    _scafoldKey.currentState.showSnackBar(snakBar);
    _formKey.currentState.reset();
  }

  void _showErrorSnak(String msg) {
    final snakBar =
        new SnackBar(content: Text(msg, style: TextStyle(color: Colors.red)));

    _scafoldKey.currentState.showSnackBar(snakBar);
    // throw Exception('Error regisering $msg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _showTitle(),
                    _showUsernameInput(),
                    _showEmailInput(),
                    _showPasswordInput(),
                    _showFormActions()
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
