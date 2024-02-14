page 51516081 "Periodics Processing-Tea"
{
    ApplicationArea = All;
    Caption = 'Tea Processing List';
    PageType = List;
    CardPageId = "Tea Processing Header";
    SourceTable = "Periodics Processing Header";
    UsageCategory = Lists;
    SourceTableView = where(posted = const(false));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No")
                {
                    Caption = 'Series Code';
                }
                field("Processing Type"; Rec."Processing Type")
                {
                }
                field("Posting Document No"; "Posting Document No")
                {
                }
                field("Date Entered"; Rec."Date Entered")
                {
                }
                field("Entered By"; Rec."Entered By")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        SetRange("Entered By", UserId);
        SetRange("Processing Type", "Processing Type"::Tea);

    end;
}
