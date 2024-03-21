#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516228 "Members Statistics"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Shares Retained"; "Shares Retained")
                {
                    ApplicationArea = Basic;
                    Caption = 'Share Capital';
                }
                field("Current Shares"; "Current Shares")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unwithdrawable Deposits';
                }
                field("Accrued Interest"; "Accrued Interest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Interest';
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Un-allocated Funds"; "Un-allocated Funds")
                {
                    ApplicationArea = Basic;
                }
                field("Registration Fee Paid"; "Registration Fee Paid")
                {
                    ApplicationArea = Basic;
                }
                field("Monthly ShareCap Cont."; "Monthly ShareCap Cont.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Share Capital';
                }
                field("Monthly Contribution"; "Monthly Contribution")
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Deposit Contribution';
                }
            }
            part(Control1102755002; "Loans Sub-Page List")
            {
                Editable = false;
                SubPageLink = "Client Code" = field("No.");
              
            }
        }
    }

    actions
    {
    }
}

