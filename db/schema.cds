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

    // --- Defending & Physical  ---
    standingTackle : Integer;  
    stamina : Integer;         
    strength : Integer;     
}