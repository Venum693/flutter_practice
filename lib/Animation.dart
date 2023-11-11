import 'package:flutter/material.dart';

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> with TickerProviderStateMixin{
 
  AnimationController? _animationController;
  Animation? _imageAnimation1;
  Animation? _imageAnimation2;

  @override
  void initState() {
    super.initState();

    // Create an AnimationController.
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Create an Animation that scales from 0 to 1.
    _imageAnimation1 = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
    _imageAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start the animation.
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          body : AnimatedBuilder(
        animation: _imageAnimation1!,
        builder: (context, child) {
          return Stack(
            children: [
              // Position the top image.
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Transform.scale(
                  scale: _imageAnimation1!.value,
                  child: Image.asset(
                    'assets/images/mypoker.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Position the bottom image.
              Positioned(
                bottom: 5,
                left: 0.0,
                right: 0.0,

                child: Transform.scale(
                  scale: _imageAnimation2!.value,
                  child: Image.asset(
                    'assets/images/sanjuydutt.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
