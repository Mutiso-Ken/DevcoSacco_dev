#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516061 "RFQ Subform"
{
    PageType = ListPart;
    SourceTable = "Purchase Quote Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // field("Amount Applied";"Amount Applied")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Appl. Doc. Type";"Appl. Doc. Type")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Appl. Doc. Original Amount";"Appl. Doc. Original Amount")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Appl. Doc. Amount";"Appl. Doc. Amount")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Appl.Doc. Amount Including VAT";"Appl.Doc. Amount Including VAT")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Appl. Doc. VAT Rate";"Appl. Doc. VAT Rate")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Direct Unit Cost";"Direct Unit Cost")
                // {
                //     ApplicationArea = Basic;
                // }
                // field(Amount;Amount)
                // {
                //     ApplicationArea = Basic;
                // }
                // field("PRF No";"PRF No")
                // {
                //     ApplicationArea = Basic;
                //     Visible = false;
                // }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Purchase Quote Params")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quote Params';

                trigger OnAction()
                var
                   // PParams: Record UnknownRecord51516058;
                begin
                    
                    /*PParams.RESET;
                    PParams.SETRANGE(PParams."Document Type","Document Type");
                    PParams.SETRANGE(PParams."Document No.","Line No.");
                    PParams.SETRANGE(PParams."Line No.",Amount);
                    PAGE.RUN(51516064,PParams);*/

                end;
            }
        }
    }
}

