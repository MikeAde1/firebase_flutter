import 'package:firebaseflutter/network/Login.dart';
import 'package:firebaseflutter/network/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

const Splash = "/";
const HomePage = "/HomePage";
const Loginpage = "/Login";
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
      case Loginpage:
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
            authStatus = AuthStatus.LOGGED_IN;
            Navigator.pushNamed(context, HomePage, arguments: {"user_id": userId});
          } else {
            //logged out
            authStatus = AuthStatus.NOT_LOGGED_IN;
            Navigator.pushNamed(context, Loginpage, arguments: {"auth": auth});
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(),
    );
  }
}
