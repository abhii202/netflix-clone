import 'package:equatable/equatable.dart';

abstract class TrailerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTrailer extends TrailerEvent {
  final int movieId;
  FetchTrailer(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
