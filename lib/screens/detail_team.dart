import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sport/models/team_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sweetalert/sweetalert.dart';

class DetailTeam extends StatefulWidget {
  final TeamLeague team;
  DetailTeam(this.team);

  @override
  _DetailTeamState createState() => _DetailTeamState();
}

class _DetailTeamState extends State<DetailTeam> {
  var database;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDb();
  }

  Future initDb() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'favorite.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE teams(idTeam TEXT PRIMARY KEY, strTeamBadge TEXT, strTeam TEXT, strStadium TEXT, strDescriptionEN TEXT, strStadiumThumb TEXT, intFormedYear TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertTeam(TeamLeague teamLeague) async {
    final Database db = await database;
    await db.insert(
      "teams",
      teamLeague.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 4.0),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(100.0),
                      ),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 25,
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.star_half),
                              iconSize: 25.0,
                              color: Colors.white,
                              onPressed: () => {
                                insertTeam(widget.team),
                                SweetAlert.show(
                                  context,
                                  title: "Added to Favorite !",
                                  style: SweetAlertStyle.success,
                                ),
                                // Scaffold.of(context).showSnackBar(SnackBar(
                                //   content: Text("Added to Favorite"),
                                // )),
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 55,
                    child: Container(
                      height: 250,
                      width: 250,
                      child:
                          Image(image: NetworkImage(widget.team.strTeamBadge)),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.team.strTeam,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.mapMarked,
                              size: 15,
                              color: Colors.white70,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.team.strStadium,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 25.0),
                            child: Container(
                              width: 160.0,
                              height: 35.0,
                              margin: EdgeInsets.only(top: 0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Team Overview',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Image.network(widget.team.strStadiumThumb != null ? widget.team.strStadiumThumb : ''),
                          ),
                          Text(
                            widget.team.strDescriptionEN,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
