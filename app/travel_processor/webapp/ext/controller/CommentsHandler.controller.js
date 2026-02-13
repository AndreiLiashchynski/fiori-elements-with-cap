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
     * @name sap.fe.cap.travel.ext.controller.CommentsHandler
     * @description Controller extension for managing and posting travel-related comments.
     */
    return ControllerExtension.extend("sap.fe.cap.travel.ext.controller.CommentsHandler", {

        override: {
            routing: {

                /**
                 * Event handler triggered after the view is bound to a new context.
                 * Ensures that input fields are reset when navigating between different records.
                 */
                onAfterBinding: function () {
                    this._clearAllFeedInputs();
                }
            }
        },

        /**
         * Event handler for opening the comments popover.
         * Sets the binding context of the popover to match the button's context.
         * @param {sap.ui.base.Event} oEvent The press event object.
         * @public
         * @returns {Promise<void>} A promise that resolves when the popover is opened.
         */
        handleCommentsButtonPress: async function (oEvent) {
            this._oView = this.getView();
            this._i18nModel = this._oView.getModel("i18n");

            const oButton = oEvent.getSource();

            if (!this._pPopover) {
                this._pPopover = await this.base.getExtensionAPI().loadFragment({
                    id: this._oView.getId(),
                    name: constants.UI.FRAGMENTS.COMMENTS_POPOVER,
                    controller: this
                });
            }

            this._clearAllFeedInputs();

            const oPopover = this._pPopover;
            oPopover.setBindingContext(oButton.getBindingContext());
            oPopover.openBy(oButton);
        },

        /**
         * Handles the creation of a new comment record.
         * Uses the 'items' binding of the comments list to create the entry.
         * @param {sap.ui.base.Event} oEvent The post event containing the comment text.
         * @public
         * @returns {void}
         */
        onCommentPost: async function (oEvent) {
            const sValue = oEvent.getParameter("value");
            const oExtAPI = this.base.getExtensionAPI();
            const oContext = oEvent.getSource().getBindingContext();
            const sTransportationUUID = oContext.getProperty(constants.DATA.PARAMETERS.TRAVEL_TRANSPORTATION_UUID);

            try {
                await oExtAPI.editFlow.invokeAction(constants.DATA.ACTIONS.POST_COMMENT, {
                    model: this.getView().getModel(),
                    parameterValues: [
                        { name: constants.DATA.PARAMETERS.TRAVEL_TRANSPORTATION_UUID, value: sTransportationUUID },
                        { name: constants.DATA.PARAMETERS.COMMENT_TEXT, value: sValue }
                    ],
                    skipParameterDialog: true
                });

                MessageToast.show(this._getBundle().getText(constants.MESSAGES.SUCCESS.COMMENT_SAVE));
                oExtAPI.refresh();
            } catch (error) {
                console.error(error);
                MessageBox.error(this._getBundle().getText(constants.MESSAGES.ERROR.COMMENT_SAVE));
            }
        },

        /**
         * Deletes a comment .
         * @param {sap.ui.base.Event} oEvent The press event from the FeedListItemAction.
         * @public
         * @returns {void}
         */
        onCommentDelete: async function (oEvent) {
            const oExtAPI = this.base.getExtensionAPI();
            const oContext = oEvent.getSource().getBindingContext();

            try {
                await oContext.delete();

                MessageToast.show(this._getBundle().getText(constants.MESSAGES.SUCCESS.COMMENT_DELETE));
                oExtAPI.refresh();
            } catch (oError) {
                console.error(oError);
                MessageBox.error(this._getBundle().getText(constants.MESSAGES.ERROR.COMMENT_DELETE));
            }
        },

        /**
         * Locates all FeedInput controls within the current view and resets their values.
         * @private
         * @returns {void}
         */
        _clearAllFeedInputs: function () {
            const oView = this.getView();
            if (!oView) return;

            const aInputs = oView.findAggregatedObjects(true, function (oControl) {
                return oControl.isA("sap.m.FeedInput");
            });

            aInputs.forEach(oInput => oInput.setValue(""));
        },

        /**
         * Helper method to retrieve the i18n resource bundle.
         * @private
         * @returns {sap.base.i18n.ResourceBundle} The resource bundle for translations.
         */
        _getBundle: function () {
            if (!this._i18nModel) {
                this._i18nModel = this.getView().getModel("i18n");
            }
            return this._i18nModel.getResourceBundle();
        }
    });
});