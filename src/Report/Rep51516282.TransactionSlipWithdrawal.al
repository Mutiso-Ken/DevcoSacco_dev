#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516282 "Transaction Slip Withdrawal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TransactionSlipWithdrawal.rdlc';

    dataset
    {
        dataitem(Transactions; Transactions)
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = No;
            column(ReportForNavId_5806; 5806)
            {
            }
            column(Transactions_Transactions__Book_Balance_; Transactions."Book Balance")
            {
            }
            column(Transactions_No; No)
            {
            }
            column(AccountNo; "Account No")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Transactions__Transaction_Date_; "Transaction Date")
            {
            }
            column(Transactions_Transactions__Transaction_Time_; Transactions."Transaction Time")
            {
            }
            column(Transactions__Cheque_No_; "Cheque No")
            {
            }
            column(Account__BOSA_Account_No_; Account."BOSA Account No")
            {
            }
            column(Transactions_Type; Type)
            {
            }
            column(Transactions_Transactions__Branch_Refference_; Transactions."Branch Refference")
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(Company_Address; CompanyInfo.Address)
            {
            }
            column(Co_phone; CompanyInfo."Phone No.")
            {
            }
            column(Company_Pic; CompanyInfo.Picture)
            {
            }
            column(AvailableBalance; AvailableBalance)
            {
            }
            column(BookBal; BookBal)
            {
            }
            column(Transactions_Transactions_Cashier; Transactions.Cashier)
            {
            }
            column(Amount_WithdrawnCaption; Amount_WithdrawnCaptionLbl)
            {
            }
            column(Book_Balance_Caption; Book_Balance_CaptionLbl)
            {
            }
            column(Transaction_No_Caption; Transaction_No_CaptionLbl)
            {
            }
            column(Account_No_Caption; Account_No_CaptionLbl)
            {
            }
            column(Account_Name_Caption; Account_Name_CaptionLbl)
            {
            }
            column(Date_Caption; Date_CaptionLbl)
            {
            }
            column(Time_Caption; Time_CaptionLbl)
            {
            }
            column(Transactions__Cheque_No_Caption; FieldCaption("Cheque No"))
            {
            }
            column(ID_No; Members."ID No.")
            {
            }
            column(Member_No_Caption; Member_No_CaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(Signature_Caption; Signature_CaptionLbl)
            {
            }
            column(I_acknowledge_receipt_of_the_above_amountCaption; I_acknowledge_receipt_of_the_above_amountCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000048; EmptyStringCaption_Control1000000048Lbl)
            {
            }
            column(I_D_No_Caption; I_D_No_CaptionLbl)
            {
            }
            column(Availbal; Available_Balance_CaptionLbl)
            {
            }
            column(BookBal_; Book_Balance_Caption_Control1102760006Lbl)
            {
            }
            column(EmptyStringCaption_Control1102756001; EmptyStringCaption_Control1102756001Lbl)
            {
            }
            column(al; Name_CaptionLbl)
            {
            }
            column(Withdrawn_By_______________________________________Caption; Withdrawn_By_______________________________________CaptionLbl)
            {
            }
            column(You_were_served_by__Caption; You_were_served_by__CaptionLbl)
            {
            }
            column(THANK_YOUCaption; THANK_YOUCaptionLbl)
            {
            }
            column(Better_life_for_our_members_globallyCaption; Better_life_for_our_members_globallyCaptionLbl)
            {
            }
            column(Transactions_Transaction_Type; "Transaction Type")
            {
            }
            column(ExpectedMaturityDate; "Expected Maturity Date")
            {
            }
            column(Members_Address; Members.Address)
            {
            }
            column(ChequeNo_Transactions; Transactions."Cheque No")
            {
            }
            column(TransactionDescription_Transactions; Transactions."Transaction Description")
            {
            }
            column(Cashier_Transactions; Transactions.Cashier)
            {
            }
            column(NumberText_1_; NumberText[1])
            {
            }
            column(SumTransactionCharges; SumTransactionCharges)
            {
            }
            column(PayeeBankNo; Transactions."Payee Bank No")
            {
            }
            dataitem("Transaction Charges"; "Transaction Charges")
            {
                DataItemLink = "Transaction Type" = field("Transaction Type");
                column(ReportForNavId_8541; 8541)
                {
                }
                column(Description; Description)
                {
                }
                column(ChAmount; ChAmount)
                {
                }
                column(Transaction_Charges_Transaction_Type; "Transaction Type")
                {
                }
                column(Transaction_Charges_Charge_Code; "Charge Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Transaction Charges"."Use Percentage" = true then
                        ChAmount := ("Transaction Charges"."Percentage of Amount" * Transactions.Amount) * 0.01
                    else
                        ChAmount := "Transaction Charges"."Charge Amount";
                end;
            }

            trigger OnAfterGetRecord()
            begin

                ATMBalance := 0;

                //"Transactions 1".CALCFIELDS("Transactions 1"."Book Balance");

                LoanGuaranteed := 0;
                UnClearedBalance := 0;
                TotalGuaranted := 0;
                BookBal := 0;
                //  MESSAGE('ChAmount',ChAmount);

                TransactionCharges.Reset;
                TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");

                TCharges := 0;
                AvailableBalance := 0;
                MinAccBal := 0;

                //CALCFIELDS("Book Balance");

                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code, "Account Type");

                if AccountTypes.Find('-') then begin
                    MinAccBal := AccountTypes."Minimum Balance";
                    FeeBelowMinBal := AccountTypes."Fee Below Minimum Balance";
                end;

                if Posted = false then begin

                    if TransactionCharges.Find('-') then
                        repeat

                            ////////
                            if TransactionCharges."Use Percentage" = true then begin
                                if TransactionCharges."Percentage of Amount" = 0 then
                                    Error('Percentage of amount cannot be zero.');
                                //USE BOOK BALANCE FOR ESTIMATING PERCENTAGE OF AMOUNT
                                TCharges := TCharges + (TransactionCharges."Percentage of Amount" / 100) * "Book Balance";
                                //TCharges:=TCharges+(TransactionCharges."Percentage of Amount"/100)*Amount;
                            end
                            else begin
                                TCharges := TCharges + TransactionCharges."Charge Amount";
                            end;
                        /////////

                        //TCharges:=TCharges+TransactionCharges."Charge Amount";
                        until TransactionCharges.Next = 0;

                    TransactionCharges.Reset;

                    ///// CHECK LAST WITHDRAWAL DATE AND FIND IF CHARGE IS APPLICABLE AND CHARGE
                    IntervalPenalty := 0;
                    Members.Reset;
                    if Members.Get("Account No") then begin

                        if Members.Status <> Members.Status::New then begin
                            /*
                            IF Type='Withdrawal' THEN BEGIN
                            AccountTypes.RESET;
                            AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                            IF AccountTypes.FIND('-') THEN  BEGIN
                            IF CALCDATE(AccountTypes."Withdrawal Interval",Members."Last Withdrawal Date") > TODAY THEN BEGIN
                            IntervalPenalty:=AccountTypes."Withdrawal Penalty";
                            END;
                            END;
                            END;
                            */
                        end;
                    end;

                    //////////////



                    /////////////
                    //FIXED DEPOSIT

                    ChargesOnFD := 0;

                    Members.Reset;
                    if Members.Get("Account No") then begin

                        AccountTypes.Reset;
                        if AccountTypes.Get(Members."Account Type") then begin
                            if AccountTypes."Fixed Deposit" = true then begin

                                if Members."Expected Maturity Date" > Today then begin
                                    ChargesOnFD := AccountTypes."Charge Closure Before Maturity";
                                end;

                            end;
                        end;


                    end;

                    Members.Reset;

                    ///////////

                end;


                //UNCLEARED CHEQUES
                chqtransactions.Reset;
                chqtransactions.SetRange(chqtransactions."Account No", "Account No");
                chqtransactions.SetRange(chqtransactions.Deposited, true);
                chqtransactions.SetRange(chqtransactions."Cheque Processed", false);

                if chqtransactions.Find('-') then begin

                    repeat

                        TotalUnprocessed := TotalUnprocessed + chqtransactions.Amount;

                    until chqtransactions.Next = 0;

                end;


                //ATM BALANCE
                AccountHolders.Reset;
                AccountHolders.SetRange(AccountHolders."No.", "Account No");
                if AccountHolders.Find('-') then begin
                    //AccountHolders.CALCFIELDS(AccountHolders."ATM Transactions");
                    ATMBalance := AccountHolders."ATM Transactions";
                end;


                if LoanGuaranteed < 0 then
                    LoanGuaranteed := 0;

                if UnClearedBalance < 0 then
                    UnClearedBalance := 0;

                AccountTypes.Reset;
                if AccountTypes.Get("Account Type") then begin
                    if AccountTypes."Fixed Deposit" = false then begin
                        if "Book Balance" < MinAccBal then
                            AvailableBalance := "Book Balance" - FeeBelowMinBal - TCharges - IntervalPenalty - MinAccBal - TotalUnprocessed - ATMBalance
                        else
                            AvailableBalance := "Book Balance" - TCharges - IntervalPenalty - MinAccBal - TotalUnprocessed - ATMBalance;


                    end else
                        AvailableBalance := "Book Balance" - TCharges - ChargesOnFD;
                end;


                if Account.Get(Transactions."Account No") then begin
                    Account.CalcFields(Account."Balance (LCY)", Account."Uncleared Cheques");
                    AvailableBalance := Account."Balance (LCY)" - (Account."Uncleared Cheques");
                    BookBal := Account."Balance (LCY)";

                end;

                if Transactions."Branch Transaction" = true then begin
                    Transactions."Book Balance" := 0;
                    BookBal := 0;
                    AvailableBalance := 0;
                end;


                vatTotalHolder := Transactions.Amount;

                TillNo := '';
                TellerTill.Reset;
                TellerTill.SetRange(TellerTill."Cashier ID", Transactions.Cashier);
                if TellerTill.Find('-') then begin
                    TillNo := TellerTill."No.";
                end;

                //Amount into words
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText, Amount, '');
                //calculate the charges
                VendLedgerEntry.Reset;
                VendLedgerEntry.SetRange("Vendor No.", Transactions."Account No");
                VendLedgerEntry.SetRange("Document No.", Transactions.No);
                if VendLedgerEntry.FindSet then
                    repeat
                        VendLedgerEntry.CalcSums(Amount);
                        SumTransactionCharges := VendLedgerEntry.Amount - Transactions.Amount;
                    until VendLedgerEntry.Next = 0;

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(CompanyInfo.Picture);
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

    var
        Account: Record Vendor;
        LoanBalance: Decimal;
        AvailableBalance: Decimal;
        UnClearedBalance: Decimal;
        LoanSecurity: Decimal;
        LoanGuaranteed: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        window: Dialog;
        Members: Record Vendor;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charges";
        TCharges: Decimal;
        LineNo: Integer;
        AccountTypes: Record "Account Types-Saving Products";
        GenLedgerSetup: Record "General Ledger Setup";
        MinAccBal: Decimal;
        FeeBelowMinBal: Decimal;
        AccountNo: Code[30];
        NewAccount: Boolean;
        CurrentTellerAmount: Decimal;
        TellerTill: Record "Bank Account";
        IntervalPenalty: Decimal;
        StandingOrders: Record "Standing Orders";
        AccountAmount: Decimal;
        STODeduction: Decimal;
        Charges: Record Charges;
        "Total Deductions": Decimal;
        STODeductedAmount: Decimal;
        NoticeAmount: Decimal;
        AccountNotices: Record "Account Types-Saving Products";
        Cust: Record Customer;
        AccountHolders: Record Vendor;
        ChargesOnFD: Decimal;
        TotalGuaranted: Decimal;
        VarAmtHolder: Decimal;
        vatTotalHolder: Decimal;
        chqtransactions: Record Transactions;
        TotalUnprocessed: Decimal;
        ATMBalance: Decimal;
        ChAmount: Decimal;
        BookBal: Decimal;
        TillNo: Code[20];
        CompanyInfo: Record "Company Information";
        Amount_WithdrawnCaptionLbl: label 'Amount Withdrawn';
        Book_Balance_CaptionLbl: label 'Book Balance:';
        Transaction_No_CaptionLbl: label 'Transaction No.';
        Account_No_CaptionLbl: label 'Account No:';
        Account_Name_CaptionLbl: label 'Account Name:';
        Date_CaptionLbl: label 'Date:';
        Time_CaptionLbl: label 'Time:';
        Member_No_CaptionLbl: label 'Member No:';
        EmptyStringCaptionLbl: label '..........................................................';
        Signature_CaptionLbl: label 'Signature:';
        I_acknowledge_receipt_of_the_above_amountCaptionLbl: label 'I acknowledge receipt of the above amount';
        EmptyStringCaption_Control1000000048Lbl: label '..........................................................';
        I_D_No_CaptionLbl: label 'I/D No.';
        Available_Balance_CaptionLbl: label 'Available Balance:';
        Book_Balance_Caption_Control1102760006Lbl: label 'Book Balance:';
        EmptyStringCaption_Control1102756001Lbl: label '..........................................................';
        Name_CaptionLbl: label 'Name:';
        Withdrawn_By_______________________________________CaptionLbl: label 'Withdrawn By :.....................................';
        You_were_served_by__CaptionLbl: label 'You were served by :';
        THANK_YOUCaptionLbl: label 'THANK YOU';
        Better_life_for_our_members_globallyCaptionLbl: label 'Better life for our members globally';
        CheckReport: Report Check;
        NumberText: array[2] of Text[120];
        TChargesSum: Decimal;
        VendLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        SumTransactionCharges: Decimal;
        Vendor: Record Vendor;


    procedure CalAvailableBal()
    begin
        ATMBalance := 0;

        TCharges := 0;
        AvailableBalance := 0;
        MinAccBal := 0;
        TotalUnprocessed := 0;
        IntervalPenalty := 0;


        if Account.Get(Transactions."Account No") then begin
            Account.CalcFields(Account.Balance);

            AccountTypes.Reset;
            AccountTypes.SetRange(AccountTypes.Code, Transactions."Account Type");
            if AccountTypes.Find('-') then begin
                MinAccBal := AccountTypes."Minimum Balance";
                FeeBelowMinBal := AccountTypes."Fee Below Minimum Balance";


                //Check Withdrawal Interval
                if Account.Status <> Account.Status::New then begin
                    if Transactions.Type = 'Withdrawal' then begin
                        AccountTypes.Reset;
                        AccountTypes.SetRange(AccountTypes.Code, Transactions."Account Type");
                        if Account."Last Withdrawal Date" <> 0D then begin
                            if CalcDate(AccountTypes."Withdrawal Interval", Account."Last Withdrawal Date") > Today then
                                IntervalPenalty := AccountTypes."Withdrawal Penalty";
                        end;
                    end;
                    //Check Withdrawal Interval

                    //Fixed Deposit
                    ChargesOnFD := 0;
                    if AccountTypes."Fixed Deposit" = true then begin
                        if Account."Expected Maturity Date" > Today then
                            ChargesOnFD := AccountTypes."Charge Closure Before Maturity";
                    end;
                    //Fixed Deposit

                    //Current Charges
                    TransactionCharges.Reset;
                    TransactionCharges.SetRange(TransactionCharges."Transaction Type", Transactions."Transaction Type");
                    if TransactionCharges.Find('-') then begin
                        repeat
                            if TransactionCharges."Use Percentage" = true then begin
                                TransactionCharges.TestField("Percentage of Amount");
                                TCharges := TCharges + (TransactionCharges."Percentage of Amount" / 100) * Transactions."Book Balance";
                            end else begin
                                TCharges := TCharges + TransactionCharges."Charge Amount";
                            end;
                        until TransactionCharges.Next = 0;
                    end;


                    TotalUnprocessed := Account."Uncleared Cheques";
                    ATMBalance := Account."ATM Transactions";

                    //FD
                    if AccountTypes."Fixed Deposit" = false then begin
                        if Account.Balance < MinAccBal then
                            AvailableBalance := Account.Balance - FeeBelowMinBal - TCharges - IntervalPenalty - MinAccBal - TotalUnprocessed - ATMBalance
                        else
                            AvailableBalance := Account.Balance - TCharges - IntervalPenalty - MinAccBal - TotalUnprocessed - ATMBalance;
                    end else begin
                        AvailableBalance := Account.Balance - TCharges - ChargesOnFD;
                    end;
                end;
                //FD
                //MESSAGE('The available balance is %1',AvailableBalance);

            end;
        end;
    end;
}

