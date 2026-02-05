using AnalyticsService as service from '../../srv/service';

// ---------------------------------------------------------
// 🔍 1. 돋보기(Value Help) 설정
// ---------------------------------------------------------
annotate service.Players with {
    // team 필드를 눌렀을 때 Teams 테이블을 참조해라!
    team @(
        Common : {
            Text : team.name,  // 화면에는 팀 이름(Tottenham...)을 보여줘
            TextArrangement : #TextOnly,
            ValueList : {
                Label : 'Select Team',
                CollectionPath : 'Teams', // 참조할 테이블 이름
                Parameters : [
                    { $Type : 'Common.ValueListParameterInOut', LocalDataProperty : team_code, ValueListProperty : 'code' },
                    { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'name' },
                    { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'league' }
                ]
            }
        }
    );
};

// ---------------------------------------------------------
// 🎨 2. 화면 레이아웃 설정
// ---------------------------------------------------------
annotate service.Players with @(
    UI.HeaderInfo: {
        TypeName: 'Player',
        TypeNamePlural: 'Players',
        Title: { Value: name }, 
        Description: { Value: team.name } // 코드가 아니라 팀 이름을 보여줌
    },

    UI.SelectionFields: [ name, team_code, position ], // team -> team_code로 변경

    UI.LineItem: [
        { Value: name, Label: '이름' },
        { Value: team_code, Label: '팀' }, // 돋보기 달린 필드
        { Value: position, Label: '포지션' },
        { Value: age, Label: '나이' },
        { Value: value, Label: '이적료' }, // transferFee -> value (DB컬럼명)
        { $Type: 'UI.DataFieldForAction', Action: 'AnalyticsService.signPlayer', Label: '선수 영입' }
    ],

    UI.FieldGroup#Main: {
        Data: [
            { Value: name, Label: '이름' },
            { Value: team_code, Label: '소속팀' }, // 돋보기 자동 적용
            { Value: position, Label: '포지션' },
            { Value: age, Label: '나이' },
            { Value: value, Label: '시장가치(Value)' },
            { Value: wage, Label: '주급' },
            { Value: overall, Label: '종합 능력치' },
            { Value: potential, Label: '잠재력' }
        ]
    }

    
    
);
// 1. 목록에 표시할 컬럼 설정
annotate service.TeamStats with @(
    // 1. [추가] 상단 검색창 만들기 (Filter Bar)
    UI.SelectionFields: [
        teamName  // '팀 이름'으로 검색
    ],

    UI.LineItem: [
        { Value: teamName, Label: '팀 이름', @UI.Importance: #High },
        { Value: playerCount, Label: '선수 규모(명)' },
        { Value: totalValue, Label: '구단 가치 총액 (€)' },
        
        // 2. 색상 입히기 (Criticality)
        { 
            Value: avgOverall, 
            Label: '평균 전력',
            Criticality: #Positive,        // 무조건 '긍정적(초록색)'으로 표시
            CriticalityRepresentation: #WithoutIcon // 아이콘 없이 색깔만 텍스트에 입힘
        },
        
        { Value: avgAge, Label: '평균 연령' }
    ],
    
    UI.HeaderInfo: {
        TypeName: 'Team Stat',
        TypeNamePlural: 'Team Stats',
        Title: { Value: teamName },
        Description: { Value: teamCode }
    }
);