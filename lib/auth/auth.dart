import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washing_schedule/auth/auth_repository.dart';
import 'package:washing_schedule/design_system/form_input.dart';
import 'package:washing_schedule/home/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();
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
                    style: Theme.of(context).textTheme.headline5,
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
              onPressed: () {
                const userId = 'test_user_id';
                storeUserId(userId);
                Navigator.pop(context, userId);
                // authorize().then((sessionId) => Navigator.pop(context, sessionId));
                // todo: perform server auth
                // todo: send request and handle the result
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

  Future<String> authorize() {
    setState(() {
      _isLoading = true;
    });
    return _authRepository
        .authorize(
      AuthRequest(
        loginController.text,
        passwordController.text,
      ),
    )
        .then((resp) {
      // todo: store sessionId
      storeUserId(resp.sessionId);
      setState(() {
        _isLoading = false;
      });
      return resp.sessionId;
    });
  }

  Future<void> storeUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefsUserIdKey, userId);
  }
}

const String prefsUserIdKey = 'userId';

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(prefsUserIdKey);
}

void requireAuth(
  BuildContext context, {
  Function(Success)? onAuthorized,
  Function()? onNonAuthorized,
}) {
  getUserId().then((userId) {
    if (userId != null) {
      onAuthorized?.call(Success(userId));
    } else {
      showModalBottomSheet(
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
            onAuthorized?.call(Success(userId));
          } else {
            onNonAuthorized?.call();
          }
        },
      );
    }
  });
}

class AuthResult {}

class Success extends AuthResult {
  final String userId;

  Success(this.userId);
}

class Failure extends AuthResult {}
