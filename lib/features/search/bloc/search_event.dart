import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchSubmitted extends SearchEvent {
  final String query;

  const SearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchRecentSelected extends SearchEvent {
  final String query;

  const SearchRecentSelected(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchRecentRemoved extends SearchEvent {
  final int index;

  const SearchRecentRemoved(this.index);

  @override
  List<Object?> get props => [index];
}

class SearchAllRecentCleared extends SearchEvent {
  const SearchAllRecentCleared();
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}
