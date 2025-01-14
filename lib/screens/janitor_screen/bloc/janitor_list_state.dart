import 'dart:math';
import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Janitor_list_model.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Reassign_janitor_model.dart';

abstract class JanitorListState extends Equatable {
  const JanitorListState();
}

class JanitorListInitial extends JanitorListState {
  @override
  List<Object> get props => [];
}

class JanitorListLoading extends JanitorListState {
  @override
  List<Object> get props => [];
}

class JanitorListSuccess extends JanitorListState {
  final List<JanitorListModel> data;
  final bool fromReassign;

  const JanitorListSuccess({required this.data, required this.fromReassign});

  @override
  List<Object?> get props => [data];
}

class JanitorListError extends JanitorListState {
  final Failure error;
  const JanitorListError({required this.error});

  @override
  List<Object> get props => [error];
}

class ReassignTaskLoading extends JanitorListState {
  final String message;
  const ReassignTaskLoading({required this.message});

  @override
  List<Object> get props => [Random().nextInt(100)];
}

class ReassignTaskSuccessful extends JanitorListState {
  ReassignTaskSuccessful();
  @override
  List<Object> get props => [];
}

class ReassignTaskError extends JanitorListState {
  final Failure error;
  const ReassignTaskError({required this.error});

  @override
  List<Object> get props => [error];
}
