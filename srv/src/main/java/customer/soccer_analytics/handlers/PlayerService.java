package customer.soccer_analytics.handlers;

import java.util.Map; 

import org.springframework.stereotype.Component;

import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;
import com.sap.cds.ql.cqn.CqnAnalyzer; // [추가] 키 추출 해결사

import cds.gen.analyticsservice.AnalyticsService_;
import cds.gen.analyticsservice.Players_;
import cds.gen.analyticsservice.Players;
import cds.gen.analyticsservice.PlayersSignPlayerContext;

@Component
@ServiceName(AnalyticsService_.CDS_NAME)
public class PlayerService implements EventHandler {

    private final PersistenceService db;

    public PlayerService(PersistenceService db) {
        this.db = db;
    }

    @Before(event = { "CREATE", "UPDATE" }, entity = Players_.CDS_NAME)
    public void validatePlayerAge(Players player) {
        if (player.getAge() != null && player.getAge() < 15) {
            throw new IllegalArgumentException("❌ 등록 실패: 선수의 나이는 최소 15세 이상이어야 합니다.");
        }
    }

    @On(event = PlayersSignPlayerContext.CDS_NAME, entity = Players_.CDS_NAME)
    public void signPlayer(PlayersSignPlayerContext context) {
    
        CqnAnalyzer analyzer = CqnAnalyzer.create(context.getModel());
        Map<String, Object> keys = analyzer.analyze(context.getCqn()).targetKeys();
        
        Integer playerId = (Integer) keys.get("ID");
        String newTeamName = context.getTeamName();

        Players playerToUpdate = Players.create();
        playerToUpdate.setTeam(newTeamName);
        playerToUpdate.setId(playerId);

        db.run(
            com.sap.cds.ql.Update.entity(Players_.CDS_NAME).data(playerToUpdate)
        );

        Players updatedPlayer = db.run(
            com.sap.cds.ql.Select.from(Players_.CDS_NAME).columns(p -> p._all()).byId(playerId)
        ).single(Players.class);

        context.setResult(updatedPlayer);
    }
}