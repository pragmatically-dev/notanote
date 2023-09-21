import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notanote",
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 37, 37, 37),
      ),
      home: const WhiteBoard(),
    );
  }
}

class WhiteBoard extends StatefulWidget {
  const WhiteBoard({super.key});

  @override
  State<WhiteBoard> createState() => _WhiteBoardState();
}

class _WhiteBoardState extends State<WhiteBoard> {
  double zoom = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 17, 17, 17),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(onPressed: (){}, icon: Icon(Icons.settings,size: 30, )),
        ),
        title: Text(
          "Notanote",
          style: GoogleFonts.poppins(fontSize: 30),
        ),
      ),
      body: SafeArea(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              heightFactor: 1,
              widthFactor: 1,
              child: Container(
                child: Card(
                  color: Color.fromARGB(255, 27, 27, 27),
                  margin: const EdgeInsets.all(5),

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  elevation: 9,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.002,
              maxScale: 200,
              interactionEndFrictionCoefficient: 0.03,
              child: LayoutBuilder(builder: (contextm, constraints) {
                return Stack(
                  fit: StackFit.loose,
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => MovableBoxController.instance.deselect(),
                      child: const Grid(),
                    ),
                    ...MovableBoxController.instance.boxes
                  ],
                );
              }),
            ),
          )
        ],
      )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(
              () {
                MovableBoxController.instance.addBox(
                  const Offset(50, 50),
                  Colors.transparent,
                  const FittedBox(
                    child: FlutterLogo(),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class Grid extends StatelessWidget {
  const Grid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 6000,
      height: 6000,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            isComplex: true,
            size: Size(6000, 6000),
            painter: GridPainter(gridSpacing: 80, strokeWidth: 0.4),
          ),
          CustomPaint(
            isComplex: true,
            size: Size(6000, 6000),
            painter: GridPainter(gridSpacing: 20, strokeWidth: 0.2),
          ),
          CustomPaint(
            isComplex: true,
            size: Size(12000, 12000),
            painter: GridPainter(gridSpacing: 10, strokeWidth: 0.1),
          ),
          CustomPaint(
            isComplex: true,
            size: Size(24000, 24000),
            painter: GridPainter(gridSpacing: 5, strokeWidth: 0.1),
          ),
        ],
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
  double width = 150.0;
  double height = 150.0;

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
        onDoubleTap: () => deselect(),
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
        child: Transform.scale(
          scaleX: width * 0.008,
          scaleY: height * 0.008,
          child: Container(
            width: width,
            height: height,
            color: selected ? widget.color.withOpacity(0.2) : widget.color,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  double gridSpacing = 20;
  double strokeWidth = 0.5;
  GridPainter({required this.gridSpacing, required this.strokeWidth});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.9)
      ..strokeWidth = strokeWidth;

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
