#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516926 "Okoa Application Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Okoa Register";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Over Draft No";"Over Draft No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa No';
                    Editable = false;
                }
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account No';
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
                field("Overdraft Repayment Start Date";"Overdraft Repayment Start Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa Repayment Start Date';
                    Editable = false;
                }
                field("Overdraft Repayment Completion";"Overdraft Repayment Completion")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa Repayment Completion';
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
                field("Outstanding Draft Per OD";"Outstanding Draft Per OD")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Okoa Per OD';
                }
                field("Outstanding Overdraft";"Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Outstanding Okoa';
                    Editable = false;
                }
                field("Oustanding Overdraft Interest";"Oustanding Overdraft Interest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Oustanding Okoa Interest';
                    Editable = false;
                }
                field("Net Overdraft";"Net Overdraft")
                {
                    ApplicationArea = Basic;
                    Caption = 'Requested Amount';
                }
                field("Amount applied";"Amount applied")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recommended Amount';
                    Editable = true;
                }
                field("Overdraft period(Months)";"Overdraft period(Months)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa period(Months)';
                }
                field("Override Interest Rate";"Override Interest Rate")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        EditableField:=false;
                        if "Override Interest Rate" then
                        EditableField:=true;
                    end;
                }
                field("Interest Rate";"Interest Rate")
                {
                    ApplicationArea = Basic;
                    Editable = EditableField;
                }
                field("Monthly Overdraft Repayment";"Monthly Overdraft Repayment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Okoa Repayment';
                    Editable = false;
                }
                field("Monthly Interest Repayment";"Monthly Interest Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Interest Charged";"Total Interest Charged")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                field("Overdraft Status";"Overdraft Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa Status';
                    Enabled = false;
                }
                field("Overdraft security";"Overdraft security")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa security';

                    trigger OnValidate()
                    begin
                        Landvisible:=false;
                        Motorvisible:=false;
                        Salaryvisible:=false;
                        if "Overdraft security"="overdraft security"::"Motor Vehicle" then begin
                          Motorvisible:=true;
                          end;
                          if "Overdraft security"="overdraft security"::Land then begin
                            Landvisible:=true;
                            end;
                            if "Overdraft security"="overdraft security"::Salary then begin
                              Salaryvisible:=true;
                              end;
                    end;
                }
                field("Do not Charge Commision";"Do not Charge Commision")
                {
                    ApplicationArea = Basic;
                }
                field("Recovery Mode";"Recovery Mode")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Salary)
            {
                Caption = 'Salary';
                Visible = Salaryvisible;
                field("Basic salary";"Basic salary")
                {
                    ApplicationArea = Basic;
                }
                field(Employer;Employer)
                {
                    ApplicationArea = Basic;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Basic;
                }
                field("Terms Of Employment";"Terms Of Employment")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Motor Vehicle")
            {
                Caption = 'Motor Vehicle';
                Visible = Motorvisible;
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Registration Number";"Registration Number")
                {
                    ApplicationArea = Basic;
                }
                field("Current Value";"Current Value")
                {
                    ApplicationArea = Basic;
                }
                field(Multpliers;Multpliers)
                {
                    ApplicationArea = Basic;
                }
                field("Amount to secure Overdraft";"Amount to secure Overdraft")
                {
                    ApplicationArea = Basic;
                }
                field(insured;insured)
                {
                    ApplicationArea = Basic;
                }
                field("Insurance Company";"Insurance Company")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Land)
            {
                Caption = 'Land';
                Visible = Landvisible;
                field("Land deed No";"Land deed No")
                {
                    ApplicationArea = Basic;
                }
                field("Land acrage";"Land acrage")
                {
                    ApplicationArea = Basic;
                }
                field("Land location";"Land location")
                {
                    ApplicationArea = Basic;
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
                Image = SendApprovalRequest;
                Promoted = true;

                trigger OnAction()
                begin
                    
                    if Posted=true then begin
                    Error("Over Draft No"+'Already posted');
                    end else
                    TestField("Account No") ;
                    TestField("Current Account No") ;
                    TestField("Amount applied");
                    TestField("Recovery Mode");
                    //TESTFIELD("Interest Rate");
                    TestField("Overdraft period(Months)");
                    Status:=Status::Approved;
                    Message('Approved succesfully');
                    Modify;
                    if Status=Status::Approved then
                      "Approved Date":=Today;
                    
                      /*
                      IF Status<>Status::Open THEN
                      ERROR(Text001);
                    
                    {//End allocate batch number
                    Doc_Type:=Doc_Type::Interbank;
                    Table_id:=DATABASE::"Funds Transfer Header";
                    IF ApprovalMgt.SendApproval(Table_id,"No.",Doc_Type,Status)THEN;}
                    
                    IF ApprovalMgt.CheckBOSATransWorkflowEnabled(Rec) THEN
                      ApprovalMgt.OnSendBOSATransForApproval(Rec);
                    */

                end;
            }
            action("Reject Request")
            {
                ApplicationArea = Basic;
                Image = Reject;
                Promoted = true;

                trigger OnAction()
                begin
                    Status:=Status::Open;
                    Message('Application rejected');
                    Modify;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Image = Post;
                Promoted = true;

                trigger OnAction()
                begin
                    TestField(Status,Status::Approved);
                    if Posted=true then begin
                    Error("Over Draft No"+'Already posted');
                    end else
                    if "Overdraft period(Months)">1 then begin
                      Error('Okoa Biashara Months cannot be greater than 1 Months');
                      end else
                      /*
                    IF "Outstanding Overdraft">0 THEN BEGIN
                      ERROR('Overdraft Months cannot be greater than 3 Months');
                      END ELSE
                      */
                    TestField("Account No") ;
                    TestField("Approved Date") ;
                    TestField("Current Account No") ;
                    overdraftno:='';
                    TestField("Amount applied");
                    TestField("Overdraft Repayment Start Date");
                    //----------------------Get Ordinary account...................................................................................
                    if vend."Account Type"='ORDINARY'then
                    vend.Reset;
                    vend.SetRange(vend."No.","Account No");
                    if vend.Find('-')then begin
                      "Approved Amount":="Amount applied";
                      vend."Overdraft amount":="Approved Amount";
                      //vend."Oustanding Overdraft interest":="Total Interest Charged";
                      vend.Modify;
                      end;
                      PostOverdraft();
                      "Posted By":=UserId;
                      Posted:=true;
                      "Time Posted":=Time;
                      "Overdraft Status":="overdraft status"::Active;
                      "Running Overdraft":=true;
                      vend.Modify;
                      Modify;
                    
                    OVED.Reset;
                    OVED.SetRange("Account No","Account No");
                    OVED.SetFilter("Over Draft No",'<>%1',"Over Draft No");
                    if OVED.Find('-') then begin
                      repeat
                        OVED."Overdraft Status":=OVED."overdraft status"::Inactive;
                        OVED.Modify;
                      until OVED.Next=0;
                      end

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
                    Report.Run(51516281,true,false,Cust);
                end;
            }
        }
    }

    var
        Gnljnline: Record "Gen. Journal Line";
        LineN: Integer;
        vend: Record Vendor;
        overdraftno: Code[30];
        Cust: Record "Okoa Register";
        LineNo: Integer;
        UserSetup: Record "User Setup";
        GenSetup: Record "Sacco General Set-Up";
        DValue: Record "Dimension Value";
        OverdraftBank: Code[10];
        GenJournalLine: Record "Gen. Journal Line";
        OverdraftAut: Record "Okoa Authorisationx";
        LneNo: Integer;
        OVED: Record "Okoa Register";
        Landvisible: Boolean;
        Salaryvisible: Boolean;
        Motorvisible: Boolean;
        SFactory: Codeunit "SURESTEP Factory";
        EditableField: Boolean;
        BATCH_TEMPLATE: Code[100];
        BATCH_NAME: Code[100];
        DOCUMENT_NO: Code[100];
        CommisionOnOverdraft: Decimal;
        Period: Code[10];

    local procedure PostOverdraft()
    var
        OverdraftAcc: Record "Over Draft Register";
        OVERBAL: Decimal;
        RemainAmount: Decimal;
        Overdraftbank: Code[10];
        dbanch: Code[50];
        balanceov: Decimal;
        vendoroverdraft: Record Vendor;
        BALRUN: Decimal;
        OVERDRAFTREC: Record Vendor;
        "overdraftcomm a/c": Code[10];
        vendor2: Record Vendor;
        commoverdraft: Decimal;
        overdraftSetup: Record "Overdraft Setup";
        currentbal: Decimal;
    begin
        BATCH_TEMPLATE:='PURCHASES';
        BATCH_NAME:='FTRANS';
        DOCUMENT_NO:="Over Draft No";
        currentbal:=0;
        overdraftSetup.Get();

        vendoroverdraft.Reset;
        vendoroverdraft.SetRange(vendoroverdraft."No.","Account No");
        if vendoroverdraft.Find('-') then begin
        vendoroverdraft.CalcFields(vendoroverdraft.Balance);
        currentbal:=vendoroverdraft.Balance;
        end;





        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name",'PURCHASES');
        GenJournalLine.SetRange("Journal Batch Name",'FTRANS');
        GenJournalLine.DeleteAll;

        CommisionOnOverdraft:=overdraftSetup."Overdraft Commision Charged";

        LineNo:=0;


        //1.----------------------CREDIT FOSA A/C WITH OVERDRAFT AMOUNT---------------------------------------------------APPROVED AMOUNT-------------------------------------------------

        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLineBalancedCashier(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."transaction type"::"0",GenJournalLine."account type"::Vendor,
        "Account No",Today,"Approved Amount"*-1,'FOSA',"Over Draft No",Format("Overdraft period(Months)")+' Month Okoa Biashara Issued','',
        GenJournalLine."account type"::"G/L Account",'1533',"Over Draft No",GenJournalLine."overdraft codes"::"Overdraft Granted");

        //2.----------------------CREDIT FOSA A/C WITH OVERDRAFT CHARGE-------------------------------------------APPROVED AMOUNT * INTEREST RATE-------------------------------------------------

        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLineBalancedCashier(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."transaction type"::"0",GenJournalLine."account type"::Vendor,
        "Account No",Today,(("Approved Amount"*"Interest Rate")*-1)/100,'FOSA',"Over Draft No",'Okoa Biashara Interest','',
        GenJournalLine."account type"::"G/L Account",'1533',"Over Draft No",GenJournalLine."overdraft codes"::"Overdraft Granted");

        //3.----------------------CREDIT FOSA A/C WITH FORM CHARGE---------------------------------------------------COMMISSION-------------------------------------------------
        if not "Do not Charge Commision" then begin
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLineBalancedCashier(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."transaction type"::"0",GenJournalLine."account type"::Vendor,
        "Account No",Today,CommisionOnOverdraft*-1,'FOSA',"Over Draft No",'Okoa Biashara Commision','',
        GenJournalLine."account type"::"G/L Account",'1533',"Over Draft No",GenJournalLine."overdraft codes"::"Overdraft Granted");

        //4.----------------------DEBIT FOSA A/C(Recover Commission on Overdraft Form)--------------------------------------------------------------------------------------------


        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."transaction type"::"0",GenJournalLine."account type"::Vendor,
        "Account No",Today,CommisionOnOverdraft,'FOSA',"Account No",'Commission on Overdraft','',
        GenJournalLine."account type"::"G/L Account",'5500');
        "commission charged":=true;
        end;


        //5.----------------------CREDIT INCOME G/L(Interest on Overdraft)--------------------------------------------------------------------------------------------

        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."transaction type"::"0",GenJournalLine."account type"::Vendor,
        "Account No",Today,("Approved Amount"*"Interest Rate")/100,'FOSA',"Account No",'Overdraft Int Charged','',
        GenJournalLine."account type"::"G/L Account",'5500');
        "Interest Charged":=true;

         GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name",BATCH_TEMPLATE);
        GenJournalLine.SetRange("Journal Batch Name",BATCH_NAME);
        if GenJournalLine.Find('-') then begin
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco",GenJournalLine);
        end;
        //END;
        Message('Okoa Biashara Successfully Credited.');
    end;
}

