class TeamLeague {
  String idTeam;
  String strTeamBadge;
  String strTeam;
  String intFormedYear;
  String strStadium;
  String strDescriptionEN;
  String strStadiumThumb;

  TeamLeague({this.idTeam, this.strTeamBadge, this.strTeam, this.intFormedYear,
      this.strStadium, this.strDescriptionEN, this.strStadiumThumb});

  Map<String, dynamic> toMap() {
    return {
      'idTeam': idTeam,
      'strTeamBadge': strTeamBadge,
      'strTeam': strTeam,
      'intFormedYear': intFormedYear,
      'strStadium': strStadium,
      'strDescriptionEN': strDescriptionEN,
      'strStadiumThumb': strStadiumThumb
    };
  }
}