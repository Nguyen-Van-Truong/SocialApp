import 'package:flutter/material.dart';
import 'package:social_app/views/screen/auth/register.dart';
import 'package:social_app/views/screen/home.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildLoginForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Text(
        "Login",
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          _buildTextField(hintText: "Email or Phone number", obscureText: false),
          _buildTextField(hintText: "Password", obscureText: true),
          SizedBox(height: 30),
          _buildLoginButton(context),
          SizedBox(height: 70),
          GestureDetector(
            onTap: () {
              // Thực hiện điều hướng đến trang đăng ký
              Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
            },
            child: Text(
              "Create Account",
              style: TextStyle(
                color: Color.fromRGBO(143, 148, 251, 1),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hintText, required bool obscureText}) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 15),
      decoration: _textFieldDecoration(),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  BoxDecoration _textFieldDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Color.fromRGBO(143, 148, 251, 1)),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(143, 148, 251, .2),
          blurRadius: 20.0,
          offset: Offset(0, 10),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Thực hiện điều hướng đến màn hình Home
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
            ],
          ),
        ),
        child: Center(
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
