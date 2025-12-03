using TravelService as service from '../../srv/travel-service';
annotate service.Passenger with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : CustomerID,
            },
            {
                $Type : 'UI.DataField',
                Value : CountryCode_code,
            },
            {
                $Type : 'UI.DataField',
                Value : PostalCode,
            },
            {
                $Type : 'UI.DataField',
                Value : City,
            },
            {
                $Type : 'UI.DataField',
                Value : Street,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>GeneralInformation}',
            ID : 'i18nGeneralInformation',
            Target : '@UI.FieldGroup#i18nGeneralInformation',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : FullName,
        },
        {
            $Type : 'UI.DataField',
            Value : CountryCode.code,
        },
        {
            $Type : 'UI.DataField',
            Value : CountryCode.descr,
        },
        {
            $Type : 'UI.DataField',
            Value : PostalCode,
        },
        {
            $Type : 'UI.DataField',
            Value : Street,
        },
    ],
    UI.SelectionFields : [
        CountryCode_code,
        City,
        PostalCode,
    ],
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Contact Details',
            ID : 'ContactDetails',
            Target : '@UI.FieldGroup#ContactDetails',
        },
    ],
    UI.FieldGroup #ContactDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : EMailAddress,
            },
            {
                $Type : 'UI.DataField',
                Value : PhoneNumber,
            },
            {
                $Type : 'UI.DataField',
                Value : FullName,
            },
        ],
    },
    UI.HeaderInfo : {
        TypeName : '{i18n>CustomerID}',
        TypeNamePlural : '{i18n>Customers}',
        Title : {
            $Type : 'UI.DataField',
            Value : FullName,
        },
    },
    UI.FieldGroup #i18nGeneralInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : CustomerID,
            },
            {
                $Type : 'UI.DataField',
                Value : PostalCode,
            },
            {
                $Type : 'UI.DataField',
                Value : CountryCode_code,
            },
            {
                $Type : 'UI.DataField',
                Value : City,
            },
            {
                $Type : 'UI.DataField',
                Value : Street,
            },
        ],
    },
);

