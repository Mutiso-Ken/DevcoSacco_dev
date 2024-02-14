#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516850 "Micro_Finance_Transactions Lis"
{
    ApplicationArea = Basic;
    Caption = 'C.E.E.P Transactions List';
    CardPageID = Micro_Fin_Transactions;
    Editable = false;
    DeleteAllowed = true;
    PageType = List;
    SourceTable = Micro_Fin_Transactions;
    SourceTableView = where(Posted = const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Group Name"; "Group Name")
                {
                    Style = StrongAccent;
                }
                field("Group Code"; "Group Code")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Total Amount"; "Total Amount")
                {
                    ApplicationArea = Basic;
                }

                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Posted By"; "Posted By")
                {
                    ApplicationArea = Basic;
                }
                field("Activity Code"; "Activity Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        SetRange("Posted By", UserId);
        Ascending(false)
    end;
}

