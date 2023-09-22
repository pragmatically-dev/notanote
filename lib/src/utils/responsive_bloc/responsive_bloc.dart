import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'responsive_layout.dart';


class ScreenTypeEvent {
  BoxConstraints bc;
  ScreenTypeEvent({required this.bc});
}

class ScreenTypeBloc extends Bloc<ScreenTypeEvent, ScreenType?> {
  MediaQueryData mediaQuery;
  ScreenTypeBloc({required this.mediaQuery}): super(_getScreenType(mediaQuery.size.width)){
    on<ScreenTypeEvent> ((event, emit) => emit(_getScreenType(event.bc.maxWidth)),);
  } 
  



  // Stream<ScreenType?> mapEventToState(ScreenTypeEvent event) async* {
  //   yield _getScreenType(event.bc.maxWidth);
  // }
}

ScreenType _getScreenType(double width) {
  print(width);
  if (width >= 1536) return const ScreenType.xxl();
  if (width >= 1280) return const ScreenType.xl();
  if (width >= 1024) return const ScreenType.lg();
  if (width <= 640) return  const ScreenType.sm();
  return const ScreenType.md();
}