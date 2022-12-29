import 'package:flutter/material.dart';
import 'data/tour_hint.dart';

class TimelineHint extends StatelessWidget {

  final TourHint hint;
  final int startYear;
  final ScrollController scrollController;
  bool isFocused = false;

  TimelineHint({Key? key, required this.hint, required this.startYear, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (hint.year.toDouble() + startYear.abs() + 400).toDouble() + 12,
      child:
      isHintVisible() ? Icon(Icons.lightbulb, color: Colors.yellow, size: 25) : Icon(Icons.lightbulb_outline, color: Colors.white, size: 25),
    );
  }

  bool isHintVisible() {
    return scrollController.offset <= (hint.year.toDouble() + startYear.abs()) + 10 && scrollController.offset >= (hint.year.toDouble() + startYear.abs()) - 10;
  }






}
