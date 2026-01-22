using TravelService from '../../srv/travel-service';
using from '../../db/schema';
using from '../../db/master-data';
using from './value-helps';


//
// annotatios that control the fiori layout
//

annotate TravelService.Travel with @(
    UI                                         : {

        Identification        : [
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.acceptTravel',
                Label : '{i18n>AcceptTravel}'
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.rejectTravel',
                Label : '{i18n>RejectTravel}'
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.deductDiscount',
                Label : '{i18n>DeductDiscount}',
            },
        ],
        HeaderInfo            : {
            TypeName      : '{i18n>Travel}',
            TypeNamePlural: '{i18n>Travels}',
            Title         : {
                $Type: 'UI.DataField',
                Value: Description
            },
            Description   : {
                $Type: 'UI.DataField',
                Value: TravelID
            }
        },
        PresentationVariant   : {
            Text          : 'Default',
            Visualizations: ['@UI.LineItem'],
            SortOrder     : [{
                $Type     : 'Common.SortOrderType',
                Property  : TravelID,
                Descending: true
            }]
        },
        SelectionFields       : [
            to_Agency_AgencyID,
            to_Customer_CustomerID,
            TravelStatus_code,
            BeginDate,
            EndDate,
        ],
        LineItem              : [
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.acceptTravel',
                Label : '{i18n>AcceptTravel}',
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.deductDiscount',
                Label : '{i18n>DeductDiscount}',
            },
            {
                $Type         : 'UI.DataField',
                Value         : TravelID,
                @UI.Importance: #High,
            },
            {
                $Type         : 'UI.DataField',
                Value         : to_Customer_CustomerID,
                @UI.Importance: #High,
            },
            {
                $Type: 'UI.DataField',
                Value: BeginDate,
            },
            {
                $Type: 'UI.DataField',
                Value: EndDate,
            },
            {
                $Type: 'UI.DataField',
                Value: BookingFee,
            },
            {
                $Type: 'UI.DataField',
                Value: TotalPrice,
            },
            {
                $Type                    : 'UI.DataField',
                Value                    : TravelStatus_code,
                Criticality              : TravelStatus.criticality,
                CriticalityRepresentation: #WithIcon,
                Label                    : 'Booking Status',
                @UI.Importance           : #High,
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.rejectTravel',
                Label : '{i18n>RejectTravel}',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target: '@UI.DataPoint#Progress',
                Label : '{i18n>ProgressOfTravel}',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target: 'to_Agency/@Communication.Contact#contact',
                Label : '{i18n>AgencyID}',
            },
            {
                $Type          : 'UI.DataFieldForIntentBasedNavigation',
                SemanticObject : 'Customer',
                Action         : 'display',
                Label          : '{i18n>DisplayCustomers}',
                RequiresContext: false,
                Mapping        : [{
                    $Type                 : 'Common.SemanticObjectMappingType',
                    LocalProperty         : to_Customer_CustomerID,
                    SemanticObjectProperty: 'CustomerID',
                }]
            },

        ],
        Facets                : [
            {
                $Type : 'UI.CollectionFacet',
                Label : '{i18n>GeneralInformation}',
                ID    : 'Travel',
                Facets: [
                    { // travel details
                        $Type : 'UI.ReferenceFacet',
                        ID    : 'TravelData',
                        Target: '@UI.FieldGroup#TravelData',
                        Label : '{i18n>GeneralInformation}'
                    },
                    {
                        $Type            : 'UI.ReferenceFacet',
                        Label            : '{i18n>TravelAdministrativeData}',
                        ID               : 'i18nTravelAdministrativeData',
                        Target           : '@UI.FieldGroup#i18nTravelAdministrativeData',
                        @UI.PartOfPreview: false,
                    },
                ]
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>Transportation}',
                ID    : 'i18nTransportation',
                Target: 'to_TransportationTypes/@UI.LineItem#i18nTransportation',
            },
            { // booking list
                $Type : 'UI.ReferenceFacet',
                Target: 'to_Booking/@UI.PresentationVariant',
                Label : '{i18n>Bookings}'
            },
        ],
        FieldGroup #TravelData: {Data: [
            {Value: TravelID},
            {Value: to_Agency_AgencyID},
            {Value: to_Customer_CustomerID},
            {Value: Description},
            {
                $Type        : 'UI.DataField',
                Value        : BeginDate,
                ![@UI.Hidden]: TravelStatus.cancelRestrictions
            },
            {
                $Type        : 'UI.DataField',
                Value        : EndDate,
                ![@UI.Hidden]: TravelStatus.cancelRestrictions
            },
        ]},
        FieldGroup #DateData  : {Data: [
            {
                $Type: 'UI.DataField',
                Value: BeginDate
            },
            {
                $Type: 'UI.DataField',
                Value: EndDate
            }
        ]}
    },
    UI.DataPoint #Progress                     : {
        Value        : Progress,
        Visualization: #Progress,
        TargetValue  : 100,
    },
    UI.SelectionPresentationVariant #tableView : {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: ![@UI.PresentationVariant],
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'O',
                }, ],
            }],
        },
        Text               : '{i18n>Open}',
    },
    UI.LineItem #tableView                     : [
        {
            $Type: 'UI.DataField',
            Value: Description,
        },
        {
            $Type: 'UI.DataField',
            Value: LastChangedAt,
        },
        {
            $Type: 'UI.DataField',
            Value: TravelID,
            Label: 'TravelID',
        },
        {
            $Type: 'UI.DataField',
            Value: to_Customer_CustomerID,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.rejectTravel',
            Label : '{i18n>RejectTravel}',
        },
    ],
    UI.SelectionPresentationVariant #tableView1: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#tableView',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'A',
                }, ],
            }],
        },
        Text               : '{i18n>Accepted}',
    },
    UI.LineItem #tableView1                    : [
        {
            $Type: 'UI.DataField',
            Value: Description,
        },
        {
            $Type: 'UI.DataField',
            Value: LastChangedAt,
        },
        {
            $Type: 'UI.DataField',
            Value: to_Agency_AgencyID,
        },
        {
            $Type: 'UI.DataField',
            Value: to_Customer_CustomerID,
        },
        {
            $Type: 'UI.DataField',
            Value: TravelID,
            Label: 'TravelID',
        },
    ],
    UI.SelectionPresentationVariant #tableView2: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#tableView1',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'X',
                }, ],
            }],
        },
        Text               : '{i18n>Canceled}',
    },
    UI.DataPoint #TotalPrice                   : {
        $Type: 'UI.DataPointType',
        Value: TotalPrice,
        Title: '{i18n>TotalPrice}',
    },
    UI.DataPoint #TravelStatus_code            : {
        $Type      : 'UI.DataPointType',
        Value      : TravelStatus_code,
        Title      : '{i18n>TravelStatus}',
        Criticality: TravelStatus.criticality,
    },
    UI.HeaderFacets                            : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'TravelStatus_code',
            Target: '@UI.DataPoint#TravelStatus_code',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'TotalPrice',
            Target: '@UI.DataPoint#TotalPrice',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Progress',
            Target: '@UI.DataPoint#progress',
        },
    ],
    UI.DataPoint #progress                     : {
        $Type        : 'UI.DataPointType',
        Value        : Progress,
        Title        : '{i18n>Progress}',
        TargetValue  : 100,
        Visualization: #Progress,
    },
    UI.FieldGroup #i18nTravelAdministrativeData: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: createdAt,
            },
            {
                $Type: 'UI.DataField',
                Value: LastChangedAt,
            },
            {
                $Type: 'UI.DataField',
                Value: createdBy,
            },
        ],
    },
);

