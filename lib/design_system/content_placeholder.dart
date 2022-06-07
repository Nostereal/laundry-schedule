import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:washing_schedule/home/home.dart';

class ContentPlaceholder extends StatelessWidget {
  const ContentPlaceholder({
    Key? key,
    required this.title,
    this.subtitle,
    this.action,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: 100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_rounded, color: Colors.red, size: 128),
          const SizedBox(height: 16),
          Text(
            title,
            style: context.textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(subtitle!, style: context.textTheme.bodyText1),
            ),
          if (action != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: action!,
            ),
        ],
      ),
    );
  }
}
