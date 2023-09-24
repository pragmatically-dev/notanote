// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:collection';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:notanote/src/components/grid_painter.dart';
import 'package:notanote/src/components/responsive_sidebar.dart';
import 'package:notanote/src/utils/responsive_bloc/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notanote/src/BLoC/movable_boxes.dart';

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => MovableBoxBloc(),
        ),
        BlocProvider(
          create: (ctx) => ScreenTypeBloc(mediaQuery: MediaQuery.of(context)),
        ),
      ],
      child: WhiteBoard(),
    );
  }
}

class WhiteBoard extends StatelessWidget {
  const WhiteBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenTypeBloc, ScreenType?>(
      builder: (context, screenType) {
        debugPrint(screenType.toString());
        return LayoutBuilder(builder: (cly, screenConstraints) {
          context
              .read<ScreenTypeBloc>()
              .add(ScreenTypeEvent(bc: screenConstraints));
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 17, 17, 17),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
              ),
              title: Text(
                "Notanote",
                style: GoogleFonts.poppins(fontSize: 30),
              ),
            ),
            body: SafeArea(child: BlocBuilder<MovableBoxBloc, MovableBoxState>(
                builder: (context, state) {
              return GestureDetector(
                onTap: () =>
                    BlocProvider.of<MovableBoxBloc>(context).add(DeselectBox()),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    screenType?.map(
                            xxl: (ctx) => ResponsiveSidebar(
                                  key: ValueKey("Sidebar"),
                                  flex: 1,
                                  widthFactor: 1,
                                  curve: Curves.bounceOut,
                                ),
                            xl: (ctx) => ResponsiveSidebar(
                                key: ValueKey("Sidebar"),
                                flex: 1,
                                widthFactor: 1,
                                curve: Curves.bounceOut),
                            lg: (ctx) => ResponsiveSidebar(
                                  key: ValueKey("Sidebar"),
                                  flex: 1,
                                  widthFactor: 1.5,
                                  curve: Curves.linear,
                                ),
                            md: (ctx) => ResponsiveSidebar(
                                  key: ValueKey("Sidebar"),
                                  flex: 2,
                                  widthFactor: 1,
                                  curve: Curves.linear,
                                ),
                            sm: (ctx) => Container()) ??
                        Container(),
                    Expanded(
                      flex: 12,
                      //TODO: IMPORTANT -> Decouple the logic from the InteractiveViewer: Create a model of the info given by the fields of the widget and a create a bloc
                      child: InteractiveViewer(
                        constrained: false,
                        minScale: 0.002,
                        maxScale: 200,
                        panEnabled: true,
                        interactionEndFrictionCoefficient: 0.03,
                        child: LayoutBuilder(
                          builder: (contextm, constraints) {
                            return Stack(
                              fit: StackFit.loose,
                              clipBehavior: Clip.none,
                              children: [
                                RepaintBoundary(
                                  child: SizedBox(
                                    width: 6000,
                                    height: 3000,
                                    child: const Grid(
                                      key: ValueKey("Grid"),
                                    ),
                                  ),
                                ),
                                //adding boxes from state
                                //TODO: Work around the logic of adding boxes to the whiteboard
                                ...state.boxes,
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            })),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  BlocProvider.of<MovableBoxBloc>(context).add(NukeBoxes());
                },
                child: const Icon(Icons.delete_outlined),
              ),
            ),
          );
        });
      },
    );
  }
}

//TODO: Restructure this mess [MovableBox]
class MovableBox extends StatefulWidget {
  final Offset initialPosition;
  final Color color;
  final Widget child;
  late Key childKey;

  late final _MovableBoxState state;

  MovableBox(this.childKey, this.initialPosition, this.color, this.child,
      {super.key}) {
    state = _MovableBoxState();
  }

  @override
  _MovableBoxState createState() => state;
}

class _MovableBoxState extends State<MovableBox> {
  late Offset position;
  double width = 150.0;
  double height = 150.0;
  late Queue<KeyEvent> events;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    this.position = widget.initialPosition;
   // ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  bool _onKey(KeyEvent event) {
    events.add(event);

    return false;
  }

  void select() {
    setState(() => selected = true);
  }

  void deselect() {
    setState(() => selected = false);
  }

  @override
  Widget build(BuildContext context) {
    bool isBigChild = false;
    double cornerSize = 22;
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onSecondaryTapDown: (details) => select(),
        onDoubleTap: () => deselect(),
        onLongPress: () => select(),
        onPanUpdate: (details) {
          deselect();
          if (!selected) {
            setState(() {
              position += details.delta;
            });
          }
        },
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              color: widget.color,
              child: LayoutBuilder(builder: (context, constraints) {
                isBigChild =
                    constraints.maxHeight > 350 || constraints.maxWidth > 350;
                cornerSize = isBigChild ? 105 : 22;
                //TODO: Think a way to resize the corners based on the InteractiveView mouse wheel scale
                print(cornerSize);
                return widget.child;
              }),
            ),
            if (selected)
              Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      width -= details.delta.dx;
                      height -= details.delta.dy;
                    });
                  },
                  child: Icon(Icons.crop_square, size: cornerSize),
                ),
              ),
            if (selected)
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      width += details.delta.dx;
                      height -= details.delta.dy;
                    });
                  },
                  child: Icon(Icons.crop_square, size: cornerSize),
                ),
              ),
            if (selected)
              Positioned(
                left: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      width -= details.delta.dx;
                      height += details.delta.dy;
                    });
                  },
                  child: Icon(Icons.crop_square, size: cornerSize),
                ),
              ),
            if (selected)
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      width += details.delta.dx;
                      height += details.delta.dy;
                    });
                  },
                  child: Icon(Icons.crop_square, size: cornerSize),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
