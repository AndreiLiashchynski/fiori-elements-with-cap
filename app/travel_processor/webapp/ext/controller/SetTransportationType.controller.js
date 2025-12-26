sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/ui/core/Fragment",
    "sap/m/MessageToast",
    "sap/fe/cap/travel/constants/dialogConstants",
    "sap/fe/cap/travel/formatter/formatter",
    "sap/fe/cap/travel/constants/messageKeys",
    "sap/fe/cap/travel/constants/actionConstants",
], function (ControllerExtension, Fragment, MessageToast,
    dialogConstants, formatter, messageKeys, actionConstants) {
    "use strict";

    return ControllerExtension.extend("sap.fe.cap.travel.ext.controller.SetTransportationType", {

        handleSetTransportationTypePress: function () {
            this._i18nModel = this.getView().getModel("i18n");

            if (!this._oDialog) {
                Fragment.load({
                    id: dialogConstants.DIALOG_ID,
                    name: dialogConstants.FRAGMENT_NAME,
                    controller: this
                }).then(function (oDialog) {
                    const oDataModel = this.getView().getModel();

                    oDialog.setModel(oDataModel)
                    oDialog.setModel(this._i18nModel, "i18n");

                    this._attachButtonHandlers(oDialog);

                    oDialog.open();
                    this._oDialog = oDialog;
                }.bind(this));
            } else {
                this._oDialog.open();
            }
        },

        _attachButtonHandlers: function (oDialog) {
            const [btnSave, btnCancel] = oDialog.getButtons();

            btnSave.attachPress(() => this._onSave(oDialog));
            btnCancel.attachPress(() => this._onCancel(oDialog));
        },

        _onSave: async function (oDialog) {
            const oMultiCombo = Fragment.byId(dialogConstants.DIALOG_ID, dialogConstants.MULTI_COMBO_ID);
            const aSelectedTypes = oMultiCombo.getSelectedKeys();

            const oTable = sap.ui.getCore().byId(dialogConstants.TABLE_ID);
            const aContexts = oTable.getSelectedContexts();
            const aUUIDs = aContexts
                .map(c => c.getProperty("TravelUUID"))
                .map(formatter.formatUUID);

            try {
                oTable.removeSelections(true);

                await this._callAssignTransportationType(aUUIDs, aSelectedTypes);

                MessageToast.show(this._getBundle().getText(messageKeys.SUCCESS_KEY_MESSAGE));
                oDialog.close();
            } catch (err) {
                console.error(err)
                MessageToast.show(this._getBundle().getText(messageKeys.ERROR_KEY_MESSAGE));
            }
        },

        _callAssignTransportationType: async function (aUUIDs, sTypes) {
            const oModel = this.getView().getModel();
            await this.base.getExtensionAPI().editFlow.invokeAction(actionConstants.ACTIONS.ASSIGN_TRANSPORTATION_TYPE, {
                model: oModel,
                parameterValues: [
                    { name: actionConstants.PARAMETERS.TRAVEL_UUIDS, value: aUUIDs },
                    { name: actionConstants.PARAMETERS.TRANSPORTATION_TYPE, value: sTypes }
                ],
                skipParameterDialog: true
            });
        },

        _onCancel: function (oDialog) {
            oDialog.close();
        },

        _getBundle: function () {
            return this._i18nModel.getResourceBundle();
        },

    });
});
