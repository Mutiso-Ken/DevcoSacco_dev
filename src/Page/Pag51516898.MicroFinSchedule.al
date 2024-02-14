#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516898 "Micro_Fin_Schedule"
{
    CardPageID = Micro_Fin_Transactions;
    DeleteAllowed = true;
    PageType = ListPart;
    SourceTable = Micro_Fin_Schedule;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Number"; "Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Loans No."; "Loans No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan No.';
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Received From Member';
                    Style = Strong;
                }
                field(Savings; Savings)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                    Caption = 'Savings Amount';
                }
                field("Principle Amount"; "Principle Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Caption = 'Principal Amount';
                    Style = Unfavorable;
                }

                field("Interest Amount"; "Interest Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Caption = 'Interest Amount';
                    Style = Unfavorable;
                }
                field("Expected Principle Amount"; "Expected Principle Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Principle';
                }
                field("Expected Interest"; "Expected Interest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Interest';
                }
                field("Excess Amount"; "Excess Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
            }
        }
    }

}

