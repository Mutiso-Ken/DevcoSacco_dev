#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516601 "Over draft Application Card-P"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Over Draft Register";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Over Draft No";"Over Draft No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                field("Overdraft Repayment Start Date";"Overdraft Repayment Start Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Overdraft Repayment Completion";"Overdraft Repayment Completion")
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
                field("Outstanding Draft Per OD";"Outstanding Draft Per OD")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Draft';
                    Editable = false;
                }
                field("Outstanding Overdraft";"Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Outstanding Overdraft';
                    Editable = false;
                }
                field("Oustanding Overdraft Interest";"Oustanding Overdraft Interest")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Amount applied";"Amount applied")
                {
                    ApplicationArea = Basic;
                }
                field("Overdraft period(Months)";"Overdraft period(Months)")
                {
                    ApplicationArea = Basic;
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
                    Enabled = false;
                }
                field("Overdraft security";"Overdraft security")
                {
                    ApplicationArea = Basic;

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
                field("Running Overdraft";"Running Overdraft")
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
            action(Terminate)
            {
                ApplicationArea = Basic;
                Image = BreakRulesOn;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Cust.Reset;
                    Cust.SetRange(Cust."Over Draft No","Over Draft No");
                    if Cust.Find('-') then begin
                      Cust."Running Overdraft":=false;
                      Cust."Overdraft Status":=Cust."Overdraft Status";
                      Cust.Modify;
                      end
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
        Landvisible: Boolean;
        Salaryvisible: Boolean;
        Motorvisible: Boolean;
        SFactory: Codeunit "SURESTEP Factory";
        EditableField: Boolean;
        BATCH_TEMPLATE: Code[100];
        BATCH_NAME: Code[100];
        DOCUMENT_NO: Code[100];
        CommisionOnOverdraft: Decimal;

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
        //1.----------------------DEDIT FOSA A/C(Commission on Overdraft)--------------------------------------------------------------------------------------------
        if  currentbal>=CommisionOnOverdraft then begin
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."transaction type"::"0",GenJournalLine."account type"::Vendor,
        "Account No",Today,ROUND(CommisionOnOverdraft,0.05,'>'),'FOSA','OV'+"Account No","Account No"+' Commission on Overdraft','',
        GenJournalLine."account type"::"G/L Account",overdraftSetup."Commission A/c");
        "commission charged":=true;
        end;
        //2.----------------------CREDIT INCOME G/L(Interest on Overdraft)--------------------------------------------------------------------------------------------
        if  currentbal>=(CommisionOnOverdraft+("Interest Rate"*"Approved Amount")/100) then begin
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLineBalancedCashier(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."transaction type"::"0",GenJournalLine."account type"::Vendor,
        "Account No",Today,("Interest Rate"*"Approved Amount")/100,'FOSA','OV'+"Account No","Account No"+' Overdraft Int Charged','',
        GenJournalLine."account type"::"G/L Account",overdraftSetup."Interest Income A/c",DOCUMENT_NO,GenJournalLine."overdraft codes"::"Interest Accrued");
        "Interest Charged":=true;
        end;
         GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name",BATCH_TEMPLATE);
        GenJournalLine.SetRange("Journal Batch Name",BATCH_NAME);
        if GenJournalLine.Find('-') then
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco21",GenJournalLine);
        Modify;
        Message('Overdraft succesfully processed.');
    end;
}

