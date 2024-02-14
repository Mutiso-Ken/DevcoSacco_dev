#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516150 "Posted Imprest List"
{
    Caption = 'Staff Travel  List';
   // CardPageID = "Posted Imprest Request";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Imprest Header";
    SourceTableView = where(Posted=filter(true));

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field("Total Net Amount";"Total Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Surrender Status";"Surrender Status")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print/Preview")
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ImprestHeader.Reset;
                    ImprestHeader.SetRange(ImprestHeader."No.","No.");
                    Report.Run(51516130,true,false, ImprestHeader);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GLEntry.Reset;
        GLEntry.SetRange("Document No.","No.");
        if not GLEntry.FindFirst then begin
          Posted:=false;
          Modify;
          end;
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE(Cashier,USERID );
    end;

    var
        ImprestHeader: Record "Imprest Header";
        GLEntry: Record "G/L Entry";
}

