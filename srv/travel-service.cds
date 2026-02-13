using {sap.fe.cap.travel as my} from '../db/schema';

service TravelService @(path: '/processor') {

  @(restrict: [
    {
      grant: 'READ',
      to   : 'authenticated-user'
    },
    {
      grant: [
        'rejectTravel',
        'acceptTravel',
        'deductDiscount'
      ],
      to   : 'reviewer'
    },
    {
      grant: ['*'],
      to   : 'processor'
    },
    {
      grant: ['*'],
      to   : 'admin'
    }
  ])

  entity SupplementScope      as projection on my.SupplementScope;

  entity TravelTransportation as projection on my.TravelTransportation;

  entity TransportStatus      as projection on my.TransportStatus;

  entity TransportationType   as projection on my.TransportationType;

  entity TravelComment        as projection on my.TravelComment;

  // Travel: To avoid number formatting of the travel ID, make it a String
  @odata.draft.enabled
  entity Travel               as
    projection on my.Travel {
      *,
      TravelID                                                                 : String  @readonly  @Common.Text: Description,

      // ***CustomerID***
      to_Customer.FirstName || ' ' || to_Customer.LastName as CustomerFullName : String,
      @Common.Text: CustomerFullName
      to_Customer,

      // ***AgencyID***
      to_Agency.Name                                       as AgencyName,
      @Common.Text: AgencyName
      to_Agency,

      // ***Passenger Country***
      to_Customer.CountryCode.name                         as PassengerCountryName,
      @Common.Text: PassengerCountryName
      to_Customer.CountryCode.code                         as PassengerCountry,

      // **TravelStatus**
      TravelStatus.name                                    as TravelStatusName,
      @Common.Text: TravelStatusName
      TravelStatus
    }
    actions {
      action createTravelByTemplate()                                                                     returns Travel;
      action acceptTravel();
      action rejectTravel();
      action deductDiscount(  @(UI.ParameterDefaultValue: 5)  percent: Percentage not null  @mandatory  ) returns Travel;
    };


  annotate TravelService.assignTransportationType with @Common.SideEffects: {
    TargetProperties: ['to_Travel/to_TransportationTypes'],
    TargetEntities  : ['/TravelService.EntityContainer/Travel']
  };

  annotate TravelService.changeTransportationStatus @Common.SideEffects: {TargetEntities: ['TravelService.TravelTransportation']};

  action   postComment(TravelTransportationUUID: UUID,
                       CommentText: String)              returns TravelComment;

  action   assignTransportationType(TravelUUIDs: array of UUID, TransportationType: array of String);
  action   changeTransportationStatus(TransportationUUIDs: array of String, Status: String);

  // Function import used in Controller Extension 'PassengerOPExtend.js' to calculate booking data
  function getBookingDataOfPassenger(CustomerID: String) returns my.BookingData;

  // Passenger: Add joined property 'FullName' and association 'to_Booking'
  entity Passenger            as
    projection on my.Passenger {
      *,
      FirstName || ' ' || LastName as FullName : String @title: '{i18n>fullName}',
      to_Booking                               : Association to many my.Booking
                                                   on to_Booking.to_Customer = $self
    }

  // Booking, Travel, Passenger: Use "FullName" as text annotation of CustomerID
  annotate Booking {
    to_Customer @Common.Text: to_Customer.FullName
  }

  annotate Passenger {
    CustomerID @Common.Text: FullName;
  }

  // Ensure all masterdata entities are available to clients
  annotate my.MasterData with  @cds.autoexpose  @readonly;
}

type Percentage : Integer @assert.range: [
  1,
  100
];

annotate TravelService.Travel with @Aggregation.ApplySupported: {
  Transformations       : [
    'aggregate',
    'topcount',
    'bottomcount',
    'identity',
    'concat',
    'groupby',
    'filter',
    'expand',
    'search'
  ],
  Rollup                : #None,
  PropertyRestrictions  : true,
  GroupableProperties   : [
    to_Customer_CustomerID,
    to_Agency_AgencyID,
    TravelStatus_code,
    BeginDate,
    PassengerCountry,
  ],
  AggregatableProperties: [{Property: TravelID, }],
};

annotate my.TravelTransportation with {
  @Measures.ISOCurrency: CurrencyCode_code
  Cost;
}

annotate TravelService.TravelTransportation with {
  TransportationType  @mandatory;
  OriginLocation      @mandatory;
  DestinationLocation @mandatory;
  DepartureTime       @mandatory;
  ArrivalTime         @mandatory;
  PassengerCount      @mandatory;
  Status              @mandatory;
  Carrier             @mandatory;
  VehicleInfo         @mandatory;
  Distance            @mandatory;
  Cost                @mandatory;
};
