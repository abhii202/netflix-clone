import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/movie_api_services.dart';
import 'trailer_event.dart';
import 'trailer_state.dart';

class TrailerBloc extends Bloc<TrailerEvent, TrailerState> {
  final MovieRepository repository;
  TrailerBloc(this.repository) : super(TrailerInitial()) {
    on<FetchTrailer>((event, emit) async {
      emit(TrailerLoading());
      int retryCount = 0;
      const int maxRetries = 3;
      const retryDelay = Duration(seconds: 2);
      while (retryCount < maxRetries) {
        try {
          final trailerKey = await repository.fetchTrailerKey(event.movieId);
          if (trailerKey != null) {
            emit(TrailerLoaded(trailerKey));
            return;
          } else {
            retryCount++;
            await Future.delayed(retryDelay);
          }
        } catch (e) {
          retryCount++;
          await Future.delayed(retryDelay);
        }
      }
      emit(
        TrailerError("Unable to fetch trailer. Please check your connection."),
      );
    });
  }
}