annotate TravelService.Booking with @(
    UI                            : {
        Identification                : [{Value: BookingID}, ],
        HeaderInfo                    : {
            TypeName      : '{i18n>Bookings}',
            TypeNamePlural: '{i18n>Bookings}',
            Title         : {Value: to_Customer.LastName},
            Description   : {Value: BookingID}
        },
        PresentationVariant           : {
            Visualizations: ['@UI.LineItem'],
            SortOrder     : [{
                $Type     : 'Common.SortOrderType',
                Property  : BookingID,
                Descending: false
            }]
        },
        SelectionFields               : [],
        LineItem                      : [
            {
                Value: to_Carrier.AirlinePicURL,
                Label: '  '
            },
            {Value: BookingID},
            {Value: BookingDate},
            {Value: to_Customer_CustomerID},
            {Value: to_Carrier_AirlineID},
            {
                Value: ConnectionID,
                Label: '{i18n>FlightNumber}'
            },
            {Value: FlightDate},
            {Value: FlightPrice},
            {Value: BookingStatus_code},
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target: '@UI.Chart#TotalSupplPrice',
                Label : '{i18n>Supplements}',
            },
        ],
        Facets                        : [
            {
                $Type : 'UI.CollectionFacet',
                Label : '{i18n>GeneralInformation}',
                ID    : 'Booking',
                Facets: [
                    { // booking details
                        $Type : 'UI.ReferenceFacet',
                        ID    : 'BookingData',
                        Target: '@UI.FieldGroup#GeneralInformation',
                        Label : '{i18n>Booking}'
                    },
                    { // flight details
                        $Type : 'UI.ReferenceFacet',
                        ID    : 'FlightData',
                        Target: '@UI.FieldGroup#Flight',
                        Label : '{i18n>Flight}'
                    }
                ]
            },
            { // supplements list
                $Type : 'UI.ReferenceFacet',
                Target: 'to_BookSupplement/@UI.PresentationVariant',
                Label : '{i18n>BookingSupplements}'
            }
        ],
        FieldGroup #GeneralInformation: {Data: [
            {Value: BookingID},
            {Value: BookingDate, },
            {Value: to_Customer_CustomerID},
            {Value: BookingDate, },
            {Value: BookingStatus_code}
        ]},
        FieldGroup #Flight            : {Data: [
            {Value: to_Carrier_AirlineID},
            {Value: ConnectionID},
            {Value: FlightDate},
            {Value: FlightPrice}
        ]},
    },
    UI.HeaderFacets               : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'TotalSupplPrice',
        Target: '@UI.Chart#TotalSupplPrice1',
    }, ],
    UI.DataPoint #TotalSupplPrice1: {
        Value                 : TotalSupplPrice,
        MinimumValue          : {$edmJson: {$Path: '/SupplementScope/MinimumValue'}},
        MaximumValue          : {$edmJson: {$Path: '/SupplementScope/MaximumValue'}},
        TargetValue           : {$edmJson: {$Path: '/SupplementScope/TargetValue'}},
        CriticalityCalculation: {
            $Type                 : 'UI.CriticalityCalculationType',
            ImprovementDirection  : #Maximize,
            DeviationRangeLowValue: {$edmJson: {$Path: '/SupplementScope/DeviationRangeLowValue'}},
            ToleranceRangeLowValue: {$edmJson: {$Path: '/SupplementScope/ToleranceRangeLowValue'}}
        }
    },
    UI.Chart #TotalSupplPrice1    : {
        ChartType        : #Bullet,
        Title            : '{i18n>TotalSupplements}',
        Measures         : [TotalSupplPrice, ],
        MeasureAttributes: [{
            DataPoint: '@UI.DataPoint#TotalSupplPrice1',
            Role     : #Axis1,
            Measure  : TotalSupplPrice,
        }, ],
    },
);

