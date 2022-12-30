import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:timeline_poi/timeline_info.dart';
import 'Navigation.dart';
import 'data/tour.dart';

class TimelineItem extends StatelessWidget {
  final Tour tour;
  final List<Tour> tours;
  final BoxConstraints constraints;
  final int numberColumns;
  final int startYear;
  final int endYear;

  const TimelineItem(
      {Key? key,
      required this.tour,
      required this.constraints,
      required this.numberColumns,
      required this.startYear,
      required this.endYear,
      required this.tours})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (tour.startYear - startYear).toDouble() + constraints.maxHeight / 2,
      left: leftPosition(),
      width: constraints.maxWidth / (numberColumns + 1),
      height: (tour.endYear - tour.startYear).toDouble(),
      child: GestureDetector(
        onTap: () => Navigation.goTo(context, TimelineInfo(tour: tour)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            child: tour.imageUri == null
                ? Align(
                    child: Text(
                      tour.title,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    alignment: Alignment.center)
                :
                //TODO : resize the image in a smaller version, and make it move with the page's scroll
                Container(
                    width: constraints.maxWidth / (numberColumns + 1) / 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: AssetImage(tour.imageUri!),
                          fit: BoxFit.contain,
                        )),
                  ),
            decoration: BoxDecoration(
              color: tour.color,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Determines on which column the item should be placed
  double leftPosition() {
    return (tour.columnId + 1) * constraints.maxWidth / (numberColumns + 1);
  }
}
