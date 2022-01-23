import 'package:flutter/material.dart';
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
                    initialValue: 'Михалев',
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
                // todo: send request and handle the result
                Navigator.pop(context, 'test_user_id');
              },
              child: const Text('Log in'),
            ),
          ),
        ],
      ),
    );
  }
}

void requireAuth(
  BuildContext context, {
  Function(Success)? onAuthorized,
  Function()? onNonAuthorized,
}) {
  // todo: perform auth

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    builder: (context) => const AuthPage(),
  ).then(
    (userId) {
      if (userId != null) {
        // todo: store userId on device
        onAuthorized?.call(Success(userId));
      } else {
        onNonAuthorized?.call();
      }
    },
  );

  // onAuthorized?.call(Success('test_user_id'));
  // onNonAuthorized?.call();
}

class AuthResult {}

class Success extends AuthResult {
  final String userId;

  Success(this.userId);
}

class Failure extends AuthResult {}
