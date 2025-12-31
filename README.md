# ⚽ Soccer Analytics Platform (SAP BTP CAP)

## 📖 프로젝트 소개
이 프로젝트는 **SAP BTP(Business Technology Platform)** 환경에서 **CAP(Cloud Application Programming Model)**을 사용하여 구축한 **축구 데이터 분석 플랫폼**입니다.
축구 선수의 데이터를 관리하고, 경기 기록을 기반으로 승률과 성과를 분석하는 시스템을 목표로 합니다.

## 🛠 기술 스택 (Tech Stack)
- **Platform:** SAP BTP (Cloud Foundry)
- **Framework:** SAP CAP (Java / Spring Boot)
- **Database:** SAP HANA Cloud (Production), H2 Database (Local)
- **Language:** Java 17, CDS
- **Tools:** SAP Business Application Studio, VS Code

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