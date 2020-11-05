import 'package:ecommerce_manager_flutter/blocs/login_bloc.dart';
import 'package:ecommerce_manager_flutter/screens/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginBloc _loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
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
                          onPressed: snapshot.hasData ? () {} : null,
                          disabledColor: Colors.pinkAccent.withAlpha(140),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
