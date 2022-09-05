import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/modules/movies/presentation/screens/see_more_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/string.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_states.dart';
import '../screens/movie_detail_screen.dart';

class PopularComponent extends StatelessWidget {
  const PopularComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      buildWhen: (previous, current) =>
          previous.popularMoviesState != current.popularMoviesState,
      builder: (context, state) {
        switch (state.popularMoviesState) {
          case RequestState.loaded:
            return FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.popular,
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeeMoreScreen(
                                  title: 'Popular',
                                  movies: state.popularMovies,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Text(
                                  AppString.seeMore,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 170.0,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final movie = state.popularMovies[index];
                        return Container(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MovieDetailScreen(id: movie.id)),
                              );
                            },
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              child: CachedNetworkImage(
                                width: 120.0,
                                fit: BoxFit.cover,
                                imageUrl:
                                    AppConstants.imageUrl(movie.posterPath),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[850]!,
                                  highlightColor: Colors.grey[800]!,
                                  child: Container(
                                    height: 170.0,
                                    width: 120.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          case RequestState.loading:
            return const SizedBox(
              height: 170,
            );
          case RequestState.error:
            return Text(state.popularMoviesMessage);
        }
      },
    );
  }
}
