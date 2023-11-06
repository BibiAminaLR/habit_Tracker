import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animation Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black38,
          bottom: const TabBar(
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.black45,
            tabs: [
              Tab(text: 'Animated'),
              Tab(text: 'Transition'),
              Tab(text: 'Builder'),
            ],
          ),
          title: const Text('Animations'),
        ),
        body: const TabBarView(
          // animations
          children: [
            AnimatedXYZ(),
            XYZTransition(),
            BuilderAnimation(),
          ],
        ),
      ),
    );
  }
}

class AnimatedXYZ extends StatefulWidget {
  const AnimatedXYZ({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedXYZState createState() => _AnimatedXYZState();
}

class _AnimatedXYZState extends State<AnimatedXYZ> {
  bool _toggle = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'AnimatedContainer',
                style: TextStyle(fontSize: 20),
              ),
            ),
            AnimatedContainer(
              decoration: BoxDecoration(
                color: _toggle == true ? Colors.black26 : Colors.pink,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              curve: Curves.easeInOutBack,
              duration: const Duration(seconds: 1),
              height: _toggle == true ? 100 : 400,
              width: _toggle == true ? 100 : 200,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _toggle = !_toggle;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _toggle == true
                    ? Colors.black26
                    : Colors.white, // Background color
              ),
              child: Text(
                _toggle == true ? 'Tap Container' : 'Release Container',
                style: TextStyle(
                    color: _toggle == true ? Colors.white : Colors.pink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class XYZTransition extends StatefulWidget {
  const XYZTransition({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _XYZTransitionState createState() => _XYZTransitionState();
}

class _XYZTransitionState extends State<XYZTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'RotationalTransition',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _animationController.isAnimating
                    ? _animationController.stop()
                    : _animationController.repeat();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // defining the animation type
                      RotationTransition(
                        alignment: Alignment.center,
                        turns: _animationController,
                        child: Image.asset("assets/images/settings.png",
                            height: 150, width: 150),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Tap to STOP/ START',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.blueGrey,
                            fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuilderAnimation extends StatefulWidget {
  const BuilderAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuilderAnimationState createState() => _BuilderAnimationState();
}

class _BuilderAnimationState extends State<BuilderAnimation>
    with SingleTickerProviderStateMixin {
  late Animation _starAnimation;
  late AnimationController _starAnimationController;

  bool toggle = false;

  @override
  void initState() {
    super.initState();
    _starAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _starAnimation = Tween(begin: 140.0, end: 160.0).animate(CurvedAnimation(
        curve: Curves.elasticInOut, parent: _starAnimationController));

    _starAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _starAnimationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _starAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'AnimatedBuilder',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: AnimatedBuilder(
              animation: _starAnimationController,
              builder: (context, child) {
                return Center(
                  child: Center(
                    child: Icon(
                      Icons.audiotrack_sharp,
                      color: Colors.black,
                      size: _starAnimation.value,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black26),
            child: const Text('START/ STOP'),
            onPressed: () {
              toggle = !toggle;
              toggle == true
                  ? _starAnimationController.forward()
                  : _starAnimationController.stop();
            },
          ),
        ],
      ),
    );
  }
}
