import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

typedef Future<String> UpdateUrlFetcher();

class Updater extends StatefulWidget {

  final UpdateUrlFetcher updateUrlFetcher;
  final Widget  child;

  const Updater({@required this.updateUrlFetcher, this.child, Key key})
      : assert(updateUrlFetcher != null),
        super(key: key);

  @override
  State createState() {
    return new UpdaterState();
  }
}

class UpdaterState extends State<Updater> {

  @override
  void initState() {
    _checkForUpdates();
  }

  static DateTime _lastUpdateCheck;
  Future<Null> _checkForUpdates() async {

  }

  Widget _buildDialog(){
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = (theme.textTheme.subhead.copyWith(color:theme.textTheme.caption.color));

  }

  @override
  Widget build(BuildContext context) => widget.child;

}
