import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
              : Container(
                  height: ((tour.startYear - startYear).toDouble() + constraints.maxHeight / 2) / 2,
                  width: constraints.maxWidth / (numberColumns + 1),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.network(tour.imageUri!, fit: BoxFit.fill).image,
                    ),
                  ),
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
    );
  }

  double leftPosition() {
    return (tour.columnId +1) * constraints.maxWidth / (numberColumns + 1);
  }
}
