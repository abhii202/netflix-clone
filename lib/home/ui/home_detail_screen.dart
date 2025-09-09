import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../bloc/trailer_bloc.dart';
import '../bloc/trailer_event.dart';
import '../bloc/trailer_state.dart';
import '../services/movie_api_services.dart';
import '../models/movie_model.dart';

class TrailerScreen extends StatefulWidget {
  final int movieId;
  TrailerScreen({super.key, required this.movieId});

  @override
  State<TrailerScreen> createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  YoutubePlayerController? _controller;
  Movie? _movie;
  bool _isMovieLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
    context.read<TrailerBloc>().add(FetchTrailer(widget.movieId));
  }

  void _fetchMovieDetails() async {
    try {
      final repo = MovieRepository();
      final details = await repo.fetchMovieDetails(widget.movieId);
      setState(() {
        _movie = details;
        _isMovieLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching movie details: $e");
      setState(() => _isMovieLoading = false);
    }
  }

  void _initializeController(String key) {
    if (_controller != null) return;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: key,
      autoPlay: true,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) => Column(
    children: [
      Icon(icon, color: Colors.white),
      SizedBox(height: 4),
      Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
    ],
  );

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Image.asset("assets/images/netflix.png", height: 30),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<TrailerBloc, TrailerState>(
              builder: (context, state) {
                if (state is TrailerLoading || state is TrailerInitial) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  );
                } else if (state is TrailerLoaded) {
                  if (_controller == null)
                    _initializeController(state.trailerKey);
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayerScaffold(
                      controller: _controller!,
                      builder: (context, player) => player,
                    ),
                  );
                } else if (state is TrailerError) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        "Trailer not available",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                return SizedBox(height: 200);
              },
            ),

            if (_isMovieLoading)
              Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              )
            else if (_movie != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      _movie!.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _movie!.overview,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(Icons.play_arrow, "Play"),
                        _buildActionButton(Icons.add, "My List"),
                        _buildActionButton(Icons.info_outline, "Info"),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
