import 'package:flutter/material.dart';
import 'package:learn_flutter/demo/shrine/shrine_home.dart';
import 'package:learn_flutter/demo/shrine/shrine_theme.dart';

class ShrineDemo extends StatelessWidget {
  static const String routName = "/shrine";

  @override
  Widget build(BuildContext context) {
    return buildShrine(context, new ShrineHome());
  }
}

Widget buildShrine(BuildContext context, Widget child) {
  return new Theme(
      data: new ThemeData(
        primarySwatch: Colors.grey,
        iconTheme: const IconThemeData(color: const Color(0xFF707070)),
        platform: Theme.of(context).platform,
      ),
      child: new ShrineTheme(child: child));
}

// route page
class ShrinePageRoute<T> extends MaterialPageRoute<T> {
  ShrinePageRoute(
      {WidgetBuilder builder, RouteSettings settings: const RouteSettings()})
      : super(builder: builder, settings: settings);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return buildShrine(
        context, super.buildPage(context, animation, secondaryAnimation));
  }
}
