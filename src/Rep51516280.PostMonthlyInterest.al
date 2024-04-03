// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Report 51516280 "Post Monthly Interest."
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Layouts/Post Monthly Interest..rdlc';

//     dataset
//     {
//         dataitem("Loans Register"; "Loans Register")
//         {
//             CalcFields = "Outstanding Balance";
//             RequestFilterFields = "Issued Date", "Date filter", Source, "Employer Code", "Loan  No.", "Client Code", "Account No", "Loan Product Type", "Outstanding Balance", "Interest Due", "Interest Paid", "Repayment Start Date";
//             column(ReportForNavId_4645; 4645)
//             {
//             }
//             column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
//             {
//             }
//             column(COMPANYNAME; COMPANYNAME)
//             {
//             }
//             column(CurrReport_PAGENO; CurrReport.PageNo)
//             {
//             }
//             column(USERID; UserId)
//             {
//             }
//             column(Loans__Loan__No__; "Loan  No.")
//             {
//             }
//             column(Loans__Application_Date_; "Application Date")
//             {
//             }
//             column(Loans__Loan_Product_Type_; "Loan Product Type")
//             {
//             }
//             column(Loans__Client_Code_; "Client Code")
//             {
//             }
//             column(Loans__Client_Name_; "Client Name")
//             {
//             }
//             column(Loans__Outstanding_Balance_; "Outstanding Balance")
//             {
//             }
//             column(Loan_Application_FormCaption; Loan_Application_FormCaptionLbl)
//             {
//             }
//             column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Loans__Loan__No__Caption; FieldCaption("Loan  No."))
//             {
//             }
//             column(Loans__Application_Date_Caption; FieldCaption("Application Date"))
//             {
//             }
//             column(Loans__Loan_Product_Type_Caption; FieldCaption("Loan Product Type"))
//             {
//             }
//             column(Loans__Client_Code_Caption; FieldCaption("Client Code"))
//             {
//             }
//             column(Loans__Client_Name_Caption; FieldCaption("Client Name"))
//             {
//             }
//             column(Loans__Outstanding_Balance_Caption; FieldCaption("Outstanding Balance"))
//             {
//             }
//             column(amount; Amount)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 PDate := "Loans Register".GetRangemax("Loans Register"."Date filter");
//                 SDATE := '..' + Format(PDate);
//                 loanapp.Reset;
//                 loanapp.SetRange(loanapp."Loan  No.", "Loan  No.");
//                 loanapp.SetRange(loanapp."Check Int", false);
//                 loanapp.SetFilter(loanapp."Date filter", SDATE);

//                 if loanapp.Find('-') then begin
//                     loanapp.CalcFields(loanapp."Outstanding Balance");
//                     if loanapp."Outstanding Balance" > 0 then begin
//                         LineNo := LineNo + 10000;

//                         GenJournalLine.Init;
//                         GenJournalLine."Journal Template Name" := 'General';
//                         GenJournalLine."Journal Batch Name" := 'INT DUE';
//                         GenJournalLine."Line No." := LineNo;
//                         GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
//                         GenJournalLine."Account No." := loanapp."Client Code";
//                         GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Due";
//                         GenJournalLine.Validate(GenJournalLine."Account No.");
//                         GenJournalLine."Document No." := DocNo;
//                         GenJournalLine."Posting Date" := PostDate;
//                         GenJournalLine.Description := DocNo + ' ' + 'Interest charged';
//                         GenJournalLine.Amount := ROUND(loanapp."Outstanding Balance" * (loanapp.Interest / 1200), 0.05, '>');
//                         if loanapp."Repayment Method" = loanapp."repayment method"::"Straight Line" then
//                             GenJournalLine.Amount := ROUND(loanapp."Approved Amount" * (loanapp.Interest / 1200), 0.05, '>');
//                         GenJournalLine.Validate(GenJournalLine.Amount);
//                         if LoanType.Get(loanapp."Loan Product Type") then begin
//                             GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
//                             GenJournalLine."Bal. Account No." := LoanType."Loan Interest Account";
//                             GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
//                         end;

