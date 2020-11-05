import 'dart:async';

class LoginValidator {
  final emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@')) {
        sink.add(email);
      } else {
        sink.addError('Insira um e-mail válido');
      }
    },
  );

  final passValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      if (pass.length >= 6) {
        sink.add(pass);
      } else {
        sink.addError('Insira senha com pelo menos 6 caracteres');
      }
    },
  );
}
