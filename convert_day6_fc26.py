import csv
import pandas as pd
import os

# 1. 파일 설정
input_file = 'db/csv/fc26_player_data.csv' 
output_players = 'db/csv/my.soccer-Players.csv'
output_teams = 'db/csv/my.soccer-Teams.csv'

TARGET_COUNT = 800

# 🏆 [핵심] 실제 축구 중계용 약어 족보 (이름 -> 코드)
# 여기에 없는 팀은 자동으로 앞 3글자를 땁니다.
TEAM_ABBREVIATIONS = {
    # Premier League
    "Manchester City": "MCI",
    "Manchester United": "MUN",
    "Tottenham Hotspur": "TOT",
    "Arsenal": "ARS",
    "Liverpool": "LIV",
    "Chelsea": "CHE",
    "Newcastle United": "NEW",
    "West Ham United": "WHU",
    "Aston Villa": "AVL",
    "Brighton & Hove Albion": "BHA",
    "Wolverhampton Wanderers": "WOL",
    
    # La Liga
    "Real Madrid": "RMA",
    "FC Barcelona": "BAR",
    "Atlético de Madrid": "ATM",
    
    # Bundesliga
    "FC Bayern München": "BAY",
    "Bayern Munich": "BAY",
    "Borussia Dortmund": "BVB",
    "Bayer 04 Leverkusen": "B04",
    
    # Serie A
    "Juventus": "JUV",
    "AC Milan": "ACM",
    "Inter": "INT",
    "Inter Milan": "INT",
    "Napoli": "NAP",
    
    # Ligue 1
    "Paris Saint-Germain": "PSG"
}

try:
    print(f"⏳ '{input_file}' 로딩 중...")
    df = pd.read_csv(input_file)
    
    print(f"⏳ 능력치(overall) 순으로 상위 {TARGET_COUNT}명 추출 중...")
    df = df.sort_values(by='overall', ascending=False).head(TARGET_COUNT)
    
    # ---------------------------------------------------------
    # [작업 A] 팀(Teams) 데이터 만들기
    # ---------------------------------------------------------
    print("⏳ 팀(Teams) 데이터 분리 및 코드 매핑 중...")
    
    unique_teams = df['club_name'].unique()
    teams_data = []
    team_map = {} 
    used_codes = set()

    for team_name in unique_teams:
        if pd.isna(team_name): continue
        
        # 1. 족보에 있는지 먼저 확인!
        if team_name in TEAM_ABBREVIATIONS:
            code = TEAM_ABBREVIATIONS[team_name]
        else:
            # 2. 족보에 없으면 자동 생성 (앞 3글자 + 대문자)
            # 예: "Crystal Palace" -> "CRY"
            safe_name = str(team_name).replace(" ", "").upper()
            code = safe_name[:3]

        # 3. 코드 중복 방지 (만약 CRY가 있는데 또 CRY가 나오면 CRY2)
        original_code = code
        counter = 2
        while code in used_codes:
            code = f"{original_code[:2]}{counter}" # 뒤에 숫자 붙임
            counter += 1
        
        used_codes.add(code)
        team_map[team_name] = code # 선수 데이터 만들 때 쓰려고 저장
        
        # 리그 정보 (없으면 Unknown)
        league = df[df['club_name'] == team_name]['league_name'].iloc[0] if 'league_name' in df.columns else 'Unknown'

        teams_data.append({
            'code': code,
            'name': team_name,
            'league': league
        })

    # Teams CSV 저장
    df_teams = pd.DataFrame(teams_data)
    df_teams.to_csv(output_teams, index=False, sep=';')
    print(f"✅ Teams 파일 생성 완료: {len(df_teams)}개 구단 (MCI, MUN 적용됨)")

    # ---------------------------------------------------------
    # [작업 B] 선수(Players) 데이터 만들기
    # ---------------------------------------------------------
    print("⏳ 선수(Players) 데이터 변환 중...")
    
    players_data = []
    
    for index, row in df.iterrows():
        t_name = row.get('club_name')
        if t_name not in team_map: continue

        # 포지션 정리
        raw_pos = str(row.get('player_positions', ''))
        main_pos = raw_pos.split(',')[0].strip()

        players_data.append({
            'ID': row.get('player_id'),
            'name': row.get('short_name'),
            'team_code': team_map[t_name], # 매핑된 코드 (MCI, MUN 등) 들어감
            'nationality': row.get('nationality_name'),
            'position': main_pos,
            'overall': row.get('overall'),
            'potential': row.get('potential'),
            'value': row.get('value_eur'),
            'wage': row.get('wage_eur'),
            'age': row.get('age'),
            'height': row.get('height_cm'),
            'weight': row.get('weight_kg'),
            'preferredFoot': row.get('preferred_foot'),
            'weakFoot': row.get('weak_foot'),
            'skillMoves': row.get('skill_moves'),
            'acceleration': row.get('movement_acceleration'),
            'sprintSpeed': row.get('movement_sprint_speed'),
            'agility': row.get('movement_agility'),
            'finishing': row.get('attacking_finishing'),
            'shotPower': row.get('power_shot_power'),
            'shortPassing': row.get('attacking_short_passing'),
            'longPassing': row.get('skill_long_passing'),
            'ballControl': row.get('skill_ball_control'),
            'dribbling': row.get('skill_dribbling'),
            'standingTackle': row.get('defending_standing_tackle'),
            'stamina': row.get('power_stamina'),
            'strength': row.get('power_strength'),
            'gkDiving': row.get('goalkeeping_diving'),
            'gkHandling': row.get('goalkeeping_handling'),
            'gkReflexes': row.get('goalkeeping_reflexes')
        })

    df_players = pd.DataFrame(players_data)
    df_players.to_csv(output_players, index=False, sep=';')
    print(f"✅ Players 파일 생성 완료: {len(df_players)}명 선수")

except Exception as e:
    print(f"❌ 에러 발생: {e}")