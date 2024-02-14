#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516263 "Loan Appraisal- FOSA"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loan Appraisal- FOSA.rdlc';

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            DataItemTableView = sorting("Loan  No.");
            RequestFilterFields = "Loan  No.";
            column(ReportForNavId_4645; 4645)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(TODAY; Today)
            {
            }
            column(Initials; Initials)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo__E_Mail_; CompanyInfo."E-Mail")
            {
            }
            column(pic; CompanyInfo.Picture)
            {
            }
            column(Loans__Application_Date_; "Application Date")
            {
            }
            column(Psalary; Psalary)
            {
            }
            column(SHARES; SHARES)
            {
            }
            column(CHARGES; Charge)
            {
            }
            column(Qsalary; Qsalary)
            {
            }
            column(Lamount; Lamount)
            {
            }
            column(DepositReinstatement; "Deposit Reinstatement")
            {
            }
            column(TotalLoanBal; TotalLoanBal)
            {
            }
            column(UpfrontInt; UpfrontInt)
            {
            }
            column(Upfronts; Upfronts)
            {
            }
            column(Netdisbursed; Netdisbursed)
            {
            }
            column(StatDeductions; StatDeductions)
            {
            }
            column(TotalTopUpCommission_LoansRegister; "Total TopUp Commission")
            {
            }
            column(TotLoans; TotLoans)
            {
            }
            column(PrincipleRepayment; "Loans Register"."Loan Principle Repayment")
            {
            }
            column(InterestRepayment; "Loans Register"."Loan Interest Repayment")
            {
            }
            column(Loans__Loan__No__; "Loan  No.")
            {
            }
            column(Loans__Loan_Product_Type_; "Loan Product Type")
            {
            }
            column(Loans_Loans__Client_Code_; "Loans Register"."Client Code")
            {
            }
            column(LoansApprovedAmount; "Loans Register"."Approved Amount")
            {
            }
            column(Cust_Name; Cust.Name)
            {
            }
            column(Loans__Requested_Amount_; "Requested Amount")
            {
            }
            column(Loans__Staff_No_; "Staff No")
            {
            }
            column(NetSalary; NetSalary)
            {
            }
            column(Approved_Amounts; "Approved Amount")
            {
            }
            column(Reccom_Amount; Recomm)
            {
            }
            column(LOANBALANCE; LOANBALANCE)
            {
            }
            column(Loans_Installments; Installments)
            {
            }
            column(Loans__No__Of_Guarantors_; "No. Of Guarantors")
            {
            }
            column(Cshares_3; Cshares * 3)
            {
            }
            column(Cshares_3__LOANBALANCE_BRIDGEBAL_LOANBALANCEFOSASEC; (Cshares * 3) - LOANBALANCE + BRIDGEBAL - LOANBALANCEFOSASEC)
            {
            }
            column(Cshares; Cshares)
            {
            }
            column(LOANBALANCE_BRIDGEBAL; TotalLoanBal - BRIDGEBAL)
            {
            }
            column(Loans__Transport_Allowance_; "Transport Allowance")
            {
            }
            column(Loans__Employer_Code_; "Employer Code")
            {
            }
            column(Loans__Loan_Product_Type_Name_; "Loan Product Type Name")
            {
            }
            column(Loans__Loan__No___Control1102760138; "Loan  No.")
            {
            }
            column(Loans__Application_Date__Control1102760139; "Application Date")
            {
            }
            column(Loans__Loan_Product_Type__Control1102760140; "Loan Product Type")
            {
            }
            column(Loans_Loans__Client_Code__Control1102760141; "Loans Register"."Client Code")
            {
            }
            column(Cust_Name_Control1102760142; Cust.Name)
            {
            }
            column(Loans__Staff_No__Control1102760144; "Staff No")
            {
            }
            column(Loans_Installments_Control1102760145; Installments)
            {
            }
            column(Loans__No__Of_Guarantors__Control1102760146; "No. Of Guarantors")
            {
            }
            column(Loans__Requested_Amount__Control1102760143; "Requested Amount")
            {
            }
            column(Loans_Repayment; Repayment)
            {
            }
            column(Loans__Employer_Code__Control1102755075; "Employer Code")
            {
            }
            column(RecommendedAmount_LoansRegister; "Loans Register"."Recommended Amount")
            {
            }
            column(Interest_LoansRegister; "Loans Register".Interest)
            {
            }
            column(MAXAvailable; MAXAvailable)
            {
            }
            column(Cshares_Control1102760156; Cshares)
            {
            }
            column(BRIDGEBAL; BRIDGEBAL)
            {
            }
            column(LOANBALANCE_BRIDGEBAL_Control1102755006; LOANBALANCE - BRIDGEBAL)
            {
            }
            column(DEpMultiplier; DEpMultiplier)
            {
            }
            column(DefaultInfo; DefaultInfo)
            {
            }
            column(RecomRemark; RecomRemark)
            {
            }
            column(Recomm; Recomm)
            {
            }
            column(BasicEarnings; BasicEarnings)
            {
            }
            column(GShares; GShares)
            {
            }
            column(GShares_TGuaranteedAmount; GShares - TGuaranteedAmount)
            {
            }
            column(Msalary; Msalary)
            {
            }
            column(MAXAvailable_Control1102755031; MAXAvailable)
            {
            }
            column(Recomm_TOTALBRIDGED; Recomm - TOTALBRIDGED)
            {
            }
            column(GuarantorQualification; GuarantorQualification)
            {
            }
            column(Requested_Amount__MAXAvailable; "Requested Amount" - MAXAvailable)
            {
            }
            column(Requested_Amount__Msalary; "Requested Amount" - Msalary)
            {
            }
            column(Requested_Amount__GShares; "Requested Amount" - GShares)
            {
            }
            column(Loan_Appraisal_AnalysisCaption; Loan_Appraisal_AnalysisCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Loan_Application_DetailsCaption; Loan_Application_DetailsCaptionLbl)
            {
            }
            column(Loans__Application_Date_Caption; FieldCaption("Application Date"))
            {
            }
            column(Loans__Loan__No__Caption; FieldCaption("Loan  No."))
            {
            }
            column(Loan_TypeCaption; Loan_TypeCaptionLbl)
            {
            }
            column(MemberCaption; MemberCaptionLbl)
            {
            }
            column(Amount_AppliedCaption; Amount_AppliedCaptionLbl)
            {
            }
            column(Loans__Staff_No_Caption; FieldCaption("Staff No"))
            {
            }
            column(Loans_InstallmentsCaption; FieldCaption(Installments))
            {
            }
            column(Deposits__3Caption; Deposits__3CaptionLbl)
            {
            }
            column(Eligibility_DetailsCaption; Eligibility_DetailsCaptionLbl)
            {
            }
            column(Maxim__Amount_Avail__for_the_LoanCaption; Maxim__Amount_Avail__for_the_LoanCaptionLbl)
            {
            }
            column(Outstanding_LoanCaption; Outstanding_LoanCaptionLbl)
            {
            }
            column(Member_DepositsCaption; Member_DepositsCaptionLbl)
            {
            }
            column(Loans__No__Of_Guarantors_Caption; FieldCaption("No. Of Guarantors"))
            {
            }
            column(Loans__Transport_Allowance_Caption; FieldCaption("Transport Allowance"))
            {
            }
            column(Loans__Employer_Code_Caption; FieldCaption("Employer Code"))
            {
            }
            column(Loans__No__Of_Guarantors__Control1102760146Caption; FieldCaption("No. Of Guarantors"))
            {
            }
            column(Loans_Installments_Control1102760145Caption; FieldCaption(Installments))
            {
            }
            column(Loans__Staff_No__Control1102760144Caption; FieldCaption("Staff No"))
            {
            }
            column(Amount_AppliedCaption_Control1102760132; Amount_AppliedCaption_Control1102760132Lbl)
            {
            }
            column(MemberCaption_Control1102760133; MemberCaption_Control1102760133Lbl)
            {
            }
            column(Loan_TypeCaption_Control1102760134; Loan_TypeCaption_Control1102760134Lbl)
            {
            }
            column(Loans__Application_Date__Control1102760139Caption; FieldCaption("Application Date"))
            {
            }
            column(Loans__Loan__No___Control1102760138Caption; FieldCaption("Loan  No."))
            {
            }
            column(Loan_Application_DetailsCaption_Control1102760151; Loan_Application_DetailsCaption_Control1102760151Lbl)
            {
            }
            column(RepaymentCaption; RepaymentCaptionLbl)
            {
            }
            column(Loans__Employer_Code__Control1102755075Caption; FieldCaption("Employer Code"))
            {
            }
            column(Maxim__Amount_Avail__for_the_LoanCaption_Control1102760150; Maxim__Amount_Avail__for_the_LoanCaption_Control1102760150Lbl)
            {
            }
            column(Total_Outstand__Loan_BalanceCaption; Total_Outstand__Loan_BalanceCaptionLbl)
            {
            }
            column(Deposits___MulitiplierCaption; Deposits___MulitiplierCaptionLbl)
            {
            }
            column(Member_DepositsCaption_Control1102760148; Member_DepositsCaption_Control1102760148Lbl)
            {
            }
            column(Deposits_AnalysisCaption; Deposits_AnalysisCaptionLbl)
            {
            }
            column(Bridged_AmountCaption; Bridged_AmountCaptionLbl)
            {
            }
            column(Out__Balance_After_Top_upCaption; Out__Balance_After_Top_upCaptionLbl)
            {
            }
            column(Recommended_AmountCaption; Recommended_AmountCaptionLbl)
            {
            }
            column(Net_Loan_Disbursement_Caption; Net_Loan_Disbursement_CaptionLbl)
            {
            }
            column(V3__Qualification_as_per_GuarantorsCaption; V3__Qualification_as_per_GuarantorsCaptionLbl)
            {
            }
            column(Defaulter_Info_Caption; Defaulter_Info_CaptionLbl)
            {
            }
            column(V2__Qualification_as_per_SalaryCaption; V2__Qualification_as_per_SalaryCaptionLbl)
            {
            }
            column(V1__Qualification_as_per_SharesCaption; V1__Qualification_as_per_SharesCaptionLbl)
            {
            }
            column(QUALIFICATIONCaption; QUALIFICATIONCaptionLbl)
            {
            }
            column(Insufficient_Deposits_to_cover_the_loan_applied__RiskCaption; Insufficient_Deposits_to_cover_the_loan_applied__RiskCaptionLbl)
            {
            }
            column(WARNING_Caption; WARNING_CaptionLbl)
            {
            }
            column(Salary_is_Insufficient_to_cover_the_loan_applied__RiskCaption; Salary_is_Insufficient_to_cover_the_loan_applied__RiskCaptionLbl)
            {
            }
            column(WARNING_Caption_Control1000000140; WARNING_Caption_Control1000000140Lbl)
            {
            }
            column(WARNING_Caption_Control1000000141; WARNING_Caption_Control1000000141Lbl)
            {
            }
            column(Guarantors_do_not_sufficiently_cover_the_loan__RiskCaption; Guarantors_do_not_sufficiently_cover_the_loan__RiskCaptionLbl)
            {
            }
            column(WARNING_Caption_Control1000000020; WARNING_Caption_Control1000000020Lbl)
            {
            }
            column(Shares_Deposits_BoostedCaption; Shares_Deposits_BoostedCaptionLbl)
            {
            }
            column(DepX; DepX)
            {
            }
            column(TwoThird; TwoThirds)
            {
            }
            column(LPrincipal; LPrincipal)
            {
            }
            column(LInterest; LInterest)
            {
            }
            column(LNumber; LNumber)
            {
            }
            column(TotalLoanDeductions; TotalLoanDeductions)
            {
            }
            column(TotalRepayments; TotalRepayments)
            {
            }
            column(Totalinterest; Totalinterest)
            {
            }
            column(Band; Band)
            {
            }
            column(NtTakeHome; NtTakeHome)
            {
            }
            column(ATHIRD; ATHIRD)
            {
            }
            column(BridgedRepayment; BridgedRepayment)
            {
            }
            column(BRIGEDAMOUNT; BRIGEDAMOUNT)
            {
            }
            column(Signature__________________Caption; Signature__________________CaptionLbl)
            {
            }
            column(Date___________________Caption; Date___________________CaptionLbl)
            {
            }
            column(General_Manger______________________Caption; General_Manger______________________CaptionLbl)
            {
            }
            column(Signature__________________Caption_Control1102760039; Signature__________________Caption_Control1102760039Lbl)
            {
            }
            column(Date___________________Caption_Control1102760040; Date___________________Caption_Control1102760040Lbl)
            {
            }
            column(Signature__________________Caption_Control1102755017; Signature__________________Caption_Control1102755017Lbl)
            {
            }
            column(Date___________________Caption_Control1102755018; Date___________________Caption_Control1102755018Lbl)
            {
            }
            column(Loans_Officer______________________Caption; Loans_Officer______________________CaptionLbl)
            {
            }
            column(Chairman_Signature______________________Caption; Chairman_Signature______________________CaptionLbl)
            {
            }
            column(Secretary_s_Signature__________________Caption; Secretary_s_Signature__________________CaptionLbl)
            {
            }
            column(Members_Signature______________________Caption; Members_Signature______________________CaptionLbl)
            {
            }
            column(Credit_Committe_Minute_No______________________Caption; Credit_Committe_Minute_No______________________CaptionLbl)
            {
            }
            column(Date___________________Caption_Control1102755074; Date___________________Caption_Control1102755074Lbl)
            {
            }
            column(Comment______________________________________________________________________________________Caption; Comment______________________________________________________________________________________CaptionLbl)
            {
            }
            column(Loans_Asst__Officer______________________Caption; Loans_Asst__Officer______________________CaptionLbl)
            {
            }
            dataitem("Loan Appraisal Salary Details"; "Loan Appraisal Salary Details")
            {
                DataItemLink = "Client Code" = field("Client Code"), "Loan No" = field("Loan  No.");
                DataItemTableView = sorting("Loan No", "Client Code", Code);
                PrintOnlyIfDetail = false;
                column(ReportForNavId_3518; 3518)
                {
                }
                column(Appraisal_Salary_Details__Client_Code_; "Client Code")
                {
                }
                column(Appraisal_Salary_Details_Code; Code)
                {
                }
                column(Appraisal_Salary_Details_Description; Description)
                {
                }
                column(Appraisal_Salary_Details_Type; Type)
                {
                }
                column(Appraisal_Salary_Details_Amount; Amount)
                {
                }
                column(Earnings; Earnings)
                {
                }
                column(Deductions; Deductions)
                {
                }
                column(Earnings_Deductions___Earnings__1_3; (Earnings - Deductions) - (Earnings) * 1 / 3)
                {
                }
                column(Earnings__1_3; (Earnings) * 1 / 3)
                {
                }
                column(Net_Salary; NetSalary)
                {
                }
                column(Msalary_Control1102755030; Msalary)
                {
                }
                column(Appraisal_Salary_Details__Client_Code_Caption; FieldCaption("Client Code"))
                {
                }
                column(Appraisal_Salary_Details_CodeCaption; FieldCaption(Code))
                {
                }
                column(Appraisal_Salary_Details_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(Appraisal_Salary_Details_TypeCaption; FieldCaption(Type))
                {
                }
                column(Appraisal_Salary_Details_AmountCaption; FieldCaption(Amount))
                {
                }
                column(Salary_Details_AnalysisCaption; Salary_Details_AnalysisCaptionLbl)
                {
                }
                column(Total_EarningsCaption; Total_EarningsCaptionLbl)
                {
                }
                column(Total_DeductionsCaption; Total_DeductionsCaptionLbl)
                {
                }
                column(Net_SalaryCaption; Net_SalaryCaptionLbl)
                {
                }
                column(Qualification_as_per_SalaryCaption; Qualification_as_per_SalaryCaptionLbl)
                {
                }
                column(V1_3_of_Gross_PayCaption; V1_3_of_Gross_PayCaptionLbl)
                {
                }
                column(GuarOutstanding; GuarOutstanding)
                {
                }
                column(OTHERDEDUCTIONS; OTHERDEDUCTIONS)
                {
                }
            }
            dataitem("Loans Guarantee Details"; "Loans Guarantee Details")
            {
                DataItemLink = "Loan No" = field("Loan  No.");
                DataItemTableView = sorting("Loan No", "Member No") where("Amont Guaranteed" = filter(<> 0));
                PrintOnlyIfDetail = false;
                column(ReportForNavId_5140; 5140)
                {
                }
                column(Amont_Guarant; "Loan No")
                {
                }
                column(Name; Name)
                {
                }
                column(AmontGuaranteed_LoansGuaranteeDetails; "Loans Guarantee Details"."Amont Guaranteed")
                {
                }
                column(Guarantor_Memb_No; "Loans Guarantee Details"."Member No")
                {
                }
                column(G_Shares; "Loans Guarantee Details".Shares)
                {
                }
                column(Loan_Guarant; "Loan No")
                {
                }
                column(Guarantor_Outstanding; "Guarantor Outstanding")
                {
                }
                column(Employer_code; "Employer Code")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    if CustRecord.Get("Loans Guarantee Details"."Member No") then begin
                        //CustRecord.CALCFIELDS(CustRecord."Current Savings",CustRecord."Principal Balance");
                        TShares := TShares + CustRecord."Current Savings";
                        TLoans := TLoans + CustRecord."Principal Balance";
                    end;

                    //GuaranteedAmount:=0;
                    LoanG.Reset;

                    LoanG.SetRange(LoanG."Member No", "Member No");
                    LoanG.SetRange(LoanG."Loan No", "Loan No");
                    if LoanG.Find('-') then begin
                        repeat
                            GuaranteedAmount += LoanG."Amont Guaranteed";
                            GuarOutstanding := LoanG."Guarantor Outstanding";

                        until LoanG.Next = 0;
                    end;
                    TGuaranteedAmount := GuaranteedAmount;
                end;

            }
            dataitem("Loan Offset Details"; "Loan Offset Details")
            {
                DataItemLink = "Loan No." = field("Loan  No.");
                DataItemTableView = where("Total Top Up" = filter(> 0));
                PrintOnlyIfDetail = false;
                column(ReportForNavId_4717; 4717)
                {
                }
                column(Loans_Top_up__Principle_Top_Up_; "Principle Top Up")
                {
                }
                column(Loans_Top_up__Loan_Type_; Ttype)
                {
                }
                column(Loans_Top_up__Client_Code_; "Client Code")
                {
                }
                column(Loans_Top_up__Loan_No__; "Loan No.")
                {
                }
                column(Loans_Top_up__Total_Top_Up_; "Principle Top Up" + "Interest Top Up" + Commision)
                {
                }
                column(Loans_Top_up__Interest_Top_Up_; "Interest Top Up")
                {
                }
                column(Loan_Type; "Loan Offset Details"."Loan Type")
                {
                }
                column(Loans_Top_up_Commision; Commision)
                {
                }
                column(Loans_Top_up__Principle_Top_Up__Control1102760116; "Principle Top Up")
                {
                }
                column(BrTopUpCom; BrTopUpCom)
                {
                }
                column(TOTALBRIDGED; TOTALBRIDGED)
                {
                }
                column(Loans_Top_up__Total_Top_Up__Control1102755050; "Total Top Up")
                {
                }
                column(Loans_Top_up_Commision_Control1102755053; Commision)
                {
                }
                column(Loans_Top_up__Interest_Top_Up__Control1102755055; "Interest Top Up")
                {
                }
                column(Total_TopupsCaption; Total_TopupsCaptionLbl)
                {
                }
                column(Bridged_LoansCaption; Bridged_LoansCaptionLbl)
                {
                }
                column(Loan_No_Caption; Loan_No_CaptionLbl)
                {
                }
                column(Loans_Top_up_CommisionCaption; FieldCaption(Commision))
                {
                }
                column(Principal_Top_UpCaption; Principal_Top_UpCaptionLbl)
                {
                }
                column(Loans_Top_up__Interest_Top_Up_Caption; FieldCaption("Interest Top Up"))
                {
                }
                column(Client_CodeCaption; Client_CodeCaptionLbl)
                {
                }
                column(Loan_TypeCaption_Control1102755059; Loan_TypeCaption_Control1102755059Lbl)
                {
                }
                column(TotalsCaption; TotalsCaptionLbl)
                {
                }
                column(Total_Amount_BridgedCaption; Total_Amount_BridgedCaptionLbl)
                {
                }
                column(Bridging_total_higher_than_the_qualifing_amountCaption; Bridging_total_higher_than_the_qualifing_amountCaptionLbl)
                {
                }
                column(WARNING_Caption_Control1102755044; WARNING_Caption_Control1102755044Lbl)
                {
                }
                column(Loans_Top_up_Loan_Top_Up; "Loan Top Up")
                {
                }
                column(WarnBridged; WarnBridged)
                {
                }
                column(WarnSalary; WarnSalary)
                {
                }
                column(WarnDeposits; WarnDeposits)
                {
                }
                column(WarnGuarantor; WarnGuarantor)
                {
                }
                column(WarnShare; WarnShare)
                {
                }
                column(LoanDefaultInfo; DefaultInfo)
                {
                }
                column(Riskamount; Riskamount)
                {
                }
                column(RiskDeposits; RiskDeposits)
                {
                }
                column(RiskGshares; RiskGshares)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    TotalTopUp := ROUND((TotalTopUp + "Principle Top Up"), 0.05, '>');
                    TotalIntPayable := TotalIntPayable + "Monthly Repayment";
                    GTotals := GTotals + ("Principle Top Up" + "Monthly Repayment");
                    if "Loans Register".Get("Loan Offset Details"."Loan No.") then begin
                        if LoanType.Get("Loans Register"."Loan Product Type") then
                            Ttype := LoanType."Product Description";
                    end;
                    //END;

                    TOTALBRIDGED := TOTALBRIDGED + "Loan Offset Details"."Total Top Up";

                    if TOTALBRIDGED > Recomm then
                        WarnBridged := UpperCase('WARNING: Bridging Total is Higher than the Qualifing Amount.')
                    else
                        WarnBridged := '';
                end;

                trigger OnPreDataItem()
                begin
                    BrTopUpCom := 0;
                    TOTALBRIDGED := 0;
                end;
            }
            dataitem("Other Commitements Clearance"; "Other Commitements Clearance")
            {
                DataItemLink = "Loan No." = field("Loan  No.");
                column(ReportForNavId_1000000049; 1000000049)
                {
                }
                column(LoanNo_OtherCommitementsClearance; "Loan No.")
                {
                }
                column(Description_OtherCommitementsClearance; "Other Commitements Clearance".Description)
                {
                }
                column(Payee_OtherCommitementsClearance; "Other Commitements Clearance".Payee)
                {
                }
                column(Amount_OtherCommitementsClearance; "Other Commitements Clearance".Amount)
                {
                }
                column(DateFilter_OtherCommitementsClearance; "Other Commitements Clearance"."Date Filter")
                {
                }
                column(BankersChequeNo_OtherCommitementsClearance; "Other Commitements Clearance"."Bankers Cheque No")
                {
                }
                column(BankersChequeNo2_OtherCommitementsClearance; "Other Commitements Clearance"."Bankers Cheque No 2")
                {
                }
                column(BankersChequeNo3_OtherCommitementsClearance; "Other Commitements Clearance"."Bankers Cheque No 3")
                {
                }
                column(BatchNo_OtherCommitementsClearance; "Other Commitements Clearance"."Batch No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                //Initials:=(COPYSTR(USERID,8));
                Cshares := 0;
                MAXAvailable := 0;
                LOANBALANCE := 0;
                TotalTopUp := 0;
                TotalIntPayable := 0;
                GTotals := 0;
                AmountGuaranteed := 0;
                TotLoans := 0;
                BInt := 0;
                UpfrontInt := 0;


                TotalSec := 0;
                TShares := 0;
                TLoans := 0;
                Earnings := 0;
                Deductions := 0;
                BASIC := 0;
                NetSalary := 0;
                Qsalary := 0;
                LoanPrincipal := 0;
                loanInterest := 0;
                Psalary := 0;
                TotalLoanBal := 0;
                TotalBand := 0;
                //NtTakeHome:=0;
                //NetDisburment:=0;
                TotalRepay := 0;



                //  Deposits analysis
                if Cust.Get("Loans Register"."Client Code") then begin
                    Cust.CalcFields(Cust."Current Shares");
                    Cshares := Cust."Current Shares";
                    if LoanType.Get("Loans Register"."Loan Product Type") then begin

                        //QUALIFICATION AS PER DEPOSITS

                        if "Loan Product Type" = 'J/L' then begin
                            DEpMultiplier := LoanType."Shares Multiplier" * (Cshares  + "Deposit Reinstatement")

                        end else begin
                            DEpMultiplier := LoanType."Shares Multiplier" * (Cshares + "Deposit Reinstatement");
                        end;

                        BridgedRepayment := 0;
                        TotalRepayments := 0;

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Client Code", "Client Code");
                        LoanApp.SetRange(LoanApp.Source, LoanApp.Source::BOSA);
                        LoanApp.SetRange(LoanApp.Posted, true);
                        if LoanApp.Find('-') then begin
                            repeat
                                //IF (LoanApp."Loan Product Type"='D/L') OR (LoanApp."Loan Product Type"='E/L')  OR  (LoanApp."Loan Product Type"='J/L') OR (LoanApp."Loan Product Type"='SELF') THEN BEGIN
                                LoanApp.CalcFields(LoanApp."Outstanding Balance", "Topup Commission");
                                if LoanApp."Outstanding Balance" > 0 then begin
                                    LOANBALANCE := LOANBALANCE + LoanApp."Outstanding Balance";
                                    TotalRepayments := TotalRepayments + LoanApp.Repayment;

                                end;
                            //END;
                            until LoanApp.Next = 0;
                        end;
                    end;
                    SHARES := 0;
                    Commision := 0;
                    Deeboster := 0;
                    TOpDeb := 0;
                    LoanTopUp.Reset;
                    LoanTopUp.SetRange(LoanTopUp."Loan No.", "Loans Register"."Loan  No.");
                    LoanTopUp.SetRange(LoanTopUp."Client Code", "Loans Register"."Client Code");
                    if LoanTopUp.Find('-') then begin
                        repeat
                            //BRIGEDAMOUNT:=BRIGEDAMOUNT+LoanTopUp."Principle Top Up";
                            BRIGEDAMOUNT := BRIGEDAMOUNT + LoanTopUp."Principle Top Up";
                            BInt := BInt + LoanTopUp."Interest Top Up";
                            Commision := Commision + LoanTopUp.Commision;
                        until LoanTopUp.Next = 0;

                    end;
                    if LoanType.Get("Loan Product Type") then begin
                        //IF LoanType.Source=LoanType.Source::BOSA THEN BEGIN
                        if LoanType."Post to Deposits" = true then begin


                            //SHARES:="Approved Amount"*0.005;
                            //IF ("Loan Product Type"='L05') THEN
                            //SHARES:=0;
                            if SHARES > 5000 then
                                SHARES := 5000;

                            if LoanType.Code = 'L16' then begin
                                Deeboster := ("Approved Amount" * 50 / 100);
                                TOpDeb := ("Approved Amount" * 5 / 100);
                            end;
                        end;
                        //END;
                    end;
                    LoanTopUp.Reset;
                    LoanTopUp.SetRange(LoanTopUp."Loan No.", "Loans Register"."Loan  No.");
                    LoanTopUp.SetRange(LoanTopUp."Client Code", "Loans Register"."Client Code");
                    if LoanTopUp.Find('-') then begin

                        repeat

                            if LoanTopUp."Partial Bridged" = false then begin

                                BridgedRepayment := BridgedRepayment + LoanTopUp."Monthly Repayment";
                                FinalInst := FinalInst + LoanTopUp."Finale Instalment";
                            end;
                        until LoanTopUp.Next = 0;
                    end;


                    TotalRepayments := TotalRepayments - BridgedRepayment;

                    TotalLoanBal := (LOANBALANCE + "Loans Register"."Approved Amount") - BRIGEDAMOUNT;


                    LBalance := LOANBALANCE - BRIGEDAMOUNT + Commision;
                    //****Banding*******************************
                    /*
                    IF CONFIRM('Do you Want the system to insert the Minimum Deposits Contributions?',FALSE)=TRUE THEN BEGIN
                    IF BANDING.FIND('-') THEN BEGIN
                    REPEAT
                    IF (TotalLoanBal>=BANDING."Minimum Amount") AND (TotalLoanBal<=BANDING."Maximum Amount") THEN BEGIN
                    Band:=BANDING."Minimum Dep Contributions";
                    "Min Deposit As Per Tier":=Band;

                    MODIFY;
                    END;
                    UNTIL BANDING.NEXT=0;
                    END;
                    END ELSE
                    Band:="Min Deposit As Per Tier";
                    */

                    ///****************End Banding************
                    TotalBand := TotalLoanBal + Band;



                    //***Banding


                    //**Guarantors Loan Balances
                    "Loans Guarantee Details".Reset;
                    "Loans Guarantee Details".SetRange("Loans Guarantee Details"."Member No", "Client Code");
                    if "Loans Guarantee Details".Find('-') then begin
                        CalcFields("Outstanding Balance");
                        GuarOutstanding := "Outstanding Balance";
                    end;


                    //qualification as per salary
                    //compute Earnings
                    SalDetails.Reset;
                    SalDetails.SetRange(SalDetails."Client Code", "Loans Register"."Client Code");
                    SalDetails.SetRange(SalDetails."Loan No", "Loans Register"."Loan  No.");
                    SalDetails.SetRange(SalDetails.Type, SalDetails.Type::Earnings);
                    if SalDetails.Find('-') then begin
                        repeat
                            Earnings := Earnings + SalDetails.Amount;
                        until SalDetails.Next = 0;
                    end;

                    //compute BASIC
                    SalDetails.Reset;
                    SalDetails.SetRange(SalDetails."Client Code", "Loans Register"."Client Code");
                    SalDetails.SetRange(SalDetails."Loan No", "Loans Register"."Loan  No.");
                    SalDetails.SetRange(SalDetails.Type, SalDetails.Type::Earnings);
                    if SalDetails.Find('-') then begin
                        repeat
                            if SalDetails.Basic then
                                BASIC := BASIC + SalDetails.Amount;
                        until SalDetails.Next = 0;
                    end;

                    /*
                    //compute Earnings
                    //compute Deduction
                    SalDetails.RESET;
                    SalDetails.SETRANGE(SalDetails."Client Code",Loans."Client Code");
                    SalDetails.SETRANGE(SalDetails.Type,SalDetails.Type::Deductions);

                    IF SalDetails.FIND('-') THEN BEGIN
                    REPEAT
                     Deductions:=Deductions+SalDetails.Amount;
                    UNTIL SalDetails.NEXT=0;
                    END;
                    MESSAGE('StatDeductions is %1',StatDeductions);

                        */

                    //**//  Statutory Ded
                    SalDetails.Reset;
                    SalDetails.SetRange(SalDetails."Client Code", "Loans Register"."Client Code");
                    SalDetails.SetRange(SalDetails."Loan No", "Loans Register"."Loan  No.");
                    SalDetails.SetRange(SalDetails.Type, SalDetails.Type::Deductions);
                    SalDetails.SetRange(SalDetails.Statutory, true);
                    if SalDetails.Find('-') then begin
                        repeat
                            StatDeductions := StatDeductions + SalDetails.Amount;
                        until SalDetails.Next = 0;
                    end;



                    //**//  Statutory Ded End


                    //**//  Long Term Ded
                    SalDetails.Reset;
                    SalDetails.SetRange(SalDetails."Client Code", "Loans Register"."Client Code");
                    SalDetails.SetRange(SalDetails."Loan No", "Loans Register"."Loan  No.");
                    SalDetails.SetRange(SalDetails.Type, SalDetails.Type::Deductions);
                    SalDetails.SetRange(SalDetails.Statutory, false);
                    if SalDetails.Find('-') then begin
                        repeat
                            OTHERDEDUCTIONS := OTHERDEDUCTIONS + SalDetails.Amount;
                        until SalDetails.Next = 0;
                    end;



                    //**//  Long Term Ded End





                    TotalMRepay := 0;
                    LPrincipal := 0;
                    LInterest := 0;
                    LoanAmount := 0;
                    InterestRate := Interest;
                    LoanAmount := "Requested Amount";
                    RepayPeriod := Installments;
                    //LBalance1:="Approved Amount";

                    if "Loan Product Type" <> 'BBL' then begin
                        if "Repayment Method" = "repayment method"::"Reducing Balance" then begin
                            TestField(Installments);
                            LPrincipal := ROUND(LoanAmount / RepayPeriod, 1, '>');
                            LInterest := ROUND((InterestRate / 100) / 12 * LoanAmount, 1, '>');

                            Repayment := LPrincipal + LInterest;
                            "Loan Principle Repayment" := LPrincipal;
                            "Loan Interest Repayment" := LInterest;

                        end;
                    end;

                    //**2Thirds Waumini

                    //TwoThirds:=ROUND((Earnings- StatDeductions)*2/3,0.05,'>');
                    //ATHIRD:=ROUND((Earnings- StatDeductions)*1/3,0.05,'>');
                    TwoThirds := ROUND((BASIC) * 2 / 3, 0.05, '>');
                    ATHIRD := ROUND((BASIC) * 1 / 3, 0.05, '>');
                    NtTakeHome := TwoThirds - (TotalRepayments + Repayment + Band);

                    //compute Deductions
                    //NetSalary:=Earnings-StatDeductions-TotalRepayments-Band-Repayment+LoanTopUp."Remaining Installments"-OTHERDEDUCTIONS;
                    NetSalary := Earnings - OTHERDEDUCTIONS;
                    salary := ROUND(((Earnings - Deductions) * 2 / 3) - Band - TotalRepayments, 0.05, '>');
                    //Psalary:=TwoThirds-(OTHERDEDUCTIONS);

                    Psalary := NetSalary - ATHIRD;
                    Qsalary := Psalary * 5;


                    //(LoanDisbAmount*LoanApps.Interest/100);
                    //QSALARY IS QUALIFICATION AS PER SALARY
                    //Total amount guaranteed
                    LoanG.Reset;
                    LoanG.SetRange(LoanG."Loan No", "Loan  No.");
                    if LoanG.Find('-') then begin
                        repeat
                            GShares1 := LoanG."Amont Guaranteed";
                            GShares += LoanG."Amont Guaranteed";

                        until LoanG.Next = 0;
                    end;
                    //End Total Amount guaranteed



                    //Recommended Amount

                    if "Loan Product Type" = 'J/L' then begin

                        DepX := DEpMultiplier - (LBalance - FinalInst)
                        //DepX:=("Member Deposits"+"Jaza Deposits"+"Deposit Reinstatement")-LBalance ;
                    end
                    else
                        DepX := (DEpMultiplier);

                    //Qualification As Per Salary
                    Msalary := ROUND((Psalary * "Requested Amount") / Repayment, 100, '<');


                    if (Psalary > Repayment) or (Psalary = Repayment) then
                        Msalary := "Requested Amount"

                    else
                        //Msalary:=ROUND((salary*100*Installments)/(100+Installments),100,'<');
                        Msalary := ROUND((Psalary * "Requested Amount") / Repayment, 100, '<');
                    // End Qualification As Per Salary
                    /*
                    IF (DepX >Msalary) THEN
                    Recomm:=ROUND(Msalary,100,'<')
                    ELSE
                    Recomm:=ROUND(DepX,100,'<');

                    IF Recomm>GShares THEN
                    Recomm:=ROUND(GShares,100,'<');

                    IF Recomm>"Loans Register"."Requested Amount" THEN
                    Recomm:=ROUND("Loans Register"."Requested Amount",100,'<');
                    IF Recomm<0 THEN BEGIN
                    Recomm:=ROUND(Recomm,100,'<');
                    END;
                    */

                    Riskamount := "Loans Register"."Requested Amount" - MAXAvailable;

                    //"Recommended Amount":=Recomm;

                    if Qsalary > 0 then begin

                        if ("Loans Register"."Requested Amount" < Qsalary) then begin
                            "Loans Register"."Recommended Amount" := "Loans Register"."Requested Amount"
                        end else
                            "Loans Register"."Recommended Amount" := Qsalary;
                        "Loans Register".Modify;
                        UpfrontInt := ("Loans Register"."Recommended Amount" * Interest / 100);
                        //Recommended Amount
                    end else
                        if Qsalary <= 0 then begin
                            "Loans Register"."Recommended Amount" := "Loans Register"."Requested Amount";
                            "Loans Register".Modify;
                        end;




                    "Loans Guarantee Details".Reset;
                    "Loans Guarantee Details".SetRange("Loans Guarantee Details"."Loan No", "Loans Register"."Loan  No.");
                    if "Loans Guarantee Details".Find('-') then begin
                        "Loans Guarantee Details".CalcSums("Loans Guarantee Details"."Amont Guaranteed");
                        TGAmount := "Loans Guarantee Details"."Amont Guaranteed";
                    end;

                    LoanApp.Reset;
                    LoanApp.SetRange(LoanApp."Loan  No.", "Loan  No.");
                    if LoanApp.Find('-') then begin
                        LoanApp.CalcFields(LoanApp."Topup Commission");
                    end;

                    Lamount := 0;
                    Lcommit.Reset;

                    Lcommit.SetRange(Lcommit."Loan No.", "Loans Register"."Loan  No.");
                    if Lcommit.Find('-') then begin
                        repeat
                            // LoanG.CALCFIELDS(LoanG."Outstanding Balance",LoanG."Guarantor Outstanding");
                            //IF LoanG."Outstanding Balance" > 0 THEN BEGIN
                            Lamount := Lamount + Lcommit.Amount;
                        ///END;
                        until Lcommit.Next = 0;
                    end;
                    Lamount := Lamount + "Loans Register"."Total TopUp Commission";
                    //"Loans Register".CALCFIELDS("Loans Register"."Topup Commission");
                    //amount:=Lamount+"Loans Register"."Topup Commission";
                    GenSetUp.Get();

                    Charge := 0;

                    Charge := 0;
                    if LoanType.Get("Loan Product Type") then begin
                        Pcharges.Reset;
                        Pcharges.SetRange(Pcharges."Product Code", "Loan Product Type");
                        if Pcharges.Find('-') then begin
                            repeat
                                if Pcharges."Use Perc" = true then
                                    Pcharges.Amount := ("Loans Register"."Recommended Amount" * Pcharges.Percentage / 100)
                                else
                                    Pcharges.Amount := Pcharges.Amount;
                                Charge := Charge + Pcharges.Amount;

                            until Pcharges.Next = 0;
                        end;


                        JazaLevy := ROUND(0* 0.15, 1, '>');
                        BridgeLevy := LoanApp."Topup Commission";

                        if LoanApp."Top Up Amount" > 0 then begin
                            if BridgeLevy < 500 then begin
                                BridgeLevy := 500;
                            end else begin
                                BridgeLevy := LoanApp."Topup Commission";
                            end;
                        end;
                        Upfronts := BRIGEDAMOUNT  + "Deposit Reinstatement" + JazaLevy + GenSetUp."Loan Trasfer Fee-Cheque" + SHARES + Charge + Lamount + BridgeLevy + BInt + Deeboster + TOpDeb + UpfrontInt;
                        // if "Mode of Disbursement" = "mode of disbursement"::Cheque then
                        //     Upfronts := BRIGEDAMOUNT + "Deposit Reinstatement" + JazaLevy + GenSetUp."Loan Trasfer Fee-Cheque" + SHARES + Charge + Lamount + BridgeLevy + BInt + Deeboster + TOpDeb + UpfrontInt
                        // else
                            // if "Mode of Disbursement" = "mode of disbursement"::EFT then
                            //     Upfronts := BRIGEDAMOUNT+ "Deposit Reinstatement" + JazaLevy + GenSetUp."Loan Trasfer Fee-EFT" + SHARES + Charge + Lamount + BridgeLevy + BInt + Deeboster + TOpDeb + UpfrontInt
                            // else
                                // if "Mode of Disbursement" = "mode of disbursement"::"Bank Transfer" then
                                //     Upfronts := BRIGEDAMOUNT + "Deposit Reinstatement" + JazaLevy + GenSetUp."Loan Trasfer Fee-FOSA" + SHARES + Charge + Lamount + BridgeLevy + BInt + Deeboster + TOpDeb + UpfrontInt
                                // else
                                    //mutinda
                                    // if "Mode of Disbursement" = "mode of disbursement"::"Cheque NonMember" then
                                    //     Upfronts := BRIGEDAMOUNT + "Deposit Reinstatement" + JazaLevy + SHARES + Charge + Lamount + BridgeLevy + BInt + Deeboster + TOpDeb + UpfrontInt
                                    // else

                                        //mutinda
                                        // if "Mode of Disbursement" = "mode of disbursement"::RTGS then
                                        //     Upfronts := BRIGEDAMOUNT + "Deposit Reinstatement" + JazaLevy + GenSetUp."Loan Trasfer Fee-RTGS" + SHARES + Charge + Lamount + BInt + Deeboster + TOpDeb + UpfrontInt;

                        Netdisbursed := "Loans Register"."Recommended Amount" - Upfronts;
                    end;
                    "Loan Processing Fee" := Charge;
                    "Checked By" := UserId;
                   // "Loan Appraisal Fee" := SHARES;
                    "Loan Disbursed Amount" := Netdisbursed;
                    Modify;

                    if Netdisbursed < 0 then
                        Message('Net Disbursed cannot be 0 or Negative');

                    if MAXAvailable < 0 then
                        WarnDeposits := UpperCase('WARNING: Insufficient Deposits to cover the loan applied: Risk %1')
                    else
                        WarnDeposits := '';
                    if MAXAvailable < 0 then
                        RiskDeposits := "Loans Register"."Requested Amount" - MAXAvailable;



                    if Msalary < "Loans Register"."Requested Amount" then
                        WarnSalary := UpperCase('WARNING: Salary is Insufficient to cover the loan applied: Risk')
                    else
                        WarnSalary := '';
                    if Msalary < "Loans Register"."Requested Amount" then
                        Riskamount := "Loans Register"."Requested Amount" - Msalary;

                    if GShares < "Loans Register"."Requested Amount" then
                        WarnGuarantor := UpperCase('WARNING: Guarantors do not sufficiently cover the loan: Risk')
                    else
                        WarnGuarantor := '';
                    if GShares < "Loans Register"."Requested Amount" then
                        RiskGshares := "Loans Register"."Requested Amount" - GShares;
                    //MESSAGE('WARNING: Insufficient Deposits to cover the loan applied: Risk %1',Riskamount)
                end;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if GenSetUp.Get(0) then
            CompanyInfo.Get;
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        Initials: Code[50];
        CustRec: Record Customer;
        GenSetUp: Record "Sacco General Set-Up";
        Cust: Record Customer;
        CustRecord: Record Customer;
        TShares: Decimal;
        TLoans: Decimal;
        LoanApp: Record "Loans Register";
        LoanShareRatio: Decimal;
        Eligibility: Decimal;
        TotalSec: Decimal;
        saccded: Decimal;
        saccded2: Decimal;
        grosspay: Decimal;
        Tdeduct: Decimal;
        Cshares: Decimal;
        "Cshares*3": Decimal;
        "Cshares*4": Decimal;
        QUALIFY_SHARES: Decimal;
        salary: Decimal;
        LoanG: Record "Loans Guarantee Details";
        GShares: Decimal;
        Recomm: Decimal;
        GShares1: Decimal;
        NETTAKEHOME: Decimal;
        Msalary: Decimal;
        RecPeriod: Integer;
        FOSARecomm: Decimal;
        FOSARecoPRD: Integer;
        "Asset Value": Decimal;
        InterestRate: Decimal;
        RepayPeriod: Decimal;
        LBalance: Decimal;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        SecuredSal: Decimal;
        Linterest1: Integer;
        LOANBALANCE: Decimal;
        BRIDGEDLOANS: Record "Loan Offset Details";
        BRIDGEBAL: Decimal;
        LOANBALANCEFOSASEC: Decimal;
        TotalTopUp: Decimal;
        TotalIntPayable: Decimal;
        GTotals: Decimal;
        TempVal: Decimal;
        TempVal2: Decimal;
        "TempCshares*4": Decimal;
        "TempCshares*3": Decimal;
        InstallP: Decimal;
        RecomRemark: Text[150];
        InstallRecom: Decimal;
        TopUpComm: Decimal;
        TotalTopupComm: Decimal;
        LoanTopUp: Record "Loan Offset Details";
        "Interest Payable": Decimal;
        LoanType: Record "Loan Products Setup";
        "general set-up": Record "Sacco General Set-Up";
        Days: Integer;
        EndMonthInt: Decimal;
        BRIDGEBAL2: Decimal;
        DefaultInfo: Text[80];
        TOTALBRIDGED: Decimal;
        DEpMultiplier: Decimal;
        MAXAvailable: Decimal;
        SalDetails: Record "Loan Appraisal Salary Details";
        Earnings: Decimal;
        Deductions: Decimal;
        BrTopUpCom: Decimal;
        LoanAmount: Decimal;
        CompanyInfo: Record "Company Information";
        CompanyAddress: Code[20];
        CompanyEmail: Text[30];
        CompanyTel: Code[20];
        CurrentAsset: Decimal;
        CurrentLiability: Decimal;
        FixedAsset: Decimal;
        Equity: Decimal;
        Sales: Decimal;
        SalesOnCredit: Decimal;
        AppraiseDeposits: Boolean;
        AppraiseShares: Boolean;
        AppraiseSalary: Boolean;
        AppraiseGuarantors: Boolean;
        AppraiseBusiness: Boolean;
        TLoan: Decimal;
        LoanBal: Decimal;
        GuaranteedAmount: Decimal;
        RunBal: Decimal;
        TGuaranteedAmount: Decimal;
        GuarantorQualification: Boolean;
        Loan_Appraisal_AnalysisCaptionLbl: label 'Loan Appraisal Analysis';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Loan_Application_DetailsCaptionLbl: label 'Loan Application Details';
        Loan_TypeCaptionLbl: label 'Loan Type';
        MemberCaptionLbl: label 'Member';
        Amount_AppliedCaptionLbl: label 'Amount Applied';
        Deposits__3CaptionLbl: label 'Deposits* 3';
        Eligibility_DetailsCaptionLbl: label 'Eligibility Details';
        Maxim__Amount_Avail__for_the_LoanCaptionLbl: label 'Maxim. Amount Avail. for the Loan';
        Outstanding_LoanCaptionLbl: label 'Outstanding Loan';
        Member_DepositsCaptionLbl: label 'Member Deposits';
        Amount_AppliedCaption_Control1102760132Lbl: label 'Amount Applied';
        MemberCaption_Control1102760133Lbl: label 'Member';
        Loan_TypeCaption_Control1102760134Lbl: label 'Loan Type';
        Loan_Application_DetailsCaption_Control1102760151Lbl: label 'Loan Application Details';
        RepaymentCaptionLbl: label 'Repayment';
        Maxim__Amount_Avail__for_the_LoanCaption_Control1102760150Lbl: label 'Maxim. Amount Avail. for the Loan';
        Total_Outstand__Loan_BalanceCaptionLbl: label 'Total Outstand. Loan Balance';
        Deposits___MulitiplierCaptionLbl: label 'Deposits * Mulitiplier';
        Member_DepositsCaption_Control1102760148Lbl: label 'Member Deposits';
        Deposits_AnalysisCaptionLbl: label 'Deposits Analysis';
        Bridged_AmountCaptionLbl: label 'Bridged Amount';
        Out__Balance_After_Top_upCaptionLbl: label 'Out. Balance After Top-up';
        Recommended_AmountCaptionLbl: label 'Recommended Amount';
        Net_Loan_Disbursement_CaptionLbl: label 'Net Loan Disbursement:';
        V3__Qualification_as_per_GuarantorsCaptionLbl: label '3. Qualification as per Guarantors';
        Defaulter_Info_CaptionLbl: label 'Defaulter Info:';
        V2__Qualification_as_per_SalaryCaptionLbl: label '2. Qualification as per Salary';
        V1__Qualification_as_per_SharesCaptionLbl: label '1. Qualification as per Shares';
        QUALIFICATIONCaptionLbl: label 'QUALIFICATION';
        Insufficient_Deposits_to_cover_the_loan_applied__RiskCaptionLbl: label 'Insufficient Deposits to cover the loan applied: Risk';
        WARNING_CaptionLbl: label 'WARNING:';
        Salary_is_Insufficient_to_cover_the_loan_applied__RiskCaptionLbl: label 'Salary is Insufficient to cover the loan applied: Risk';
        WARNING_Caption_Control1000000140Lbl: label 'WARNING:';
        WARNING_Caption_Control1000000141Lbl: label 'WARNING:';
        Guarantors_do_not_sufficiently_cover_the_loan__RiskCaptionLbl: label 'Guarantors do not sufficiently cover the loan: Risk';
        WARNING_Caption_Control1000000020Lbl: label 'WARNING:';
        Shares_Deposits_BoostedCaptionLbl: label 'Shares/Deposits Boosted';
        I_Certify_that_the_foregoing_details_and_member_information_is_true_statement_of_the_account_maintained_CaptionLbl: label 'I Certify that the foregoing details and member information is true statement of the account maintained.';
        Loans_Asst__Officer______________________CaptionLbl: label 'Loans Asst. Officer:_____________________';
        Signature__________________CaptionLbl: label 'Signature:_________________';
        Date___________________CaptionLbl: label 'Date:__________________';
        General_Manger______________________CaptionLbl: label 'General Manger:_____________________';
        Signature__________________Caption_Control1102760039Lbl: label 'Sign:_________________';
        Date___________________Caption_Control1102760040Lbl: label 'Date:__________________';
        Signature__________________Caption_Control1102755017Lbl: label 'Sign:_________________';
        Date___________________Caption_Control1102755018Lbl: label 'Date:__________________';
        Loans_Officer______________________CaptionLbl: label 'Officer''s Comments:_____________________';
        Chairman_Signature______________________CaptionLbl: label 'Chairman Signature:_____________________';
        Secretary_s_Signature__________________CaptionLbl: label 'Secretary''s Signature:_________________';
        Members_Signature______________________CaptionLbl: label 'Members Signature:_____________________';
        Credit_Committe_Minute_No______________________CaptionLbl: label 'Credit Committe Minute No._____________________';
        Date___________________Caption_Control1102755074Lbl: label 'Date:__________________';
        Comment______________________________________________________________________________________CaptionLbl: label 'Comment :____________________________________________________________________________________';
        Amount_Approved______________________CaptionLbl: label 'Amount Approved:_____________________';
        Signatory_1__________________CaptionLbl: label 'Signatory 1:_________________';
        Signatory_2__________________CaptionLbl: label 'Signatory 2:_________________';
        Signatory_3__________________CaptionLbl: label 'Signatory 3:_________________';
        FOSA_SIGNATORIES_CaptionLbl: label 'FOSA SIGNATORIES:';
        Comment_______________________________________________Caption_Control1102755070Lbl: label 'Comment :____________________________________________________________________________________';
        FINANCE_CaptionLbl: label 'FINANCE:';
        Disbursed_By__________________CaptionLbl: label 'Disbursed By:_________________';
        Signature__________________Caption_Control1102755081Lbl: label 'Sign:_________________';
        Date___________________Caption_Control1102755082Lbl: label 'Date:__________________';
        Salary_Details_AnalysisCaptionLbl: label 'Salary Details Analysis';
        Total_EarningsCaptionLbl: label 'Total Earnings';
        Total_DeductionsCaptionLbl: label 'Total Deductions';
        Net_SalaryCaptionLbl: label 'Net Salary';
        Qualification_as_per_SalaryCaptionLbl: label 'Qualification as per Salary';
        V1_3_of_Gross_PayCaptionLbl: label '1/3 of Gross Pay';
        Amount_GuaranteedCaptionLbl: label 'Amount Guaranteed';
        Loan_GuarantorsCaptionLbl: label 'Loan Guarantors';
        RatioCaptionLbl: label 'Ratio';
        Total_Amount_GuaranteedCaptionLbl: label 'Total Amount Guaranteed';
        Total_TopupsCaptionLbl: label 'Total Topups';
        Bridged_LoansCaptionLbl: label 'Bridged Loans';
        Loan_No_CaptionLbl: label 'Loan No.';
        Principal_Top_UpCaptionLbl: label 'Principal Top Up';
        Client_CodeCaptionLbl: label 'Client Code';
        Loan_TypeCaption_Control1102755059Lbl: label 'Loan Type';
        TotalsCaptionLbl: label 'Totals';
        Total_Amount_BridgedCaptionLbl: label 'Total Amount Bridged';
        Bridging_total_higher_than_the_qualifing_amountCaptionLbl: label 'Bridging total higher than the qualifing amount';
        WARNING_Caption_Control1102755044Lbl: label 'WARNING:';
        TotalLoanBalance: Decimal;
        TGAmount: Decimal;
        NetSalary: Decimal;
        Riskamount: Decimal;
        WarnBridged: Text;
        WarnSalary: Text;
        WarnDeposits: Text;
        WarnGuarantor: Text;
        WarnShare: Text;
        RiskGshares: Decimal;
        RiskDeposits: Decimal;
        BasicEarnings: Decimal;
        DepX: Decimal;
        LoanPrincipal: Decimal;
        loanInterest: Decimal;
        AmountGuaranteed: Decimal;
        StatDeductions: Decimal;
        GuarOutstanding: Decimal;
        TwoThirds: Decimal;
        Bridged_AmountCaption: Integer;
        LNumber: Code[20];
        TotalLoanDeductions: Decimal;
        TotalRepayments: Decimal;
        Totalinterest: Decimal;
        Band: Decimal;
        TotalOutstanding: Decimal;
        BANDING: Record "Deposit Tier Setup";
        NtTakeHome: Decimal;
        ATHIRD: Decimal;
        Psalary: Decimal;
        LoanApss: Record "Loans Register";
        TotalLoanBal: Decimal;
        TotalBand: Decimal;
        LoanAp: Record "Loans Register";
        TotalRepay: Decimal;
        TotalInt: Decimal;
        LastFieldNo: Integer;
        TotLoans: Decimal;
        JazaLevy: Decimal;
        BridgeLevy: Decimal;
        Upfronts: Decimal;
        Netdisbursed: Decimal;
        TotalLRepayments: Decimal;
        BridgedRepayment: Decimal;
        OutstandingLrepay: Decimal;
        Loantop: Record "Loan Offset Details";
        BRIGEDAMOUNT: Decimal;
        TOTALBRIGEDAMOUNT: Decimal;
        FinalInst: Decimal;
        NonRec: Decimal;
        OTHERDEDUCTIONS: Decimal;
        StartDate: Date;
        DateFilter: Text[100];
        FromDate: Date;
        ToDate: Date;
        FromDateS: Text[100];
        ToDateS: Text[100];
        DivTotal: Decimal;
        CDeposits: Decimal;
        CustDiv: Record Customer;
        DivProg: Record "Dividends Progression";
        CDiv: Decimal;
        BDate: Date;
        CustR: Record Customer;
        BASIC: Decimal;
        SHARES: Decimal;
        Pcharges: Record "Loan Product Charges";
        Charge: Decimal;
        Commision: Decimal;
        LBalance1: Decimal;
        Ttype: Text;
        Lcommit: Record "Other Commitements Clearance";
        Lamount: Decimal;
        BInt: Decimal;
        Deeboster: Decimal;
        TOpDeb: Decimal;
        Qsalary: Decimal;
        LAppCharges: Record "Loan Applicaton Charges";
        UpfrontInt: Decimal;


    procedure ComputeTax()
    begin
    end;
}

