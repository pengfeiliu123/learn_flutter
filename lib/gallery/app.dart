import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/gallery/home.dart';
import 'package:learn_flutter/gallery/updates.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

final ThemeData _kGalleryLightTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData _kGalleryDarkTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);

class GalleryApp extends StatefulWidget {
  const GalleryApp({this.updateUrlFetcher,
    this.enablePerformanceOverlay: true,
    this.checkerboardRasterCacheImages: true,
    this.checkerboardOffscreenLayers: true,
    this.onSendFeedback,
    Key key})
      : super(key: key);

  final UpdateUrlFetcher updateUrlFetcher;

  final bool enablePerformanceOverlay;

  final bool checkerboardRasterCacheImages;

  final bool checkerboardOffscreenLayers;

  final VoidCallback onSendFeedback;

  @override
  GalleryAppState createState() => new GalleryAppState();
}

class GalleryAppState extends State<GalleryApp> {
  bool _useLightTheme = true;
  bool _showPerformanceOverlay = false;
  bool _checkerboardRasterCacheImages = false;
  bool _checkerboardOffscreenLayers = false;
  TextDirection _overrideDirection = TextDirection.ltr;
  double _timeDilation = 1.0;
  TargetPlatform _platform;

  double _textScaleFactor;
  Timer _timeDilationTimer;

  @override
  void initState() {
    // TODO: implement initState
    _timeDilation = timeDilation;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timeDilationTimer?.cancel();
    _timeDilationTimer = null;
  }

  Widget _applyScaleFactor(Widget child) {
    return new Builder(
      builder: (BuildContext context) =>
      new MediaQuery(
          data: MediaQuery
              .of(context)
              .copyWith(textScaleFactor: _textScaleFactor),
          child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget home = new GalleryHome(
      useLightTheme: _useLightTheme,
      onThemeChanged: (bool value) {
        setState(() {
          _useLightTheme = value;
        });
      },
      showPerformanceOverlay: _showPerformanceOverlay,
      onShowPerformanceOverlayChanged: widget.enablePerformanceOverlay?(bool value){
        setState((){
          _showPerformanceOverlay = value;
        });
      }:null,
      checkerboardRasterCacheImages: _checkerboardRasterCacheImages,
      onCheckerboardRasterCacheImagesChanged: widget.checkerboardRasterCacheImages ? (bool value) {
        setState(() {
          _checkerboardRasterCacheImages = value;
        });
      } : null,
      checkerboardOffscreenLayers: _checkerboardOffscreenLayers,
      onCheckerboardOffscreenLayersChanged: widget.checkerboardOffscreenLayers ? (bool value) {
        setState(() {
          _checkerboardOffscreenLayers = value;
        });
      } : null,
      onPlatformChanged: (TargetPlatform value) {
        setState(() {
          _platform = value == defaultTargetPlatform ? null : value;
        });
      },
      timeDilation: _timeDilation,
      onTimeDilationChanged: (double value) {
        setState(() {
          _timeDilationTimer?.cancel();
          _timeDilationTimer = null;
          _timeDilation = value;
          if (_timeDilation > 1.0) {
            // We delay the time dilation change long enough that the user can see
            // that the checkbox in the drawer has started reacting, then we slam
            // on the brakes so that they see that the time is in fact now dilated.
            _timeDilationTimer = new Timer(const Duration(milliseconds: 150), () {
              timeDilation = _timeDilation;
            });
          } else {
            timeDilation = _timeDilation;
          }
        });
      },
      textScaleFactor: _textScaleFactor,
      onTextScaleFactorChanged: (double value){
        setState((){
          _textScaleFactor = value;
        });
      },
      overrideDirection: _overrideDirection,
      onOverrideDirectionChanged: (TextDirection value){
        setState((){
          _overrideDirection = value;
        });
      },
      onSendFeedback: widget.onSendFeedback,

    );

    return new MaterialApp(
      title: "Learn Flutter",
      color: Colors.red,
      theme: (_useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme)
          .copyWith(platform: _platform ?? defaultTargetPlatform),
      home: _applyScaleFactor(home),
      builder: (BuildContext context, Widget child) {
        return new Directionality(
            textDirection: _overrideDirection,
            child: _applyScaleFactor(child));
      },
    );
  }
}
