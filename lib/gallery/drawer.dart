import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, required;
import 'package:flutter/gestures.dart';

class GalleryDrawerHeader extends StatefulWidget {
  final bool light;

  const GalleryDrawerHeader({Key key, this.light}) : super(key: key);

  @override
  State createState() {
    new _GalleryDrawerHeaderState();
  }
}

class _GalleryDrawerHeaderState extends State<GalleryDrawerHeader> {
  bool _logoHasName = true;
  bool _logoHorizontal = true;
  MaterialColor _logoColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final double systemTopPadding = MediaQuery.of(context).padding.top;

    return new Semantics(
        label: 'Fltter',
        child: new DrawerHeader(
          child: new GestureDetector(
            onLongPress: () {
              setState(() {
                _logoHorizontal = !_logoHorizontal;
                if (!_logoHorizontal) _logoHorizontal = true;
              });
            },
            onTap: () {
              setState(() {
                _logoHasName = !_logoHasName;
              });
            },
            onDoubleTap: () {
              setState(() {
                final List<MaterialColor> options = <MaterialColor>[];
                if (_logoColor != Colors.blue)
                  options.addAll(<MaterialColor>[
                    Colors.blue,
                    Colors.blue,
                    Colors.blue,
                    Colors.blue,
                    Colors.blue,
                    Colors.blue,
                    Colors.blue
                  ]);
                if (_logoColor != Colors.amber)
                  options.addAll(<MaterialColor>[
                    Colors.amber,
                    Colors.amber,
                    Colors.amber
                  ]);
                if (_logoColor != Colors.red)
                  options.addAll(
                      <MaterialColor>[Colors.red, Colors.red, Colors.red]);
                if (_logoColor != Colors.indigo)
                  options.addAll(<MaterialColor>[
                    Colors.indigo,
                    Colors.indigo,
                    Colors.indigo
                  ]);
                if (_logoColor != Colors.pink)
                  options.addAll(<MaterialColor>[Colors.pink]);
                if (_logoColor != Colors.purple)
                  options.addAll(<MaterialColor>[Colors.purple]);
                if (_logoColor != Colors.cyan)
                  options.addAll(<MaterialColor>[Colors.cyan]);
                _logoColor = options[new math.Random().nextInt(options.length)];
              });
            },
          ),
          duration: const Duration(microseconds: 750),
          decoration: new FlutterLogoDecoration(
            margin: new EdgeInsets.fromLTRB(
                12.0, 12.0 + systemTopPadding, 12.0, 12.0),
            style: _logoHasName
                ? _logoHorizontal
                    ? FlutterLogoStyle.horizontal
                    : FlutterLogoStyle.stacked
                : FlutterLogoStyle.markOnly,
            lightColor: _logoColor.shade400,
            darkColor: _logoColor.shade900,
            textColor: widget.light
                ? const Color(0xFF616161)
                : const Color(0xFF9E9E9E),
          ),
        ));
  }
}

class GalleryDrawer extends StatelessWidget {
  const GalleryDrawer({
    Key key,
    this.useLightTheme,
    @required this.onThemeChanged,
    this.timeDilation,
    @required this.onTimeDilationChanged,
    this.textScaleFactor,
    this.onTextScaleFactorChanged,
    this.showPerformanceOverlay,
    this.onShowPerformanceOverlayChanged,
    this.checkerboardRasterCacheImages,
    this.onCheckerboardRasterCacheImagesChanged,
    this.checkerboardOffscreenLayers,
    this.onCheckerboardOffscreenLayersChanged,
    this.onPlatformChanged,
    this.overrideDirection: TextDirection.ltr,
    this.onOverrideDirectionChanged,
    this.onSendFeedback,
  })
      : assert(onThemeChanged != null),
        assert(onTimeDilationChanged != null),
        super(key: key);

  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double timeDilation;
  final ValueChanged<double> onTimeDilationChanged;

  final double textScaleFactor;
  final ValueChanged<double> onTextScaleFactorChanged;

  final bool showPerformanceOverlay;
  final ValueChanged<bool> onShowPerformanceOverlayChanged;

  final bool checkerboardRasterCacheImages;
  final ValueChanged<bool> onCheckerboardRasterCacheImagesChanged;

  final bool checkerboardOffscreenLayers;
  final ValueChanged<bool> onCheckerboardOffscreenLayersChanged;

  final ValueChanged<TargetPlatform> onPlatformChanged;

  final TextDirection overrideDirection;
  final ValueChanged<TextDirection> onOverrideDirectionChanged;

  final VoidCallback onSendFeedback;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final List<Widget> allDrawerItems = <Widget>[
      new GalleryDrawerHeader(light: useLightTheme),
      const Divider(),
    ];

    return new Drawer(
        child: new ListView(
      primary: false,
      children: allDrawerItems,
    ));
  }
}
