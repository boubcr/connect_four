import 'package:connect_four/auth/bloc/bloc.dart';
import 'package:connect_four/auth/login/widgets/sign_in_button.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../register.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _usernameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (BuildContext context, RegisterState state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('register.registering').tr(),
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
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('register.failure').tr(),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (BuildContext context, RegisterState state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 15.0),
                    child: ListTile(
                      title: Center(
                          child: Text(
                        'register.title',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ).tr()),
                      subtitle: Center(
                          child: Text(
                        'register.subtitle',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ).tr()),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            'register.withEmail',
                            style: TextStyle(fontSize: 16),
                          ).tr()),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'register.username'.tr(),
                            ),
                            obscureText: false,
                            autocorrect: false,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: 'login.email'.tr(),
                            ),
                            autocorrect: false,
                            autovalidate: true,
                            validator: (_) {
                              return !state.isEmailValid
                                  ? 'login.invalidEmail'.tr()
                                  : null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'login.password'.tr(),
                            ),
                            obscureText: true,
                            autocorrect: false,
                            autovalidate: true,
                            validator: (_) {
                              return !state.isPasswordValid
                                  ? 'login.invalidPassword'.tr()
                                  : null;
                            },
                          ),
                          SizedBox(height: 15.0),
                          RegisterButton(
                            onPressed: isRegisterButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Text('register.orSocials').tr(),
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
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('register.haveAccount').tr(),
                            GestureDetector(
                                child: Text("login.signIn",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue)).tr(),
                                onTap: () {
                                  Navigator.of(context).pop();
                                })
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
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
