using my.soccer from '../db/schema';

service AnalyticsService {
   
    entity Players as projection on soccer.Players actions{
        action signPlayer(teamName: String) returns Players;
    };

     @readonly entity Strikers as projection on soccer.Strikers;

}