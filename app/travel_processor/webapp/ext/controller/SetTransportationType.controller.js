sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "sap/fe/cap/travel/formatter/formatter",
    "sap/fe/cap/travel/constants/constants"
], function (ControllerExtension, MessageToast, MessageBox,
    formatter, constants) {
    "use strict";

    /**
     * @class
     * @name sap.fe.cap.travel.ext.controller.SetTransportationType
     * @description Controller extension for assigning transportation types to travel records.
     */
    return ControllerExtension.extend("sap.fe.cap.travel.ext.controller.SetTransportationType", {

        /**
        * Opens the Transportation Type dialog fragment.
        * @public
        * @returns {Promise<void>} A promise that resolves when the dialog is opened.
        */
        handleSetTransportationTypePress: async function () {
            this._oView = this.getView();
            this._i18nModel = this._oView.getModel("i18n");

            if (!this._oDialog) {
                this._oDialog = await this.base.getExtensionAPI().loadFragment({
                    id: constants.UI.IDS.TRANSPORTATION_DIALOG,
                    name: constants.UI.FRAGMENTS.SET_TRANSPORTATION_DIALOG,
                    controller: this
                });
            }
            this._oDialog.open();
        },

        /**
         * Validates multi-combo selection and table context.
         * Triggers the assignment action and provides feedback.
         * @public
         * @returns {Promise<void>} Representing the asynchronous save process.
         */
        onSetTypeSave: async function () {
            const oMultiCombo = this._oView.byId(constants.UI.IDS.MULTI_COMBO);
            const aSelectedTypes = oMultiCombo.getSelectedKeys();

            const oTable = this._oView.byId(constants.UI.IDS.TRANSPORTATION_TABLE);
            const aContexts = oTable.getSelectedContexts();
            const aUUIDs = aContexts
                .map(c => c.getProperty(constants.DATA.PARAMETERS.TRAVEL_UUID,))
                .map(formatter.formatUUID);

            try {
                oTable.removeSelections(true);

                await this._callAssignTransportationType(aUUIDs, aSelectedTypes);

                MessageToast.show(this._getBundle().getText(constants.MESSAGES.SUCCESS.TRANSPORTATION));
                this._oDialog.close();
            } catch (err) {
                console.error(err)
                MessageBox.error(this._getBundle().getText(constants.MESSAGES.ERROR.TRANSPORTATION));
            }
        },

        /**
         * Invokes the backend action 'assignTransportationType' via the EditFlow API.
         * @param {string[]} aUUIDs Array of Travel UUIDs to update.
         * @param {string[]} sTypes Array of selected transportation type keys.
         * @private
         * @returns {Promise<void>} The action invocation promise.
         */
        _callAssignTransportationType: async function (aUUIDs, sTypes) {
            const oModel = this._oView.getModel();

            await this.base.getExtensionAPI().editFlow.invokeAction(constants.DATA.ACTIONS.ASSIGN_TRANSPORTATION_TYPE, {
                model: oModel,
                parameterValues: [
                    { name: constants.DATA.PARAMETERS.TRAVEL_UUIDS, value: aUUIDs },
                    { name: constants.DATA.PARAMETERS.TRANSPORTATION_TYPE, value: sTypes }
                ],
                skipParameterDialog: true
            });
        },

        /**
         * Closes the transportation type dialog.
         * @public
         */
        onSetTypeCancel: function () {
            this._oDialog.close();
        },

        /**
         * Retrieves the i18n resource bundle for translation lookups.
         * @private
         * @returns {sap.base.i18n.ResourceBundle} The resource bundle.
         */
        _getBundle: function () {
            return this._i18nModel.getResourceBundle();
        },
    });
});
