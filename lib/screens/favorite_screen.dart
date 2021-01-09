import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sport/models/team_model.dart';
import 'package:sport/screens/detail_team.dart';
import 'package:sport/screens/home_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../screens/detail_team.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweetalert/sweetalert.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var database;

  List<TeamLeague> teams = List<TeamLeague>();

  Future initDb() async{
    database = openDatabase(
    join(await getDatabasesPath(), 'favorite.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE teams(idTeam TEXT PRIMARY KEY, strTeamBadge TEXT, strTeam TEXT, strStadium TEXT, strDescriptionEN TEXT, strStadiumThumb TEXT, intFormedYear TEXT)",
      );
    },
    version: 1,
    );

    getTeams().then((value){
      setState(() {
        teams = value;
      });
    });
  }


  Future<List<TeamLeague>> getTeams() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('teams');

    return List.generate(maps.length, (i) {
      return TeamLeague(
        idTeam : maps[i]['idTeam'],
        strTeamBadge : maps[i]['strTeamBadge'],
        strTeam : maps[i]['strTeam'],
        intFormedYear : maps[i]['intFormedYear'],
        strStadium : maps[i]['strStadium'],
        strDescriptionEN : maps[i]['strDescriptionEN'],
        strStadiumThumb: maps[i]['strStadiumThumb'],
      );
    });

    //prin
  }

  Future<void> deleteTeams(String idTeam) async {
    final db = await database;
    await db.delete(
      'teams',
      where: 'idTeam=?',
      whereArgs: [idTeam],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Favorite Teams",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.home),
                    iconSize: 26,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: teams.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => DetailTeam(teams[index]),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(6),
                            height: 70,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 2)
                                ]),
                            child: ListTile(
                              leading: Image.network(teams[index].strTeamBadge),
                              title: Text(
                                teams[index].strTeam,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(teams[index].strStadium),
                              trailing: IconButton(
                                icon: Icon(FontAwesomeIcons.trashAlt),
                                color: Colors.grey,
                                iconSize: 22.0,
                                onPressed: () {
                                  SweetAlert.show(context,
                                    title: "Apakah yakin menghapus?",
                                    cancelButtonText: "Tidak",
                                    confirmButtonText: "Iya, Yakin",
                                    showCancelButton: true,
                                    style: SweetAlertStyle.confirm,
                                    onPress: (isConfirm){
                                      if(isConfirm){
                                        deleteTeams(teams[index].idTeam).then((value){
                                          getTeams().then((value){
                                            setState(() {
                                              teams = value;
                                            });
                                          });
                                        });
                                        SweetAlert.show(
                                            context,
                                            title: "Deleted Successfully!",
                                            style: SweetAlertStyle.success,
                                        );
                                        return false;
                                      }
                                    }
                                  );
                                  // deleteTeams(teams[index].idTeam).then((value){
                                  //   getTeams().then((value){
                                  //     setState(() {
                                  //       teams = value;
                                  //     });
                                  //   });
                                  // });
                                  // Scaffold.of(context).showSnackBar(SnackBar(
                                  //   content: Text("Remove from Favorite"),
                                  // ));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
