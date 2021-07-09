import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../core.dart';

class LoadImage extends StatefulWidget {
  const LoadImage(
      {required this.url,
      this.fit = BoxFit.contain,
      this.boxShape = BoxShape.rectangle});

  final String url;
  final BoxFit fit;
  final BoxShape boxShape;

  @override
  _LoadImageState createState() => _LoadImageState();
}

class _LoadImageState extends State<LoadImage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      fit: widget.fit,
      key: Key(widget.url),
      // cacheKey: widget.url,
      shape: widget.boxShape,
      width: MediaQuery.of(context).size.width * 0.75,
      cache: true,
      color: AppColors.white,
      mode: ExtendedImageMode.gesture,
      cacheMaxAge: Duration(minutes: 5),
      initGestureConfigHandler: (state) {
        return GestureConfig(
          minScale: 0.9,
          animationMinScale: 0.7,
          maxScale: 3.0,
          animationMaxScale: 3.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: false,
          initialAlignment: InitialAlignment.center,
        );
      },
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {

          ///if you don't want override completed widget
          ///please return null or state.completedWidget
          //return null;
          //return state.completedWidget;
          case LoadState.completed:
            _controller.forward();
            return FadeTransition(
              opacity: _controller,
              child: ExtendedRawImage(
                fit: widget.fit,
                image: state.extendedImageInfo?.image,
              ),
            );
          case LoadState.failed:
            _controller.reset();
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('unkown error'),
                  const Text(
                    "press to reload",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              onTap: () {
                state.reLoadImage();
              },
            );

          default:
            return null;
        }
      },
    );
  }
}
