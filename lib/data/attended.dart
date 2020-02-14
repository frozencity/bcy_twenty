import 'package:flutter/material.dart';

class Attended extends ChangeNotifier {

  int rooms = 0;

  int get totalRooms => rooms;


  void addRoom() {
    rooms = rooms + 1;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }




}