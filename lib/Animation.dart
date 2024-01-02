import 'package:flutter/material.dart';

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> with TickerProviderStateMixin{
 
  AnimationController? _animationController;
  Animation? _imageAnimation1;
  //Animation? _imageAnimation2;
  bool _showBottomSheet = false;


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
        curve: Interval(0.0, 1.0, curve: Curves.easeIn),
      ),
    );
    // _imageAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(
    //     parent: _animationController!,
    //     curve: Interval(0.0, 1.0, curve: Curves.easeIn),
    //   ),
    // );

    // Start the animation.
    _animationController!.forward();

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _showBottomSheet = true;
      });
    });
  }


  @override
  void dispose() {

    _animationController!.dispose();
    super.dispose();
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
                    //alignment:Alignment(0,-1),
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
                    scale: _imageAnimation1!.value,
                    //alignment: Alignment(0,1),
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
      bottomSheet: _showBottomSheet ? AnimatedBottomSheet() : SizedBox(),
    );
  }
}

class AnimatedBottomSheet extends StatefulWidget {
  @override
  _AnimatedBottomSheetState createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<AnimatedBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0, _animation.value * MediaQuery.of(context).size.height),
          child: Container(
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Text(
                'This is a Bottom Sheet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}