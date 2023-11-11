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
    _imageAnimation1 = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.elasticOut),
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
      appBar: AppBar(
        title: Text('Animation'),
      ),
      backgroundColor: Color(0xff0D310E),
          body : AnimatedBuilder(
        animation: _imageAnimation1!,
        builder: (context, child) {
          return Center(
            child: Column(
              children: [
                // Position the top image.
                Container(
                  height: 100,
                  child: Transform.scale(
                    scale: _imageAnimation1!.value,
                    child: Image.asset(
                      'assets/images/mypoker.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Position the bottom image.
                Container(
                  height: 200,
                  child: Transform.scale(
                    scale: _imageAnimation2!.value,
                    child: Image.asset(
                      'assets/images/sanjuydutt.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
