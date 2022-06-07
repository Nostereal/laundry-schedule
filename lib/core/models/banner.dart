import 'package:flutter/material.dart';
import 'package:washing_schedule/core/models/result.dart';

@immutable
class AlertBannerModel {
  final String title;
  final String body;

  AlertBannerModel.fromJson(Json json)
      : title = json['title'],
        body = json['body'];
}
