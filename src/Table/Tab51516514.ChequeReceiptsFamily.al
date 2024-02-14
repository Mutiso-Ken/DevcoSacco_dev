#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516514 "Cheque Receipts-Family"
{

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    NoSeriesmgt.TestManual(SalesSetup."Cheque Receipts Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Transaction Date"; Date)
        {
        }
        field(3; "Refference Document"; Code[20])
        {
        }
        field(4; "Transaction Time"; Time)
        {
        }
        field(5; "Created By"; Code[40])
        {
        }
        field(6; "Posted By"; Code[40])
        {
        }
        field(7; Posted; Boolean)
        {
        }
        field(8; "No. Series"; Code[20])
        {
        }
        field(9; "Unpaid By"; Code[20])
        {
            Editable = false;
        }
        field(10; Unpaid; Boolean)
        {
            Editable = false;
        }
        field(11; Imported; Boolean)
        {
        }
        field(12; Processed; Boolean)
        {
        }
        field(13; "Document Name"; Text[60])
        {
        }
        field(14; "Bank Account"; Code[40])
        {
            TableRelation = "Bank Account"."No." where("Cheque Clearing  Account" = const(true));
        }
        field(15; "No of Cheques"; Integer)
        {
            CalcFormula = count("Cheque Issue Lines-Family" where("Header No" = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Cheque Receipts Nos");
            NoSeriesmgt.InitSeries(SalesSetup."Cheque Receipts Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Transaction Time" := Time;
        "Transaction Date" := Today;
    end;

    var
        NoSeriesmgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Sacco No. Series";
}

