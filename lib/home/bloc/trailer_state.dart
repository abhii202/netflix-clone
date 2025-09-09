abstract class TrailerState {}

class TrailerInitial extends TrailerState {}

class TrailerLoading extends TrailerState {}

class TrailerLoaded extends TrailerState {
  final String trailerKey;
  TrailerLoaded(this.trailerKey);
}

class TrailerError extends TrailerState {
  final String message;
  TrailerError(this.message);
}
