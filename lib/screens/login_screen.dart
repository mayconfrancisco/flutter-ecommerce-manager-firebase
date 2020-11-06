import 'dart:async';

import 'package:ecommerce_manager_flutter/blocs/login_bloc.dart';
import 'package:ecommerce_manager_flutter/screens/home_screen.dart';
import 'package:ecommerce_manager_flutter/screens/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginBloc _loginBloc = LoginBloc();
  StreamSubscription<LoginState> _loginStateSubscription;

  @override
  void initState() {
    super.initState();
    _loginStateSubscription = _loginBloc.stateOutout.listen((state) {
      switch (state) {
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Erro'),
                    content: Text(
                        'Você não possui os privilégios necessários ou essa conta não existe'),
                  ));
          break;
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.IDLE:
        case LoginState.LOADING:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: StreamBuilder<LoginState>(
          initialData: LoginState.LOADING,
          stream: _loginBloc.stateOutout,
          builder: (context, loginStateSnapshot) {
            switch (loginStateSnapshot.data) {
              case LoginState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
              default:
                return Center(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.store_mall_directory,
                            size: 130,
                            color: Colors.pinkAccent,
                          ),
                          InputField(
                            icon: Icons.person_outline,
                            hint: 'E-mail',
                            obscure: false,
                            onChanged: _loginBloc.changeEmail,
                            stream: _loginBloc.emailOutput,
                          ),
                          InputField(
                            icon: Icons.lock_outline,
                            hint: 'Senha',
                            obscure: true,
                            onChanged: _loginBloc.changePass,
                            stream: _loginBloc.passOutput,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          StreamBuilder<bool>(
                              stream: _loginBloc.submitValidOutput,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    child: Text(
                                      'Entrar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.pinkAccent,
                                    onPressed: snapshot.hasData
                                        ? _loginBloc.submit
                                        : null,
                                    disabledColor:
                                        Colors.pinkAccent.withAlpha(140),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                );
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginStateSubscription.cancel();
    _loginBloc.dispose();
  }
}
