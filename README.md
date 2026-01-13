# ⚽ Soccer Analytics Platform (SAP BTP CAP)

## 📖 프로젝트 소개
이 프로젝트는 **SAP BTP(Business Technology Platform)** 환경에서 **CAP(Cloud Application Programming Model)**을 사용하여 구축한 **축구 데이터 분석 플랫폼**입니다.
축구 선수의 데이터를 관리하고, 경기 기록을 기반으로 승률과 성과를 분석하는 시스템을 목표로 합니다.

## 🛠 기술 스택 (Tech Stack)
- **Platform:** SAP BTP (Cloud Foundry)
- **Framework:** SAP CAP (Java / Spring Boot)
- **Database:** SAP HANA Cloud (Production), SQLite (Local Persistence)
- **Language:** Java 17, CDS, Python (Data Processing), Node.js (Tooling)
- **Tools:** SAP Business Application Studio, VS Code, Postman, Git

## 📂 주요 기능 (Features)
- **데이터 모델링 (CDS):** 축구 선수(Player), 팀(Team), 경기(Match) 엔티티 설계
- **OData 서비스:** RESTful API를 통한 데이터 조회(Read), 생성(Create), 수정(Update), 삭제(Delete)
- **비즈니스 로직:** 선수 영입(Action), 유소년 보호 검증(Validation) 로직 구현
- **(예정)** Vector Engine을 활용한 선수 스타일 유사도 검색 (AI)
- **(예정)** Fiori Elements 기반의 관리자 대시보드

## 🚀 실행 방법 (How to Run)
로컬 환경(Hybrid Testing)에서 프로젝트를 실행하는 방법입니다.

### 1. 필수 요구사항
- Node.js & NPM
- Java 17 (Spring Boot)
- Maven

### 2. 실행 명령어 (Terminal)
```bash
# 1. 의존성 설치 (프로젝트 루트)
npm install

# 2. DB 파일 생성 및 스키마 배포 (Draft 테이블 포함)
# * 주의: 데이터 스키마가 변경될 때마다 실행 필요
npx cds deploy --to sqlite

# 3. 로컬 서버 실행 (파일 DB 모드)
npx cds watch
```

---

## 📅 Dev Log (개발 일지)

### Day 1: 프로젝트 셋업 및 기본 설계 (2026.01.01)
**✅ 오늘 한 일 (Done)**
1. **환경 구축:** SAP Business Application Studio (Full Stack) 셋업 완료.
2. **프로젝트 생성:** `cds init` 명령어로 CAP Java 프로젝트 구조 생성.
3. **DB 모델링 (Schema):** CDS를 사용하여 `Players`(축구 선수) 엔티티 정의.
4. **API 개발 (Service):** OData V4 기반의 `AnalyticsService` 노출 (Read-only).
5. **형상 관리:** GitHub 리포지토리 연동 및 초기 코드 푸시.

**🧠 배운 점 (Learned)**
- **CAP 모델의 장점:** SQL과 Java Controller 없이 CDS 파일 두 개만으로 DB와 API가 생성되는 것을 경험함.
- **OData:** REST API보다 유연하게 데이터를 조회할 수 있는 SAP 표준 프로토콜임을 이해함.

**📸 실행 결과**
- 로컬 환경(Port 8080)에서 메타데이터(`$metadata`) 조회 성공.

### Day 2: EA Sports FC 24 데이터셋 확장 적용 (2026.01.02)

**✅ 오늘 한 일 (Done)**
1. **스키마 수정:** acceleration, sprintSpeed, finishing 등 12가지 상세 스탯으로 엔티티 수정.
2. **데이터 ETL:** Python 스크립트(convert_fc25.py)를 작성하여 Kaggle의 EA Sports FC 25 + 실제 선수 데이터 (SoFIFA 병합)
를 추출 및 가공. url: https://www.kaggle.com/datasets/sametozturkk/ea-sports-fc-25-real-player-data-sofifa-merge
3. **DB Seeding:** 가공된 실제 선수 데이터(my.soccer-Players.csv)를 로컬 DB에 적재하여 정밀 분석이 가능한 환경 구축.

**🧠 배운 점 (Learned)**
- **Schema Design:** 분석 목적에 맞게 필요한 컬럼을 선정하고 데이터 타입(Integer)을 적절히 배치하는 법을 익힘.
- **Data Quality:** 원본 데이터(Raw Data)의 포맷(쉼표 포함 등)을 시스템에 맞게 전처리(Preprocessing)하는 과정의 중요성을 배움.
- **CAP Seeding 규칙:** CSV 파일명은 반드시 namespace-entity.csv 형식을 지켜야만 DB에 자동 입력된다는 것을 확인함.

**📸 실행 결과**
- 웹 브라우저에서 'Tottenham' 선수 검색하여 상세 능력치 조회 성공.

### Day 3: 고급 데이터 분석 및 스키마 확장 (2026.01.03)

