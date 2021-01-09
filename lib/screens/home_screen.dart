import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sport/models/league_model.dart';
import 'package:http/http.dart' as http;
import 'package:sport/screens/favorite_screen.dart';
import 'package:sport/widgets/team_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  int selectedIndex = 0;
  String idLeague = "4328";

  Future<List<LeagueModel>> getLeague() async {
    var url = "https://www.thesportsdb.com/api/v1/json/1/all_leagues.php";
    var data = await http.get(url);

    var jsonData = jsonDecode(data.body)['leagues'] as List;
    final List<LeagueModel> leagues = [];

    for (var t in jsonData) {
      if (t['strSport'] == 'Soccer') {
        LeagueModel league = LeagueModel(
          idLeague: t['idLeague'],
          strLeague: t['strLeague'],
          strSport: t['strSport'],
        );
        leagues.add(league);
      }
    }

    return leagues;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Football Apps",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.star),
                      iconSize: 25,
                      color: Colors.white,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => FavoriteScreen(),
                          ),
                        ),
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40.0,
                                child: FutureBuilder(
                                  future: getLeague(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.data == null) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 150,
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Loading...",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                                idLeague = snapshot
                                                    .data[index].idLeague;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Container(
                                                width: 200,
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: selectedIndex == index
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      snapshot.data[index]
                                                          .strLeague,
                                                      style: TextStyle(
                                                        color: selectedIndex ==
                                                                index
                                                            ? Theme.of(context)
                                                                .accentColor
                                                            : Colors.black45,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        TeamList(idLeague),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //   ),
      //   child: Container(
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(20),
      //           topRight: Radius.circular(20),
      //         ),
      //         color: Colors.white,
      //         boxShadow: [
      //           BoxShadow(
      //             blurRadius: 5,
      //             color: Colors.black,
      //           )
      //         ]),
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(20),
      //         topRight: Radius.circular(20),
      //       ),
      //       child: BottomNavigationBar(
      //         backgroundColor: Colors.white,
      //         currentIndex: currentTab,
      //         onTap: (int value) {
      //           setState(() {
      //             currentTab = value;
      //           });
      //         },
      //         items: [
      //           BottomNavigationBarItem(
      //               icon: Icon(
      //                 FontAwesomeIcons.home,
      //                 size: 22.0,
      //               ),
      //               title: SizedBox.shrink()
      //               // title: Text("Home",
      //               //   style: TextStyle(
      //               //     fontSize: 18.0,
      //               //     fontWeight: FontWeight.w500,
      //               //   ),
      //               // ),
      //               ),
      //           BottomNavigationBarItem(
      //             icon: Icon(
      //               FontAwesomeIcons.star,
      //               size: 22.0,
      //             ),
      //             title: SizedBox.shrink(),
      //           ),
      //           // BottomNavigationBarItem(
      //           //   icon: CircleAvatar(
      //           //     radius: 13.0,
      //           //     backgroundImage: NetworkImage('http://i.imgur.com/zL4Krbz.jpg'),
      //           //   ),
      //           //   title: SizedBox.shrink(),
      //           // ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
