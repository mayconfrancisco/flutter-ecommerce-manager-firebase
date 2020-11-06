import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_manager_flutter/validators/login_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidator {
  final _emailController = BehaviorSubject<String>();
  final _passController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get emailOutput =>
      _emailController.stream.transform(emailValidator);

  Stream<String> get passOutput =>
      _passController.stream.transform(passValidator);

  Stream<LoginState> get stateOutout => _stateController.stream;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePass => _passController.sink.add;

  Stream<bool> get submitValidOutput =>
      Observable.combineLatest2(emailOutput, passOutput, (a, b) => true);

  StreamSubscription<FirebaseUser> _streamSubscription;

  LoginBloc() {
    _streamSubscription =
        FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.IDLE);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  void submit() {
    final email = _emailController.value;
    final pass = _passController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass)
        .catchError((onError) {
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return Firestore.instance
        .collection('admins')
        .document(user.uid)
        .get()
        .then((doc) {
      if (doc.data != null) {
        return true;
      }
      return false;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }
}
