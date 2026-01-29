namespace my.soccer;

// 1. 구단 (Teams) 
entity Teams {
    key code : String(3);   // 예: TOT, MCI (PK)
    name : String;          // 예: Tottenham Hotspur
    league : String;        // 예: Premier League
    
    // 역방향 연결: "이 팀을 클릭하면 소속 선수들을 보여줘"
    players : Association to many Players on players.team = $self;
}

// 2. 선수 (Players)
entity Players {
    key ID : Integer;
    name : String;
    
    // 핵심 변경: String -> Association (글자가 아니라 '연결'됨)
    team : Association to Teams;
    
    nationality : String;
    position : String;
    overall : Integer;
    potential : Integer;
    value : Integer;
    
    // --- Financial ---
    wage : Integer;

    // --- Physical & Profile ---
    age : Integer;
    height : Integer;
    weight : Integer;
    preferredFoot : String;
    weakFoot : Integer;
    skillMoves : Integer;

    // --- Movement ---
    acceleration : Integer;
    sprintSpeed : Integer;
    agility : Integer;

    // --- Shooting ---
    finishing : Integer;
    shotPower : Integer;

    // --- Passing & Dribbling ---
    shortPassing : Integer;
    longPassing : Integer;
    ballControl : Integer;
    dribbling : Integer;

    // --- Defending & Physical ---
    standingTackle : Integer;
    stamina : Integer;
    strength : Integer;

    // --- Goalkeeping ---
    gkDiving : Integer;
    gkHandling : Integer;
    gkReflexes : Integer;
}

// 3. 공격수 전용 뷰 
entity Strikers as select from Players {
    key ID,
    name,
    team, // 이제 이 team은 연결고리(Association) 역할을 합니다.
    finishing, 
    shotPower,
    sprintSpeed,
    potential,
    value,
    agility,
    strength
} where position in ('ST', 'CF');

entity TeamStats as select from Players{
    key team.code as teamCode,
    team.name as teamName,

    count(ID) as playerCount : Integer,
    round(avg(age), 1) as avgAge : Decimal(10,1),
    sum(value) as totalValue : Integer,
    round(avg(overall), 1) as avgOverall : Decimal(10,1)

} group by team.code, team.name;