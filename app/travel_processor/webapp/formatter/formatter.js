sap.ui.define([], function () {
    "use strict";
    return {
        transportationIcon: function (sType) {
            console.log(sType)
            if (!sType) return "sap-icon://question-mark";
            switch (sType.toLowerCase()) {
                case "train":
                    return "sap-icon://cargo-train";
                case "car":
                    return "sap-icon://car-rental";
                default:
                    return "sap-icon://flight";
            }
        },

        formatUUID: function (uuid) {
            if (!uuid) return uuid;
            const clean = uuid.replace(/-/g, '');
            return clean.replace(/^(.{8})(.{4})(.{4})(.{4})(.{12})$/, '$1-$2-$3-$4-$5');
        },
    };
});
