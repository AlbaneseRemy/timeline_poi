import 'package:flutter/material.dart';
import 'package:timeline_poi/data/tour_hint.dart';

class Tour {

  final String title;
  final String id;
  final String? description;
  final String? imageUri;
  final int startYear;
  final int endYear;
  final Color color;
  int columnId;
  final List<TourHint>? hints;


  Tour({
    required this.title,
    required this.id,
    required this.startYear,
    required this.endYear,
    this.description,
    this.imageUri,
    this.color = Colors.blue,
    this.columnId = 0,
    this.hints,
  });

}