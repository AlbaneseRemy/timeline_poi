import 'package:flutter/material.dart';
import 'data/tour_hint.dart';

class TimelineHint extends StatefulWidget {
  final TourHint hint;
  final int startYear;
  final ScrollController scrollController;
  final int iconSize;
  final BoxConstraints constraints;

  TimelineHint({Key? key, required this.hint, required this.startYear, required this.scrollController, this.iconSize = 25, required this.constraints})
      : super(key: key);

  @override
  State<TimelineHint> createState() => _TimelineHintState();
}

class _TimelineHintState extends State<TimelineHint> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: (widget.hint.year.toDouble() + widget.startYear.abs() + 400).toDouble() + 12,
        child: Column(
          children: [
            isHintVisible() ? Icon(Icons.lightbulb, color: Colors.yellow, size: 25) : Icon(Icons.lightbulb_outline, color: Colors.white, size: 25),
          ],
        ));
  }

  //Checks if the cursor is between the icon start and the icon end with icon size / 2 and scrollcontroller offset
  bool isHintVisible() {
    return widget.scrollController.offset <= (widget.hint.year.toDouble() + widget.startYear.abs()) + widget.iconSize / 2 &&
        widget.scrollController.offset >= (widget.hint.year.toDouble() + widget.startYear.abs()) - widget.iconSize / 2;
  }
}
