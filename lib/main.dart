import 'package:flutter/material.dart';

// main function to run flutter app
void main() {
  runApp(const MovingSquareApp());
}

// application widget
class MovingSquareApp extends StatelessWidget {
  const MovingSquareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // to hide the banner
      home: MovingSquareScreen(),
    );
  }
}

// creating a stateful widget to handle the animation of the square
class MovingSquareScreen extends StatefulWidget {
  const MovingSquareScreen({super.key});

  @override
  _MovingSquareScreenState createState() => _MovingSquareScreenState();
}

class _MovingSquareScreenState extends State<MovingSquareScreen> {
  double _position = 0; // setting default position to 0
  final double _squareSize = 50.0; // square size
  bool _isAnimating = false; // flag to handle animations

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {      //to be called when user interface is renderred 
      setState(() {
        double screenWidth = MediaQuery.of(context).size.width; //to find the screen width to centre the square
        _position = (screenWidth - _squareSize) / 2; // logic to centre the square
      });
    });
  }

  // Function to move the square either left or right
  void _moveSquare(bool toRight) {
    if (_isAnimating) return; // If already animating, ignore further requests

    setState(() {
      _isAnimating = true; // Disable buttons while animating
    });

    double screenWidth = MediaQuery.of(context).size.width;   //to find the screen width using media query
    double targetPosition = toRight ? screenWidth - _squareSize - 16 : 0; //to move to the right or left edge (-16) for padding

    // Delays state update until animation is complete
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _position = targetPosition; //move to target 
        _isAnimating = false; //enable buttons
      });
    });
  }

  // Function to reset square position to center
  void _resetSquare() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    double screenWidth = MediaQuery.of(context).size.width;
    double centerPosition = (screenWidth - _squareSize) / 2;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _position = centerPosition;
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Moving Square'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container to hold the square and provide animation space
          Container(
            width: double.infinity,
            height: 100,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(seconds: 1),
                  left: _position,
                  child: Container(
                    width: _squareSize,
                    height: _squareSize,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8), // Slightly rounded edges
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Row for Left, Right, and Reset Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isAnimating || _position == 0 ? null : () => _moveSquare(false),
                icon: const Icon(Icons.arrow_left, color: Colors.black),
                label: const Text(
                  'To Left',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _isAnimating || _position >= MediaQuery.of(context).size.width - _squareSize - 16 
                    ? null 
                    : () => _moveSquare(true),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'To Right',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 5), // Space between text and icon
                    Icon(Icons.arrow_right, color: Colors.black),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
              ),


              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 50,),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
             ElevatedButton(
                onPressed: _isAnimating ? null : _resetSquare,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Icon(Icons.refresh, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
