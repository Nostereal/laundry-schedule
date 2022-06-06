import 'package:flutter/material.dart';
import 'package:washing_schedule/core/models/result.dart';

@immutable
class AlertBanner {
  final String title;
  final String body;

  AlertBanner.fromJson(Json json)
      : title = json['title'],
        body = json['body'];
}
