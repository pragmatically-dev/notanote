import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notanote/main.dart';

// Define los eventos
abstract class MovableBoxEvent {}

class AddBox extends MovableBoxEvent {
  final Offset position;
  final Color color;
  final Widget child;
  final Key key;
  AddBox(this.key,this.position, this.color, this.child);
}

class SelectBox extends MovableBoxEvent {
  final MovableBox box;

  SelectBox(this.box);
}

class DeselectBox extends MovableBoxEvent {}

class OnDragBox extends MovableBoxEvent {
  //DragUpdateDetails
  //Offset
  //TODO:Implement this event
}

class OnResizeBox extends MovableBoxEvent {
//TODO:Implement this event
}

class NukeBoxes extends MovableBoxEvent {}

class DeleteBox extends MovableBoxEvent {
  final Key key;

  DeleteBox(this.key);
}

// Define los estados
class MovableBoxState {
  final List<MovableBox> boxes;
  final bool resizing;
  final MovableBox? selectedBox;

  MovableBoxState({
    required this.boxes,
    required this.resizing,
    required this.selectedBox,
  });
}

// Define el Bloc
class MovableBoxBloc extends Bloc<MovableBoxEvent, MovableBoxState> {
  MovableBoxBloc()
      : super(
          MovableBoxState(boxes: [], resizing: false, selectedBox: null),
        ) {
    on<AddBox>(
      (event, emit) {
        final boxes = List<MovableBox>.from(state.boxes)
          ..add(
            MovableBox(event.key??ValueKey("random"), event.position, event.color, event.child),
          );
        emit(
          MovableBoxState(
            boxes: boxes,
            resizing: state.resizing,
            selectedBox: state.selectedBox,
          ),
        );
      },
    );

    on<SelectBox>((event, emit) {
      final boxes = state.boxes.map((box) {
        if (box == event.box) {
          box.state.select();
          box.state.selected = true;
        } else {
          box.state.deselect();
        }
        return box;
      }).toList();
      emit(MovableBoxState(
          boxes: boxes, resizing: true, selectedBox: event.box));
    });

    on<DeselectBox>((event, emit) {
      final boxes = state.boxes.map((box) {
        box.state.deselect();
        box.state.selected = false;
        return box;
      }).toList();
      emit(MovableBoxState(boxes: boxes, resizing: false, selectedBox: null));
    });

    on<NukeBoxes>((event, emit) {
      state.boxes.clear();
      emit(MovableBoxState(
          boxes: state.boxes, resizing: false, selectedBox: null));
      emit(MovableBoxState(boxes: [], resizing: false, selectedBox: null));
    });

    on<DeleteBox>((event, emit) {
      final boxes = state.boxes.where((box) => (box.childKey as ValueKey).value  != (event.key as ValueKey).value).toList();
      emit(MovableBoxState(
          boxes: boxes,
          resizing: state.resizing,
          selectedBox: state.selectedBox));
    });
  }
}
