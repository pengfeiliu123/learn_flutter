import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/demo/shrine_demo.dart';

typedef Widget GalleryDemoBuilder();

class GalleryItem extends StatelessWidget {
  const GalleryItem({
    @required this.title,
    this.subtitle,
    @required this.category,
    @required this.routeName,
    @required this.buildRoute,
  })
      : assert(title != null),
        assert(category != null),
        assert(routeName != null),
        assert(buildRoute != null);

  final String title;
  final String subtitle;
  final String category;
  final String routeName;
  final WidgetBuilder buildRoute;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(title),
      subtitle: new Text(subtitle),
      onTap: () {
        if (routeName != null) {
          Timeline.instantSync('Start Transition',
              arguments: <String, String>{'from': '/', 'to': routeName});
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }
}

List<GalleryItem> _buildGalleryItems() {
  final List<GalleryItem> galleryItems = <GalleryItem>[
    new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),
    new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'test category1',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),
    new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),
    new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),
    new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),
    new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),
    new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),
    new GalleryItem(
        title: 'Shrine',
        subtitle: 'Basic shopping app',
        category: 'Demos',
        routeName: ShrineDemo.routName,
        buildRoute: (BuildContext context) => new ShrineDemo()),


  ];

  return galleryItems;
}

final List<GalleryItem> kAllGalleryItems = _buildGalleryItems();
