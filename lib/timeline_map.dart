import 'package:flutter/material.dart';
import 'data/timeline_entry.dart';

class TimelineMap extends StatefulWidget {
  final ScrollController scrollController;
  final ScrollController scrollControllerVertical;
  final int numberColumns;
  final int maxScreenColumns;
  final BoxConstraints constraints;
  final int totalYears;
  final int startYear;
  final List<TimelineEntry>? tours;
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
      required this.totalWidth,
      required this.maxScreenColumns})
      : super(key: key);

  @override
  State<TimelineMap> createState() => _TimelineMapState();
}

class _TimelineMapState extends State<TimelineMap> {
  int verticalMapSize = 10;
  int horizontalMapSize = 5;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _buildBackgroundWidget(),
      for (var tour in widget.tours ?? []) _buildTimelineItem(tour),
      Positioned(
        child: _buildCameraOutlineWidget(),
        left: boxLeftPosition(),
        top: boxTopPosition(),
      ),
    ]);
  }

  Widget _buildBackgroundWidget() {
    return Draggable(
      onDragUpdate: (details) {
        updateMapPosition(details);
      },
      feedback: Container(),
      child: Container(
        width: widget.constraints.maxWidth,
        height: widget.isVertical ? widget.constraints.maxHeight / verticalMapSize : widget.constraints.maxHeight / horizontalMapSize,
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
    );
  }

  Widget _buildTimelineItem(TimelineEntry tour) {
    return Positioned(
      top: getItemTopPosition(tour),
      left: getItemLeftPosition(tour),
      child: Draggable(
        onDragUpdate: (details) {
          updateMapPosition(details);
        },
        feedback: Container(),
        child: Container(
          width: getItemLength(tour),
          height: widget.isVertical
              ? ((widget.constraints.maxHeight / verticalMapSize) / widget.numberColumns) * 0.8
              : ((widget.constraints.maxHeight / horizontalMapSize) / widget.numberColumns) * 0.8,
          decoration: BoxDecoration(
            color: tour.color.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraOutlineWidget() {
    return Draggable(
        onDragUpdate: (details) {
          updateMapPosition(details);
        },
        axis: Axis.horizontal,
        feedback: Container(),
        child: Container(
          width: boxWidth(),
          height: boxHeight(), //.isVertical ? height20 : height10,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.75), width: 2),
          ),
        ));
  }

  //Moves the scroll offset of the page when the user drags the Container at the bottom of the screen
  void updateMapPosition(DragUpdateDetails details) {
    widget.scrollController.position.moveTo(widget.scrollController.offset + details.delta.dx * widget.totalYears / widget.constraints.maxWidth);
    //Only move the vertical scroll if the user is dragging the map and not above it
    if (details.globalPosition.dy >= widget.constraints.maxHeight - widget.constraints.maxHeight / horizontalMapSize)
      widget.scrollControllerVertical.position.moveTo(widget.scrollControllerVertical.offset +
          (details.delta.dy / (widget.constraints.maxHeight / (widget.isVertical ? verticalMapSize : horizontalMapSize))) * widget.totalWidth);
  }

  //Defines how long the tour's line is in the map
  double getItemLength(TimelineEntry tour) {
    return (((tour.endYear - tour.startYear) / widget.totalYears) * widget.constraints.maxWidth).toDouble();
  }

  //Defines the left position of the tour's line in the map
  double getItemLeftPosition(TimelineEntry tour) {
    //sets the left position according to all the parameters
    return (((tour.startYear - widget.startYear) / widget.totalYears) * widget.constraints.maxWidth).toDouble();
  }

  double getItemTopPosition(TimelineEntry tour) {
    //Sets the position of the tour's line in the map. It should always be an equal distance between lines
    return widget.isVertical
        ? widget.constraints.maxHeight / verticalMapSize / (widget.numberColumns) * (tour.columnId)
        : widget.constraints.maxHeight / horizontalMapSize / (widget.numberColumns) * (tour.columnId);
  }

  double boxWidth() {
    return widget.isVertical
        ? (widget.constraints.maxHeight - widget.constraints.maxHeight / verticalMapSize) * widget.constraints.maxWidth / widget.totalYears
        : widget.constraints.maxWidth * widget.constraints.maxWidth / widget.totalYears;
  }

  double boxHeight() {
    if (widget.numberColumns > widget.maxScreenColumns) {
      if (widget.isVertical) {
        return widget.constraints.maxHeight /
            verticalMapSize *
            (widget.constraints.maxWidth - widget.constraints.maxWidth / verticalMapSize + 30) /
            (widget.totalWidth - widget.constraints.maxWidth / verticalMapSize);
      } else {
        return (widget.constraints.maxHeight / horizontalMapSize) *
            (widget.constraints.maxHeight - widget.constraints.maxHeight / horizontalMapSize) /
            widget.totalHeight;
      }
    }
    return widget.isVertical ? widget.constraints.maxHeight / verticalMapSize : widget.constraints.maxHeight / horizontalMapSize;
  }

  //Sets the left position of the white frame that follows the user's finger
  double boxLeftPosition() {
    return (widget.scrollController.offset / (widget.totalYears / widget.constraints.maxWidth)) -
        boxWidth() / 2 -
        (widget.isVertical ? (widget.constraints.maxHeight * widget.constraints.maxWidth / widget.totalYears) / 10 / 2 : 0);
  }

  double boxTopPosition() {
    if (widget.numberColumns <= widget.maxScreenColumns) return 0;

    return widget.isVertical
        ? widget.scrollControllerVertical.offset / widget.totalWidth * (widget.constraints.maxHeight / verticalMapSize)
        : widget.scrollControllerVertical.offset /
            (widget.totalHeight - widget.constraints.maxHeight / horizontalMapSize - 50) *
            (widget.constraints.maxHeight / horizontalMapSize);
  }
}
