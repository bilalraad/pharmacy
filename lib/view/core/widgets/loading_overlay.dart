import 'package:flutter/material.dart';

import '../core.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final double opacity;
  final Color color;
  final Widget? costumeIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;
  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    this.opacity = 0.3,
    this.color = AppColors.kPrimaryLightColor,
    this.costumeIndicator,
    this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    Widget layOutProgressIndicator;
    if (offset == null) {
      layOutProgressIndicator =
          Center(child: costumeIndicator ?? const LoadingDialog());
    } else {
      layOutProgressIndicator = Positioned(
        child: costumeIndicator ?? const LoadingDialog(),
        left: offset?.dx,
        top: offset?.dy,
      );
    }

    return Stack(
      children: [
        child,
        Opacity(
          child: ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        layOutProgressIndicator,
      ],
    );
  }
}

class LoadingDialog extends StatelessWidget {
  final Color? bgColor;
  const LoadingDialog({this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: bgColor ?? Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: CircularProgressIndicator(backgroundColor: Colors.grey),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Loading..'),
            ),
          ],
        ),
      ),
    );
  }
}
