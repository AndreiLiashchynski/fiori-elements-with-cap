sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "sap/fe/cap/travel/constants/constants"
], function (ControllerExtension, MessageToast, MessageBox, constants
) {
    "use strict";

    /**
     * @class
     * @name sap.fe.cap.travel.ext.controller.ChangeStatusHandler
     * @description Controller extension for handling travel transportation status changes.
     */
    return ControllerExtension.extend("sap.fe.cap.travel.ext.controller.ChangeStatusHandler", {

        /**
         * Opens the Change Status dialog fragment.
         * Initializes the view reference and i18n model on the first call.
         * @public
         * @returns {Promise<void>} A promise that resolves when the dialog is opened.
         */
        handleChangeStatusTypePress: async function () {
            this._oView = this.getView();
            this._i18nModel = this._oView.getModel("i18n");

            if (!this._oDialog) {
                this._oDialog = await this.base.getExtensionAPI().loadFragment({
                    id: this._oView.getId(),
                    name: constants.UI.FRAGMENTS.CHANGE_STATUS_DIALOG,
                    controller: this
                });
            }
            const oSelect = this._oView.byId(constants.UI.IDS.STATUS_SELECT);
            if (oSelect) {
                oSelect.setSelectedKey("");
                oSelect.setValueState("None");
            }

            this._oDialog.open();
        },

        /**
         * Validates the selection and invokes the backend action to update the status.
         * Refreshes the UI and closes the dialog upon success.
         * @public
         * @returns {Promise<void>} A promise representing the async save operation.
         */
        onChangeStatusSave: async function () {
            const oModel = this._oView.getModel();
            const oSelect = this._oView.byId(constants.UI.IDS.STATUS_SELECT);
            const sNewStatus = oSelect.getSelectedKey();

            if (!sNewStatus) {
                oSelect.setValueState("Error");
                return;
            }

            oSelect.setValueState("None");

            const oTable = this._oView.byId(constants.UI.IDS.STATUS_TABLE);
            const aContexts = oTable.getSelectedContexts();

            const oExtAPI = this.base.getExtensionAPI();

            const aUUIDs = aContexts.map(oContext =>
                oContext.getProperty(constants.DATA.PARAMETERS.TRAVEL_TRANSPORTATION_UUID));

            try {
                await oExtAPI.editFlow.invokeAction(constants.DATA.ACTIONS.CHANGE_TRASNPORTATION_STATUS, {
                    model: oModel,
                    parameterValues: [
                        { name: constants.DATA.PARAMETERS.TRAVEL_TRANSPORTATION_UUIDS, value: aUUIDs },
                        { name: constants.DATA.PARAMETERS.STATUS, value: sNewStatus }
                    ],
                    skipParameterDialog: true
                });

                MessageToast.show(this._getBundle().getText(constants.MESSAGES.SUCCESS.STATUS));
                oExtAPI.refresh();
                this._oDialog.close();
            } catch (error) {
                console.error(error);
                MessageBox.error(this._getBundle().getText(constants.MESSAGES.ERROR.STATUS));
            }
        },

        /**
         * Closes the Change Status dialog without saving.
         * @public
         */
        onChangeStatusCancel: function () {
            this._oDialog.close();
        },

        /**
         * Helper method to retrieve the i18n resource bundle.
         * @private
         * @returns {sap.base.i18n.ResourceBundle} The resource bundle for translations.
         */
        _getBundle: function () {
            return this._i18nModel.getResourceBundle();
        },
    });
});