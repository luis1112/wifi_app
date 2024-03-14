import 'dart:async';

import 'package:wifi/docs.dart';
import 'package:flutter/material.dart';

LoadController? loadController;

class PageGlobal extends StatefulWidget {
  final Widget? child;
  final Function onChangeTheme;

  const PageGlobal({
    required this.child,
    required this.onChangeTheme,
    super.key,
  });

  @override
  State<PageGlobal> createState() => _PageGlobalState();
}

class _PageGlobalState extends State<PageGlobal> implements LoadListener {
  _PageGlobalState() {
    loadController = LoadController(this);
  }



  bool isLoadGlobal = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // valueNotifier.secure();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return getWidget();
  }

  Widget getWidget() {
    return Stack(
      children: [
        widget.child ?? Container(),
        if (isLoadGlobal) ...[const PageLoad()],
      ],
    );
  }

  @override
  void onLoad(bool type) {
    Future.delayed(Duration.zero, () {
      setState(() => isLoadGlobal = type);
    });
  }



  @override
  void onChangeTheme() => widget.onChangeTheme();
}

abstract class LoadListener {
  void onLoad(bool type);
  void onChangeTheme();
}

class LoadController {
  LoadListener loadListener;

  LoadController(this.loadListener);

  onLoadType(bool value) => loadListener.onLoad(value);

  onChangeTheme() => loadListener.onChangeTheme();

}

void onLoad(bool value) => loadController!.onLoadType(value);

void onChangeTheme() => loadController!.onChangeTheme();
