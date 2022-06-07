import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:washing_schedule/home/home.dart';

class AlertBanner extends StatelessWidget {
  const AlertBanner({
    Key? key,
    required this.title,
    required this.body,
    required this.margin,
  }) : super(key: key);

  final String title;
  final String body;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 20,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: context.textTheme.headline5),
            const SizedBox(height: 8),
            Text(body, style: context.textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
