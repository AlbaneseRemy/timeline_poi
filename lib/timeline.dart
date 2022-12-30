import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:timeline_poi/timeline_hints.dart';
import 'package:timeline_poi/timeline_item.dart';
import 'package:timeline_poi/timeline_map.dart';
import 'data/tour.dart';
import 'data/tour_hint.dart';

class MyTimeline extends StatefulWidget {
  final List<Tour> tours;
  final int numberColumns;
  final int startYear;
  final int endYear;

  const MyTimeline({
    Key? key,
    required this.tours,
    this.numberColumns = 5,
    this.startYear = -400,
    this.endYear = 2000,
  }) : super(key: key);

  @override
  State<MyTimeline> createState() => _MyTimelineState();
}

class _MyTimelineState extends State<MyTimeline> {
  final ScrollController scrollController = ScrollController();
  late int currentYear;
  late String textYear;

  @override
  void initState() {
    //Sets the default text displaying the current year
    currentYear = widget.startYear;
    currentYear > 0 ? textYear = "${currentYear.abs().toString()} CE" : textYear = "${currentYear.abs().toString()} BCE";
    scrollController.addListener(_onSlide); //Subscribes the scrollController to the _onSlide method
    super.initState();
  }

  void _onSlide() {
    //set a new State in the timeline when the user slides the timeline
    setState(_textCurrentYear);
  }

  void _textCurrentYear() {
    //Calculates the current year based on the scrollController position
    currentYear = (scrollController.offset * 1).round() + widget.startYear;
    currentYear > 0 ? textYear = "${currentYear.abs().toString()} CE" : textYear = "${currentYear.abs().toString()} BCE";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              child: (Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: (widget.startYear.abs() + widget.endYear.abs()).toDouble() + constraints.maxHeight,
                        width: constraints.maxWidth,
                        color: Colors.black,
                      ),
                      for (int i = widget.startYear; i < widget.endYear; i += 100) createContainer(i, constraints),
                      for (var tour in widget.tours)
                        TimelineItem(
                          tour: tour,
                          tours: widget.tours,
                          constraints: constraints,
                          numberColumns: widget.numberColumns,
                          startYear: widget.startYear,
                          endYear: widget.endYear,
                        ),
                      for (var tour in widget.tours)
                        if (tour.hints != null)
                          for (var hint in tour.hints!) TimelineHint(hint: hint, startYear: widget.startYear, scrollController: scrollController, constraints: constraints),
                    ],
                  ),
                ],
              ))),
          Container(
            margin: EdgeInsets.only(top: constraints.maxHeight / 2),
            child: transparentDottedLine(),
          ),
          Positioned(
            child: Text(
              textYear,
              style: TextStyle(color: Colors.white),
            ),
            top: constraints.maxHeight / 2 - 40,
            left: constraints.maxWidth * 0.8,
          ),
          Positioned(
            child: TimelineMap(
              constraints: constraints,
              scrollController: scrollController,
              totalYears: widget.startYear.abs() + widget.endYear.abs(),
              tours: widget.tours,
              columnNumber: widget.numberColumns,
            ),
            bottom: 0,
          )
        ],
      );
    }));
  }

  //Used to set the years in the timeline
  Widget createContainer(int i, BoxConstraints constraints) {
    return Positioned(
        top: i + widget.startYear.abs() + constraints.maxHeight / 2,
        width: constraints.maxWidth / (widget.numberColumns + 1),
        child: Container(
          alignment: Alignment.center,
          child: Text(i.toString(), style: const TextStyle(color: Colors.white)),
        ));
  }

  //Transparent dotted line in the middle of the screen
  Widget transparentDottedLine() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Colors.grey.withOpacity(0.8),
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      dashGapRadius: 0.0,
    );
  }
}
