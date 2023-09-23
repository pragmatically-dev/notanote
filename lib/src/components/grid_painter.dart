
import 'package:flutter/material.dart';


// class Grid extends StatelessWidget {
//   const Grid({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 6000,
//       height: 6000,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           CustomPaint(
//             isComplex: true,
//             size: const Size(6000, 6000),
//             painter: GridPainter(gridSpacing: 80, strokeWidth: 0.4),
//           ),
//           CustomPaint(
//             isComplex: true,
//             size: const Size(6000, 6000),
//             painter: GridPainter(gridSpacing: 20, strokeWidth: 0.2),
//           ),
//           CustomPaint(
//             isComplex: true,
//             size: const Size(12000, 12000),
//             painter: GridPainter(gridSpacing: 10, strokeWidth: 0.1),
//           ),
//           CustomPaint(
//             isComplex: true,
//             size: const Size(24000, 24000),
//             painter: GridPainter(gridSpacing: 5, strokeWidth: 0.1),
//           ),
          
//         ],
//       ),
//     );
//   }
// }




// class GridPainter extends CustomPainter {
//   double gridSpacing = 20;
//   double strokeWidth = 0.5;
//   GridPainter({required this.gridSpacing, required this.strokeWidth});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black.withOpacity(0.9)
//       ..strokeWidth = strokeWidth;

//     for (int i = 0; i <= size.width / gridSpacing; i++) {
//       canvas.drawLine(
//         Offset(gridSpacing * i, 0),
//         Offset(gridSpacing * i, size.height),
//         paint,
//       );
//     }

//     for (int j = 0; j <= size.height / gridSpacing; j++) {
//       canvas.drawLine(
//         Offset(0, gridSpacing * j),
//         Offset(size.width, gridSpacing * j),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
// class Grid extends LeafRenderObjectWidget {
//   const Grid({Key? key}) : super(key: key);

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return RenderGrid();
//   }
// }

// class GridPainter extends CustomPainter {
//   final double gridSpacing;
//   final double strokeWidth;

//   GridPainter({required this.gridSpacing, required this.strokeWidth});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black.withOpacity(0.9)
//       ..strokeWidth = strokeWidth;

//     for (int i = 0; i <= size.width / gridSpacing; i++) {
//       canvas.drawLine(
//         Offset(gridSpacing * i, 0),
//         Offset(gridSpacing * i, size.height),
//         paint,
//       );
//     }

//     for (int j = 0; j <= size.height / gridSpacing; j++) {
//       canvas.drawLine(
//         Offset(0, gridSpacing * j),
//         Offset(size.width, gridSpacing * j),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class RenderGrid extends RenderBox {
//   @override
//   bool get sizedByParent => true;

//   @override
//   void performResize() {
//     size = constraints.biggest;
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     final canvas = context.canvas;
//     final gridPainter = GridPainter(gridSpacing: 20, strokeWidth: 0.5);
//     gridPainter.paint(canvas, size);
//   }
// }

// This is a custom widget class named `Grid` that extends `LeafRenderObjectWidget`.
class Grid extends LeafRenderObjectWidget {
  // Constructor for the Grid class.
  const Grid({Key? key}) : super(key: key);

  // This method is overridden to create an instance of `RenderGrid` when the framework needs to inflate this widget.
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGrid();
  }
}

// This is a custom painter class named `GridPainter` that extends `CustomPainter`.
class GridPainter extends CustomPainter {
  // These are the properties of the GridPainter class.
  final double gridSpacing;
  final double strokeWidth;
  final Paint paintt;
  List<Offset> verticalLines = [];
  List<Offset> horizontalLines = [];
  
  // Constructor for the GridPainter class.
  GridPainter({required this.gridSpacing, required this.strokeWidth})
      : paintt = Paint()
          ..color = Colors.black.withOpacity(0.9)
          ..strokeWidth = strokeWidth;

  // This method is overridden to draw on the given canvas. It draws vertical and horizontal lines to create a grid pattern.
  @override
  void paint(Canvas canvas, Size size) {
    // If there are no vertical or horizontal lines, calculate their positions.
    if (verticalLines.isEmpty || horizontalLines.isEmpty) {
      // Calculate the positions of vertical lines.
      for (int i = 0; i <= size.width / gridSpacing; i++) {
        verticalLines.add(Offset(gridSpacing * i, 0));
        verticalLines.add(Offset(gridSpacing * i, size.height));
      }

      // Calculate the positions of horizontal lines.
      for (int j = 0; j <= size.height / gridSpacing; j++) {
        horizontalLines.add(Offset(0, gridSpacing * j));
        horizontalLines.add(Offset(size.width, gridSpacing * j));
      }
    }

    // Draw each vertical line on the canvas.
    for (int i = 0; i < verticalLines.length; i += 2) {
      canvas.drawLine(verticalLines[i], verticalLines[i + 1], paintt);
    }

    // Draw each horizontal line on the canvas.
    for (int i = 0; i < horizontalLines.length; i += 2) {
      canvas.drawLine(horizontalLines[i], horizontalLines[i + 1], paintt);
    }
  }

  // This method is overridden to decide whether the painter should repaint. It always returns false, meaning the grid does not repaint when updated.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// This is a custom render box class named `RenderGrid` that extends `RenderBox`.
class RenderGrid extends RenderBox {
  
  // This getter is overridden to indicate that this render object's dimensions depend on its parent's dimensions.
  @override
  bool get sizedByParent => true;

  
   // This method is overridden to resize the render box to the biggest size allowed by the constraints.
   @override
   void performResize() {
     size = constraints.biggest;
   }

  
   // This method is overridden to paint using the given painting context and offset. It creates an instance of `GridPainter` and paints it on the canvas.
   @override
   void paint(PaintingContext context, Offset offset) {
     final canvas = context.canvas;
     final gridPainter = GridPainter(gridSpacing: 20, strokeWidth: 0.5);
     gridPainter.paint(canvas, size);
   }
}
