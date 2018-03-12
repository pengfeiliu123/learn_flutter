import 'package:flutter/material.dart';

class ShrineDemo extends StatelessWidget{

  static const String routName = "/shrine";

  @override
  Widget build(BuildContext context) {
    return buildShrine(context,new ShrineDemo());
  }
}

Widget buildShrine(BuildContext context, ShrineDemo shrineDemo) {
  return new Theme(data: new ThemeData(
    primarySwatch: Colors.grey,
    iconTheme: const IconThemeData(color:const Color(0xFF707070)),
    platform: Theme.of(context).platform,
  ), child: new Text("haha"));
}