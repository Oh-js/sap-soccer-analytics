namespace my.soccer;

//축구 선수 엔티티 (테이블)
entity Players {
    key Id  : UUID;
    firstName : String;
    lastName :String;
    team : String;
    position : String;
    shirtNumber : Integer;
    
}