annotate TravelService.BookingSupplement with @UI: {
    Identification     : [{Value: BookingSupplementID}],
    HeaderInfo         : {
        TypeName      : '{i18n>BookingSupplement}',
        TypeNamePlural: '{i18n>BookingSupplements}',
        Title         : {Value: BookingSupplementID},
        Description   : {Value: BookingSupplementID}
    },
    PresentationVariant: {
        Text          : 'Default',
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : BookingSupplementID,
            Descending: false
        }]
    },
    LineItem           : [
        {Value: BookingSupplementID},
        {
            Value: to_Supplement_SupplementID,
            Label: '{i18n>ProductID}'
        },
        {
            Value: Price,
            Label: '{i18n>ProductPrice}'
        }
    ],
};

annotate TravelService.Flight with @UI: {PresentationVariant #SortOrderPV: { // used in the value help for ConnectionId in Bookings
SortOrder: [{
    Property  : FlightDate,
    Descending: true
}]}};

annotate TravelService.Travel with {
    CustomerFullName @Common.Label: 'CustomerFullName'
};

annotate TravelService.Booking with @(
    UI.DataPoint #TotalSupplPrice: {
        Value                 : TotalSupplPrice,
        MinimumValue          : 0,
        MaximumValue          : 120,
        TargetValue           : 100,
        Visualization         : #BulletChart,
        //  Criticality : TotalSupplPrice, // it has precedence over criticalityCalculation => in order to have the criticality color do not use it
        CriticalityCalculation: {
            $Type                 : 'UI.CriticalityCalculationType',
            ImprovementDirection  : #Maximize,
            DeviationRangeLowValue: 20,
            ToleranceRangeLowValue: 75
        }
    },
    UI.Chart #TotalSupplPrice    : {
        ChartType        : #Bullet,
        Title            : 'total supplements',
        AxisScaling      : {$Type: 'UI.ChartAxisScalingType',
        },
        Measures         : [TotalSupplPrice, ],
        MeasureAttributes: [{
            DataPoint: '@UI.DataPoint#TotalSupplPrice',
            Role     : #Axis1,
            Measure  : TotalSupplPrice,
        }, ],
    }
);

