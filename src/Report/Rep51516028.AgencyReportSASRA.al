report 51516028 "Agency Report-SASRA"
{
    ApplicationArea = All;
    Caption = 'Agency Report-SASRA';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Agency Report-SASRA.rdlc';
    dataset
    {
        dataitem("Agent transaction"; "Agent transaction")
        {
            RequestFilterFields = "Transaction Date";
            column(CashDeposits; CashDeposits)
            {

            }
            column(CashDepositsCount; CashDepositsCount)
            {

            }
            column(CashWithdrawal; CashWithdrawal)
            {

            }
            column(CashWithdrawalCount; CashWithdrawalCount)
            {

            }
            column(BalanceEnquiry; BalanceEnquiry)
            {

            }
            column(BalanceEnquiryCount; BalanceEnquiryCount)
            {

            }
            column(MiniStatement; MiniStatement)
            {

            }
            column(MiniStatementCount; MiniStatementCount)
            {

            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                "Agent transaction".SetFilter("Agent transaction"."Transaction Date", PeriodFilter);
                if "Agent transaction".Find('-') then begin
                    repeat
                        //....................Cash Deposits Totals
                        if "Agent transaction"."Transaction Type" = "Agent transaction"."Transaction Type"::Deposit then begin
                            CashDeposits += (("Agent transaction".Amount) * -1);
                            CashDepositsCount := CashDepositsCount + 1;
                        end else
                            //....................Cash Withdrawal Totals
                            if "Agent transaction"."Transaction Type" = "Agent transaction"."Transaction Type"::Withdrawal then begin
                                CashWithdrawal += (("Agent transaction".Amount));
                                CashWithdrawalCount := CashWithdrawalCount + 1;
                            end
                            else
                                //....................Account Balance Enquiry Totals
                                if "Agent transaction"."Transaction Type" = "Agent transaction"."Transaction Type"::Balance then begin
                                    BalanceEnquiry += (("Agent transaction".Amount) * -1);
                                    BalanceEnquiryCount := BalanceEnquiryCount + 1;
                                end
                                else
                                    //....................Ministatements Totals
                                    if "Agent transaction"."Transaction Type" = "Agent transaction"."Transaction Type"::Ministatment then begin
                                        MiniStatement += (("Agent transaction".Amount) * -1);
                                        MiniStatementCount := MiniStatementCount + 1;
                                    end

                    until "Agent transaction".Next = 0;
                end;
            end;

            trigger OnPostDataItem()
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
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        PeriodFilter := "Agent transaction".GetFilter("Agent transaction"."Transaction Date");
        CashDepositsCount := 0;
        CashDeposits := 0;
        CashWithdrawal := 0;
        CashWithdrawalCount := 0;
        BalanceEnquiry := 0;
        BalanceEnquiryCount := 0;

        MiniStatement := 0;
        MiniStatementCount := 0;
    end;

    trigger OnPostReport()
    begin

    end;

    var
        PeriodFilter: Text;
        CashDeposits: Decimal;
        CashDepositsCount: Integer;
        CashWithdrawal: Integer;
        CashWithdrawalCount: Integer;
        BalanceEnquiry: Decimal;
        BalanceEnquiryCount: Decimal;

        MiniStatement: Decimal;
        MiniStatementCount: Decimal;

}
