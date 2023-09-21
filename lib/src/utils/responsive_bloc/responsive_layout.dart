import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'responsive_layout.freezed.dart';

@freezed
abstract class ScreenType with _$ScreenType {
  const factory ScreenType.sm() = SM;
  const factory ScreenType.md() = MD;
  const factory ScreenType.lg() = LG;
  const factory ScreenType.xl() = XL;
  const factory ScreenType.xxl() = XXL;
}
