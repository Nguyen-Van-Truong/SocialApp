import 'package:flutter/material.dart';
import 'package:social_app/views/screen/auth/register.dart';
import 'package:social_app/views/widgets/MainScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/AdminDashboardPage.dart';
import 'forgot_password.dart';
import 'package:social_app/config.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    var response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/users/login.php'),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setInt('user_id', data['user_id']);
        await prefs.setString('email', data['email']);
        await prefs.setString('username', data['username']);
        String profileImageUrl = data['profile_image_url'] != null
            ? data['profile_image_url']
            : 'assets/images/user_placeholder.png';
        await prefs.setString('profile_image_url', profileImageUrl);

        // Check the user's role
        String role = data['role'];
        if (role == 'admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AdminDashboardPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        }
      } else {
        _showErrorDialog(context, data['message']);
      }
    } else {
      _showErrorDialog(context, 'Network Error');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _buildTextField(controller: _emailController, hintText: "Email", obscureText: false),
          _buildTextField(controller: _passwordController, hintText: "Password", obscureText: true),
          SizedBox(height: 30),
          _buildLoginButton(context),
          _buildTextButton(context, "Forgot Password?", ForgotPassword()),
          SizedBox(height: 40),
          _buildTextButton(context, "Create Account", Register()),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20.0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _login(context),
      child: Text(
        "Login",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, String text, Widget page) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Text(text),
    );
  }
}
