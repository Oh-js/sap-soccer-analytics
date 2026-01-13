const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {

    // 1. Players 엔티티 가져오기
    const { Players } = this.entities;

    // -----------------------------------------------------------
    // 🛑 규칙 1: 선수 생성/수정 시 나이 검증 (Validation)
    // -----------------------------------------------------------
    this.before(['CREATE', 'UPDATE'], 'Players', (req) => {
        const { age } = req.data;
        if (age && age < 15) {
            req.error(400, '유소년 규정에 따라 15세 미만 선수는 등록할 수 없습니다.');
        }
    });

    // -----------------------------------------------------------
    // ⚽ 규칙 2: 'signPlayer' 버튼 클릭 시 로직 (수정됨!)
    // -----------------------------------------------------------
    this.on('signPlayer', async (req) => {
        // [수정 포인트] ID만 가져오는 게 아니라, 전체 키(ID + IsActiveEntity)를 통째로 가져옵니다.
        // Draft 모드에서는 키가 2개이기 때문입니다.
        const keys = req.params[0]; 
        const newTeam = req.data.teamName;

        // 2. 해당 선수의 팀 정보를 업데이트
        // where({ ID: playerID }) 대신 where(keys)를 사용하여 정확한 대상을 찾습니다.
        await UPDATE(Players)
            .set({ team: newTeam })
            .where(keys);

        // 3. 변경된 데이터 반환
        return await SELECT.from(Players).where(keys);
    });
});