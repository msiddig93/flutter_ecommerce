import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();

  bool _isSubmitting, _obscureText = true;
  String _email, _password;

  Widget _showTitle() {
    return Text(
      "Login",
      style: Theme.of(context).textTheme.headline3,
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
                    "Login",
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
                  Navigator.pushReplacementNamed(context, '/register'),
              child: Text("New user ? Register"))
        ],
      ),
    );
  }

  void _submit() {
    print("Form is submit !");
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _registerUser();
      // print("Email : $_email ,Password : $_password");
    }
  }

  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response = await http.post(
        'http://192.168.43.169:1337/auth/local',
        body: {"identifier": _email, "password": _password});

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
      _storeUserData(responseData);
      _showSuccessSnak();
      _redirectUser();
      print(responseData);
    } else {
      setState(() {
        _isSubmitting = false;
      });

      final String erorrMsg = responseData['data'][0]['messages'][0]['message'];
      print(response.body);
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
        content: Text('User Successfuly Login !',
            style: TextStyle(color: Colors.green)));

    _scafoldKey.currentState.showSnackBar(snakBar);
    _formKey.currentState.reset();
  }

  void _showErrorSnak(String msg) {
    final snakBar = new SnackBar(
        content: Text(msg.toString(), style: TextStyle(color: Colors.red)));

    _scafoldKey.currentState.showSnackBar(snakBar);
    throw Exception('Error Loging $msg');
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
          "Login",
          // style: TextStyle(color: Colors.white),
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
