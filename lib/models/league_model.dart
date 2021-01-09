class LeagueModel {
  String idLeague;
  String strLeague;
  String strSport;

  LeagueModel({this.idLeague, this.strLeague, this.strSport});

  Map<String, dynamic> toMap(){
    return{
      'idLeague':idLeague,
      'strLeague':strLeague,
      'strSport':strSport
    };
  }
}