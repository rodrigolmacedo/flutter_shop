import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/firebase_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  AnimationController _controllerAnimation;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controllerAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controllerAnimation, curve: Curves.linear));

    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _controllerAnimation, curve: Curves.linear));
  }

  @override
  void dispose() {
    super.dispose();
    _controllerAnimation.dispose();
  }

  final Map<String, String> authData = {'email': '', 'password': ''};
  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    Auth auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_authMode == AuthMode.Login) {
        await auth.logIn(authData["email"], authData["password"]);
      } else {
        await auth.signup(authData["email"], authData["password"]);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro inesperado.");
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controllerAnimation.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controllerAnimation.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        width: deviceSize.width * 0.75,
        height: _authMode == AuthMode.Login ? 290 : 371,
        //height: _heightAnimation.value.height,
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  //keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@'))
                      return 'informe um email válido';
                    return null;
                  },
                  onSaved: (value) => authData['email'] = value,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Senha'),
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty || value.length < 5)
                            return 'informe uma senha válida';
                          return null;
                        },
                        onSaved: (value) => authData['password'] = value,
                      ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirmar Senha'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text)
                                  return 'senhas são diferentes!';
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Text(
                      _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
                ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      "ALTERNAR P/ ${_authMode == AuthMode.Login ? 'REGISTRAR' : 'ENTRAR'}"),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            )),
      ),
    );
  }
}
