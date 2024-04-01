import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SlideContainer extends StatefulWidget {
  const SlideContainer({Key? key}) : super(key: key);

  @override
  State<SlideContainer> createState() => SlideContainerState();
}

class SlideContainerState extends State<SlideContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _positionX = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: _positionX, end: _positionX)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.2;

    return GestureDetector(
      onHorizontalDragStart: (_) {
        _isDragging = true;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        color: Colors.red,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: containerWidth,
                color: Colors.blue,
                child: Center(child: Text("E")),
              ),
            ),
            Positioned(
              left: containerWidth,
              right: containerWidth,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: containerWidth,
                color: Colors.green,
                child: Center(child: Text("D")),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: containerWidth,
                color: Colors.yellow,
                child: Center(child: Text("A")),
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: _animation.value,
                  right: -_animation.value,
                  child: child!,
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: Colors.purple,
                child: Center(child: Text("B")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
