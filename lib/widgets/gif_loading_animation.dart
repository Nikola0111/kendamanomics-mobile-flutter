import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

class GifLoadingAnimation extends StatefulWidget {
  const GifLoadingAnimation({super.key});

  @override
  State<GifLoadingAnimation> createState() => _GifLoadingAnimationState();
}

class _GifLoadingAnimationState extends State<GifLoadingAnimation> with SingleTickerProviderStateMixin {
  FlutterGifController? controller;
  @override
  void initState() {
    super.initState();
    controller = FlutterGifController(vsync: this);
    controller?.repeat(min: 0, max: 6, period: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: GifImage(
        controller: controller!,
        image: const AssetImage('assets/gif/loading_animation.gif'),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
