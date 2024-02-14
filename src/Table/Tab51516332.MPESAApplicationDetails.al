#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516332 "MPESA Application Details"
{

    fields
    {
        field(1;"Application No";Code[30])
        {
            NotBlank = true;
            TableRelation = "MPESA Applications";
        }
        field(2;"Account Type";Option)
        {
            Caption = 'Account Type';
            NotBlank = true;
            OptionCaption = 'Debtor,Creditor';
            OptionMembers = Customer,Vendor;
        }
        field(3;"Account No.";Code[20])
        {
            Caption = 'Account No.';
            NotBlank = true;
            TableRelation = if ("Account Type"=const(Vendor)) Vendor;

            trigger OnValidate()
            begin

                case "Account Type" of
                  "account type"::Customer:
                    begin
                      Cust.Get("Account No.");
                      Description := Cust.Name;
                    end;
                  "account type"::Vendor:
                    begin
                      Vend.Get("Account No.");
                      Description := Vend.Name;
                    end;
                end;
            end;
        }
        field(4;Description;Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1;"Application No","Account Type","Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Cust: Record Customer;
        Vend: Record Vendor;
}

