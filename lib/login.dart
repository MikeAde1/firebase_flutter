import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';
import 'network/authentication.dart';

class LoginPage extends StatefulWidget {
  final Auth auth;
  LoginPage(this.auth);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String email;
  String password;
  String errorMessage = "";

  bool isLoginForm = false;
  bool isLoading= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  final formKey = new GlobalKey<FormState>();

  Widget _showCircularProgress() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (errorMessage.length > 0 && errorMessage != null) {
      return new Text(
        errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/alarm.jpg'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
      onPressed: () {
        //go to sign up
        Navigator.pushNamed(context, SignUp, arguments: {"auth": widget.auth});
      },
      child: new Text(
          'Create an account',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)
            ),
            color: Colors.blue,
            onPressed:  () async {
              if(validateFields()){
                Fluttertoast.showToast(msg: "shows");
                performLogin();
              }
            },
            child: new Text( 'Login',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          ),
        ));
  }

  bool validateFields() {
    final form = formKey.currentState;
    if (!form.validate()) {
      return false;
    }
    form.save();
    if(!EmailValidator.validate(email)){
      setState(() {
        errorMessage = "Invalid Email";
      });
      Fluttertoast.showToast(msg: email);
      return false;
    }
    form.save();
    return true;
  }

  void performLogin() async {
    setState(() {
      errorMessage = "";
      isLoading = true;
    });
    String userId = "";
    try {
      userId = await widget.auth.signIn(email, password);
      //widget.auth.sendEmailVerification();
      //_showVerifyEmailSentDialog();
      Fluttertoast.showToast(msg: userId);
      print('Signed up user: $userId');

      setState(() {
        isLoading = false;
      });

      if (userId.length > 0 && userId != null) {
        //navigate to next activity
        Navigator.pushNamed(context, HomePage, arguments: {"user_id": userId});
      }
    } catch (e) {
      print('Error::: $e');
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
        //reset form key
      });
    }
  }

}
