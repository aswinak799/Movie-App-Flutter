import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflix/login.dart';
import 'package:netflix/payment/plans.dart';
import 'package:netflix/search.dart';
import 'package:netflix/theme.dart';
import 'package:http/http.dart' as http;
import 'package:netflix/trailer.dart';

class Fantasy {
  final int id;
  final String image;
  final String movie;
  final String movieposter;

  Fantasy(
      {required this.id,
      required this.image,
      required this.movie,
      required this.movieposter});
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  _HomeScreenState() {
    // _getUser();
    _getData();
  }
  // late Customer _customer;
  bool prime = false;
  List<Fantasy> _fanasy = [];
  List<Fantasy> _fanasy2 = [];
  List<Fantasy> _romantic = [];
  final ValueNotifier<int> poster = ValueNotifier(0);
  String userName = "";

  Future<void> _getData() async {
    List<Fantasy> fanasy = [];
    List<Fantasy> fanasy2 = [];
    List<Fantasy> romantic = [];

    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=d18f91f6a8c7ef5c2014f334336d48f6&with_genres=28');
    var url2 = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=d18f91f6a8c7ef5c2014f334336d48f6&with_genres=14');
    var url3 = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=d18f91f6a8c7ef5c2014f334336d48f6&with_genres=35');
// 10749
    var response = await http.get(url);
    var response2 = await http.get(url2);
    var response3 = await http.get(url3);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final body = response.body;
      final data = json.decode(body);
      // print(data);

      for (var value in data['results']) {
        fanasy.add(Fantasy(
            id: value['id'],
            image: value['backdrop_path'],
            movie: value['original_title'],
            movieposter: value['poster_path']));
        print(value);
      }

      // Handle the data here
    } else {
      print("=======##################===============");
    }
    if (response2.statusCode == 200) {
      final body2 = response2.body;
      final data2 = json.decode(body2);
      // print(data);

      for (var val2 in data2['results']) {
        fanasy2.add(Fantasy(
            id: val2['id'],
            image: val2['backdrop_path'],
            movie: val2['original_title'],
            movieposter: val2['poster_path']));
        print('${val2}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      }
    }
    if (response3.statusCode == 200) {
      final body3 = response3.body;
      final data3 = json.decode(body3);
      // print(data);

      for (var val in data3['results']) {
        romantic.add(Fantasy(
            id: val['id'],
            image: val['backdrop_path'],
            movie: val['original_title'],
            movieposter: val['poster_path']));
        print(val);
      }
    }
    if (mounted) {
      setState(() {
        _fanasy = fanasy;
        _fanasy2 = fanasy2;
        _romantic = romantic;
      });
    }
  }

  Future<void> _getUser() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid) // Add your condition here
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (mounted) {
          setState(() {
            prime = doc['prime'];
            // _customer = Customer(name: doc['name'], prime: doc['name']);
          });
        }
      }
    } catch (e) {
      print('Error reading documents: $e');
    }
  }

  Future<String> _youtubeKey(int id) async {
    String videoKey;
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/${id}/videos?api_key=d18f91f6a8c7ef5c2014f334336d48f6&language=en-US");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final body = response.body;
      final data = json.decode(body);

      var video = data['results'][0];

      videoKey = video['key'];

      return videoKey;
    }

    return 'UJZx8MayWxk';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await _getUser();
                  if (prime) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return SearchMoview();
                    }));
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return PrimeMember();
                    }));
                  }
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (ctx) {
                    return LoginScreen();
                  }));
                },
                icon: Icon(Icons.logout))
          ],
          title: Text("A K MOVIES"),
        ),
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
                Color.fromRGBO(72, 240, 210, 0.4),
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
                        "${user?.displayName}",
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
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    color: Colors.blueGrey[200],
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        "${user?.displayName}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKnkHmiO0N4mdQR_9SeuyNnU1Jd2CCedHdk7IKmrvU-Q3AKtGcLr5gnT7yRR_RYMjhWEQ&usqp=CAU"),
                      ),
                      subtitle: Text(
                        '${user!.email}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      trailing: Icon(Icons.person),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 27),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "RECOMENDED MOVIES",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white60),
                      ),
                      Icon(
                        Icons.movie,
                        color: Colors.white30,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: screenHeight * 0.297,
                  width: screenWidth,
                  // color: Colors.amber,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          // color: Colors.blue[50],
                          width: 350,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () async {
                                  String vidKey =
                                      await _youtubeKey(_fanasy[index].id);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return TrailerScreen(
                                          vidkey: vidKey,
                                          id: _fanasy[index].id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                title: Image.network(
                                    "https://image.tmdb.org/t/p/original/${_fanasy[index].image}"),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                  onPressed: () async {
                                    String vidKey =
                                        await _youtubeKey(_fanasy[index].id);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) {
                                          return TrailerScreen(
                                            vidkey: vidKey,
                                            id: _fanasy[index].id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${_fanasy[index].movie}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                      itemCount: _fanasy.length),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "FANTASY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.movie,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: screenHeight * 0.297,
                  width: screenWidth,
                  // color: Colors.amber,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          // color: Colors.blue[50],
                          width: 350,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () async {
                                  String vidkey =
                                      await _youtubeKey(_fanasy2[index].id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return TrailerScreen(
                                          vidkey: vidkey,
                                          id: _fanasy2[index].id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                title: Image.network(
                                    "https://image.tmdb.org/t/p/original/${_fanasy2[index].image}"),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                  onPressed: () async {
                                    String vidkey =
                                        await _youtubeKey(_fanasy2[index].id);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) {
                                          return TrailerScreen(
                                            vidkey: vidkey,
                                            id: _fanasy2[index].id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${_fanasy2[index].movie}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                      itemCount: _fanasy2.length),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ROMANTIC",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.movie,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: screenHeight * 0.297,
                  width: screenWidth,
                  // color: Colors.amber,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          // color: Colors.blue[50],
                          width: 350,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () async {
                                  String vidkey =
                                      await _youtubeKey(_romantic[index].id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return TrailerScreen(
                                          vidkey: vidkey,
                                          id: _romantic[index].id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                title: Image.network(
                                    "https://image.tmdb.org/t/p/original/${_romantic[index].image}"),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                  onPressed: () async {
                                    String vidkey =
                                        await _youtubeKey(_romantic[index].id);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) {
                                          return TrailerScreen(
                                            vidkey: vidkey,
                                            id: _romantic[index].id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${_romantic[index].movie}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                      itemCount: _romantic.length),
                )
              ],
            ),
          )),
        ));
  }
}
