#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516232 "Account Schedule Names List"
{
    Caption = 'Account Schedule Names';
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Acc. Schedule Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field("Default Column Layout"; "Default Column Layout")
                {
                    ApplicationArea = Basic;
                }
                field("Analysis View Name"; "Analysis View Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditAccountSchedule)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Account Schedule';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';

                trigger OnAction()
                var
                    AccSchedule: Page "Account Schedule";
                begin
                    AccSchedule.SetAccSchedName(Name);
                    AccSchedule.Run;
                end;
            }
            action(EditColumnLayoutSetup)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Column Layout Setup';
                Ellipsis = true;
                Image = SetupColumns;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ColumnLayout: Page "Column Layout";
                begin
                    ColumnLayout.SetColumnLayoutName("Default Column Layout");
                    ColumnLayout.Run;
                end;
            }
        }
        area(navigation)
        {
            action(Overview)
            {
                ApplicationArea = Basic;
                Caption = 'Overview';
                Ellipsis = true;
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AccSchedOverview: Page "Acc. Schedule Overview List";
                begin
                    AccSchedOverview.SetAccSchedName(Name);
                    AccSchedOverview.Run;
                end;
            }
        }
    }
}

