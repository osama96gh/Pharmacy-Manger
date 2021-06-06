import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmacy_manager/pages/login/authentication.dart';

import 'models/drug.dart';

class ApplicationState with ChangeNotifier {
  ApplicationState() {
    init();
  }

  StreamSubscription<QuerySnapshot>? _drugsSubscription;

  ApplicationLoginState _loginState = ApplicationLoginState.notKnown;

  ApplicationLoginState get loginState => _loginState;

  String? _email;

  String? get email => _email;

  List<Drug> drugs = [];

  void addDummyDrug() {
    drugs.add(
      Drug(
          serial: '1111111111',
          name: 'dummy drug ${drugs.length + 1}',
          expiredAt: DateTime.now().millisecond,
          description: "dummy very very long description"),
    );
    notifyListeners();
  }

  void addDrug(Drug drug) {
    drugs.add(drug);
    notifyListeners();
  }

  Future<DocumentReference> addDrugToFirestore(Drug drug) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Drugs")
        .add({
      'name': drug.name,
      'serial': drug.serial,
      'expiredAt': drug.expiredAt,
      'description': drug.description,
    });
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        _drugsSubscription = FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Drugs")
            .orderBy('expiredAt', descending: true)
            .snapshots()
            .listen((snapshot) {
          drugs = [];
          snapshot.docs.forEach((document) {
            drugs.add(
              Drug(
                name: document.data()['name'],
                serial: document.data()['serial'],
                expiredAt: document.data()['expiredAt'],
                description: document.data()['description'],
              ),
            );
          });
          notifyListeners();
        });
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        // Navigator.pushNamed(context, "/login");
      }

      notifyListeners();
    });
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateProfile(displayName: displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
