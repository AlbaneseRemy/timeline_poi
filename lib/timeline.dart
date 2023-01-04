import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:timeline_poi/timeline_hints.dart';
import 'package:timeline_poi/timeline_hints_description.dart';
import 'package:timeline_poi/timeline_item.dart';
import 'package:timeline_poi/timeline_map.dart';
import 'data/tour.dart';

class MyTimeline extends StatefulWidget {
  final List<Tour> tours;
  final int numberColumns;
  final int startYear;
  final int endYear;
  final bool isVertical;

  const MyTimeline({
    Key? key,
    required this.tours,
    this.numberColumns = 5,
    this.startYear = -400,
    this.endYear = 2000,
    this.isVertical = false,
  }) : super(key: key);

  @override
  State<MyTimeline> createState() => _MyTimelineState();
}

class _MyTimelineState extends State<MyTimeline> {
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerVertical = ScrollController();
  late int currentYear;
  late String textYear;
  late double dateOffset;
  late AnimationController _animationController;

  @override
  void initState() {
    //Sets the default text displaying the current year
    currentYear = widget.startYear;
    currentYear > 0 ? textYear = "${currentYear.abs().toString()} CE" : textYear = "${currentYear.abs().toString()} BCE";
    scrollController.addListener(_onSlide); //Subscribes the scrollController to the _onSlide method
    scrollControllerVertical.addListener(_onSlide);
    widget.isVertical
        ? SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
        : SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    dateOffset = 5;
    super.initState();
  }

  void _onSlide() {
    //set a new State in the timeline when the user slides the timeline
    setState(_textCurrentYear);
    setState(_dateOffset);
  }

  void _textCurrentYear() {
    //Calculates the current year based on the scrollController position
    currentYear = (scrollController.offset * 1).round() + widget.startYear;
    currentYear > 0 ? textYear = "${currentYear.abs().toString()} CE" : textYear = "${currentYear.abs().toString()} BCE";
  }

  void _dateOffset() {
    dateOffset = dateOffset = scrollControllerVertical.offset + 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                scrollController.position.moveTo(widget.isVertical ? scrollController.position.pixels - details.delta.dy : scrollController.position.pixels - details.delta.dx);
                scrollControllerVertical.position.moveTo(widget.isVertical ? scrollControllerVertical.position.pixels - details.delta.dx : scrollController.position.pixels - details.delta.dy);
              });
            },
            onPanEnd: (details) {
              scrollController.position.animateTo(
                scrollController.offset - details.velocity.pixelsPerSecond.dy/5,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
              );
              scrollControllerVertical.position.animateTo(
                scrollControllerVertical.offset - details.velocity.pixelsPerSecond.dx/5,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
              );
            },
            child: SingleChildScrollView(
                scrollDirection: widget.isVertical ? Axis.vertical : Axis.horizontal,
                physics: kIsWeb ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: (SingleChildScrollView(
                  physics: kIsWeb ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  scrollDirection: widget.isVertical ? Axis.horizontal : Axis.vertical,
                  controller: scrollControllerVertical,
                  child: Container(
                    width: calculateWidth(constraints),
                    height: calculateHeight(constraints),
                    color: Colors.black,
                    child: Stack(
                      children: [
                        for (int i = 0; i <= widget.endYear - widget.startYear; i += 100) createContainer(i, constraints),
                        for (var tour in widget.tours)
                          TimelineItem(
                            tour: tour,
                            tours: widget.tours,
                            constraints: constraints,
                            numberColumns: widget.numberColumns,
                            startYear: widget.startYear,
                            endYear: widget.endYear,
                            isVertical: widget.isVertical,
                          ),
                        for (var tour in widget.tours)
                          if (tour.hints != null)
                            for (var hint in tour.hints!)
                              TimelineHint(hint: hint, startYear: widget.startYear, scrollController: scrollController, constraints: constraints),
                        for (var tour in widget.tours)
                          if (tour.hints != null)
                            for (var hint in tour.hints!)
                              TimelineHintDescription(hint: hint, startYear: widget.startYear, scrollController: scrollController, constraints: constraints),
                      ],
                    ),
                  ),
                ))),
          ),
          Container(
            margin: widget.isVertical ? EdgeInsets.only(top: constraints.maxHeight / 2) : EdgeInsets.only(left: constraints.maxWidth / 2),
            child: transparentDottedLine(),
          ),
          Positioned(
            child: Text(
              textYear,
              style: TextStyle(color: Colors.white),
            ),
            top: widget.isVertical ? constraints.maxHeight / 2 - 40 : constraints.maxHeight  * 0.8 - 40,
            left: widget.isVertical ? constraints.maxWidth * 0.8 : constraints.maxWidth / 2 - 40,
          ),
          Positioned(
            child: TimelineMap(
              constraints: constraints,
              scrollController: scrollController,
              scrollControllerVertical: scrollControllerVertical,
              totalYears: widget.endYear - widget.startYear,
              tours: widget.tours,
              numberColumns: widget.numberColumns,
              startYear: widget.startYear,
              isVertical: widget.isVertical,
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
        top: widget.isVertical ? i + constraints.maxHeight / 2 : dateOffset,
        left: widget.isVertical ? dateOffset : i + constraints.maxWidth / 2,
        width: constraints.maxWidth / (widget.numberColumns),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            (i + widget.startYear).toString(),
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ));
  }

  //Transparent dotted line in the middle of the screen
  Widget transparentDottedLine() {
    return DottedLine(
      direction: widget.isVertical ? Axis.horizontal : Axis.vertical,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Colors.grey.withOpacity(0.8),
    );
  }

  double calculateWidth(BoxConstraints constraints) {
    if (widget.numberColumns > 5) {
      return widget.isVertical
          ? (constraints.maxWidth / 5) * (widget.numberColumns - 1)
          : (widget.endYear - widget.startYear.toDouble() + constraints.maxWidth);
    }
    return widget.isVertical ? constraints.maxWidth : constraints.maxHeight;
  }

  double calculateHeight(BoxConstraints constraints) {
    return widget.isVertical
        ? (widget.startYear.abs() + widget.endYear.abs()).toDouble() + constraints.maxHeight
        : kIsWeb ? (constraints.maxHeight / 5) * (widget.numberColumns - 1) + 150 : (constraints.maxHeight / 5) * (widget.numberColumns - 1) + 50;
  }

  void dispose() {
    scrollController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }
}
