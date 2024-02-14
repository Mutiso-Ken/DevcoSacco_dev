#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516203 "Loans Defaulters Aging -(Auto)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loans Defaulters Aging -Auto.rdlc';

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            DataItemTableView = sorting("Loan  No.") where(Posted = const(true));
            RequestFilterFields = Source, "Client Code", "Loan Product Type", "Outstanding Balance", "Date filter", "Issued Date", "Employer Code", "Loan  No.";
            column(VarNo; VarNo)
            {
            }
            column(ReportForNavId_4645; 4645)
            {
            }
            column(Client_Code; "Client Code")
            {
            }


            column(Issued_Date; "Issued Date")
            {
            }
            column(DateOutstandingBal; DateOutstandingBal)
            {
            }
            column(LoanPerfoming; LoanPerfoming)
            {
            }
            column(LoanWatch; LoanWatch)
            {
            }
            column(LoanSubstandard; LoanSubstandard)
            {
            }
            column(LoanDoubtful; LoanDoubtful)
            {
            }
            column(LoanLoss; LoanLoss)
            {
            }
            column(BOSANo_Loans; "Loans Register"."BOSA No")
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
            column(Loans__Loan__No__; "Loan  No.")
            {
            }
            column(Loans__Loan_Product_Type_; "Loan Product Type")
            {
            }
            column(Loans_Loans__Staff_No_; "Loans Register"."Staff No")
            {
            }
            column(Loans__Client_Name_; "Client Name")
            {
            }
            column(Loans_Loans__Outstanding_Balance_; "Loans Register"."Outstanding Balance")
            {
            }
            column(V2Month_; "2Month")
            {
            }
            column(V3Month_; "3Month")
            {
            }
            column(Over3Month; Over3Month)
            {
            }
            column(V1Month_; "1Month")
            {
            }
            column(V0Month_; "0Month")
            {
            }
            column(Loans_Loans__Outstanding_Balance__Control1000000016; "Loans Register"."Outstanding Balance")
            {
            }
            column(Loans__Approved_Amount_; "Approved Amount")
            {
            }
            column(Loans_Loans__Interest_Due_; "Loans Register"."Interest Due")
            {
            }
            column(V1MonthC_; "1MonthC")
            {
            }
            column(V2MonthC_; "2MonthC")
            {
            }
            column(V3MonthC_; "3MonthC")
            {
            }
            column(Over3MonthC; Over3MonthC)
            {
            }
            column(NoLoans; NoLoans)
            {
            }
            column(GrandTotal; GrandTotal)
            {
            }
            column(V0Month__Control1102760031; "0Month")
            {
            }
            column(V1Month__Control1102760032; "1Month")
            {
            }
            column(V2Month__Control1102760033; "2Month")
            {
            }
            column(V3Month__Control1102760034; "3Month")
            {
            }
            column(Over3Month_Control1102760035; Over3Month)
            {
            }
            column(V0MonthC_; "0MonthC")
            {
            }
            column(Loans_Aging_Analysis__SASRA_Caption; Loans_Aging_Analysis__SASRA_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Loans__Loan__No__Caption; FieldCaption("Loan  No."))
            {
            }
            column(Loan_TypeCaption; Loan_TypeCaptionLbl)
            {
            }
            column(Staff_No_Caption; Staff_No_CaptionLbl)
            {
            }
            column(Loans__Client_Name_Caption; FieldCaption("Client Name"))
            {
            }
            column(Oustanding_BalanceCaption; Oustanding_BalanceCaptionLbl)
            {
            }
            column(PerformingCaption; PerformingCaptionLbl)
            {
            }
            column(V1___30_Days_Caption; V1___30_Days_CaptionLbl)
            {
            }
            column(V0_Days_Caption; V0_Days_CaptionLbl)
            {
            }
            column(WatchCaption; WatchCaptionLbl)
            {
            }
            column(V31___180_Days_Caption; V31___180_Days_CaptionLbl)
            {
            }
            column(SubstandardCaption; SubstandardCaptionLbl)
            {
            }
            column(V181___360_Days_Caption; V181___360_Days_CaptionLbl)
            {
            }
            column(DoubtfulCaption; DoubtfulCaptionLbl)
            {
            }
            column(Over_360_DaysCaption; Over_360_DaysCaptionLbl)
            {
            }
            column(LossCaption; LossCaptionLbl)
            {
            }
            column(TotalsCaption; TotalsCaptionLbl)
            {
            }
            column(CountCaption; CountCaptionLbl)
            {
            }
            column(Grand_TotalCaption; Grand_TotalCaptionLbl)
            {
            }
            column(Lbal; LBalance)
            {
            }
            trigger OnAfterGetRecord()
            begin
                //-------------------------------------------------------------------
                LoanRec.reset;
                LoanRec.SetFilter(LoanRec."Date filter", DateFilter);
                LoanRec.SetRange(LoanRec.Posted, true);
                LoanRec.SetAutoCalcFields(LoanRec."Outstanding Balance");
                LoanRec.SetRange(LoanRec."Loan  No.", "Loans Register"."Loan  No.");
                IF LoanRec.Find('-') then begin
                    repeat
                        DateOutstandingBal := 0;
                        LoanPerfoming := 0;
                        LoanWatch := 0;
                        LoanSubstandard := 0;
                        LoanDoubtful := 0;
                        LoanLoss := 0;
                        SasraClassificationCodeUnit.ClassifyLoansSASRA(LoanRec."Loan  No.", DateFilter);
                        //...............................Get LoanBal AsAt Filter Date

                        DateOutstandingBal := LoanRec."Outstanding Balance";
                        //................................Loan Categories Now
                        LoanPerfoming := 0;
                        LoanWatch := 0;
                        LoanSubstandard := 0;
                        LoanDoubtful := 0;
                        LoanLoss := 0;
                        Commit();
                        //..................................
                        case LoanRec."Loans Category-SASRA" of
                            LoanRec."Loans Category-SASRA"::Perfoming:
                                begin
                                    LoanPerfoming := DateOutstandingBal;
                                end;
                            LoanRec."Loans Category-SASRA"::Watch:
                                begin
                                    LoanWatch := DateOutstandingBal;
                                end;
                            LoanRec."Loans Category-SASRA"::Substandard:
                                begin
                                    LoanSubstandard := DateOutstandingBal;
                                end;
                            LoanRec."Loans Category-SASRA"::Doubtful:
                                begin
                                    LoanDoubtful := DateOutstandingBal;
                                end;
                            LoanRec."Loans Category-SASRA"::Loss:
                                begin
                                    LoanLoss := DateOutstandingBal;
                                end;
                        end;
                    until LoanRec.Next = 0;
                end else
                    CurrReport.Skip();
                VarNo := VarNo + 1;
            end;

            trigger OnPreDataItem()
            begin

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
        "1Month": Decimal;
        VarNo: Integer;
        SasraClassificationCodeUnit: Codeunit "Loan Classification-SASRA";
        ClassifyLoans: Codeunit "Generate Loan Performance";
        "2Month": Decimal;
        "3Month": Decimal;
        Over3Month: Decimal;
        ShowLoan: Boolean;
        AsAt: Date;
        LastDueDate: Date;
        DFormula: DateFormula;
        "0MonthC": Integer;
        "1MonthC": Integer;
        "2MonthC": Integer;
        "3MonthC": Integer;
        Over3MonthC: Integer;
        NoLoans: Integer;
        PhoneNo: Text[30];
        Cust: Record Customer;
        "StaffNo.": Text[30];
        Deposits: Decimal;
        GrandTotal: Decimal;
        "0Month": Decimal;
        LoanProduct: Record "Loan Products Setup";
        FirstMonthDate: Date;
        EndMonthDate: Date;
        Loans_Aging_Analysis__SASRA_CaptionLbl: label 'Loans Aging Analysis (SASRA)';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Loan_TypeCaptionLbl: label 'Loan Type';
        Staff_No_CaptionLbl: label 'Staff No.';
        Oustanding_BalanceCaptionLbl: label 'Oustanding Balance';
        PerformingCaptionLbl: label 'Performing';
        V1___30_Days_CaptionLbl: label '(1 - 30 Days)';
        V0_Days_CaptionLbl: label '(0 Days)';
        WatchCaptionLbl: label 'Watch';
        V31___180_Days_CaptionLbl: label '(31 - 180 Days)';
        SubstandardCaptionLbl: label 'Substandard';
        V181___360_Days_CaptionLbl: label '(181 - 360 Days)';
        DoubtfulCaptionLbl: label 'Doubtful';
        Over_360_DaysCaptionLbl: label 'Over 360 Days';
        LossCaptionLbl: label 'Loss';
        TotalsCaptionLbl: label 'Totals';
        CountCaptionLbl: label 'Count';
        Grand_TotalCaptionLbl: label 'Grand Total';
        CustLedger: Record "Cust. Ledger Entry";
        LBalance: Decimal;
        Criteria: Option " ","Use Date","Use Schedule";
        LoanRec: Record "Loans Register";
        PrPaid: Decimal;
        PrExp: Decimal;
        outInt: Decimal;
        Variance: Decimal;
        LowerLimit: Date;
        UpperLimit: Date;
        Expected: Decimal;
        Paid: Decimal;
        AmountInArrears: Decimal;
        NoOfMonthsInArrears: Decimal;
        LoansDefaulterAging: Codeunit UpdateLoanClassification;
        DateFilter: Text;
        DateOutstandingBal: Decimal;
        LoanPerfoming: Decimal;
        LoanWatch: Decimal;
        LoanSubstandard: Decimal;
        LoanDoubtful: Decimal;
        LoanLoss: Decimal;

    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        LoanPerfoming := 0;
        LoanWatch := 0;
        LoanSubstandard := 0;
        LoanDoubtful := 0;
        LoanLoss := 0;
        DateFilter := "Loans Register".GetFilter("Loans Register"."Date filter");
        if DateFilter = '' then begin
            DateFilter := '..' + Format(Today);
        end;
    end;

    trigger OnPostReport()
    begin

    end;


}

