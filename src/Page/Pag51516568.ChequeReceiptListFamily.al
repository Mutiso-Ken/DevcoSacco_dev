#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516568 "Cheque Receipt List-Family"
{
    ApplicationArea = Basic;
    CardPageID = "Cheque Receipt Header-Family";
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = true;
    PageType = List;
    SourceTable = "Cheque Receipts-Family";
    UsageCategory = Lists;
    SourceTableView = where(Posted = const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Refference Document"; "Refference Document")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("No of Cheques"; "No of Cheques")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Posted By"; "Posted By")
                {
                    ApplicationArea = Basic;
                }
                field(Imported; Imported)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Processed; Processed)
                {
                    ApplicationArea = Basic;
                    Visible = false;

                }
                field("Document Name"; "Document Name")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                }
                field("Bank Account"; "Bank Account")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Unpaid By"; "Unpaid By")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Unpaid; Unpaid)
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
        Ascending(false)
    end;
}

