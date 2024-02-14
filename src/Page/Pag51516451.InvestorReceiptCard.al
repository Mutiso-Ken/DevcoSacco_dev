#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516451 "Investor Receipt Card"
{
    PageType = Card;
    SourceTable = "Receipt Header";
    SourceTableView = where("Receipt Category"=const(Investor),
                            Posted=const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Investor No.";"Investor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Name";"Investor Name")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Code";"Interest Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Code";"Bank Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Balance";"Bank Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Received From";"Received From")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Amount Received";"Amount Received")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Amount Received(LCY)";"Amount Received(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount(LCY)";"Total Amount(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Net Amount";"Investor Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Net Amount(LCY)";"Investor Net Amount(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control22;"Investor Receipt Lines")
            {
                SubPageLink = "Document No"=field("No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Post Receipt")
            {
                ApplicationArea = Basic;
                Caption = 'Post Receipt';
                Image = PostPrint;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //TESTFIELD(Status,Status::Approved);
                    CalcFields("Investor Net Amount","Investor Net Amount(LCY)","Total Amount");
                    if "Total Amount"<>"Amount Received" then
                      Error('The amount received entered must be equal to the total amount in lines');
                    ok:=Confirm('Post Receipt No:'+Format("No.")+'. The Investor account will be credited with KES:'+Format("Investor Net Amount(LCY)")+' Continue?');
                    if ok then begin
                      DocNo:="No.";
                      if FundsUser.Get(UserId) then begin
                        FundsUser.TestField(FundsUser."Receipt Journal Template");
                        FundsUser.TestField(FundsUser."Receipt Journal Batch");
                        JTemplate:=FundsUser."Receipt Journal Template";JBatch:=FundsUser."Receipt Journal Batch";
                        PostedEntry:=FundsManager.PostInvestorReceipt(Rec,JTemplate,JBatch);
                    
                        /*IF PostedEntry THEN BEGIN
                          ReceiptHeader.RESET;
                          ReceiptHeader.SETRANGE(ReceiptHeader."No.",DocNo);
                          IF ReceiptHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Investor Receipt",TRUE,FALSE,ReceiptHeader);
                          END;
                        END;*/
                      end else begin
                        Error('User Account Not Setup');
                      end;
                    end;

                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                      ReceiptHeader.Reset;
                      ReceiptHeader.SetRange(ReceiptHeader."No.",DocNo);
                      if ReceiptHeader.FindFirst then begin
                        Error('DEV');
                        // Report.RunModal(Report::"Investor Receipt",true,false,ReceiptHeader);
                      end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
            "Receipt Category":="receipt category"::Investor;
    end;

    var
        FundsManager: Codeunit "Funds Management";
        JTemplate: Code[20];
        JBatch: Code[20];
        FundsUser: Record "Funds User Setup";
        ok: Boolean;
        ReceiptHeader: Record "Receipt Header";
        PostedEntry: Boolean;
        DocNo: Code[20];
}

