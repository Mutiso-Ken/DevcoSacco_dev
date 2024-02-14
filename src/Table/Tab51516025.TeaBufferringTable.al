table 51516025 "Tea Bufferring Table"
{
    Caption = 'Tea Bufferring Table';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Document No"; Code[50])
        {
            Caption = 'Document No';
        }
        field(2; "Account No"; Code[50])
        {
            Caption = 'Account No';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
        }
    }
    keys
    {
        key(PK; "Document No","Account No")
        {
            Clustered = true;
        }
    }
}
