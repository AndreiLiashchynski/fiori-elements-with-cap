sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/ui/core/Fragment",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "sap/fe/cap/travel/constants/messageKeys",
    "sap/fe/cap/travel/constants/commentsPopoverConstants",
    "sap/fe/cap/travel/constants/actionConstants",
], function (ControllerExtension, Fragment, MessageToast, MessageBox,
    messageKeys, commentsPopoverConstants, actionConstants
) {
    "use strict";

    return ControllerExtension.extend("sap.fe.cap.travel.ext.controller.CommentsHandler", {

        onPress: async function (oEvent) {
            this._i18nModel = this.getView().getModel("i18n");
            const oButton = oEvent.getSource();
            const oView = this.base.getView();

            if (!this._pPopover) {
                this._pPopover = await Fragment.load({
                    id: oView.getId(),
                    name: commentsPopoverConstants.POPOVER_NAME,
                    controller: this
                });
                oView.addDependent(this._pPopover);
            }

            const oPopover = this._pPopover;
            oPopover.setBindingContext(oButton.getBindingContext());
            oPopover.openBy(oButton);
        },

        onPostComment: async function (oEvent) {
            const sValue = oEvent.getParameter("value");
            const oView = this.base.getView();

            const oList = Fragment.byId(oView.getId(), commentsPopoverConstants.LIST_ID);
            const oBinding = oList.getBinding("items");

            if (!sValue) return;

            try {
                oBinding.create({
                    [actionConstants.ENTITY_PROPERTIES.COMMENT_TEXT]: sValue
                });

                MessageToast.show(this._getBundle().getText(messageKeys.COMMENT_SUCCESS_KEY_MESSAGE));
            } catch (error) {
                console.error(error);
                MessageBox.error(this._getBundle().getText(messageKeys.COMMENT_ERROR_KEY_MESSAGE));
            }
        },

        _getBundle: function () {
            return this._i18nModel.getResourceBundle();
        },

    });
});