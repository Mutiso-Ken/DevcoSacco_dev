page 51516145 "Member Re-Application Page"
{
    ApplicationArea = All;
    Caption = 'Member Re-Application Page';
    PageType = Card;
    SourceTable = "Member Reapplication";
    
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Editable=false;
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field("Member Name"; Rec."Member Name")
                {
                    ToolTip = 'Specifies the value of the Member Name field.';
                         Editable=false;
                }
                field("Reason for Re-Application"; Rec."Reason for Re-Application")
                {
                    ToolTip = 'Specifies the value of the Reason for Re-Application field.';
                }
                field("Reason for Exit"; Rec."Reason for Exit")
                {
                    ToolTip = 'Specifies the value of the Reason for Exit field.';
                         Editable=false;
                }
                field("Re-Application By"; Rec."Re-Application By")
                {
                    ToolTip = 'Specifies the value of the Re-Application By field.';
                         Editable=false;
                }
                field("Re-Application On"; Rec."Re-Application On")
                {
                    ToolTip = 'Specifies the value of the Re-Application On field.';
                         Editable=false;
                }
                field("Re-Application status"; Rec."Re-Application status")
                {
                    ToolTip = 'Specifies the value of the Re-Application status field.';
                         Editable=false;
                }
                field("Status on Exit"; Rec."Status on Exit")
                {
                    ToolTip = 'Specifies the value of the Status on Exit field.';
                         Editable=false;
                }
                field("Exit Date"; Rec."Exit Date")
                {
                    ToolTip = 'Specifies the value of the Exit Date field.';
                         Editable=false;
                }
                field("Exited By"; Rec."Exited By")
                {
                    ToolTip = 'Specifies the value of the Exited By field.';
                         Editable=false;
                }
            }
        }
    }
}