**✅ 오늘 한 일 (Done)**
1. **API 테스팅 환경 구축:** `.http` 파일을 생성하여 OData의 필터링(`$filter`), 정렬(`$orderby`), 선택(`$select`) 기능을 활용한 정밀 스카우팅 구현.
2. **CDS View 모델링:** 자주 사용하는 조건(공격수)을 가상 엔티티(`Strikers`)로 정의하여 조회 효율성 증대.
3. **데이터 분석(Analytics):** `$apply`와 `aggregate` 기능을 활용하여 '팀별 평균 능력치', '국적별 선수 수' 등 통계 데이터 추출.
4. **스키마 고도화:** FC 26 최신 데이터셋을 도입하고, 분석 차원을 넓히기 위해 피지컬(키, 몸무게), 주급, 주발/약발 등 상세 컬럼 추가.
url: https://www.kaggle.com/datasets/rovnez/fc-26-fifa-26-player-data

**🧠 배운 점 (Learned)**
- **View의 장점:** 복잡한 쿼리 조건을 미리 정의해두고 재사용함으로써 클라이언트의 요청을 단순화할 수 있음.
- **Aggregation:** 데이터를 개별 조회가 아닌 그룹화(Group By)하여 통계적 수치를 뽑아내는 분석 기법 습득.

**📸 실행 결과**
- `requests.http`를 통해 '왼발잡이 센터백', '키 190cm 이상 타겟터' 등 복합 조건 검색 성공.
- 팀별 평균 몸값 분석을 통해 구단 재정 순위 도출 완료.

### Day 4: 비즈니스 로직과 데이터 검증 (2026.01.12)

**✅ 오늘 한 일 (Done)**
1. **커스텀 액션(Action) 구현:** `signPlayer` 기능을 통해 특정 선수를 원하는 팀으로 이적시키는 비즈니스 로직 개발.
2. **데이터 검증(Validation) 로직:** `@Before` 핸들러를 사용하여 15세 미만 선수의 등록/수정을 원천 봉쇄하는 '유소년 보호' 로직 적용.
3. **Java 핸들러 개발:** SAP CAP Java SDK의 `EventHandler`, `CqnAnalyzer`를 활용하여 안전하고 효율적인 DB 제어 코드 작성.
4. **테스트 자동화:** `requests.http`를 이용해 'Validation 에러 케이스'와 'Action 성공 케이스'를 검증.

**🧠 배운 점 (Learned)**
- **Handler의 개념:** API 요청이 DB에 닿기 전/후에 Java 코드가 개입하여 로직을 처리하는 흐름 이해.
- **CQN Analyzer:** 복잡한 OData 요청 URL에서 ID(Key)를 안전하게 추출하는 방법 습득.
- **Troubleshooting:** Java 컴파일 에러와 자동 생성 파일(SignPlayerContext) 간의 의존성 문제를 해결하며 빌드 프로세스 이해.

**📸 실행 결과**
- 나이 10세 수정 시도 -> `400 Bad Request` 에러 발생 성공.
- '호날두' 영입 실행 -> 소속 팀이 'My Dream Team'으로 변경됨.

### Day 5: 로컬 DB 영구 저장 구현 및 환경 트러블슈팅 (2026.01.14)

**✅ 오늘 한 일 (Done)**
- **데이터 영구 저장(Persistence) 구현:** 서버 재시작 시 데이터가 초기화되던 In-Memory 방식에서, 파일 기반(`sqlite.db`)의 영구 저장 방식으로 전환 성공.
- **CAP & UI5 연동 안정화:** 백엔드 서비스 경로와 프론트엔드 호출 경로 불일치 문제 해결.
- **Draft(임시 저장) 기능 활성화:** Fiori Elements의 수정 기능을 위한 Draft 테이블 생성 및 배포.

### 🛠️ 트러블슈팅 (Troubleshooting)

**1. `better-sqlite3` 빌드 에러 및 경로 충돌**
- **문제:** `cds watch` 실행 시 시스템 공용(Global) 모듈을 참조하여 버전 충돌 및 바인딩 에러 발생.
- **해결:** - 프로젝트 로컬에 의존성 재설치 (`npm install`)
    - 네이티브 모듈 리빌드 (`npm rebuild better-sqlite3`)
    - `npx cds watch`를 사용하여 로컬 모듈 강제 실행.

**2. UI5 화면 404 에러 (White Screen)**
- **문제:** 백엔드 서비스는 소문자(`analytics`)로 열렸으나, UI5는 대문자(`AnalyticsService`)로 요청하여 데이터 로드 실패.
- **해결:** `webapp/manifest.json`의 `dataSources` URI를 서버 로그와 동일하게 수정.

**3. "no such table: ..._drafts" 에러**
- **문제:** SQLite DB 파일 생성 시, 일반 테이블만 생성되고 Draft(가수정)용 테이블이 누락되어 데이터 수정 불가.
- **해결:** `npx cds deploy --to sqlite` 명령어를 통해 Draft 테이블까지 포함하여 스키마 재배포.

**🧠 배운 점 (Learned)**
- **Persistence Model:** 복잡한 OData 요청 URL에서 ID(Key)를 안전하게 추출하는 방법 습득.
- **Persistence Mode:** package.json 설정을 통해 In-Memory와 File-Based DB를 전환하는 방법을 익힘.

**📸 실행 결과**
- 서버를 재시작해도 'Kane' 선수 영입 상태가 유지됨을 확인 (영구 저장 성공).
