sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"customer/playermanagement/test/integration/pages/PlayersList",
	"customer/playermanagement/test/integration/pages/PlayersObjectPage"
], function (JourneyRunner, PlayersList, PlayersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('customer/playermanagement') + '/test/flpSandbox.html#customerplayermanagement-tile',
        pages: {
			onThePlayersList: PlayersList,
			onThePlayersObjectPage: PlayersObjectPage
        },
        async: true
    });

    return runner;
});

