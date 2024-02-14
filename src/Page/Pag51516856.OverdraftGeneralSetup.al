#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516856 "Overdraft GeneralSetup"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Overdraft Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Overdraft Nos";"Overdraft Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Overdraft Limt";"Overdraft Limt")
                {
                    ApplicationArea = Basic;
                }
                field("Overdraft Interest  Rate";"Overdraft Interest  Rate")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Overdraft Maximum prd";"Overdraft Maximum prd")
                {
                    ApplicationArea = Basic;
                }
                field("Overdraft Commision Charged";"Overdraft Commision Charged")
                {
                    ApplicationArea = Basic;
                }
                field("One Month Interest Rate";"One Month Interest Rate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interest Rate<=1M';
                }
                field("More than Month Interest Rate";"More than Month Interest Rate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interest Rate >1M';
                }
            }
            group("Commision/Accounts")
            {
                field("Control Account";"Control Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Overdraft Receivable A/c';
                }
                field("Interest Receivable A/c";"Interest Receivable A/c")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Income A/c";"Interest Income A/c")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interest On Overdraft A/c';
                }
                field("Commission A/c";"Commission A/c")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Form / Overdraft';
                }
            }
        }
    }

    actions
    {
    }
}

