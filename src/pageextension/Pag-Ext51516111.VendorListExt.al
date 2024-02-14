pageextension 51516111 VendorListExt extends "Vendor List"
{
    layout
    {
        addbefore(Name)
        {
            field("ID No."; "ID No.")
            {
                ApplicationArea = Basic;
            }
            field("BOSA Account No"; "BOSA Account No")
            {
                ApplicationArea = Basic;
            }
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }

    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('Not allowed');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Error('Not allowed');
    end;

    trigger OnModifyRecord(): Boolean
    begin

    end;
}
