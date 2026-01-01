namespace my.soccer;

entity Players {
    key ID : Integer;          
    name : String;            
    team : String;            
    nationality : String;   
    position : String;        
    overall : Integer;        
    potential : Integer;      
    value : Double;            // 이적료 가치 (Euro)
    
    // 상세 스탯 (육각형 스탯)
    pace : Integer;           
    shooting : Integer;      
    passing : Integer;        
    dribbling : Integer;      
    defending : Integer;    
    physical : Integer;        
}