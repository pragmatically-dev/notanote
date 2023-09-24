// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TitleSidebar(),
                SidebarDraggableBox(
                  component: const FittedBox(child: FlutterLogo()),
                  child: const FittedBox(child: FlutterLogo()),
                  onDragEnd: (e) {},
                ),
                SidebarDraggableBox(
                  component: const Icon(
                    Icons.accessibility_new_sharp,
                    color: Colors.black,
                  ),
                  onDragEnd: (e) {},
                  child: const FittedBox(
                    child: Icon(
                      Icons.accessibility_new_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
                const ImageComponent()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//TODO: Extract all the logic of [ImageComponent] to a BloC
class ImageComponent extends StatefulWidget {
  const ImageComponent({
    super.key,
  });

  @override
  State<ImageComponent> createState() => _ImageComponentState();
}

class _ImageComponentState extends State<ImageComponent> {
  FilePickerResult? result;
  File? file;
  Widget img = Container();
  Future<void> _pickFile() async {
    // Lets the user pick one file; files with any file extension can be selected
    result = await FilePicker.platform.pickFiles(type: FileType.any);

// The result will be null, if the user aborted the dialog
    if (result != null && !kIsWeb) {
      file = File(result!.files.first.path ?? "");

      img = SizedBox(width: 400, height: 400, child: Image.file(file!));
    }

    if (result != null && kIsWeb) {
      file = File.fromRawPath(result!.files.first.bytes!);

      img = SizedBox(
          width: 400,
          height: 400,
          child: Image.memory(result!.files.first.bytes!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: SidebarDraggableBox(
        key: const ValueKey("image-picker"),
        onDragEnd: (e) {},
        component: SizedBox(
          key: const ValueKey("picker"),
          height: 100,
          width: 200,
          child: Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    "Pick your image",
                    style: GoogleFonts.openSans(
                        color: Colors.black.withOpacity(0.95), fontSize: 17),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _pickFile();
                    BlocProvider.of<MovableBoxBloc>(context).add(
                      DeleteBox(
                        const ValueKey("picker"),
                      ),
                    );

                    BlocProvider.of<MovableBoxBloc>(context).add(
                      AddBox(
                        img.key ?? ValueKey(result!.files.single.name.trim()),
                        const Offset(200, 200),
                        Colors.transparent,
                        Container(
                          child: img,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Open",
                      style:
                          GoogleFonts.poppins(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: const Icon(
          Icons.image_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TitleSidebar extends StatelessWidget {
  const TitleSidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        heightFactor: 0.08,
        child: Card(
          elevation: 9,
          color: Color.fromARGB(0, 255, 255, 255),
          child: Center(
            child: FittedBox(
              child: Text(
                "Componentes",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//TODO: Create a flexible API to create Sidebar component
class SidebarDraggableBox extends StatelessWidget {
  final Widget child;
  final Widget component;
  final void Function(DraggableDetails details) onDragEnd;
  const SidebarDraggableBox(
      {super.key,
      required this.child,
      required this.onDragEnd,
      required this.component});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Draggable(
        feedback: SizedBox(
          width: 90,
          height: 90,
          child: FittedBox(
            child: child,
          ),
        ),
        onDragEnd: (details) {
          debugPrint("Sidebar on end drop  ${details.offset}");
          BlocProvider.of<MovableBoxBloc>(context).add(
            AddBox(
              component.key ?? const ValueKey("unnamed"),
              details.offset.translate(-100, -100),
              Colors.transparent,
              FittedBox(child: component),
            ),
          );

          onDragEnd(details);
        },
        child: SizedBox(
          width: 70,
          height: 70,
          child: FittedBox(
            child: child,
          ),
        ),
      ),
    );
  }
}
