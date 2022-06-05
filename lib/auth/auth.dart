import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washing_schedule/auth/auth_repository.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/core/models/typed_error.dart';
import 'package:washing_schedule/design_system/form_input.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/schedule/schedule.dart';
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
                    'Log into your account',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5,
                  ),
                  const SizedBox(height: 12),
                  FormInput(
                    controller: loginController,
                    hint: 'Username',
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
                    hint: 'Password',
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
                  storeUserId(data.userId);
                  Navigator.pop(context, data.userId);
                } else {
                  final TypedError error = (result as FailureResult).error;
                  showTextSnackBar(context, error.message);
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Log in'),
            ),
          ),
        ],
      ),
    );
  }
}

const String prefsUserIdKey = 'userId';

Future<void> storeUserId(int? userId) async {
  final prefs = await SharedPreferences.getInstance();
  if (userId == null) {
    prefs.remove(prefsUserIdKey);
  } else {
    prefs.setInt(prefsUserIdKey, userId);
  }
}

Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(prefsUserIdKey);
}

Future<AuthResult> requireAuth(BuildContext context) {
  return getUserId().then((userId) async {
    if (userId != null) {
      return Success(userId);
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
        (userId) {
          if (userId != null) {
            return Success(userId);
          } else {
            return Failure();
          }
        },
      );
    }
  });
}

abstract class AuthResult {}

class Success extends AuthResult {
  final int userId;

  Success(this.userId);
}

class Failure extends AuthResult {}
