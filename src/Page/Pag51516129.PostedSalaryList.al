page 51516129 "Posted Salary List"
{
    ApplicationArea = All;
    Caption = 'Posted Salary List';
    PageType = List;
    Editable = false;
    CardPageId = "Posted Periodics Header";
    SourceTable = "Periodics Processing Header";
    UsageCategory = Lists;
    SourceTableView = where(posted = const(true));

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
    begin
        SetRange("Entered By", UserId);
    end;
}
