page 51516206 "Teller Transaction Types"
{
    ApplicationArea = All;
    Caption = 'Teller Transaction Types';
    PageType = List;
    SourceTable = "Transaction Types";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Code"; Rec."Code")
                {
                }
                field("Default Mode"; Rec."Default Mode")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Has Schedule"; Rec."Has Schedule")
                {
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                }
                field("Transaction Category"; Rec."Transaction Category")
                {
                }
                field("Transaction Span"; Rec."Transaction Span")
                {
                }
                field("Type"; Rec."Type")
                {
                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                }
            }
        }
    }
}
