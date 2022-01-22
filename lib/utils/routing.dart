import 'package:flutter/cupertino.dart';

Args extractArgsFrom<Args>(BuildContext context) {
  return ModalRoute.of(context)!.settings.arguments as Args;
}