import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'responsive_layout.dart';


class ScreenTypeEvent {}

class ScreenTypeBloc extends Bloc<ScreenTypeEvent, ScreenType?> {
  ScreenTypeBloc({required this.mediaQueryData}) : super(_getScreenType(mediaQueryData.size.width));

  final MediaQueryData mediaQueryData;

  Stream<ScreenType?> mapEventToState(ScreenTypeEvent event) async* {
    yield _getScreenType(mediaQueryData.size.width);
  }
}

ScreenType _getScreenType(double width) {
  if (width >= 1536) return const ScreenType.xxl();
  if (width >= 1280) return const ScreenType.xl();
  if (width >= 1024) return const ScreenType.lg();
  if (width <= 640) return  const ScreenType.sm();
  return const ScreenType.md();
}