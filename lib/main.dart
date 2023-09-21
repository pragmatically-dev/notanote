import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(
                () {
                  MovableBoxController.instance.addBox(
                      Offset(50, 50),
                      Colors.transparent,
                      FittedBox(
                        child: FlutterLogo(),
                      ));
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        body: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(1),
          minScale: 0.000001,
          maxScale: 10,
          interactionEndFrictionCoefficient: 0.03,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return GestureDetector(
                onTap: () => MovableBoxController.instance.deselect(),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: GridPainter(),
                    ),
                    ...MovableBoxController.instance.boxes,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MovableBoxController extends ChangeNotifier {
  static final instance = MovableBoxController();

  List<MovableBox> boxes = [];

  void addBox(Offset position, Color color, Widget child) {
    boxes.add(MovableBox(position, color, child));
    notifyListeners();
  }

  void select(MovableBox box) {
    for (var box in boxes) {
      box.state.deselect();
    }
    box.state.select();
    notifyListeners();
  }

  void deselect() {
    for (var box in boxes) {
      box.state.deselect();
    }
    notifyListeners();
  }
}

class MovableBox extends StatefulWidget {
  final Offset initialPosition;
  final Color color;
  final Widget child;
  late final _MovableBoxState state;

  MovableBox(this.initialPosition, this.color, this.child)
      : state = _MovableBoxState();

  @override
  _MovableBoxState createState() => state;
}

class _MovableBoxState extends State<MovableBox> {
  Offset position = Offset.zero;
  double width = 100.0;
  double height = 100.0;

  bool selected = false;

  void select() {
    setState(() => selected = true);
  }

  void deselect() {
    setState(() => selected = false);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onSecondaryTapDown: (details) => select(),
        onPanUpdate: (details) {
          if (selected) {
            setState(() {
              width += details.delta.dx;
              height += details.delta.dy;
            });
          } else {
            setState(() {
              position += details.delta;
            });
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, minWidth: 10),
          child: Transform.scale(
            child: Container(
              width: width,
              height: height,
              color: selected ? widget.color.withOpacity(0.2) : widget.color,
              child: widget.child,
            ),
            scaleX: width * 0.008,
            scaleY: height * 0.008,
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 0.5;

    final double gridSpacing = 20.0;

    for (int i = 0; i <= size.width / gridSpacing; i++) {
      canvas.drawLine(
        Offset(gridSpacing * i, 0),
        Offset(gridSpacing * i, size.height),
        paint,
      );
    }

    for (int j = 0; j <= size.height / gridSpacing; j++) {
      canvas.drawLine(
        Offset(0, gridSpacing * j),
        Offset(size.width, gridSpacing * j),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
