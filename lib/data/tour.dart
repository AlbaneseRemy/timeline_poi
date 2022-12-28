import 'package:flutter/material.dart';

class Tour {

  final String title;
  final String id;
  final String? description;
  final String? imageUri;
  final int startYear;
  final int endYear;
  final Color color;
  int columnIndex = 0;


  Tour({
    required this.title,
    required this.id,
    this.description,
    this.imageUri,
    required this.startYear,
    required this.endYear,
    this.color = Colors.blue,
  });



  String get getTitle => title;
  String get getId => id;
  String? get getDescription => description;
  String? get getImageUri => imageUri;
  int get getStartYear => startYear;
  int get getEndYear => endYear;
  Color get getColor => color;



}