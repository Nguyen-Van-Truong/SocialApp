import 'package:flutter/material.dart';
import 'package:social_app/views/screen/auth/Login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String gender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildRegistrationForm(),
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
          color: Colors.black,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          _buildTextField(hintText: "Name", obscureText: false),
          _buildGenderSelection(),
          _buildTextField(hintText: "Email", obscureText: false),
          _buildTextField(hintText: "Password", obscureText: true),
          _buildTextField(hintText: "Confirm password", obscureText: true),
          SizedBox(height: 30),
          _buildRegisterButton(),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              // Điều hướng đến trang đăng nhập
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Text(
              "Already have an account",
              style: TextStyle(
                color: Color.fromRGBO(143, 148, 251, 1),
                fontWeight: FontWeight.bold,
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

  Widget _buildGenderSelection() {
    return Row(
      children: <Widget>[
        Text(
          "Gender:",
          style: TextStyle(color: Colors.grey[700]),
        ),
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

  Widget _buildRegisterButton() {
    return Container(
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
          "Register",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
