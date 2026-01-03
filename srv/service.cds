using my.soccer from '../db/schema';

service AnalyticsService {
    @readonly entity Players as projection on soccer.Players;
    @readonly entity Strikers as projection on soccer.Strikers;
}