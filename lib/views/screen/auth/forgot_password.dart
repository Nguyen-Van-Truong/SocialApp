import 'package:flutter/material.dart';
import 'package:social_app/views/screen/auth/Login.dart';
import 'package:social_app/views/screen/auth/password_reset_verification.dart';


class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildForgotPasswordForm(context),
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
        "Forgot Password",
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          _buildTextField(hintText: "Email", obscureText: false),
          SizedBox(height: 30),
          _buildResetButton(context),
          SizedBox(height: 70),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Text(
              "Back to login",
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
        controller: _emailController, // Sử dụng controller ở đây
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

  Widget _buildResetButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_isValidEmail(_emailController.text)) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordResetVerification(email: _emailController.text),
            ),
          );

          if (result != null && result is String) {
            _emailController.text = result; // Cập nhật controller với email được chỉnh sửa
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter a valid email address')),
          );
        }
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
            "Send Request",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }
}
