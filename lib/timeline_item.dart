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
  final bool isVertical;

  const TimelineItem(
      {Key? key,
      required this.tour,
      required this.constraints,
      required this.numberColumns,
      required this.startYear,
      required this.endYear,
      required this.tours,
      required this.isVertical})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: isVertical ? (tour.startYear - startYear).toDouble() + constraints.maxHeight / 2 : leftPosition(),
      left: isVertical ? leftPosition() : (tour.startYear - startYear).toDouble() + constraints.maxWidth / 2,
      width: calculateWidth(),
      height: calculateHeight(),
      child: GestureDetector(
        onTap: () => Navigation.goTo(context, TimelineInfo(tour: tour)),
        child: Padding(
          padding: isVertical ? EdgeInsets.symmetric(horizontal: numberColumns == 2 ? 30 : 20.0) : EdgeInsets.symmetric(vertical: 8.0),
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
    if (numberColumns > 5) {
      return isVertical? constraints.maxWidth / 6 * (tour.columnId + 1) - 30 : (constraints.maxHeight / 6 * (tour.columnId + 1) - 30);

      /*(constraints.maxHeight) / (6) * (tour.columnId) +
          ((constraints.maxHeight / (numberColumns + 1)) / (numberColumns + 1)) +
          60 / numberColumns;*/
    }

    double dateWidth = 40;
    double itemWidth = (constraints.maxWidth - dateWidth) / (numberColumns + 1);

    return isVertical
        ? (dateWidth + ((constraints.maxWidth-dateWidth)/(numberColumns+1) - itemWidth/2)) * (tour.columnId+1)
        : (constraints.maxHeight) / (numberColumns + 1) * (tour.columnId) +
            ((constraints.maxHeight / (numberColumns + 1)) / (numberColumns + 1)) +
            60 / numberColumns;
  }

  double calculateWidth() {
    if(numberColumns > 5){
      return isVertical ? (constraints.maxWidth / 5) : (tour.endYear - tour.startYear).toDouble();
    }
    return isVertical ? (constraints.maxWidth - 40) / (numberColumns + 1) : (tour.endYear - tour.startYear).toDouble();
  }

  double calculateHeight() {
    if(numberColumns > 5){
      return isVertical ? (tour.endYear - tour.startYear).toDouble() : ((constraints.maxHeight -40)/ 6);
    }

    return isVertical
        ? (tour.endYear - tour.startYear).toDouble()
        : constraints.maxHeight / (numberColumns + 1) - (constraints.maxHeight / 10) / (numberColumns);
  }
}
