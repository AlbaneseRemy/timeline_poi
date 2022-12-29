import 'package:flutter/material.dart';

class Tour {

  final String title;
  final String id;
  final String? description;
  final String? imageUri;
  final int startYear;
  final int endYear;
  final Color color;
  int columnId;


  Tour({
    required this.title,
    required this.id,
    required this.startYear,
    required this.endYear,
    this.description,
    this.imageUri,
    this.color = Colors.blue,
    this.columnId = 0,
  });



  String get getTitle => title;
  String get getId => id;
  String? get getDescription => description;
  String? get getImageUri => imageUri;
  int get getStartYear => startYear;
  int get getEndYear => endYear;
  Color get getColor => color;



}