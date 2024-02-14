#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 51516976 Receivetellercashlist
{
    ApplicationArea = Basic;
    CardPageID = ReceiveTellerCash;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Treasury Transactions";
    UsageCategory = Tasks;
    SourceTableView = where(Issued = const(Yes), "Transaction Type" = filter('Issue To Teller' | 'Issue From Bank'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; No)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;

                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = Basic;

                }
                field("From Account"; "From Account")
                {
                    ApplicationArea = Basic;
                }
                field("To Account"; "To Account")
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
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field("Received By"; "Received By")
                {

                }
            }
        }
    }

    actions
    {
    }
      trigger OnOpenPage()
    begin
        Ascending(false);
    end;
}

