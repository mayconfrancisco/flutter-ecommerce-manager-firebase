import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ecommerce_manager_flutter/validators/login_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class LoginBloc extends BlocBase with LoginValidator {
  final _emailController = BehaviorSubject<String>();
  final _passController = BehaviorSubject<String>();

  Stream<String> get emailOutput =>
      _emailController.stream.transform(emailValidator);

  Stream<String> get passOutput =>
      _passController.stream.transform(passValidator);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePass => _passController.sink.add;

  Stream<bool> get submitValidOutput =>
      Observable.combineLatest2(emailOutput, passOutput, (a, b) => true);

  @override
  void dispose() {
    _emailController.close();
    _passController.close();
  }
}
