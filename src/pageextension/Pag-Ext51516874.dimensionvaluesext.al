pageextension 51516874 "dimensionvaluesext" extends "Dimension Values"
{
    layout
    {
        addafter(Blocked)
        {
            field("Account Code"; "Account Code")
            {
                ApplicationArea = Basic;
            }
            field("Banker Cheque Account"; "Banker Cheque Account")
            {
                ApplicationArea = Basic;
            }
            field("Clearing Bank Account"; "Clearing Bank Account")
            {
                ApplicationArea = Basic;
            }
            field("No. Series"; "No. Series")
            {
                ApplicationArea = Basic;
            }
            field("Global Dimension No."; "Global Dimension No.")
            {
                ApplicationArea = Basic;
            }
            field("Local Cheque Charges"; "Local Cheque Charges")
            {
                ApplicationArea = Basic;
            }
            field("Upcountry Cheque Charges"; "Upcountry Cheque Charges")
            {
                ApplicationArea = Basic;
            }
            field("Bounced Cheque Charges"; "Bounced Cheque Charges")
            {
                ApplicationArea = Basic;
            }
        }
        //..............modify
        modify(Totaling)
        {
            Visible = false;
        }
    }
}
