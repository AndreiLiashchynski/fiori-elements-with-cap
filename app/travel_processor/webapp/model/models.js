sap.ui.define([
    "sap/ui/model/json/JSONModel",
    "sap/fe/cap/travel/constants/modelConstants"
], function (JSONModel, modelConstants) {
    "use strict";

    return {
        createTransportatioOptionsModel: function () {
            return new JSONModel({
                options: modelConstants.TRANSPORTATION_OPTIONS
            });
        }
    };
});
