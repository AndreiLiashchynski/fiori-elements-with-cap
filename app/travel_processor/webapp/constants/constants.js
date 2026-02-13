sap.ui.define([], function () {
    "use strict";

    return {
        DATA: {
            ACTIONS: {
                ASSIGN_TRANSPORTATION_TYPE: "assignTransportationType",
                CHANGE_TRASNPORTATION_STATUS: "changeTransportationStatus",
                POST_COMMENT: "postComment"
            },
            PARAMETERS: {
                TRAVEL_UUIDS: "TravelUUIDs",
                TRAVEL_UUID: "TravelUUID",
                TRANSPORTATION_TYPE: "TransportationType",
                TRAVEL_TRANSPORTATION_UUIDS: "TransportationUUIDs",
                TRAVEL_TRANSPORTATION_UUID: "TravelTransportationUUID",
                STATUS: "Status",
                COMMENT_TEXT: "CommentText"
            },
        },
        UI: {
            FRAGMENTS: {
                COMMENTS_POPOVER: "sap.fe.cap.travel.ext.fragment.CommentsPopover",
                SET_TRANSPORTATION_DIALOG: "sap.fe.cap.travel.ext.fragment.SetTransportationTypeDialog",
                CHANGE_STATUS_DIALOG: "sap.fe.cap.travel.ext.fragment.ChangeStatusDialog"
            },
            IDS: {
                COMMENTS_LIST: "CommentsPopoverList",
                TRANSPORTATION_DIALOG: "travelSetTransportationType",
                TRANSPORTATION_TABLE: "sap.fe.cap.travel::TravelList--fe::table::tableView::LineItem-innerTable",
                STATUS_TABLE: "sap.fe.cap.travel::TravelObjectPage--fe::table::to_TransportationTypes::LineItem::i18nTransportation-innerTable",
                MULTI_COMBO: "transportationMultiCombo",
                STATUS_SELECT: "StatusSelect",
            },
            KEYS: {
                SAVED_SELECTED: "savedSelected"
            }
        },
        MESSAGES: {
            SUCCESS: {
                TRANSPORTATION: "transportationTypeUpdated",
                COMMENT_SAVE: "commentSaved",
                COMMENT_DELETE: "commentDeleted",
                STATUS: "statusChangeUpdated"
            },
            ERROR: {
                TRANSPORTATION: "transportationTypeUpdateFailed",
                COMMENT_SAVE: "commentSaveFailed",
                COMMENT_DELETE: "commentDeleteFailed",
                STATUS: "statusChangeFailed"
            }
        }
    };
});