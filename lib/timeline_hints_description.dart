import 'dart:math';

import 'package:flutter/material.dart';

import 'data/tour_hint.dart';

class TimelineHintDescription extends StatefulWidget {
  final TourHint hint;
  final int startYear;
  final ScrollController scrollController;
  final BoxConstraints constraints;
  final int iconSize;

  const TimelineHintDescription(
      {Key? key, required this.hint, required this.startYear, required this.scrollController, required this.constraints, this.iconSize = 25})
      : super(key: key);

  @override
  State<TimelineHintDescription> createState() => _TimelineHintDescriptionState();
}

class _TimelineHintDescriptionState extends State<TimelineHintDescription> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.scrollController.offset + 50,
      left: widget.constraints.maxWidth / 2 - 100,
      child: AnimatedContainer(
        padding: EdgeInsets.all(8),
        color: isHintVisible() ? Colors.white : Colors.transparent,
        width: 200,
        duration: Duration(milliseconds: 400),
        child: Align(
          child: Text(
            "Année ${widget.hint.year} : ${widget.hint.description}",
            style: TextStyle(color: isHintVisible() ? Colors.black : Colors.transparent),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  bool isHintVisible() {
    return widget.scrollController.offset <= (widget.hint.year.toDouble() + widget.startYear.abs()) + widget.iconSize / 2 &&
        widget.scrollController.offset >= (widget.hint.year.toDouble() + widget.startYear.abs()) - widget.iconSize / 2;
  }
}
