import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
  @override
  List<Object?> get props => [];
}

class FetchMovies extends MovieEvent {}

class MovieSelected extends MovieEvent {
  final int movieId;
  const MovieSelected(this.movieId);
  @override
  List<Object?> get props => [movieId];
}
