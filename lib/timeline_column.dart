import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'data/tour.dart';

class TimeColumn extends StatelessWidget {

  final Tour tour;
  final List<Tour> tours;
  final BoxConstraints constraints;
  final int numberColumns;
  final int startYear;
  final int endYear;

  const TimeColumn({Key? key, required this.tour, required this.constraints, required this.numberColumns, required this.startYear, required this.endYear, required this.tours}) : super(key: key);



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
        ));;
  }

  double leftPosition(){
    int i = 1;
    for (var tourList in tours){
      if(tour.startYear > tourList.startYear && tour.startYear < tourList.endYear && tour != tourList){
        i+= 1;
      }
    }
    tour.columnIndex = i-1;
    return i * constraints.maxWidth / (numberColumns + 1);
  }

}
