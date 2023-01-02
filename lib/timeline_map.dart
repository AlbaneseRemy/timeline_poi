import 'package:flutter/material.dart';
import 'data/tour.dart';

class TimelineMap extends StatefulWidget {
  final ScrollController scrollController;
  final int numberColumns;
  final BoxConstraints constraints;
  final int totalYears;
  final int startYear;
  final List<Tour>? tours;

  const TimelineMap({Key? key, required this.scrollController, required this.constraints, required this.totalYears, this.tours, required this.numberColumns, required this.startYear})
      : super(key: key);

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
            //TODO: Make it so the box is the representation of what's displayed on the screen
            width: widget.constraints.maxWidth / 5,
            height: widget.constraints.maxHeight / 10,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
          ),
        ),
        left: leftPosition(),
      ),
      if (widget.tours != null)
        for (var tour in widget.tours!)
          Positioned(
            top: getTopPosition(tour),
            left: getLeftPosition(tour),
            child: Draggable(
              onDragUpdate: (details) {
                updatePosition(details);
              },
              feedback: Container(),
              child: Container(
                width: getLength(tour),
                height: widget.constraints.maxHeight / 150,
                decoration: BoxDecoration(
                  color: tour.color.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
    ]);
  }

  //Moves the scroll offset of the page when the user drags the Container at the bottom of the screen
  void updatePosition(DragUpdateDetails details) {
    widget.scrollController.position.moveTo(widget.scrollController.offset + details.delta.dx * widget.totalYears / widget.constraints.maxWidth);
  }

  //Sets the left position of the white frame that follows the user's finger
  double leftPosition() {
    return (widget.scrollController.offset / (widget.totalYears / widget.constraints.maxWidth)) - widget.constraints.maxWidth / 10;
  }

  //Defines how long the tour's line is in the map
  double getLength(Tour tour) {
    return (((tour.endYear - tour.startYear) / widget.totalYears) * widget.constraints.maxWidth).toDouble();
  }

  //Defines the left position of the tour's line in the map
  double getLeftPosition(Tour tour) {
    //sets the left position according to all the parameters
    return (((tour.startYear - widget.startYear) / widget.totalYears) * widget.constraints.maxWidth).toDouble();
  }

  double getTopPosition(Tour tour) {
    //Sets the position of the tour's line in the map. It should always be an equal distance between lines
    return (widget.constraints.maxHeight / 10) / (widget.numberColumns + 1) * (tour.columnId + 1);
  }
}
