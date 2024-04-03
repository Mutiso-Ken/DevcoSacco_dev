table 51516874 "Sacco Information"
{
    Caption = 'Sacco Information';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

        }
        field(2; "Sacco CEO"; Code[50])
        {
            TableRelation = Customer."No.";
            trigger OnValidate()
            begin
                if cust.Get("Sacco CEO") then begin
                    "Sacco CEO Name" := cust.Name;
                end;
            end;
        }
        field(3; "Sacco CEO Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Floor Number"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Building Number"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Street/Road"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "P.O Box"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Telephone; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Fax; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "E-Mail"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; IndAuditorBOX; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; PrincipalBankers; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; LegalAdvisorsName; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(15; NoSaccoBraches; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(16; NoOfEmployees; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "L.R.No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; FloorNo; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Independent Auditor"; Text[50])
        {

        }
        field(21; PrincipalBankBox; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Sacco Principal Activities"; Text[150])
        {
            DataClassification = ToBeClassified;
        }


    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    var
        cust: record Customer;
}
