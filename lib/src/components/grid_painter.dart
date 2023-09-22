
import 'package:flutter/material.dart';


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
            size: const Size(6000, 6000),
            painter: GridPainter(gridSpacing: 80, strokeWidth: 0.4),
          ),
          CustomPaint(
            isComplex: true,
            size: const Size(6000, 6000),
            painter: GridPainter(gridSpacing: 20, strokeWidth: 0.2),
          ),
          CustomPaint(
            isComplex: true,
            size: const Size(12000, 12000),
            painter: GridPainter(gridSpacing: 10, strokeWidth: 0.1),
          ),
          CustomPaint(
            isComplex: true,
            size: const Size(24000, 24000),
            painter: GridPainter(gridSpacing: 5, strokeWidth: 0.1),
          ),
          
        ],
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
