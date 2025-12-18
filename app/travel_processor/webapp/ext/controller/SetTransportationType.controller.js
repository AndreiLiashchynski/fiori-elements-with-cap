sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/ui/core/Fragment",
    "sap/m/MessageToast",
    "sap/m/RadioButton",
    "sap/fe/cap/travel/model/models",
    "sap/fe/cap/travel/constants/modelConstants",
    "sap/fe/cap/travel/constants/dialogConstants",
    "sap/fe/cap/travel/formatter/formatter",
    "sap/fe/cap/travel/constants/messageKeys",
    "sap/fe/cap/travel/constants/actionConstants",
], function (ControllerExtension, Fragment, MessageToast, RadioButton,
    models, modelConstants, dialogConstants, formatter, messageKeys, actionConstants) {
    "use strict";

    return ControllerExtension.extend("sap.fe.cap.travel.ext.controller.SetTransportationType", {

        handleSetTransportationTypePress: function () {
            const oTransportationOptionsModel = models.createTransportatioOptionsModel();
            this._i18nModel = this.getView().getModel("i18n");

            if (!this._oDialog) {
                Fragment.load({
                    id: dialogConstants.DIALOG_ID,
                    name: dialogConstants.FRAGMENT_NAME,
                    controller: this
                }).then(function (oDialog) {
                    oDialog.setModel(oTransportationOptionsModel, modelConstants.TRANSPORTATION_MODEL_NAME);
                    oDialog.setModel(this._i18nModel, "i18n");

                    const oRadioGroup = Fragment.byId(dialogConstants.DIALOG_ID, dialogConstants.RADIO_GROUP_ID);

                    this._createRadioButtons(oRadioGroup, oTransportationOptionsModel);
                    this._attachButtonHandlers(oDialog, oRadioGroup);

                    oDialog.open();
                    this._oDialog = oDialog;
                }.bind(this));
            } else {
                this._oDialog.open();
            }
        },

        _createRadioButtons: function (oRadioGroup, oTransportationOptionsModel) {
            const aOptions = oTransportationOptionsModel.getProperty("/options") || [];

            aOptions.forEach(opt => {
                const oRadioButton = new RadioButton({
                    text: this._getBundle().getText(opt.textKey),
                    id: opt.id
                });
                oRadioGroup.addButton(oRadioButton);
            });
        },

        _attachButtonHandlers: function (oDialog, oRadioGroup) {
            const [btnSave, btnCancel] = oDialog.getButtons();

            btnSave.attachPress(() => this._onSave(oDialog, oRadioGroup));
            btnCancel.attachPress(() => this._onCancel(oDialog));
        },

        _onSave: async function (oDialog, oRadioGroup) {
            const oSelected = oRadioGroup.getSelectedButton();
            const sType = oSelected ? oSelected.getText() : "";

            const oTable = sap.ui.getCore().byId(dialogConstants.TABLE_ID);
            const aContexts = oTable.getSelectedContexts();
            const aUUIDs = aContexts
                .map(c => c.getProperty("TravelUUID"))
                .map(formatter.formatUUID);

            try {
                await this._callAssignTransportationType(aUUIDs, sType);


                MessageToast.show(this._getBundle().getText(messageKeys.SUCCESS_KEY_MESSAGE));
                oDialog.close();
            } catch (err) {
                console.error(err)
                MessageToast.show(this._getBundle().getText(messageKeys.ERROR_KEY_MESSAGE));
            }
        },

        _callAssignTransportationType: async function (aUUIDs, sType) {
            const oModel = this.getView().getModel();
            await this.base.getExtensionAPI().editFlow.invokeAction(actionConstants.ACTIONS.ASSIGN_TRANSPORTATION_TYPE, {
                model: oModel,
                parameterValues: [
                    { name: actionConstants.PARAMETERS.TRAVEL_UUIDS, value: aUUIDs },
                    { name: actionConstants.PARAMETERS.TRANSPORTATION_TYPE, value: sType }
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
