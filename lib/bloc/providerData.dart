import 'package:flutter/material.dart';
import 'dart:io';

class ProviderData with ChangeNotifier{

  TextEditingController? _control2 = TextEditingController();
  TextEditingController? _control1 = TextEditingController();

  ScrollController? _control3 = ScrollController();

  InternetAddress addressesIListenFrom = InternetAddress.anyIPv4;
  InternetAddress addresesToSend = InternetAddress("192.168.2.1");
  int port = 9742; //0 is random
  int _start = 0;

  bool? _conection1 = false, _oz = false, _comp = false, _ion = false, _air = false, _scroll = true, _measure = false;

  RawDatagramSocket? _udpDatagram;

  double _ozoneValue1 = 0.0, _ozoneValue2 = 0.0;

//////////*varables de tipo TextEditingController*/////////
  TextEditingController? get ctrl2 => _control2;
  set ctrl2(TextEditingController? value){
    _control2 = value;
    notifyListeners();
  }

  TextEditingController? get ctrl1 => _control1;
  set ctrl1(TextEditingController? value){
    _control1 = value;
    notifyListeners();
  }

  ScrollController? get ctrl3 => _control3;
  set ctrl3(ScrollController? value){
    _control3 = value;
    notifyListeners();
  }
/////////////////////////////////////////////////////////


/////////////*variables de tipo double*//////////////////
  double get ozoneValuePPM => _ozoneValue1;
  set ozoneValuePPM(double value){
    _ozoneValue1 = value;
    notifyListeners();
  }

  double get ozoneValuePPB => _ozoneValue2;
  set ozoneValuePPB(double value){
    _ozoneValue2 = value;
    notifyListeners();
  }
//////////////////////////////////////////////////////


/////////*variables booleanas*////////
  bool? get isConnect => _conection1;
  set isConnect(bool? value){
    _conection1 = value;
    notifyListeners();
  }

  bool? get ozone => _oz;
  set ozone(bool? value){
    _oz = value;
    notifyListeners();
  }

  bool? get compresor => _comp;
  set compresor(bool? value){
    _comp = value;
    notifyListeners();
  }

  bool? get ionize => _ion;
  set ionize(bool? value){
    _ion = value;
    notifyListeners();
  }

  bool? get airFresh => _air;
  set airFresh(bool? value){
    _air = value;
    notifyListeners();
  }

  bool? get scrolling => _scroll;
  set scrolling(bool? value){
    _scroll = value;
    notifyListeners();
  }

  bool? get takeMeasure => _measure;
  set takeMeasure(bool? value){
    _measure = value;
    notifyListeners();
  }

//////////////////////////////////////////


////////////*variables RawDatagramSocket*//////////////
  RawDatagramSocket? get udp => _udpDatagram;
  set udp(RawDatagramSocket? value){
    _udpDatagram = value;
    notifyListeners();
  }
///////////////////////////////////////////////////////

/////////////////*variables de tipo entero*///////////////////
  int get startTimer => _start;
  set startTimer(int value){
    _start = value;
    notifyListeners();
  }
/////////////////////////////////////////////////////////////


}