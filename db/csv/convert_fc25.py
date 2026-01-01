import csv

# 1. 파일 설정
input_file = 'raw_fc25.csv'
output_file = 'my.soccer-Players.csv'

# 2. 화폐 단위 변환 함수 (그대로 유지)
def parse_value(value_str):
    if not value_str: return 0
    clean_str = value_str.replace('€', '').replace(',', '')
    multiplier = 1
    if 'M' in clean_str:
        multiplier = 1_000_000
        clean_str = clean_str.replace('M', '')
    elif 'K' in clean_str:
        multiplier = 1_000
        clean_str = clean_str.replace('K', '')
    try:
        return int(float(clean_str) * multiplier)
    except:
        return 0

# 3. ID 추출 함수 (그대로 유지)
def extract_id_from_image(url):
    try:
        parts = url.split('/')
        p1 = parts[-3]
        p2 = parts[-2]
        return int(p1 + p2)
    except:
        return 0

try:
    with open(input_file, mode='r', encoding='utf-8') as infile, \
         open(output_file, mode='w', encoding='utf-8', newline='') as outfile:
        
        reader = csv.DictReader(infile)
        
        # 수정된 Schema에 맞춘 헤더
        fieldnames = [
            'ID', 'name', 'team', 'nationality', 'position', 'overall', 'potential', 'value',
            'acceleration', 'sprintSpeed', 'agility',         # Movement
            'finishing', 'shotPower',                         # Shooting
            'shortPassing', 'longPassing', 'ballControl', 'dribbling', # Skill
            'standingTackle', 'stamina', 'strength'           # Defending/Physical
        ]
        
        writer = csv.DictWriter(outfile, fieldnames=fieldnames)
        writer.writeheader()
        
        count = 0
        for row in reader:
            # (1) ID 생성
            p_id = extract_id_from_image(row.get('image', ''))
            if p_id == 0: continue

            # (2) Value 변환
            p_value = parse_value(row.get('value', '0'))

            # (3) 데이터 매핑 (계산 없이 원본 컬럼 그대로 가져옴)
            # CSV 컬럼명(snake_case) -> CDS 프로퍼티명(camelCase) 매핑에 주의!
            writer.writerow({
                'ID': p_id,
                'name': row.get('name', ''),
                'team': row.get('club_name', ''),
                'nationality': row.get('country_name', ''),
                'position': row.get('best_position', ''),
                'overall': row.get('overall_rating', 0),
                'potential': row.get('potential', 0),
                'value': p_value,
                
                # 여기서부터 1:1 매핑 (없는 값은 0 처리)
                'acceleration': row.get('acceleration', 0),
                'sprintSpeed': row.get('sprint_speed', 0),
                'agility': row.get('agility', 0),
                
                'finishing': row.get('finishing', 0),
                'shotPower': row.get('shot_power', 0),
                
                'shortPassing': row.get('short_passing', 0),
                'longPassing': row.get('long_passing', 0),
                'ballControl': row.get('ball_control', 0),
                'dribbling': row.get('dribbling', 0),  # 요약 스탯 dribbling이 아니라 세부 스탯 dribbling 사용
                
                'standingTackle': row.get('standing_tackle', 0),
                'stamina': row.get('stamina', 0),
                'strength': row.get('strength', 0)
            })
            count += 1

    print(f"✅ 변환 완료! {count}명의 선수 데이터가 'my.soccer-Players.csv'로 저장되었습니다.")

except FileNotFoundError:
    print("❌ 'raw_fc25.csv' 파일을 찾을 수 없습니다.")
except Exception as e:
    print(f"❌ 에러 발생: {e}")