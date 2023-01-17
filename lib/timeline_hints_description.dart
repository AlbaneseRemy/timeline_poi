import 'package:flutter/material.dart';
import 'data/hint.dart';

class TimelineHintDescription extends StatefulWidget {
  final Hint hint;
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
      left: widget.constraints.maxWidth / 2 - (widget.constraints.maxWidth*0.8)/2,

      child: AnimatedContainer(
        padding: EdgeInsets.all(8),
        curve: Curves.easeInOut,
        width: widget.constraints.maxWidth * 0.8,
        duration: Duration(milliseconds: 800),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: isHintVisible() ? Colors.white : Colors.transparent, boxShadow: [
          isHintVisible()
              ? BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: const Offset(1.0, 0.0),
                )
              : BoxShadow(
                  color: Colors.transparent,
                )
        ]),
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
