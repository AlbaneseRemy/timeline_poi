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
      Tour(
          title: "Tour numéro 1",
          id: "1",
          startYear: -150,
          endYear: 150,
          color: Colors.red,
          imageUri: "https://images.unsplash.com/photo-1547721064-da6cfb341d50",
          columnId: 0),
      Tour(title: "Tour numéro 2", id: "2", startYear: 200, endYear: 300, color: Colors.green),
      Tour(title: "Tour numéro 3", id: "3", startYear: 300, endYear: 600, color: Colors.purple),
      Tour(title: "Tour numéro 4", id: "4", startYear: 800, endYear: 1200, color: Colors.pink),
      Tour(title: "Tour numéro 5", id: "5", startYear: 350, endYear: 450, color: Colors.blue),
      Tour(title: "Tour numéro 6", id: "6", startYear: 500, endYear: 600, color: Colors.yellow),
      Tour(title: "Tour numéro 7", id: "7", startYear: 540, endYear: 700, color: Colors.brown),
      Tour(title: "Tour numéro 8", id: "8", startYear: 540, endYear: 700, color: Colors.white),
      Tour(title: "Tour numéro 9", id: "9", startYear: 600, endYear: 750, color: Colors.orange),
      Tour(title: "Tour numéro 10", id: "10", startYear: 700, endYear: 800, color: Colors.yellow),
    ];

    tours.sort((a, b) => a.endYear.compareTo(b.endYear));
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


  void setColumnIds(List<Tour> tours) {
    for (int i = 0; i <= tours.length -1; i++) {
      int j = 0;
      List<Tour> concurrent = [];
      for (int k = 0; k <= i - 1; k++) {
        if (tours[k].endYear >= tours[i].startYear) {
          concurrent.add(tours[k]);
        }
      }
      while(concurrent.firstWhereOrNull((element) => element.columnId == j) != null) {
        j++;
      }
      tours[i].columnId = j;
    }
  }

  int maxColumn(List<Tour> tours){
    int maxColumnId = 0;
    for (int i = 0; i <= tours.length - 1; i++) {
      if (tours[i].columnId > maxColumnId) {
        maxColumnId = tours[i].columnId;
      }
    }
    return maxColumnId +1;
  }

}
