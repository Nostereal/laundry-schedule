import 'package:flutter/material.dart';
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
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: 'Михалев',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(),
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
