import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/services.dart';
import 'package:timeline_poi/timeline_hints.dart';
import 'package:timeline_poi/timeline_hints_description.dart';
import 'package:timeline_poi/timeline_info.dart';
import 'package:timeline_poi/timeline_item.dart';
import 'package:timeline_poi/timeline_map.dart';
import 'Navigation.dart';
import 'data/timeline_entry.dart';
import 'data/hint.dart';

class TimelineWidget extends StatefulWidget {
  final List<TimelineEntry> tours;
  final List<Hint>? hints;
  final int numberColumns;
  final int maxScreenColumns;
  final int startYear;
  final int endYear;
  final bool isVertical;
  final bool displayMap;

  const TimelineWidget({
    Key? key,
    required this.tours,
    this.numberColumns = 5,
    this.maxScreenColumns = 5,
    this.startYear = -400,
    this.endYear = 2000,
    this.isVertical = false,
    this.displayMap = true,
    this.hints,
  }) : super(key: key);

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerVertical = ScrollController();
  late int currentYear;
  late String textYear;
  late double dateOffset;
  Color baseColor = Colors.black;

  @override
  void initState() {
    //Sets the default text displaying the current year
    _textCurrentYear(null);

    scrollController.addListener(_onSlide); //Subscribes the scrollController to the _onSlide method
    scrollControllerVertical.addListener(_onSlide);
    dateOffset = 0;
    super.initState();
  }

  void _onSlide() {
    //set a new State in the timeline when the user slides the timeline
    _textCurrentYear(scrollController);
    setState(_dateOffset);
  }

  void _textCurrentYear(ScrollController? scrollController) {
    //Calculates the current year based on the scrollController position
    if (scrollController == null) {
      textYear = "${widget.startYear.abs().toString()} ${widget.startYear > 0 ? "CE" : "BCE"}";
    } else {
      currentYear = (scrollController!.offset).round() + widget.startYear;
      textYear = "${currentYear.abs().toString()} ${currentYear > 0 ? "CE" : "BCE"}";
    }
  }

