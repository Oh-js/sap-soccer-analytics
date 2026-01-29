using my.soccer from '../db/schema';

service AnalyticsService {
    
    // 1. Edit 버튼 활성화 (Draft 모드)
    @odata.draft.enabled
    @cds.redirection.target
    entity Players as projection on soccer.Players actions {
        // 2. 선수 영입 버튼 정의
        action signPlayer(teamName: String) returns Players;
    };


    //2. 팀 목록
    @readonly entity Teams as projection on soccer.Teams;
    // 3. 공격수 뷰 
    @readonly entity Strikers as projection on soccer.Strikers;

    //4. TeamStats
    @readonly entity TeamStats as projection on soccer.TeamStats;
}

// ---------------------------------------------------------
// 👇 화면(UI) 설정 & 검색 설정 
// ---------------------------------------------------------

annotate AnalyticsService.Players with @(
    // A. 화면 상단 타이틀
    UI.HeaderInfo: {
        TypeName: 'Player',
        TypeNamePlural: 'Players',
        Title: { Value: name }, 
        Description: { Value: team }
    },

    // B. 검색창(Filter) 설정
    UI.SelectionFields: [
        name,
        team,
        position
    ],

    // C. 목록 테이블(List) 컬럼 + 버튼 추가!
    UI.LineItem: [
        { Value: name, Label: '이름' },
        { Value: team, Label: '소속팀' },
        { Value: position, Label: '포지션' },
        { Value: age, Label: '나이' },
        { Value: transferFee, Label: '이적료' }, // transferFee가 안 나오면 value로 변경
        // 👇 목록에 '선수 영입' 버튼 추가
        { $Type: 'UI.DataFieldForAction', Action: 'AnalyticsService.signPlayer', Label: '선수 영입' }
    ],

    // D. 상세 페이지 상단 버튼 추가! (여기가 중요)
    UI.Identification: [
        { $Type: 'UI.DataFieldForAction', Action: 'AnalyticsService.signPlayer', Label: '선수 영입 (Sign)' }
    ],

    // E. 상세 페이지 그룹 설정
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: '선수 상세 정보',
            Target: '@UI.FieldGroup#Main'
        }
    ],

    // F. 상세 페이지 내부 (모든 정보 표시)
    UI.FieldGroup#Main: {
        Data: [
            { Value: name, Label: '이름' },
            { Value: team, Label: '소속팀' },
            { Value: position, Label: '포지션' },
            { Value: age, Label: '나이' },
            { Value: transferFee, Label: '이적료' },
            { Value: wage, Label: '주급' },
            { Value: overall, Label: '종합 능력치' },
            { Value: potential, Label: '잠재력' }
        ]
    }
);

// G. 부분 검색 허용 설정 (Kan -> Kane 검색 가능)
annotate AnalyticsService.Players with {
    name      @Search.defaultSearchElement : true
              @Search.fuzzinessThreshold : 0.8; 
    team      @Search.defaultSearchElement : true;
    position  @Search.defaultSearchElement : true;
};