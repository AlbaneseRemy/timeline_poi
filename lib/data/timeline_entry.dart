import 'package:flutter/material.dart';

class TimelineEntry {

  final String title;
  final String id;
  final String? description;
  final String? imageUri;
  final int startYear;
  final int endYear;
  final Color color;
  final Color textColor;
  int columnId;


  TimelineEntry({
    required this.title,
    required this.id,
    required this.startYear,
    required this.endYear,
    this.description,
    this.imageUri,
    this.color = Colors.blue,
    this.textColor = Colors.black,
    this.columnId = 0,
  });

}