import 'package:flutter/material.dart';
import 'package:social_app/views/screen/auth/change_password.dart';

class PasswordResetVerification extends StatefulWidget {
  final String email;

  PasswordResetVerification({Key? key, required this.email}) : super(key: key);

  @override
  _PasswordResetVerificationState createState() => _PasswordResetVerificationState();
}

class _PasswordResetVerificationState extends State<PasswordResetVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildVerificationForm(context),
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
        "Reset Password Verification",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVerificationForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          _buildEmailField(),
          SizedBox(height: 30),
          _buildCodeInputFields(),
          SizedBox(height: 20),
          _buildResendEmailButton(context),
          SizedBox(height: 30),
          _buildVerifyButton(context),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.email,
            style: TextStyle(fontSize: 18),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pop(context, widget.email); // Quay lại và truyền email
          },
        ),
      ],
    );
  }

  Widget _buildCodeInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) => _buildSingleCodeInput()),
    );
  }

  Widget _buildSingleCodeInput() {
    return Container(
      width: 40,
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildResendEmailButton(BuildContext context) {
    return TextButton(
      child: Text(
        "Resend Email",
        style: TextStyle(
          color: Color.fromRGBO(143, 148, 251, 1),
        ),
      ),
      onPressed: () {
        // Xử lý sự kiện gửi lại email
      },
    );
  }


  Widget _buildVerifyButton(BuildContext context) {
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
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword()),
            );
          },
          child: Text(
            "Verify",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