  void _dateOffset() {
    dateOffset = scrollControllerVertical.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      double width = calculateWidth(constraints);
      double height = calculateHeight(constraints);
      return Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              updateGesture(details);
            },
            onPanEnd: (details) {
              endGesture(details);
            },
            child: SingleChildScrollView(
                scrollDirection: widget.isVertical ? Axis.vertical : Axis.horizontal,
                physics: kIsWeb ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: (SingleChildScrollView(
                  physics: kIsWeb ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  scrollDirection: widget.isVertical ? Axis.horizontal : Axis.vertical,
                  controller: scrollControllerVertical,
                  child: Container(
                    width: calculateWidth(constraints),
                    height: calculateHeight(constraints),
                    color: baseColor,
                    child: Stack(
                      children: [
                        for (var tour in widget.tours)
                          TimelineItem(
                            tour: tour,
                            constraints: constraints,
                            numberColumns: widget.numberColumns,
                            maxScreenColumns: widget.maxScreenColumns,
                            startYear: widget.startYear,
                            isVertical: widget.isVertical,
                            onTap: () => Navigation.goTo(context, TimelineInfo(tour: tour)),
                          ),
                        for (var hint in widget.hints ?? [])
                          TimelineHint(hint: hint, startYear: widget.startYear, scrollController: scrollController, constraints: constraints),
                        for (var hint in widget.hints ?? [])
                          TimelineHintDescription(hint: hint, startYear: widget.startYear, scrollController: scrollController, constraints: constraints),
                        for (int i = 0; i <= widget.endYear - widget.startYear; i += 100) buildDateListWidget(i, constraints),
                      ],
                    ),
                  ),
                ))),
          ),
          Container(
            margin: widget.isVertical ? EdgeInsets.only(top: constraints.maxHeight / 2) : EdgeInsets.only(left: constraints.maxWidth / 2),
            child: buildDottedLineWidget(),
          ),
          Positioned(
            child: Text(
              textYear,
              style: TextStyle(color: Colors.white),
            ),
            top: widget.isVertical ? constraints.maxHeight / 2 - 40 : constraints.maxHeight * 0.8 - 40,
            left: widget.isVertical ? constraints.maxWidth * 0.8 : constraints.maxWidth / 2 - 40,
          ),
          if (widget.displayMap)
            Positioned(
              child: TimelineMap(
                constraints: constraints,
                scrollController: scrollController,
                scrollControllerVertical: scrollControllerVertical,
                totalYears: widget.endYear - widget.startYear,
                tours: widget.tours,
                numberColumns: widget.numberColumns,
                maxScreenColumns: widget.maxScreenColumns,
                startYear: widget.startYear,
                isVertical: widget.isVertical,
                totalHeight: height,
                totalWidth: width,
              ),
              bottom: 0,
            )
        ],
      );
    }));
  }

  //Used to set the years in the timeline
  Widget buildDateListWidget(int i, BoxConstraints constraints) {
    return Positioned(
        top: widget.isVertical ? i + constraints.maxHeight / 2 : dateOffset,
        left: widget.isVertical ? dateOffset : i + constraints.maxWidth / 2,
        width: widget.isVertical ? 50 : 100,
        height: widget.isVertical ? 100 : 30,
        child: Container(
          alignment: Alignment.topLeft,
          color: baseColor,
          child: Text(
            (i + widget.startYear).toString(),
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ));
  }

  //Transparent dotted line in the middle of the screen
  Widget buildDottedLineWidget() {
    return DottedLine(
      direction: widget.isVertical ? Axis.horizontal : Axis.vertical,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Colors.grey.withOpacity(0.8),
    );
  }

  void updateGesture(DragUpdateDetails details) {
    setState(() {
      scrollController.position
          .moveTo(widget.isVertical ? scrollController.position.pixels - details.delta.dy : scrollController.position.pixels - details.delta.dx);
      scrollControllerVertical.position.moveTo(widget.isVertical
          ? scrollControllerVertical.position.pixels - details.delta.dx
          : scrollControllerVertical.position.pixels - details.delta.dy);
    });
  }

  void endGesture(DragEndDetails details){
    scrollController.position.animateTo(
      widget.isVertical
          ? scrollController.offset - details.velocity.pixelsPerSecond.dy / 5
          : scrollController.offset - details.velocity.pixelsPerSecond.dx / 5,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
    );
    scrollControllerVertical.position.animateTo(
      widget.isVertical
          ? scrollControllerVertical.offset - details.velocity.pixelsPerSecond.dx / 5
          : scrollControllerVertical.offset - details.velocity.pixelsPerSecond.dy / 5,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
    );
  }

  double calculateWidth(BoxConstraints constraints) {
    if (widget.numberColumns > widget.maxScreenColumns) {
      return widget.isVertical
          ? (constraints.maxWidth / widget.maxScreenColumns) * (widget.numberColumns) + 40
          : (widget.endYear - widget.startYear + constraints.maxWidth);
    }
    return widget.isVertical ? constraints.maxWidth : (widget.endYear - widget.startYear + constraints.maxWidth);
  }

  double calculateHeight(BoxConstraints constraints) {
    if (widget.numberColumns > widget.maxScreenColumns) {
      return widget.isVertical
          ? (widget.endYear - widget.startYear + constraints.maxHeight)
          : ((constraints.maxHeight) / widget.maxScreenColumns) * (widget.numberColumns);
    }
    return (widget.isVertical ? widget.endYear - widget.startYear + constraints.maxHeight : constraints.maxHeight);
  }

  void dispose() {
    scrollController.removeListener(_onSlide);
    scrollControllerVertical.removeListener(_onSlide);
    scrollController.dispose();
    scrollControllerVertical.dispose();

    super.dispose();
  }
}
