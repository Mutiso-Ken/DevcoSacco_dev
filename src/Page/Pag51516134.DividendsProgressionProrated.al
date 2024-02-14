page 51516134 "Dividends Progression-Prorated"
{
    ApplicationArea = All;
    Caption = 'Dividends Progression-Prorated';
    PageType = ListPart;
    SourceTable = "Dividends Progression";
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Member No"; Rec."Member No")
                {
                }
                field("Date"; Rec."Date")
                {
                }
                field("Dividend Year"; Rec."Dividend Year")
                {
                }
                field("Qualifying Current Shares"; Rec."Qualifying Current Shares")
                {
                }
                field("Gross Current Shares"; Rec."Gross Current Shares")
                {
                }
                field("WTax-Current Shares"; Rec."WTax-Current Shares")
                {
                }
                field("Net Current Shares"; Rec."Net Current Shares")
                {
                }
            }
        }
    }
}
