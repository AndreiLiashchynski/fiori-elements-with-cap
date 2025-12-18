sap.ui.define([
  "sap/fe/core/AppComponent",
  "sap/fe/cap/travel/formatter/formatter"
], function (Component, formatter) {
  "use strict";

  return Component.extend("sap.fe.cap.travel.Component", {

    metadata: {
      manifest: "json"
    },

    init: function () {
      Component.prototype.init.apply(this, arguments);

      window.Formatter = formatter;
    }
  });
});