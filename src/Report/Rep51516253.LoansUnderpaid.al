#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516253 "Loans Underpaid"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loans Underpaid.rdlc';

    dataset
    {
        dataitem(Loans; "Loans Register")
        {
            DataItemTableView = sorting("Staff No") order(ascending);
            RequestFilterFields = Source, "Loan Product Type", "Date filter", "Application Date", "Loan Status", "Issued Date", Posted, "Batch No.", "Captured By", "Branch Code", "Outstanding Balance", "Loan  No.";
            column(ReportForNavId_4645; 4645)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(LoanType; LoanType)
            {
            }
            column(RFilters; RFilters)
            {
            }
            column(Loans__Loan__No__; "Loan  No.")
            {
            }
            column(Loans__Client_Code_; "Client Code")
            {
            }
            column(Loans__Client_Name_; "Client Name")
            {
            }
            column(Loans__Requested_Amount_; "Requested Amount")
            {
            }
            column(Loans__Approved_Amount_; "Approved Amount")
            {
            }
            column(Repayment; Repayment)
            {
            }
            column(Loans_Installments; Installments)
            {
            }
            column(Loans__Loan_Status_; "Loan Status")
            {
            }
            column(Loans_Loans__Outstanding_Balance_; Loans."Outstanding Balance")
            {
            }
            column(Loans__Application_Date_; "Application Date")
            {
            }
            column(Loans__Issued_Date_; "Issued Date")
            {
            }
            column(Loans__Oustanding_Interest_; "Oustanding Interest")
            {
            }
            column(Loans_Loans__Loan_Product_Type_; Loans."Loan Product Type")
            {
            }
            column(Loans__Last_Pay_Date_; "Last Pay Date")
            {
            }
            column(Loans__Top_Up_Amount_; "Top Up Amount")
            {
            }
            column(Loans__Approved_Amount__Control1102760017; "Approved Amount")
            {
            }
            column(Loans__Requested_Amount__Control1102760038; "Requested Amount")
            {
            }
            column(LCount; LCount)
            {
            }
            column(Loans_Loans__Outstanding_Balance__Control1102760040; Loans."Outstanding Balance")
            {
            }
            column(Loans__Oustanding_Interest__Control1102760041; "Oustanding Interest")
            {
            }
            column(Loans__Top_Up_Amount__Control1000000001; "Top Up Amount")
            {
            }
            column(Loans_RegisterCaption; Loans_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Loan_TypeCaption; Loan_TypeCaptionLbl)
            {
            }
            column(Loans__Loan__No__Caption; FieldCaption("Loan  No."))
            {
            }
            column(Client_No_Caption; Client_No_CaptionLbl)
            {
            }
            column(Loans__Client_Name_Caption; FieldCaption("Client Name"))
            {
            }
            column(Loans__Requested_Amount_Caption; FieldCaption("Requested Amount"))
            {
            }
            column(Loans__Approved_Amount_Caption; FieldCaption("Approved Amount"))
            {
            }
            column(Loans__Loan_Status_Caption; FieldCaption("Loan Status"))
            {
            }
            column(Outstanding_LoanCaption; Outstanding_LoanCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(Loans__Application_Date_Caption; FieldCaption("Application Date"))
            {
            }
            column(Approved_DateCaption; Approved_DateCaptionLbl)
            {
            }
            column(Loans__Oustanding_Interest_Caption; FieldCaption("Oustanding Interest"))
            {
            }
            column(Loan_TypeCaption_Control1102760043; Loan_TypeCaption_Control1102760043Lbl)
            {
            }
            column(Loans__Last_Pay_Date_Caption; FieldCaption("Last Pay Date"))
            {
            }
            column(Loans__Top_Up_Amount_Caption; FieldCaption("Top Up Amount"))
            {
            }
            column(Verified_By__________________________________________________Caption; Verified_By__________________________________________________CaptionLbl)
            {
            }
            column(Confirmed_By__________________________________________________Caption; Confirmed_By__________________________________________________CaptionLbl)
            {
            }
            column(Sign________________________Caption; Sign________________________CaptionLbl)
            {
            }
            column(Sign________________________Caption_Control1102755003; Sign________________________Caption_Control1102755003Lbl)
            {
            }
            column(Date________________________Caption; Date________________________CaptionLbl)
            {
            }
            column(Date________________________Caption_Control1102755005; Date________________________Caption_Control1102755005Lbl)
            {
            }
            column(Lbal; LBalance)
            {
            }
            column(TOTRep; Loans."Total Repayment")
            {
            }
            column(VARIANCE; MonthlyREP + Loans."Total Repayment")
            {
            }
            column(MonthlyREP; MonthlyREP)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //Datefilter:=Loans.GETRANGEMAX(Loans."Date filter");
                LBalance := 0;
                MonthlyREP := 0;


                if Loans."Monthly Repayment" <> 0 then
                    MonthlyREP := Loans."Monthly Repayment"
                else
                    MonthlyREP := Loans.Repayment;



                CustLedger.Reset;
                CustLedger.SetRange(CustLedger."Loan No", Loans."Loan  No.");
                //CustLedger.SETRANGE(CustLedger."Transaction Type",CustLedger."Transaction Type"::"Interest Due");
                CustLedger.SetRange(CustLedger."Posting Date", 0D, DateFilterr);
                //CustLedger.SETRANGE(CustLedger.Open,TRUE);
                if CustLedger.Find('-') then begin
                    repeat

                        if (CustLedger."Transaction Type" = CustLedger."transaction type"::Loan) or
                        (CustLedger."Transaction Type" = CustLedger."transaction type"::Repayment) then begin

                            LBalance := LBalance + CustLedger.Amount;

                        end;
                    until
                    CustLedger.Next = 0;
                end;

                /*
                BOSABal:=0;
                SuperBal:=0;
                Deposits:=0;
                LCount:=LCount+1;
                CompanyCode:='';
                
                LocationFilter:='';
                RPeriod:=Loans.Installments;
                IF (Loans."Outstanding Balance" > 0) AND (Loans.Repayment > 0) THEN
                RPeriod:=Loans."Outstanding Balance"/Loans.Repayment;
                
                BatchL:='';
                IF Batches.GET(Loans."Batch No.") THEN BEGIN
                Batches.CALCFIELDS(Batches."Currect Location");
                BatchL:=Batches."Currect Location";
                END;
                
                IF Loans.GETFILTER(Loans."Location Filter") <> '' THEN  BEGIN
                ApprovalSetup.RESET;
                ApprovalSetup.SETRANGE(ApprovalSetup."Approval Type",ApprovalSetup."Approval Type"::"File Movement");
                ApprovalSetup.SETFILTER(ApprovalSetup.Stage,Loans.GETFILTER(Loans."Location Filter"));
                IF ApprovalSetup.FIND('-') THEN
                LocationFilter:=ApprovalSetup.Station;
                END;
                
                IF LocationFilter = '' THEN
                TotalApproved:=TotalApproved+Loans."Approved Amount"
                ELSE BEGIN
                IF LocationFilter = BatchL THEN
                TotalApproved:=TotalApproved+Loans."Approved Amount"
                END;
                
                //Get balance of BOSA Loans + super loans
                IF (Loans.Source=Loans.Source::BOSA) OR (Loans."Loan Product Type"='SUPER') THEN BEGIN
                cust.RESET;
                cust.SETRANGE(cust."No.",Loans."Client Code");
                cust.SETRANGE(cust."Customer Type",cust."Customer Type"::Member);
                IF cust.FIND('-') THEN BEGIN
                cust.CALCFIELDS(cust."Outstanding Balance",cust."Current Shares");
                BOSABal:=cust."Outstanding Balance";
                Deposits:=ABS(cust."Current Shares");
                CompanyCode:=cust."Employer Code";
                END ELSE BEGIN
                cust.RESET;
                cust.SETRANGE(cust."No.",Loans."BOSA No");
                cust.SETRANGE(cust."Customer Type",cust."Customer Type"::Member);
                
                IF cust.FIND('-') THEN BEGIN
                cust.CALCFIELDS(cust."Outstanding Balance",cust."Current Shares");
                BOSABal:=cust."Outstanding Balance";
                Deposits:=ABS(cust."Current Shares");
                CompanyCode:=cust."Employer Code";
                
                END;
                END;
                LAppl.RESET;
                LAppl.SETRANGE(LAppl."Client Code",Loans."Account No");
                LAppl.SETRANGE(LAppl."Loan Product Type",'SUPER');
                LAppl.SETFILTER(LAppl."Outstanding Balance",'>0');
                LAppl.SETRANGE(LAppl.Posted,TRUE);
                IF LAppl.FIND('-') THEN BEGIN
                REPEAT
                LAppl.CALCFIELDS(LAppl."Outstanding Balance");
                SuperBal:=SuperBal+LAppl."Outstanding Balance";
                UNTIL LAppl.NEXT=0;
                END;
                END;
                
                //Loans."Net Amount":=Loans."Approved Amount"-Loans."Top Up Amount";
                
                //Get The Loan Type
                */

                CompanyCode := '';
                if cust.Get(Loans."BOSA No") then
                    CompanyCode := cust."Employer Code";

                LCount := LCount + 1;

            end;

            trigger OnPreDataItem()
            begin
                if LoanProdType.Get(Loans.GetFilter(Loans."Loan Product Type")) then
                    LoanType := LoanProdType."Product Description";
                LCount := 0;

                if Loans.GetFilter(Loans."Branch Code") <> '' then begin
                    DValue.Reset;
                    DValue.SetRange(DValue."Global Dimension No.", 2);
                    DValue.SetRange(DValue.Code, Loans.GetFilter(Loans."Branch Code"));
                    if DValue.Find('-') then
                        RFilters := 'Branch: ' + DValue.Name;

                end;



                //Datefilter:=Loans.GETRANGEMAX(Loans."Date filter");
                //Loans.SETRANGE(Loans."Date filter",0D,Datefilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        RPeriod: Decimal;
        BatchL: Code[100];
        Batches: Record "Loan Disburesment-Batching";
        LocationFilter: Code[20];
        TotalApproved: Decimal;
        cust: Record Customer;
        BOSABal: Decimal;
        SuperBal: Decimal;
        LAppl: Record "Loans Register";
        Deposits: Decimal;
        CompanyCode: Code[20];
        LoanType: Text[50];
        LoanProdType: Record "Loan Products Setup";
        LCount: Integer;
        RFilters: Text[250];
        DValue: Record "Dimension Value";
        VALREPAY: Record "Cust. Ledger Entry";
        Loans_RegisterCaptionLbl: label 'Loans Register';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Loan_TypeCaptionLbl: label 'Loan Type';
        Client_No_CaptionLbl: label 'Client No.';
        Outstanding_LoanCaptionLbl: label 'Outstanding Loan';
        PeriodCaptionLbl: label 'Period';
        Approved_DateCaptionLbl: label 'Approved Date';
        Loan_TypeCaption_Control1102760043Lbl: label 'Loan Type';
        Verified_By__________________________________________________CaptionLbl: label 'Verified By..................................................';
        Confirmed_By__________________________________________________CaptionLbl: label 'Confirmed By..................................................';
        Sign________________________CaptionLbl: label 'Sign........................';
        Sign________________________Caption_Control1102755003Lbl: label 'Sign........................';
        Date________________________CaptionLbl: label 'Date........................';
        Date________________________Caption_Control1102755005Lbl: label 'Date........................';
        Datefilter: Date;
        CustLedger: Record "Cust. Ledger Entry";
        DateFilterr: Date;
        LBalance: Decimal;
        MonthlyREP: Decimal;
}

