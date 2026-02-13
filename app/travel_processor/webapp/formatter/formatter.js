sap.ui.define([], function () {
    "use strict";
    return {
        mapTransportCodeToIcon: function (sCode) {
            const oMap = {
                "Plane": "sap-icon://flight",
                "Train": "sap-icon://cargo-train",
                "Car": "sap-icon://car-rental"
            };

            return oMap[sCode] || "sap-icon://question-mark";
        },

        formatUUID: function (uuid) {
            if (!uuid) return uuid;
            const clean = uuid.replace(/-/g, '');
            return clean.replace(/^(.{8})(.{4})(.{4})(.{4})(.{12})$/, '$1-$2-$3-$4-$5');
        },
    };
});
