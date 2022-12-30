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
        top: isHintVisible() ? (widget.scrollController.offset) + 50: (widget.hint.year.toDouble() + widget.startYear.abs() + 400).toDouble() + 12,
        left: isHintVisible() ? widget.constraints.maxWidth / 2 -100: null,
        child: Column(
          children: [
            isHintVisible() ? Icon(Icons.lightbulb, color: Colors.yellow, size: 25) : Icon(Icons.lightbulb_outline, color: Colors.white, size: 25),
            isHintVisible()
                ? Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.white,
                    width: 200,
                    child: Align(
                      child: Text(
                        widget.hint.description,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
          ],
        ));
  }

  bool isHintVisible() {
    return widget.scrollController.offset <= (widget.hint.year.toDouble() + widget.startYear.abs()) + widget.iconSize / 2 &&
        widget.scrollController.offset >= (widget.hint.year.toDouble() + widget.startYear.abs()) - widget.iconSize / 2;
  }
}
