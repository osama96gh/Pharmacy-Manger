import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_manager/pages/home/home_page.dart';
import 'package:pharmacy_manager/app_state.dart';
 import 'package:pharmacy_manager/pages/login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_manager/utilities/enums.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Firebase Meetup',
          theme: ThemeData(
            buttonTheme: Theme.of(context).buttonTheme.copyWith(
                  highlightColor: Colors.blueGrey,
                ),
            primarySwatch: Colors.blueGrey,
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) {
                  switch (appState.loginState) {
                    case ApplicationLoginState.loggedIn:
                    case ApplicationLoginState.notKnown:
                       return HomePage();
                    default:
                      return LoginPage();
                  }
                });
              case '/login':
                return MaterialPageRoute(builder: (_) => LoginPage());
              case '/home':
                return MaterialPageRoute(builder: (_) => HomePage());
            }
          },
        );
      },
    );
  }
}
