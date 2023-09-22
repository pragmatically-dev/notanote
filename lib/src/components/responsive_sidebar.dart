import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notanote/src/BLoC/movable_boxes.dart';

class ResponsiveSidebar extends StatelessWidget {
  final double widthFactor;
  final int flex;
  final Curve curve;
  const ResponsiveSidebar(
      {super.key,
      required this.flex,
      required this.widthFactor,
      required this.curve});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 1000),
        curve: curve,
        alignment: Alignment.centerLeft,
        heightFactor: 1,
        widthFactor: widthFactor,
        child: Card(
          color: const Color.fromARGB(255, 27, 27, 27),
          margin: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          elevation: 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Draggable(
                feedback: const SizedBox(
                  width: 90,
                  height: 90,
                  child: FittedBox(
                    child: FlutterLogo(),
                  ),
                ),
                onDragEnd: (details) {
                  print(details.offset);
                  BlocProvider.of<MovableBoxBloc>(context).add(
                    AddBox(
                      details.offset.translate(-100, -100),
                      Colors.transparent,
                      const FlutterLogo(),
                    ),
                  );
                },
                child: const SizedBox(
                  width: 70,
                  height: 70,
                  child: FittedBox(child: FlutterLogo()),
                ),
                
              )
            ],
          ),
        ),
      ),
    );
  }
}
