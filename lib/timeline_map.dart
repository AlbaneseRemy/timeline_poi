import 'package:flutter/material.dart';
import 'data/tour.dart';

class TimelineMap extends StatefulWidget {
  final ScrollController scrollController;
  final ScrollController scrollControllerVertical;
  final int numberColumns;
  final BoxConstraints constraints;
  final int totalYears;
  final int startYear;
  final List<Tour>? tours;
  final bool isVertical;
  final double totalHeight;
  final double totalWidth;

  const TimelineMap(
      {Key? key,
      required this.scrollController,
      required this.constraints,
      required this.totalYears,
      this.tours,
      required this.numberColumns,
      required this.startYear,
      required this.scrollControllerVertical,
      required this.isVertical,
      required this.totalHeight,
      required this.totalWidth})
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
          height: widget.isVertical ? widget.constraints.maxHeight / 10 : widget.constraints.maxHeight / 5,
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
      if (widget.tours != null)
        for (var tour in widget.tours!)
          Positioned(
            top: getItemTopPosition(tour),
            left: getItemLeftPosition(tour),
            child: Draggable(
              onDragUpdate: (details) {
                updatePosition(details);
              },
              feedback: Container(),
              child: Container(
                width: getLength(tour),
                height: widget.isVertical
                    ? ((widget.constraints.maxHeight / 10) / widget.numberColumns) * 0.8
                    : ((widget.constraints.maxHeight / 5) / widget.numberColumns) * 0.8,
                decoration: BoxDecoration(
                  color: tour.color.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
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
            width: boxWidth(),
            height: boxHeight(), //.isVertical ? height20 : height10,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.75), width: 2),
            ),
          ),
        ),
        left: leftPosition(),
        top: mapTopPosition(),
      ),
    ]);
  }

  //Moves the scroll offset of the page when the user drags the Container at the bottom of the screen
  void updatePosition(DragUpdateDetails details) {
    widget.scrollController.position.moveTo(widget.scrollController.offset + details.delta.dx * widget.totalYears / widget.constraints.maxWidth);
    //Only move the vertical scroll if the user is dragging the map and not above it
    if (details.globalPosition.dy >= widget.constraints.maxHeight - widget.constraints.maxHeight / 5)
      widget.isVertical
          ? widget.scrollControllerVertical.position
              .moveTo(widget.scrollControllerVertical.offset + (details.delta.dy / (widget.constraints.maxHeight / 10)) * widget.totalWidth)
          : widget.scrollControllerVertical.position
              .moveTo(widget.scrollControllerVertical.offset + (details.delta.dy / (widget.constraints.maxHeight / 5)) * widget.totalWidth);
  }

  //Sets the left position of the white frame that follows the user's finger
  double leftPosition() {
    return (widget.scrollController.offset / (widget.totalYears / widget.constraints.maxWidth)) - boxWidth() / 2;
  }

  double mapTopPosition() {
    if (widget.numberColumns <= 5) return 0;

    return widget.isVertical
        ? widget.scrollControllerVertical.offset / widget.totalWidth * (widget.constraints.maxHeight / 10)
        : widget.scrollControllerVertical.offset / (widget.totalHeight-widget.constraints.maxHeight/5 - 50) * (widget.constraints.maxHeight / 5);
  }

  //Defines how long the tour's line is in the map
  double getLength(Tour tour) {
    return (((tour.endYear - tour.startYear) / widget.totalYears) * widget.constraints.maxWidth).toDouble();
  }

  //Defines the left position of the tour's line in the map
  double getItemLeftPosition(Tour tour) {
    //sets the left position according to all the parameters
    return (((tour.startYear - widget.startYear) / widget.totalYears) * widget.constraints.maxWidth).toDouble();
  }

  double getItemTopPosition(Tour tour) {
    //Sets the position of the tour's line in the map. It should always be an equal distance between lines
    return widget.isVertical
        ? widget.constraints.maxHeight / 10 / (widget.numberColumns) * (tour.columnId)
        : widget.constraints.maxHeight / 5 / (widget.numberColumns) * (tour.columnId);
  }

  double boxWidth() {
    return widget.isVertical
        ? widget.constraints.maxHeight * widget.constraints.maxWidth / widget.totalYears
        : widget.constraints.maxWidth * widget.constraints.maxWidth / widget.totalYears;
  }

  double boxHeight() {
    if (widget.numberColumns > 5) {
      return widget.isVertical
          ? widget.constraints.maxHeight /
              10 *
              (widget.constraints.maxWidth - widget.constraints.maxWidth / 10 + 30) /
              (widget.totalWidth - widget.constraints.maxWidth / 10)
          : (widget.constraints.maxHeight / 5) * (widget.constraints.maxHeight - widget.constraints.maxHeight / 5) / widget.totalHeight;
    }
    return widget.isVertical ? widget.constraints.maxHeight / 10 : (widget.constraints.maxWidth / 5);
  }
}
