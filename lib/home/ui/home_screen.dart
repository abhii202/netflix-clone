import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../bloc/trailer_bloc.dart';
import '../services/movie_api_services.dart';
import '../../core/tmdb_api.dart';
import 'home_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeVideo;
  late final MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = VideoPlayerController.asset("assets/videos/trailler.mp4");
    _initializeVideo = _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.setVolume(0);
      _controller.play();
    });

    _movieBloc = MovieBloc(MovieRepository())..add(FetchMovies());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _movieBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.play();
    } else if (state == AppLifecycleState.paused) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _movieBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        drawer: const Drawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              expandedHeight: 200,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Image.asset("assets/images/netflix.png", height: 30),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.tv)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    FutureBuilder(
                      future: _initializeVideo,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller.value.size.width,
                              height: _controller.value.size.height,
                              child: VideoPlayer(_controller),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          );
                        }
                      },
                    ),
                    Positioned(
                      top: 180,
                      left: 320,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    );
                  } else if (state is MovieLoaded) {
                    final movies = state.movies;
                    final popular = movies;
                    final horror = movies
                        .where((m) => m.genreIds.contains(27))
                        .toList();
                    final thriller = movies
                        .where((m) => m.genreIds.contains(53))
                        .toList();
                    final sciFi = movies
                        .where((m) => m.genreIds.contains(878))
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCategory("Popular on Netflix", popular, context),
                        buildCategory("Horrorrrr", horror, context),
                        buildCategory("Thriller", thriller, context),
                        buildCategory("Sci-Fi", sciFi, context),
                      ],
                    );
                  } else if (state is MovieError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategory(String title, List movies, BuildContext context) {
    if (movies.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  _controller.pause();

                  _movieBloc.add(MovieSelected(movie.id));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (_) => TrailerBloc(MovieRepository()),
                        child: TrailerScreen(movieId: movie.id),
                      ),
                    ),
                  ).then((_) {
                    _controller.play();
                    _movieBloc.add(FetchMovies());
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(
                        "${TMDBConfig.imageBaseUrl}${movie.posterPath}",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