annotate TravelService.TravelAgency with @(Communication.Contact #contact: {
    $Type: 'Communication.ContactType',
    fn   : Name,
    tel  : [{
        $Type: 'Communication.PhoneNumberType',
        type : #work,
        uri  : PhoneNumber,
    }, ],
    adr  : [{
        $Type   : 'Communication.AddressType',
        type    : #work,
        street  : Street,
        locality: City,
        region  : PostalCode,
    }, ],
});

annotate TravelService.Travel with {
    Description @UI.MultiLineText: true
                @UI.Placeholder  : '{i18n>DescrPlcehlder}'
};

annotate TravelService.Booking with {
    ConnectionID @(
        Common.ValueList               : {
            CollectionPath              : 'Flight',
            Label                       : '',
            Parameters                  : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    ValueListProperty: 'AirlineID',
                    LocalDataProperty: to_Carrier_AirlineID,
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ConnectionID,
                    ValueListProperty: 'ConnectionID',
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    ValueListProperty: 'FlightDate',
                    LocalDataProperty: FlightDate,
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    ValueListProperty: 'Price',
                    LocalDataProperty: FlightPrice,
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    ValueListProperty: 'CurrencyCode_code',
                    LocalDataProperty: CurrencyCode_code,
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'to_Airline/Name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'PlaneType',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'MaximumSeats',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'OccupiedSeats',
                },
            ],
            PresentationVariantQualifier: 'SortOrderPV',
        },
        Common.ValueListWithFixedValues: true,
    )
};

annotate TravelService.Travel @(Common.SideEffects #ReactonItemCreationOrDeletion: {
    SourceEntities  : [to_Booking],
    TargetProperties: ['TotalPrice']
});

annotate TravelService.Travel with {
    @(Common: {
        SemanticObject       : 'Customer',
        SemanticObjectMapping: [{
            $Type                 : 'Common.SemanticObjectMappingType',
            LocalProperty         : to_Customer_CustomerID,
            SemanticObjectProperty: 'CustomerID',
        }]
    })
    to_Customer
};

