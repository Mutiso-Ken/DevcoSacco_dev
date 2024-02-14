#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516579 "PAYBILL Transactions"
{
    ApplicationArea = Basic;
    CardPageID = "posted paybills card";
    PageType = List;
    SourceTable = "CloudPESA MPESA Trans";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No"; "Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; "Account No")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Account Name"; "Account Name")
                {
                    Caption = 'Sender Name';

                    ApplicationArea = Basic;
                }

                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    visible = false;
                    ApplicationArea = Basic;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                }

                field(Telephone; Telephone)
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted"; "Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Paybill Acc Balance"; "Paybill Acc Balance")
                {
                    ApplicationArea = Basic;
                }

                field("Key Word"; "Key Word")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Needs Manual Posting"; "Needs Manual Posting")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Basic;
                }

            }


        }
    }

    actions
    {

        area(Navigation)
        {
            action(Refresh)
            {

                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Refresh;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin

        SetCurrentKey("Transaction Date");
        Ascending(false);

        // if "Account No" <> '' then begin
        //     "Destination Acc" := Accounts.Name;

        // end;
    end;



    var
        Accounts: Record Customer;

}