//                         if loanapp.Source = loanapp.Source::BOSA then begin
//                             GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
//                         end else
//                             if loanapp.Source = loanapp.Source::FOSA then begin
//                                 GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
//                             end else
//                                 if loanapp.Source = loanapp.Source::MICRO then
//                                     GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
//                         GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
//                         GenJournalLine."Shortcut Dimension 2 Code" := FnGetMemberBranch(loanapp."Client Code");
//                         GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
//                         GenJournalLine."Loan No" := loanapp."Loan  No.";
//                         //IF (GenJournalLine.Amount<>0) AND (loanapp.Source<>loanapp.Source::FOSA) THEN
//                         if (GenJournalLine.Amount <> 0) then
//                             GenJournalLine.Insert;
//                     end;
//                 end;
//                 /*
//                 //Post New
//                 GenJournalLine.RESET;
//                 GenJournalLine.SETRANGE("Journal Template Name",'General');
//                 GenJournalLine.SETRANGE("Journal Batch Name",'INT DUE');
//                 IF GenJournalLine.FIND('-') THEN BEGIN
//                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post B",GenJournalLine);
//                 END; */
//                 //Post New

//             end;

//             trigger OnPostDataItem()
//             begin
//                 /*//Post New
//                 GenJournalLine.RESET;
//                 GenJournalLine.SETRANGE("Journal Template Name",Jtemplate);
//                 GenJournalLine.SETRANGE("Journal Batch Name",JBatch);
//                 IF GenJournalLine.FIND('-') THEN BEGIN
//                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post B",GenJournalLine);
//                 END;
//                 //Post New */

//             end;

//             trigger OnPreDataItem()
//             begin
//                 if PostDate = 0D then
//                     Error('Please create Interest period');

//                 if DocNo = '' then
//                     Error('You must specify the Document No.');


//                 //delete journal line
//                 GenJournalLine.Reset;
//                 GenJournalLine.SetRange("Journal Template Name", 'General');
//                 GenJournalLine.SetRange("Journal Batch Name", 'INT DUE');
//                 GenJournalLine.DeleteAll;
//                 //end of deletion

//                 GenBatches.Reset;
//                 GenBatches.SetRange(GenBatches."Journal Template Name", 'General');
//                 GenBatches.SetRange(GenBatches.Name, 'INT DUE');
//                 if GenBatches.Find('-') = false then begin
//                     GenBatches.Init;
//                     GenBatches."Journal Template Name" := 'General';
//                     GenBatches.Name := 'INT DUE';
//                     GenBatches.Description := 'Interest Due';
//                     //GenBatches.VALIDATE(GenBatches."Journal Template Name");
//                     //GenBatches.VALIDATE(GenBatches.Name);
//                     GenBatches.Insert;
//                 end;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 field(PostDate; PostDate)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Posting Date';
//                     Editable = true;
//                 }
//                 field(DocNo; DocNo)
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Document No.';
//                     Editable = true;
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnInitReport()
//     begin
//         //Accounting periods
//         AccountingPeriod.SetRange(AccountingPeriod.Closed, false);
//         if AccountingPeriod.Find('-') then begin
//             FiscalYearStartDate := AccountingPeriod."Interest Calcuation Date";
//             PostDate := (FiscalYearStartDate);
//             DocNo := AccountingPeriod.Name + '  ' + Format(PostDate);
//         end;
//         //Accounting periods
//     end;

//     var
//         GenBatches: Record "Gen. Journal Batch";
//         PDate: Date;
//         LoanType: Record "Loan Products Setup";
//         PostDate: Date;
//         Cust: Record Customer;
//         LineNo: Integer;
//         DocNo: Code[20];
//         GenJournalLine: Record "Gen. Journal Line";
//         GLPosting: Codeunit "Gen. Jnl.-Post Line";
//         EndDate: Date;
//         DontCharge: Boolean;
//         Temp: Record "Funds User Setup";
//         JBatch: Code[10];
//         Jtemplate: Code[10];
//         CustLedger: Record "Cust. Ledger Entry";
//         AccountingPeriod: Record "Interest Due Period";
//         FiscalYearStartDate: Date;
//         "ExtDocNo.": Text[30];
//         Loan_Application_FormCaptionLbl: label 'Loan Application Form';
//         CurrReport_PAGENOCaptionLbl: label 'Page';
//         loanapp: Record "Loans Register";
//         SDATE: Text[30];
//         Amount: Decimal;
//         ObJMemberLedger: Record "Cust. Ledger Entry";

//     local procedure FnGetMemberBranch(MemberNo: Code[50]): Code[100]
//     var
//         MemberBranch: Code[100];
//     begin
//         Cust.Reset;
//         Cust.SetRange(Cust."No.", MemberNo);
//         if Cust.Find('-') then begin
//             MemberBranch := Cust."Global Dimension 2 Code";
//         end;
//         exit(MemberBranch);
//     end;
// }

