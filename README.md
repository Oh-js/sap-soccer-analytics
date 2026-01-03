# ⚽ Soccer Analytics Platform (SAP BTP CAP)

## 📖 프로젝트 소개
이 프로젝트는 **SAP BTP(Business Technology Platform)** 환경에서 **CAP(Cloud Application Programming Model)**을 사용하여 구축한 **축구 데이터 분석 플랫폼**입니다.
축구 선수의 데이터를 관리하고, 경기 기록을 기반으로 승률과 성과를 분석하는 시스템을 목표로 합니다.

## 🛠 기술 스택 (Tech Stack)
- **Platform:** SAP BTP (Cloud Foundry)
- **Framework:** SAP CAP (Java / Spring Boot)
- **Database:** SAP HANA Cloud (Production), H2 Database (Local)
- **Language:** Java 17, CDS, Python (Data Processing)
- **Tools:** SAP Business Application Studio, VS Code, Postman

## 📂 주요 기능 (Features)
- **데이터 모델링 (CDS):** 축구 선수(Player), 팀(Team), 경기(Match) 엔티티 설계
- **OData 서비스:** RESTful API를 통한 데이터 조회 및 관리
- **(예정)** Vector Engine을 활용한 선수 스타일 유사도 검색 (AI)
- **(예정)** Fiori Elements 기반의 관리자 대시보드

## 🚀 실행 방법 (How to Run)
로컬 환경(Hybrid Testing)에서 프로젝트를 실행하는 방법입니다.

### 1. 필수 요구사항
- Node.js & NPM
- Java 17 (Spring Boot)
- Maven

### 2. 실행 명령어
```bash
# 의존성 설치 및 Spring Boot 서버 실행
mvn clean spring-boot:run
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

**🧠 배운 점 (Learned)**
- **View의 장점:** 복잡한 쿼리 조건을 미리 정의해두고 재사용함으로써 클라이언트의 요청을 단순화할 수 있음.
- **Aggregation:** 데이터를 개별 조회가 아닌 그룹화(Group By)하여 통계적 수치를 뽑아내는 분석 기법 습득.

**📸 실행 결과**
- `requests.http`를 통해 '왼발잡이 센터백', '키 190cm 이상 타겟터' 등 복합 조건 검색 성공.
- 팀별 평균 몸값 분석을 통해 구단 재정 순위 도출 완료.