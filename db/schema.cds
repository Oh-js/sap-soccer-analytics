namespace my.soccer;

entity Players {
      key ID : Integer;
    name : String;
    team : String;
    nationality : String;
    position : String;
    overall : Integer;
    potential : Integer;
    value : Integer;
    
    // --- 💰 Financial (새로 추가) ---
    wage : Integer;            // 주급 (wage_eur)

    // --- 🧬 Physical & Profile (새로 추가) ---
    age : Integer;             // 나이
    height : Integer;          // 키 (cm)
    weight : Integer;          // 몸무게 (kg)
    preferredFoot : String;    // 주발 (Left/Right)
    weakFoot : Integer;        // 약발 (1-5)
    skillMoves : Integer;      // 개인기 (1-5)

    // --- 🏃 Movement ---
    acceleration : Integer;
    sprintSpeed : Integer;
    agility : Integer;

    // --- ⚽ Shooting ---
    finishing : Integer;
    shotPower : Integer;

    // --- 🎯 Passing & Dribbling ---
    shortPassing : Integer;
    longPassing : Integer;
    ballControl : Integer;
    dribbling : Integer;

    // --- 🛡️ Defending & Physical ---
    standingTackle : Integer;
    stamina : Integer;
    strength : Integer;

    // --- 🧤 Goalkeeping  ---
    gkDiving : Integer;
    gkHandling : Integer;
    gkReflexes : Integer;
}

// 1. 공격수 전용 뷰 (ST, CF 포지션만 모아보기)
entity Strikers as select from Players {
    
    key ID,
    name,
    team,
    finishing, 
    shotPower,
    sprintSpeed,
    potential,
    value,
    agility,
    strength

} where position in ('ST', 'CF');