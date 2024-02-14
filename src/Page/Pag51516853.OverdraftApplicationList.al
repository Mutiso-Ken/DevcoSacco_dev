#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516853 "Over draft Application List"
{
    ApplicationArea = Basic;
    CardPageID = "Over draft Application Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Over Draft Register";
    SourceTableView = where(Posted = const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Over Draft No"; "Over Draft No")
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; "Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Application date"; "Application date")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = Basic;
                }
                field("Captured by"; "Captured by")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Current Account No"; "Current Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Outstanding Overdraft"; "Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                }
                field("Amount applied"; "Amount applied")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    local procedure PostOverdraft()
    begin
    end;
}

