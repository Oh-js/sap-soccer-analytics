import csv

# 1. 파일 설정
input_file = 'fc26_player_data.csv'   # 사용자님이 업로드한 파일명
output_file = 'my.soccer-Players.csv' # DB에 들어갈 파일명

try:
    print(f"⏳ '{input_file}' 로딩 중...")
    
    with open(input_file, mode='r', encoding='utf-8') as infile:
        reader = csv.DictReader(infile)
        all_players = list(reader)

    # 2. 정렬 및 필터링 (Top 500)
    # FC 26 데이터는 'overall' 컬럼을 사용합니다. (문자열일 수 있으니 안전하게 변환)
    print("⏳ 능력치(overall) 순으로 정렬 중...")
    all_players.sort(key=lambda x: int(float(x.get('overall', 0) or 0)), reverse=True)

    # 상위 500명 추출
    top_players = all_players[:500]
    
    print(f"📊 전체 {len(all_players)}명 중 상위 {len(top_players)}명을 추출했습니다.")

    # 3. 파일 쓰기
    with open(output_file, mode='w', encoding='utf-8', newline='') as outfile:
        # DB 스키마(db/schema.cds)와 정확히 일치하는 순서
        fieldnames = [
            'ID', 'name', 'team', 'nationality', 'position', 'overall', 'potential', 'value',
            'wage', 'age', 'height', 'weight', 'preferredFoot', 'weakFoot', 'skillMoves', # 추가된 프로필
            'acceleration', 'sprintSpeed', 'agility',
            'finishing', 'shotPower',
            'shortPassing', 'longPassing', 'ballControl', 'dribbling',
            'standingTackle', 'stamina', 'strength'
        ]
        
        writer = csv.DictWriter(outfile, fieldnames=fieldnames)
        writer.writeheader()
        
        count = 0
        for row in top_players:
            # (1) 포지션 처리: "ST, LW" -> "ST"만 가져오기
            raw_pos = row.get('player_positions', '')
            main_pos = raw_pos.split(',')[0].strip()

            # (2) 데이터 매핑 (CSV 컬럼 -> CDS 컬럼)
            writer.writerow({
                'ID': row.get('player_id', 0),            # 이제 URL 파싱 필요 없음!
                'name': row.get('short_name', ''),        # 긴 이름 대신 짧은 이름
                'team': row.get('club_name', ''),
                'nationality': row.get('nationality_name', ''), # 국적 이름
                'position': main_pos,
                'overall': row.get('overall', 0),
                'potential': row.get('potential', 0),
                'value': row.get('value_eur', 0),         # 이미 숫자라 파싱 불필요
                
                # -- 추가된 프로필 --
                'wage': row.get('wage_eur', 0),
                'age': row.get('age', 0),
                'height': row.get('height_cm', 0),
                'weight': row.get('weight_kg', 0),
                'preferredFoot': row.get('preferred_foot', ''),
                'weakFoot': row.get('weak_foot', 0),
                'skillMoves': row.get('skill_moves', 0),

                # -- 세부 스탯 (FC 26 컬럼명 적용) --
                'acceleration': row.get('movement_acceleration', 0),
                'sprintSpeed': row.get('movement_sprint_speed', 0),
                'agility': row.get('movement_agility', 0),
                
                'finishing': row.get('attacking_finishing', 0),
                'shotPower': row.get('power_shot_power', 0),
                
                'shortPassing': row.get('attacking_short_passing', 0),
                'longPassing': row.get('skill_long_passing', 0),
                'ballControl': row.get('skill_ball_control', 0),
                'dribbling': row.get('skill_dribbling', 0),
                
                'standingTackle': row.get('defending_standing_tackle', 0),
                'stamina': row.get('power_stamina', 0),
                'strength': row.get('power_strength', 0)
            })
            count += 1

    print(f"✅ 성공! Top {count}명의 데이터가 '{output_file}'로 저장되었습니다.")

except FileNotFoundError:
    print(f"❌ '{input_file}' 파일을 찾을 수 없습니다. db/data 폴더를 확인하세요.")
except Exception as e:
    print(f"❌ 에러 발생: {e}")