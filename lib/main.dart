import 'file:///C:/Users/micha/Desktop/firebase_flutter/lib/signup.dart';
import 'package:firebaseflutter/login.dart';
import 'package:firebaseflutter/network/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

const Splash = "/";
const HomePage = "/HomePage";
const SignUp = "/signup";
const Login = "/login";
AuthStatus authStatus;

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: _route(),
    );
  }
}

RouteFactory _route() {
  return (settings) {
    final Map<String, dynamic> arguments = settings.arguments;
    Widget screen;
    switch (settings.name) {
      case Splash:
        screen = SplashPage();
        break;
      case HomePage:
        screen = MyHomePage(arguments["user_id"]);
        break;
      case SignUp:
        screen = SignUpPage(arguments["auth"]);
        break;
      case Login:
        screen = LoginPage(arguments["auth"]);
        break;
      default:
        return null;
    }
    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}

class SplashPage extends StatefulWidget {
  @override
  SplashScreen createState() => SplashScreen();
}

class SplashScreen extends State<SplashPage> {
  Auth auth = new Auth();
  String userId;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      auth.getCurrentUser().then((user) {
        setState(() {
          if (user != null) {
            userId = user?.uid;
          }
          if (userId != null) {
            //logged in
            Navigator.popAndPushNamed(context,  HomePage, arguments: {"user_id": userId});
          } else {
            //logged out
            Navigator.popAndPushNamed(context, Login, arguments: {"auth": auth});
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: new BorderRadius.all(Radius.circular(30)),
              ),
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Text(
                  "Time Keeper",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )),
        ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  final String userId;
  MyHomePage(this.userId);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Auth auth = new Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            PopupMenuButton<int>(itemBuilder: (context) => [
              PopupMenuItem(
                height: 30,
                value: 1,
                child: Text("Log out"),
              ),
            ],
              onSelected: (int) {
                signOut();
              },
          )]
      ),
      body: Center(

      ),
    );
  }

  signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    } finally {
      Navigator.of(context).pushNamedAndRemoveUntil(Login, (Route<dynamic> route) => false, arguments: {"auth": auth});
    }
  }
}
