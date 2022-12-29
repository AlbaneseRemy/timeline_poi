import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timeline_poi/timeline.dart';
import 'package:timeline_poi/data/tour.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter timeline poi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Tour> tours;

  @override
  void initState() {
    super.initState();
    tours = [
      Tour(title: "Tour numéro 1", id: "1", startYear: -150, endYear: 150, color: Colors.red, imageUri: "images/logoOrpheo.png"),
      Tour(title: "Tour numéro 2", id: "2", startYear: 200, endYear: 300, color: Colors.green),
      Tour(title: "Tour numéro 3", id: "3", startYear: 300, endYear: 600, color: Colors.purple),
      Tour(title: "Tour numéro 4", id: "4", startYear: 800, endYear: 1200, color: Colors.pink),
      Tour(title: "Tour numéro 5", id: "5", startYear: 350, endYear: 450, color: Colors.blue, imageUri: "images/logoOrpheo.png"),
      Tour(title: "Tour numéro 6", id: "6", startYear: 500, endYear: 600, color: Colors.yellow),
      Tour(title: "Tour numéro 7", id: "7", startYear: 540, endYear: 700, color: Colors.brown),
      Tour(title: "Tour numéro 8", id: "8", startYear: 540, endYear: 700, color: Colors.white),
      Tour(title: "Tour numéro 9", id: "9", startYear: 600, endYear: 750, color: Colors.orange),
      Tour(title: "Tour numéro 10", id: "10", startYear: 700, endYear: 800, color: Colors.yellow),
    ];

    setColumnIds(tours);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: () => changeTour(), child: const Text('Try the timeline')),
          ],
        ),
      ),
    );
  }

  void changeTour() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyTimeline(
                tours: tours,
                numberColumns: maxColumn(tours),
              )),
    );
  }

  //Sorts the table by their startYear and sets the columnId so they don't overlap
  void setColumnIds(List<Tour> tours) {
    tours.sort((a, b) => a.startYear.compareTo(b.startYear));
    for (int i = 0; i <= tours.length - 1; i++) {
      int indexToSet = 0;
      List<Tour> concurrent = [];
      for (int k = 0; k <= i - 1; k++) {
        //Look for concurrent tours (tours that will overlap)
        if (tours[k].endYear >= tours[i].startYear) {
          concurrent.add(tours[k]);
        }
      }
      //While there is a concurrent tour that has the same columnId, we increment the columnIndex
      while (concurrent.firstWhereOrNull((element) => element.columnId == indexToSet) != null) {
        indexToSet++;
      }
      tours[i].columnId = indexToSet;
    }
  }

  //Look for the maximum columnId in the list of tours
  int maxColumn(List<Tour> tours) {
    int maxColumnId = 0;
    for (int i = 0; i <= tours.length - 1; i++) {
      if (tours[i].columnId > maxColumnId) {
        maxColumnId = tours[i].columnId;
      }
    }
    return maxColumnId + 1;
  }
}
