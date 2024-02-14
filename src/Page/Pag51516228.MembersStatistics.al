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
                field("School Fees Shares"; "School Fees Shares")
                {
                    ApplicationArea = Basic;
                    Caption = 'CO- OP Shares';
                }
                field("Monthly Sch.Fees Cont."; "Monthly Sch.Fees Cont.")
                {
                    ApplicationArea = Basic;
                }
                field("Pepea Shares"; "Pepea Shares")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pepea Shares';
                    Editable = false;
                }
                field("Fosa Shares"; "Fosa Shares")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Computer Shares"; "Computer Shares")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("van Shares"; "van Shares")
                {
                    ApplicationArea = Basic;
                    Caption = 'Van Shares';
                    Editable = false;
                }
                field("Investment Max Limit."; "Investment Max Limit.")
                {
                    ApplicationArea = Basic;
                    Caption = 'FOSA Shares Monthly Cont.';
                }
                field("Changamka Shares"; "Changamka Shares")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Housing Deposits"; "Housing Deposits")
                {
                    ApplicationArea = Basic;
                    Caption = 'Housing Deposit';
                    Editable = false;
                }
                field("Executive Deposits"; "Executive Deposits")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Preferencial Building Shares"; "Preferencial Building Shares")
                {
                    ApplicationArea = Basic;
                    Caption = '15% Preferencial Shares';
                    Editable = false;
                }
                field("Tamba Shares"; "Tamba Shares")
                {
                    ApplicationArea = Basic;
                }
                field("Kussco Shares"; "Kussco Shares")
                {
                    ApplicationArea = Basic;
                }
                field("CIC Shares"; "CIC Shares")
                {
                    ApplicationArea = Basic;
                }
                field("Lift Shares"; "Lift Shares")
                {
                    ApplicationArea = Basic;
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

