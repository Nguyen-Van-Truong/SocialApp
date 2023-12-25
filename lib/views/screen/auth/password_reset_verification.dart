import 'package:flutter/material.dart';
import 'package:social_app/views/screen/auth/change_password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:social_app/config.dart';

class PasswordResetVerification extends StatefulWidget {
  final String email;

  PasswordResetVerification({Key? key, required this.email}) : super(key: key);

  @override
  _PasswordResetVerificationState createState() => _PasswordResetVerificationState();
}

class _PasswordResetVerificationState extends State<PasswordResetVerification> {
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  Future<void> resendVerificationCode() async {
    var response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/users/forgotPassword.php'),
      body: {
        'email': widget.email,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      _showErrorDialog(context, 'Network error occurred');
    }
  }

  Future<void> verifyCode() async {
    String code = controllers.map((controller) => controller.text).join();

    var response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/users/verifyCode.php'),
      body: {
        'email': widget.email,
        'code': code,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(email: widget.email,)));
      } else {
        _showErrorDialog(context, data['message']);
      }
    } else {
      _showErrorDialog(context, 'Network error occurred');
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
            Navigator.pop(context, widget.email); // Go back and pass the email
          },
        ),
      ],
    );
  }

  Widget _buildCodeInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) => _buildSingleCodeInput(index)),
    );
  }

  Widget _buildSingleCodeInput(int index) {
    return Container(
      width: 40,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: "", // Hides the counter text below the TextField
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Clear and replace the existing digit
            controllers[index].text = ''; // Clear the existing digit
            controllers[index].text = value.substring(value.length - 1); // Insert the new digit

            // Move to the next field if current field is filled and not the last one
            if (index < 5) {
              focusNodes[index + 1].requestFocus();
            }
          } else if (value.isEmpty && index > 0) {
            // Move to the previous field if current is cleared
            focusNodes[index - 1].requestFocus();
          }
        },
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
        resendVerificationCode(); // Resend the verification code
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
            verifyCode(); // Verify the code
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
