import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sport/screens/detail_team.dart';
import '../models/team_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TeamList extends StatelessWidget {
  final String idLeague;
  TeamList(this.idLeague);

  Future<List<TeamLeague>> getTeam() async {
    var url =
        "https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id=$idLeague";
    var data = await http.get(url);

    var jsonData = jsonDecode(data.body)['teams'] as List;
    final List<TeamLeague> teams = [];

    for (var t in jsonData) {
      TeamLeague team = TeamLeague(
        idTeam: t['idTeam'],
        strTeamBadge: t["strTeamBadge"],
        strTeam: t["strTeam"],
        intFormedYear: t["intFormedYear"],
        strStadium: t["strStadium"],
        strDescriptionEN: t["strDescriptionEN"],
        strStadiumThumb: t['strStadiumThumb'],
      );
      teams.add(team);
    }

    return teams;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Team List",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: 550,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: FutureBuilder(
            future: getTeam(),
            builder: (BuildContext context, AsyncSnapshot snapshoot) {
              if (snapshoot.data == null) {
                return Container(
                  child: Center(
                    child: LinearProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshoot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          new MaterialPageRoute(
                            builder: (context) => DetailTeam(snapshoot.data[index]),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(6.0),
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 2.0,
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: ExcludeSemantics(
                            child: CircleAvatar(
                              child: Image.network(
                                snapshoot.data[index].strTeamBadge
                              ),
                            ),
                          ),
                          title: Text(
                            snapshoot.data[index].strTeam,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(snapshoot.data[index].strStadium),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
