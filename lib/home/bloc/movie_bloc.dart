import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/movie_api_services.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc(this.repository) : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await repository.fetchTrendingMovies();

        if (movies.isNotEmpty) {
          emit(MovieLoaded(movies));
        } else {
          emit(
            MovieError(
              "No movies found. Please check your API key or network connection.",
            ),
          );
        }
      } catch (e, stackTrace) {
        debugPrint('MovieBloc FetchMovies Error: $e');
        debugPrintStack(stackTrace: stackTrace);
        emit(MovieError("Failed to fetch movies: ${e.toString()}"));
      }
    });
    on<MovieSelected>((event, emit) {
      emit(MovieSelectedState(event.movieId));
    });
  }
}
