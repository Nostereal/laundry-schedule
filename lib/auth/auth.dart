import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washing_schedule/auth/auth_repository.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/core/models/typed_error.dart';
import 'package:washing_schedule/design_system/form_input.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/utils/snackbars.dart';

import 'models/auth_response.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = getIt.get();
  bool _isLoading = false;

  final loginController = TextEditingController(text: 'Михалев');
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: horizontalPadding, right: horizontalPadding, top: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.appLocal.authHeader,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 12),
                  FormInput(
                    controller: loginController,
                    hint: context.appLocal.loginHint,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  FormInput(
                    controller: passwordController,
                    hint: context.appLocal.passwordHint,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                final Result<AuthResponse> result = await _authRepository
                    .authorize(loginController.text, passwordController.text);

                setState(() {
                  _isLoading = false;
                });
                if (result is SuccessResult) {
                  final AuthResponse data = (result as SuccessResult).data;
                  storeUserToken(data.token);
                  Navigator.pop(context, data.token);
                } else {
                  final TypedError error = (result as FailureResult).error;
                  showTextSnackBar(context, error.message);
                }
              },
              child: _isLoading
                  ? Transform.scale(
                      scale: 0.6,
                      child: const CircularProgressIndicator(),
                    )
                  : Text(context.appLocal.loginButton),
            ),
          ),
        ],
      ),
    );
  }
}

const String prefsUserTokenKey = 'userToken';

Future<void> storeUserToken(String? token) async {
  final prefs = await SharedPreferences.getInstance();
  if (token == null) {
    prefs.remove(prefsUserTokenKey);
  } else {
    prefs.setString(prefsUserTokenKey, token);
  }
}

Future<String?> getUserToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(prefsUserTokenKey);
}

Future<AuthResult> requireAuth(BuildContext context) {
  return getUserToken().then((token) async {
    if (token != null) {
      return Success(token);
    } else {
      return await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) => const AuthPage(),
      ).then(
        (token) => token != null ? Success(token) : Failure(),
      );
    }
  });
}

abstract class AuthResult {}

class Success extends AuthResult {
  final String token;

  Success(this.token);
}

class Failure extends AuthResult {}
