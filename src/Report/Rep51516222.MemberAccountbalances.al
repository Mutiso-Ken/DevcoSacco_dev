#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516222 "Member Account  balances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MemberAccountbalances.rdlc';

    dataset
    {
        dataitem(member; Customer)
        {
            RequestFilterFields = "No.", Name;
            column(ReportForNavId_1102755077; 1102755077)
            {
            }
            column(No_member; member."No.")
            {
            }
            column(Name_member; member.Name)
            {
            }


            column(CurrentShares_member; CurrentShares)
            {
            }

            column(OutstandingBalance_member; LoansBal)
            {
            }
            column(Shares_capital;SharesCap)
            {
            }

            column(Outstanding_Interest; InterestBal)
            {
            }



            column(ASAT; ASAT)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DFilter := '01/01/05..' + Format(ASAT);
                CalcFields("Current Shares","Share Capital","Outstanding Balance","Outstanding Interest");
                LoansBal:="Outstanding Balance";
                CurrentShares:="Current Shares";
                SharesCap:="Share Capital";
                InterestBal:="Outstanding Interest";

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("As at"; ASAT)
                {
                    ApplicationArea = Basic;
                    Caption = 'As at';
                }
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
        CurrentShares: Decimal;
        SharesCap: Decimal;
        LoansBal: Decimal;
        InterestBal: Decimal;
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
        NameCreditOff: label 'Name..............................................';
        NameCreditDate: label 'Date...............................................';
        NameCreditSign: label 'Signature.........................................';
        NameCreditMNG: label 'Name..............................................';
        NameCreditMNGDate: label 'Date...............................................';
        NameCreditMNGSign: label 'Signature...........................................';
        NameCEO: label 'Name................................................';
        NameCEOSign: label 'Signature...........................................';
        NameCEODate: label 'Date.................................................';
        CreditCom1: label 'Name................................................';
        CreditCom1Sign: label 'Signature...........................................';
        CreditCom1Date: label 'Date.................................................';
        CreditCom2: label 'Name................................................';
        CreditCom2Sign: label 'Signature...........................................';
        CreditCom2Date: label 'Date.................................................';
        CreditCom3: label 'Name................................................';
        CreditComDate3: label 'Date..................................................';
        CreditComSign3: label 'Signature............................................';
        From: Date;
        "To": Integer;
        DFilter: Text;
        ASAT: Date;
}

