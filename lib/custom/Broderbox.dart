import 'package:flutter/material.dart';

class Broderbox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double width, height;
  const Broderbox({
    Key? key,
    required this.child,
    required this.padding,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.withAlpha(40), width: 2)),
      padding: const EdgeInsets.all(8.0),
      child: Center(child: child),
    );
  }
}
