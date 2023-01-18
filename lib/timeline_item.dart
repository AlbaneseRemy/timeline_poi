import 'package:flutter/material.dart';
import 'data/timeline_entry.dart';

class TimelineItem extends StatelessWidget {
  final TimelineEntry tour;
  final BoxConstraints constraints;
  final int numberColumns;
  final int maxScreenColumns;
  final int startYear;
  final bool isVertical;
  final GestureTapCallback? onTap;

  const TimelineItem(
      {Key? key, required this.tour, required this.constraints, required this.numberColumns, required this.startYear, required this.isVertical, this.onTap, this.maxScreenColumns = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: isVertical ? (tour.startYear - startYear).toDouble() + constraints.maxHeight / 2 : itemPosition(),
      left: isVertical ? itemPosition() : (tour.startYear - startYear).toDouble() + constraints.maxWidth / 2,
      width: calculateWidth(),
      height: calculateHeight(),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: isVertical ? EdgeInsets.symmetric(horizontal: numberColumns == 2 ? 30 : 20.0) : EdgeInsets.symmetric(vertical: 16.0),
          child: Container(
            child: tour.imageUri == null
                ? Align(
                    child: Text(
                      tour.title,
                      style: TextStyle(fontSize: 10, color: tour.textColor),
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
  //40 is the size of the date container
  double itemPosition() {
    if (numberColumns > maxScreenColumns) {
      return isVertical ? constraints.maxWidth / maxScreenColumns * (tour.columnId) + 40 :
      ((constraints.maxHeight - constraints.maxHeight/5 - 40) / maxScreenColumns * (tour.columnId) + 40);
    }

    return isVertical
        ? (((constraints.maxWidth - 40) / (numberColumns))) * (tour.columnId) + 40
        : ((constraints.maxHeight - constraints.maxHeight / maxScreenColumns - 40) / numberColumns) * tour.columnId + 40;
  }

  double calculateWidth() {
    if (numberColumns > maxScreenColumns) {
      return isVertical ? ((constraints.maxWidth - 40) / maxScreenColumns) : (tour.endYear - tour.startYear).toDouble();
    }
    return isVertical ? (constraints.maxWidth - 40) / (numberColumns) : (tour.endYear - tour.startYear).toDouble();
  }

  double calculateHeight() {
    if (numberColumns > maxScreenColumns) {
      return isVertical ? (tour.endYear - tour.startYear).toDouble() :
      //((constraints.maxHeight - 40 - constraints.maxHeight/5) / maxScreenColumns);
      (constraints.maxHeight - constraints.maxHeight/5 - 40) / maxScreenColumns;
    }

    return isVertical
        ? (tour.endYear - tour.startYear).toDouble()
        : constraints.maxHeight / (numberColumns+1) - (constraints.maxHeight / 10) / (numberColumns);
  }
}
