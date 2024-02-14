#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516044 "SUREPESA Transactions"
{
    ApplicationArea = Basic;
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "SurePESA Transactions";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document No"; "Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; "Account No")
                {
                    ApplicationArea = Basic;

                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Telephone Number"; "Telephone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;

                    TableRelation = "Vendor"."Name";
                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {

    }

    trigger OnOpenPage()
    begin
        SetCurrentKey("Document Date");
        Ascending(false);
    end;

}


