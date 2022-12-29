import 'package:flutter/material.dart';
import 'data/tour.dart';

class Navigation{

  static void goTo(BuildContext context, Widget page){
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

}