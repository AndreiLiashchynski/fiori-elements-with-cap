sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/ui/core/Fragment",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "sap/fe/cap/travel/constants/statusDialogConstants",
    "sap/fe/cap/travel/constants/actionConstants",
    "sap/fe/cap/travel/constants/messageKeys",
], function (ControllerExtension, Fragment, MessageToast, MessageBox, statusDialogConstants,
    actionConstants, messageKeys
) {
    "use strict";

    return ControllerExtension.extend("sap.fe.cap.travel.ext.controller.ChangeStatusHandler", {

        handleChangeStatusTypePress: async function () {
            const oView = this.base.getView();
            this._i18nModel = this.getView().getModel("i18n");

            if (!this._oDialog) {
                this._oDialog = await Fragment.load({
                    id: oView.getId(),
                    name: statusDialogConstants.DIALOG_NAME,
                    controller: this
                });
                this.getView().addDependent(this._oDialog);
            }
            this._oDialog.open();
        },

        onSave: async function () {
            const oModel = this.getView().getModel();
            const oSelect = this.base.getView().byId(statusDialogConstants.SELECT_ID);
            const sNewStatus = oSelect.getSelectedKey();

            const oTable = sap.ui.getCore().byId(statusDialogConstants.TABLE_ID);
            const aContexts = oTable.getSelectedContexts();

            const aUUIDs = aContexts.map(oContext =>
                oContext.getProperty("TravelTransportationUUID"));

            try {
                await this.base.getExtensionAPI().editFlow.invokeAction(actionConstants.ACTIONS.CHANGE_TRASNPORTATION_STATUS, {
                    model: oModel,
                    parameterValues: [
                        { name: actionConstants.PARAMETERS.TRAVEL_TRANSPORTATION_UUIDS, value: aUUIDs },
                        { name: actionConstants.PARAMETERS.STATUS, value: sNewStatus }
                    ],
                    skipParameterDialog: true
                });

                MessageToast.show(this._getBundle().getText(messageKeys.STATUS_SUCCESS_KEY_MESSAGE));
                this.base.getExtensionAPI().refresh();
                this._oDialog.close();
            } catch (error) {
                console.error(error);
                MessageBox.error(this._getBundle().getText(messageKeys.STATUS_ERROR_KEY_MESSAGE));
            }
        },

        onCancel: function () {
            this._oDialog.close();
        },

        _getBundle: function () {
            return this._i18nModel.getResourceBundle();
        },
    });
});