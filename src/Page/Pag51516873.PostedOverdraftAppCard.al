#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516873 "Posted Over draft App Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Over Draft Register";
    SourceTableView = where(Posted=const(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("Over Draft No";"Over Draft No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Over Draft Payoff";"Over Draft Payoff")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Application date";"Application date")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Date";"Approved Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Captured by";"Captured by")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Member No";"Current Account No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Outstanding Overdraft";"Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                }
                field("Amount applied";"Amount applied")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No";"Phone No")
                {
                    ApplicationArea = Basic;
                }
                field("Email Address";"Email Address")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Send Approval")
            {
                ApplicationArea = Basic;
                Enabled = false;
                Image = SendApprovalRequest;
                Promoted = true;

                trigger OnAction()
                begin
                    if Posted=true then begin
                    Error("Over Draft No"+'Already posted');
                    end else
                    TestField("Account No") ;
                    //TESTFIELD("Approved Date") ;
                    TestField("Current Account No") ;

                    Status:=Status::Approved;
                    Message('Approved succesfully');
                    Modify;
                    if Status=Status::Approved then
                      "Approved Date":=Today;
                end;
            }
            action("Reject Request")
            {
                ApplicationArea = Basic;
                Enabled = false;
                Image = Reject;
                Promoted = true;

                trigger OnAction()
                begin
                    Status:=Status::Open;
                    Message('application rejected');
                    Modify;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Enabled = false;
                Image = Post;
                Promoted = true;

                trigger OnAction()
                begin
                    if Posted=true then begin
                    Error("Over Draft No"+'Already posted');
                    end else
                    TestField("Account No") ;
                    TestField("Approved Date") ;
                    TestField("Current Account No") ;
                    overdraftno:='';
                    TestField("Amount applied");
                    //get Current account
                    if vend."Account Type"='CURRENT'then
                    vend.Reset;
                    vend.SetRange(vend."No.","Account No");
                    //vend.SETRANGE()
                    if vend.Find('-')then begin
                      "Approved Amount":="Amount applied";
                      vend."Overdraft amount":="Approved Amount";
                      vend.Modify;
                      end;

                    LneNo:=LneNo+10000;

                    OverdraftAut.Init;
                    OverdraftAut."Entry NO":=LneNo;
                    OverdraftAut."Over Draft No":="Over Draft No";
                    OverdraftAut."Account No":="Account No";
                    OverdraftAut."Account Name":="Account Name";
                    //IF "Outstanding Overdraft">0 THEN OverdraftAut."Approved Amount":="Outstanding Overdraft" ELSE
                    OverdraftAut."Approved Amount":="Approved Amount";
                    OverdraftAut."Approved Date":="Approved Date";
                    OverdraftAut."Current Account No":="Current Account No";
                    OverdraftAut."Captured by":="Captured by";
                    OverdraftAut."ID Number":="ID Number";
                    OverdraftAut."Over Draft Payoff":="Over Draft Payoff";
                    OverdraftAut.Status:=Status::Approved;
                    OverdraftAut."Overdraft Status":="overdraft status"::Active;
                    OverdraftAut."Document Type":="Document Type";
                    if "Approved Amount"<>0 then
                     OverdraftAut.Insert(true);
                    //END;

                        //end authorisation

                      Message('Over draft successfully updated');
                      "Posted By":=UserId;
                      Posted:=true;
                      "Time Posted":=Time;
                      "Overdraft Status":="overdraft status"::Active;
                      vend.Modify;
                      Modify;
                      //Postoverdraft;
                      //END;
                       //END;
                      //Postoverdraft

                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    TestField(Status,Status::Approved);
                    Cust.Reset;
                    Cust.SetRange(Cust."Account No","Account No");
                    Report.Run(51516301,true,false,Cust);
                end;
            }
        }
    }

    var
        Gnljnline: Record "Gen. Journal Line";
        LineN: Integer;
        vend: Record Vendor;
        overdraftno: Code[30];
        Cust: Record "Over Draft Register";
        LineNo: Integer;
        UserSetup: Record "User Setup";
        GenSetup: Record "Sacco General Set-Up";
        DValue: Record "Dimension Value";
        OverdraftBank: Code[10];
        GenJournalLine: Record "Gen. Journal Line";
        OverdraftAut: Record "Over Draft Authorisationx";
        LneNo: Integer;
        OVED: Record "Over Draft Register";

    local procedure Postoverdraft()
    begin

        //Post New
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name",'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name",'OVERDRAFT');
        if GenJournalLine.Find('-') then begin
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco21",GenJournalLine);
        end;

        //Post New
        Posted:=true;
        "Overdraft Status":="overdraft status"::Active;
        "Supervisor Checked":=true;
        "Date Posted":=Today;
        "Time Posted":=Time;
        "Posted By":=UserId;
        Modify;

        Message('Overdraft  posted successfully.');
        Cust.Reset;
        Cust.SetRange(Cust."Account No","Account No");
        if Cust.Find('-') then
        Report.Run(51516281,false,true,Cust);


        //END;
    end;
}

