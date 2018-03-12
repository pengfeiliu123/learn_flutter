import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef Widget GalleryDemoBuilder();

class GalleryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String category;
  final String routeName;
  final WidgetBuilder buildRoute;

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

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(title),
      subtitle: new Text(subtitle),
      onTap: (){
        if(routeName!=null){
          Timeline.instantSync('Start Transition',arguments: <String,String>{
            'from':'/',
            'to':routeName
          });
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }


}


final List<GalleryItem> kAllGalleryItems = _buildGalleryItems();

List<GalleryItem> _buildGalleryItems() {

  final List<GalleryItem> galleryItems = <GalleryItem>[
//    new GalleryItem(title: Shrine, category: 'Demos', routeName: null, buildRoute: null)
  ];

  return galleryItems;
}











