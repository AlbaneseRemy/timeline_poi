import 'package:flutter/material.dart';
import 'data/hint.dart';

class TimelineHint extends StatefulWidget {
  final Hint hint;
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
        top: (widget.hint.year + widget.startYear.abs()) + 12,
        left: 35,
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: isHintVisible() ? widget.iconSize * 1.1: widget.iconSize.toDouble() / 2,
              curve: Curves.easeOut,
              child: isHintVisible()
                  ? Icon(Icons.lightbulb, color: Colors.yellow)
                  : Icon(Icons.lightbulb_outline, color: Colors.white),
            ),
          ],
        ));
  }

  //Checks if the cursor is between the icon start and the icon end with icon size / 2 and scrollcontroller offset
  bool isHintVisible() {
    return widget.scrollController.offset <= (widget.hint.year.toDouble() + widget.startYear.abs()) + widget.iconSize / 2 &&
        widget.scrollController.offset >= (widget.hint.year.toDouble() + widget.startYear.abs()) - widget.iconSize / 2;
  }
}
