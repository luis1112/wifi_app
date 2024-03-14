import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PageLoad extends StatelessWidget {
  const PageLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.5),
      body: loadCenter(),
    );
  }
}

Widget loadCenter([Color? color]) {
  return Center(
    child: LoadingAnimationWidget.staggeredDotsWave(
      color: color ?? Colors.white,
      size: 50.0,
    ),
  );
}
