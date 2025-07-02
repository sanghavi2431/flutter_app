import 'package:equatable/equatable.dart';

abstract class HistoryListEvent extends Equatable {
  const HistoryListEvent();
}

class GetAllHistory extends HistoryListEvent {
  final String month;
  final String year;

  const GetAllHistory({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class GetAllMonths extends HistoryListEvent {
  const GetAllMonths();

  @override
  List<Object?> get props => [];
}
