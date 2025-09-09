import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/bloc/movie_bloc.dart';
import '../../home/bloc/movie_event.dart';
import '../../home/services/movie_api_services.dart';
import '../../home/ui/home_screen.dart';
import '../../widget/curved_clipper.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import '../model/profile_model.dart';
import '../services/account_api_services.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountBloc(AccountApiService())..add(FetchProfiles()),
      child: Scaffold(
        backgroundColor: Colors.black38,
        body: Padding(
          padding: EdgeInsets.only(top: 80, left: 10, right: 10),
          child: Column(
            children: [
              Image.asset("assets/images/netflix.png", height: 80),
              SizedBox(height: 10),
              Text(
                "WHO'S WATCHING?",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit_calendar,
                      color: Colors.white,
                      size: 14,
                    ),
                    label: Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size(60, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, state) {
                    if (state is AccountLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is AccountLoaded) {
                      final profiles = state.profiles;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.70,
                        ),
                        itemCount: profiles.length + 1, // +1 for Add Profile
                        itemBuilder: (context, index) {
                          if (index == profiles.length) {
                            // Add Profile container
                            return GestureDetector(
                              onTap: () {
                                // Navigate to HomeScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.grey.shade800,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.border_style_outlined,
                                              size: 70,
                                              color: Colors.white54,
                                            ),
                                            Icon(
                                              Icons.add,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        "Add Profile",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          final ProfileModel profile = profiles[index];
                          final colors = [
                            Colors.yellow.shade600,
                            Colors.blue.shade600,
                            Colors.pink.shade200,
                          ];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) =>
                                        MovieBloc(MovieRepository())
                                          ..add(FetchMovies()),
                                    child: HomeScreen(),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  Image.network(
                                    profile.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: SizedBox(
                                      height: 110,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipPath(
                                            clipper: CurvedTextClipper(),
                                            child: Container(
                                              height: 110,
                                              color:
                                                  colors[index % colors.length],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 70),
                                            child: Text(
                                              profile.name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is AccountError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
