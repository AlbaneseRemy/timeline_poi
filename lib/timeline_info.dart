import 'package:flutter/material.dart';

import 'data/tour.dart';

class TimelineInfo extends StatefulWidget {

  final Tour tour;

  const TimelineInfo({Key? key, required this.tour}) : super(key: key);

  @override
  State<TimelineInfo> createState() => _TimelineInfoState();
}

class _TimelineInfoState extends State<TimelineInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tour.title),
      ),
      body: Container(
        child: widget.tour.description != null ? Text('${widget.tour.description} ') : Text('No description'),
      ),
    );
  }
}
