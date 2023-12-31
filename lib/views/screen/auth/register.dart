import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:social_app/config.dart';
import 'package:social_app/views/screen/auth/Login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String gender = 'Male';

  Future<void> _registerUser(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog(context, "Passwords do not match");
      return;
    }

    var response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/users/register.php'),
      body: {
        'username': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'gender': gender == 'Male' ? '1' : '2',
        'bio': '', // Assuming bio is optional
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        _showErrorDialog(context, data['message']);
      }
    } else {
      _showErrorDialog(context, 'Lỗi kết nối mạng');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Lỗi'),
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildRegistrationForm(context),
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
        "Register",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          _buildTextField(controller: _nameController, hintText: "Name", obscureText: false),
          _buildGenderSelection(),
          _buildTextField(controller: _emailController, hintText: "Email", obscureText: false),
          _buildTextField(controller: _passwordController, hintText: "Password", obscureText: true),
          _buildTextField(controller: _confirmPasswordController, hintText: "Confirm Password", obscureText: true),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => _registerUser(context),
            child: Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // Full width button
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Text("Already have an account"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, required bool obscureText}) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 15),
      decoration: _textFieldDecoration(),
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

  BoxDecoration _textFieldDecoration() {
    return BoxDecoration(
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
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: <Widget>[
        Text("Gender:"),
        _buildGenderRadio("Male", "Male"),
        _buildGenderRadio("Female", "Female"),
      ],
    );
  }

  Widget _buildGenderRadio(String label, String value) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: gender,
          onChanged: (String? newValue) {
            setState(() {
              gender = newValue!;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