annotate TravelService.TravelTransportation with @(
    UI.LineItem #i18nTransportation      : [
        {
            $Type                    : 'UI.DataField',
            Value                    : Status_code,
            Label                    : '{i18n>Status}',
            Criticality              : Criticality,
            CriticalityRepresentation: #WithoutIcon,
        },
        {
            $Type: 'UI.DataField',
            Value: OriginLocation,
            Label: '{i18n>Originlocation}',
        },
        {
            $Type: 'UI.DataField',
            Value: DestinationLocation,
            Label: '{i18n>Destinationlocation}',
        },
        {
            $Type: 'UI.DataField',
            Value: DepartureTime,
            Label: '{i18n>Departuretime}',
        },
        {
            $Type: 'UI.DataField',
            Value: ArrivalTime,
            Label: '{i18n>Arrivaltime}',
        },
        {
            $Type: 'UI.DataField',
            Value: Carrier,
            Label: '{i18n>Carrier}',
        },
        {
            $Type: 'UI.DataField',
            Value: PassengerCount,
            Label: '{i18n>Passengercount}',
        },
        {
            $Type: 'UI.DataField',
            Value: VehicleInfo,
            Label: '{i18n>Vehicleinfo}',
        },
        {
            $Type: 'UI.DataField',
            Value: Distance,
            Label: '{i18n>Distance}',
        },
        {
            $Type: 'UI.DataField',
            Value: Cost,
            Label: '{i18n>Cost}',
        },
    ],
    UI.Facets                            : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>GeneralInformation}',
            ID    : 'i18nGeneralInformation',
            Target: '@UI.FieldGroup#i18nGeneralInformation',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>Comments}',
            ID    : 'i18nComments',
            Target: 'to_Comments/@UI.LineItem#i18nComments',
        },
    ],
    UI.FieldGroup #i18nGeneralInformation: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: TransportationType.name,
                Label: '{i18n>TransportationType}',
            },
            {
                $Type: 'UI.DataField',
                Value: Status.name,
                Label: '{i18n>Status}',
            },
            {
                $Type: 'UI.DataField',
                Value: OriginLocation,
                Label: '{i18n>Originlocation}',
            },
            {
                $Type: 'UI.DataField',
                Value: DestinationLocation,
                Label: '{i18n>Destinationlocation}',
            },
            {
                $Type: 'UI.DataField',
                Value: DepartureTime,
                Label: '{i18n>Departuretime}',
            },
            {
                $Type: 'UI.DataField',
                Value: ArrivalTime,
                Label: '{i18n>Arrivaltime}',
            },
            {
                $Type: 'UI.DataField',
                Value: Carrier,
                Label: '{i18n>Carrier}',
            },
            {
                $Type: 'UI.DataField',
                Value: PassengerCount,
                Label: '{i18n>Passengercount}',
            },
            {
                $Type: 'UI.DataField',
                Value: Distance,
                Label: '{i18n>Distance}',
            },
            {
                $Type: 'UI.DataField',
                Value: Cost,
                Label: '{i18n>Cost}',
            },
        ],
    },
);

annotate TravelService.TravelTransportation with {
    Status
    @Common.Text           : Status.name
    @Common.TextArrangement: #TextOnly;
};

annotate TravelService.TravelTransportation with {
    Status
    @Common.ValueListWithFixedValues: true
    @Common.ValueList               : {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'TransportStatus',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Status_code,
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            }
        ]
    };
};

annotate TravelService.TransportStatus with {
    code  @Common.Text: name  @Common.TextArrangement: #TextOnly;
}

annotate TravelService.TravelComment with @(UI.LineItem #i18nComments: [
    {
        $Type: 'UI.DataField',
        Value: CommentText,
        Label: '{i18n>Commenttext}',
    },
    {
        $Type: 'UI.DataField',
        Value: createdAt,
        Label: '{i18n>CreatedAt}'
    },
    {
        $Type: 'UI.DataField',
        Value: createdBy,
        Label: '{i18n>CreatedBy}'
    },
]);
