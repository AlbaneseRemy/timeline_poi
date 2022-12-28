import 'package:flutter/material.dart';

class TimelineMap extends StatefulWidget {
  final ScrollController scrollController;
  final BoxConstraints constraints;
  final int totalYears;

  const TimelineMap({Key? key, required this.scrollController, required this.constraints, required this.totalYears}) : super(key: key);

  @override
  State<TimelineMap> createState() => _TimelineMapState();
}

class _TimelineMapState extends State<TimelineMap> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Draggable(
        onDragUpdate: (details) {
          updatePosition(details);
        },
        feedback: Container(),
        child: Container(
          width: widget.constraints.maxWidth,
          height: widget.constraints.maxHeight / 10,
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 25.0,
                spreadRadius: 8.0,
                offset: const Offset(0.0, 0.0),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        child: Draggable(
          onDragUpdate: (details) {
            updatePosition(details);
          },
          axis: Axis.horizontal,
          feedback: Container(),
          child: Container(
            width: widget.constraints.maxWidth / 5,
            height: widget.constraints.maxHeight / 10,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
          ),
        ),
        left: leftPosition(),
      ),
    ]);
  }

  double leftPosition() {
    return (widget.scrollController.offset / (widget.totalYears / widget.constraints.maxWidth)) - widget.constraints.maxWidth / 10;
  }

  void updatePosition(DragUpdateDetails details) {
    widget.scrollController.position.moveTo(widget.scrollController.offset + details.delta.dx * widget.totalYears / widget.constraints.maxWidth);
  }
}
