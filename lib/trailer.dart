import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix/colors.dart';
import 'package:netflix/web_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class TrailerScreen extends StatefulWidget {
  const TrailerScreen({super.key, required this.vidkey, required this.id});
  final String vidkey;
  final int id;
  @override
  State<TrailerScreen> createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  _TrailerScreenState() {
    _getUser();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mid = widget.id;
    _controller = YoutubePlayerController(
      initialVideoId: widget.vidkey,
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
    _getMovie();
  }

  late YoutubePlayerController _controller;
  String movieName = "";
  String userName = "";
  String overview = "";
  String poster_path = "";
  bool status = false;
  late int mid;
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> _getUser() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid) // Add your condition here
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        print('Name: ${doc['name']},');

        if (mounted) {
          setState(() {
            userName = doc['name'];
          });
        }
      }
    } catch (e) {
      print('Error reading documents: $e');
    }
  }

  Future<String> _getUrl() async {
    var urlMovie = '';
    try {
      var url = Uri.parse(
          "https://api.themoviedb.org/3/movie/${mid}/watch/providers?api_key=d18f91f6a8c7ef5c2014f334336d48f6&language=en-US");
      var response = await http.get(url);
      final body = response.body;
      final data = json.decode(body);
      print(
          '${data['results']['US']['link']}###################################');
      var obj = data['results'];
      String result = obj.toString();
      // var link = data['results']['US']['link'];
      List<String> words = result.split(":");
      String wordlink = words[3];
      List<String> wordsplit = wordlink.split(",");
      List<String> linksplit = wordsplit[0].split("?");

      String movieUrl =
          'https:${linksplit[0]}?api_key=d18f91f6a8c7ef5c2014f334336d48f6&${linksplit[1]}';
      urlMovie = movieUrl;
      // print(movieUrl);
    } catch (e) {}
    return urlMovie;
  }

  Future<void> _getMovie() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/${mid}?api_key=d18f91f6a8c7ef5c2014f334336d48f6&language=en-US");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final body = response.body;
      final data = json.decode(body);
      print(data['overview']);
      if (mounted) {
        setState(() {
          movieName = data['original_title'];
          overview = data['overview'];
          poster_path = data['poster_path'];
          status = true;
        });
      }
    }
    print('${response.statusCode}##################################');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Trailer")),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.8],
            colors: [
              Color.fromRGBO(0, 0, 0, 1),
              Color.fromRGBO(123, 226, 234, 0.2),
            ],
          )),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKnkHmiO0N4mdQR_9SeuyNnU1Jd2CCedHdk7IKmrvU-Q3AKtGcLr5gnT7yRR_RYMjhWEQ&usqp=CAU"),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.amber,
                  progressColors: ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),
                  onReady: () {
                    _controller.addListener(() {});
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Movie Details",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white38),
                    ),
                    Icon(
                      Icons.workspace_premium,
                      color: Colors.cyan,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Card(
                  color: Colors.blueGrey,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () async {
                        var url = await _getUrl();
                        if (url.length == 0) {
                          customSnack(
                              context, Colors.orange, "Network Busy...!");
                        } else {
                          print(url.length);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return MovieDetails(
                              url: url,
                            );
                          }));
                        }
                      },
                      title: Text(
                        movieName,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        overview,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              status
                  ? Card(
                      elevation: 5,
                      child: Container(
                        width: screenWidth * 0.9,
                        child: Image.network(
                          "https://image.tmdb.org/t/p/original/${poster_path}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Text('data')
            ],
          ),
        )),
      ),
    );
  }
}
