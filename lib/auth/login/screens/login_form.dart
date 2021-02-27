import 'package:connect_four/auth/bloc/bloc.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../login.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('login.failure').tr(), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('login.logging').tr(),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
          Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 15.0),
                    child: ListTile(
                      title: Center(
                          child: Text(
                        'login.title',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ).tr()),
                      subtitle: Center(
                          child: Text(
                        'login.subtitle',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ).tr()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text('login.socials').tr(),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: SignInButton(type: ButtonType.Facebook),
                            ),
                            Expanded(
                              child: SignInButton(type: ButtonType.Google),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                          'login.emailLogin',
                          style: TextStyle(fontSize: 16),
                        ).tr()),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'login.email'.tr(),
                          ),
                          autovalidate: true,
                          autocorrect: false,
                          validator: (_) {
                            return !state.isEmailValid ? 'login.invalidEmail'.tr() : null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: 'login.password'.tr(),
                          ),
                          obscureText: true,
                          autovalidate: true,
                          autocorrect: false,
                          validator: (_) {
                            return !state.isPasswordValid
                                ? 'login.invalidPassword'.tr()
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                          onPressed: isLoginButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('login.noAccount').tr(),
                            SizedBox(width: 5.0),
                            GestureDetector(
                                child: Text("register.title",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue)).tr(),
                                onTap: _onRegisterLinkTap)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    //_loginBloc.close();
    super.dispose();
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  _onRegisterLinkTap() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  void _onEmailChanged() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
