#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 51516065 "fosaloansapplicationlist"
{
    CardPageID = fosaloansapplicationcard;
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Loans Register";
    SourceTableView = where(Posted = filter(false), "Loan Product Type" = filter(<> 'OKOA' | 'OVERDRAFT'), Source = const(FOSA));
    layout
    {
        area(content)
        {
            repeater(Control14)
            {
                field("Loan  No."; "Loan  No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Loan Application Date';
                }
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Client Name"; "Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }


                field("BOSA No"; "BOSA No")
                {
                    ApplicationArea = Basic;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount Applied';
                    Style = Unfavorable;
                }

                field("Loan Status"; "Loan Status")
                {
                    ApplicationArea = Basic;
                    Style = Ambiguous;
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = Basic;
                    Style = Ambiguous;
                }
                field("Captured By"; "Captured By")
                {

                }

            }
        }
        area(factboxes)
        {
            part("FOSA Statistics FactBox"; "FOSA Statistics FactBox")
            {
                SubPageLink = "No." = field("Account No");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {

        }
    }

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        LoansReg: Record "Loans Register";
    begin
    end;

    trigger OnOpenPage()
    begin
        SetRange("Captured By", UserId);
        Ascending(false)
        //SetFilter("Loan Product Type", '<>%1|<>%2', 'OVERDRAFT', 'OKOA');
    end;

    var

}


