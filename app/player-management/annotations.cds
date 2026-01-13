using AnalyticsService as service from '../../srv/service';

annotate service.Players with @(
    // 1. 화면 상단 타이틀 (선수 이름과 소속팀 표시)
    UI.HeaderInfo : {
        TypeName : '선수',
        TypeNamePlural : '선수 목록',
        Title : { Value : name },
        Description : { Value : team }
    },

    // 2. 검색창 필터 (이름, 팀, 포지션으로 검색)
    UI.SelectionFields : [
        name,
        team,
        position
    ],

    // 3. 목록 테이블 (주요 정보 5개만 깔끔하게)
    UI.LineItem : [
        { $Type : 'UI.DataField', Label : '이름', Value : name },
        { $Type : 'UI.DataField', Label : '소속팀', Value : team },
        { $Type : 'UI.DataField', Label : '포지션', Value : position },
        { $Type : 'UI.DataField', Label : '나이', Value : age },
        { $Type : 'UI.DataField', Label : '이적료', Value : value } 
    ],

    // 4. 상세 페이지 그룹 설정
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '모든 선수 정보',
            Target : '@UI.FieldGroup#AllDetails'
        }
    ],

    // 5. 상세 페이지 내부 (여기에 모든 필드를 다 넣었습니다!)
    UI.FieldGroup #AllDetails : {
        Data : [
            // --- 기본 정보 ---
            { $Type : 'UI.DataField', Label : '이름', Value : name },
            { $Type : 'UI.DataField', Label : '소속팀', Value : team },
            { $Type : 'UI.DataField', Label : '국적', Value : nationality },
            { $Type : 'UI.DataField', Label : '포지션', Value : position },
            { $Type : 'UI.DataField', Label : '나이', Value : age },
            { $Type : 'UI.DataField', Label : '키 (cm)', Value : height },
            { $Type : 'UI.DataField', Label : '몸무게 (kg)', Value : weight },
            
            // --- 계약 정보 ---
            { $Type : 'UI.DataField', Label : '이적료 (Value)', Value : value },
            { $Type : 'UI.DataField', Label : '주급 (Wage)', Value : wage },

            // --- 주요 능력치 ---
            { $Type : 'UI.DataField', Label : '종합 능력치', Value : overall },
            { $Type : 'UI.DataField', Label : '잠재력', Value : potential },
            { $Type : 'UI.DataField', Label : '주발', Value : preferredFoot },
            { $Type : 'UI.DataField', Label : '약발', Value : weakFoot },
            { $Type : 'UI.DataField', Label : '개인기', Value : skillMoves },

            // --- 세부 능력치 (공격/미드필더) ---
            { $Type : 'UI.DataField', Label : '가속력', Value : acceleration },
            { $Type : 'UI.DataField', Label : '속력', Value : sprintSpeed },
            { $Type : 'UI.DataField', Label : '민첩성', Value : agility },
            { $Type : 'UI.DataField', Label : '골 결정력', Value : finishing },
            { $Type : 'UI.DataField', Label : '슛 파워', Value : shotPower },
            { $Type : 'UI.DataField', Label : '짧은 패스', Value : shortPassing },
            { $Type : 'UI.DataField', Label : '긴 패스', Value : longPassing },
            { $Type : 'UI.DataField', Label : '볼 컨트롤', Value : ballControl },
            { $Type : 'UI.DataField', Label : '드리블', Value : dribbling },

            // --- 세부 능력치 (수비/피지컬) ---
            { $Type : 'UI.DataField', Label : '스탠딩 태클', Value : standingTackle },
            { $Type : 'UI.DataField', Label : '스태미너', Value : stamina },
            { $Type : 'UI.DataField', Label : '몸싸움', Value : strength },

            // --- 골키퍼 능력치 ---
            { $Type : 'UI.DataField', Label : 'GK 다이빙', Value : gkDiving },
            { $Type : 'UI.DataField', Label : 'GK 핸들링', Value : gkHandling },
            { $Type : 'UI.DataField', Label : 'GK 반사신경', Value : gkReflexes }
        ]
    }
);