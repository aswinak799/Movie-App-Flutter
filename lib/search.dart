import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:netflix/colors.dart';
import 'package:netflix/trailer.dart';

class Movies {
  final int id;
  final String image;
  final String movie;
  final String movieposter;

  Movies(
      {required this.id,
      required this.image,
      required this.movie,
      required this.movieposter});
}

class SearchMoview extends StatefulWidget {
  const SearchMoview({super.key});

  @override
  State<SearchMoview> createState() => _SearchMoviewState();
}

class _SearchMoviewState extends State<SearchMoview> {
  final TextEditingController _query = TextEditingController();
  List<Movies> _movies = [];
  Future<String> _youtubeKey(int id) async {
    String videoKey;
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/${id}/videos?api_key=d18f91f6a8c7ef5c2014f334336d48f6&language=en-US");
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final body = response.body;
        final data = json.decode(body);

        var video = data['results'][0];

        videoKey = video['key'];

        return videoKey;
      }
    } catch (e) {
      customSnack(context, Colors.orange, e.toString());
    }

    return 'UJZx8MayWxk';
  }

  Future<void> _searchMovies(query, BuildContext ctx) async {
    List<Movies> movies = [];
    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=d18f91f6a8c7ef5c2014f334336d48f6&query=${query}&page=1&language=en-US');
    try {
      var response = await http.get(url);
      final body = response.body;
      final data = json.decode(body);
      print(data);
      for (var value in data['results']) {
        if (value['backdrop_path'] == null || value['poster_path'] == null) {
          movies.add(Movies(
              id: value['id'],
              image: "/vL5LR6WdxWPjLPFRLe133jXWsh5.jpg",
              movie: value['original_title'],
              movieposter: "/vL5LR6WdxWPjLPFRLe133jXWsh5.jpg"));
        } else {
          movies.add(Movies(
              id: value['id'],
              image: value['backdrop_path'],
              movie: value['original_title'],
              movieposter: value['poster_path']));
        }

        print(value['original_title']);
      }
      if (mounted) {
        setState(() {
          _movies = movies;
        });
      }
    } catch (e) {
      print(e);
      customSnack(ctx, Colors.orange, "Network Busy...!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Movie")),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.4, 0.8],
          colors: [
            Color.fromRGBO(0, 0, 0, 1),
            Color.fromRGBO(72, 240, 210, 0.4),
          ],
        )),
        child: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors
                            .teal, // Replace with your desired border color
                        width: 1.0, // Set the border width as needed
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // Add border radius if desired
                    ),
                    child: TextFormField(
                      style: TextStyle(color: Colors.teal[200]),
                      cursorColor: Colors.teal,
                      controller: _query,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.teal),
                          suffixIconColor: Colors.teal,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                          hintText: "Search Movies here ...",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0)),
                          suffix: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              String value = _query.text.trim();
                              _searchMovies(value, context);
                              print(value);
                            },
                          ),
                          suffixIcon: Icon(Icons.abc)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 600,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: _movies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 12,
                              child: GridTile(
                                header: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.play_arrow,
                                        size: 40.0,
                                        color: Colors.teal,
                                      ),
                                      onPressed: () async {
                                        String id = await _youtubeKey(
                                            _movies[index].id);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TrailerScreen(
                                              vidkey: id,
                                              id: _movies[index].id);
                                        }));
                                      },
                                    ),
                                  ],
                                ),
                                footer: Text(
                                  "${_movies[index].movie}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black87),
                                ),
                                child: Container(
                                  child: Image.network(
                                      fit: BoxFit.cover,
                                      "https://image.tmdb.org/t/p/original/${_movies[index].image}"),
                                  height: 100,
                                  width: 100,
                                  color: Colors.teal[100],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
