#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 51516511 "Membership Exit Card"
{
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption';
    SourceTable = "Membership Exist";
    SourceTableView = where(Posted = filter(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Closing Date"; "Closing Date")
                {
                    ApplicationArea = Basic;
                    Editable = ClosingDateEditable;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Closure Type"; "Closure Type")
                {
                    ApplicationArea = Basic;
                    Editable = ClosureTypeEditable;
                }
                field("Exit Type"; "Exit Type")
                {
                    ApplicationArea = Basic;
                }
                field("Total Loan"; "Total Loan")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Loans';
                    Editable = false;
                }
                field("Total Interest"; "Total Interest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Interest Due';
                    Editable = false;
                }
                field("Member Deposits"; "Member Deposits")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = true;
                }
                field("Share Capital"; "Share Capital")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = true;
                }

                field(Payee; Payee)
                {
                    ApplicationArea = Basic;
                }
                field("Mode Of Disbursement"; "Mode Of Disbursement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment mode';
                    trigger OnValidate()
                    begin
                        UpdateControl();
                    end;
                }
                field("Paying Bank"; "Paying Bank")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    ShowMandatory = true;
                }
                field("Cheque No."; "Cheque No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque No';
                    Enabled = EnableCheque;
                }
                field("EFT Charge"; "EFT Charge")
                {
                    ApplicationArea = basic;

                }
                field("Reason For Withdrawal"; "Reason For Withdrawal")
                {
                    ApplicationArea = Basic;
                }
                field("Closed By"; "Closed By")
                {
                    ApplicationArea = Basic;
                }
                field("Closed On"; "Closed On")
                {
                    ApplicationArea = Basic;
                }
                field("Notice Date"; "Notice Date")
                {
                    ApplicationArea = Basic;
                }
                field("Muturity Date"; "Muturity Date")
                {
                    ApplicationArea = Basic;
                }

            }
        }
        area(factboxes)
        {
            part(Control24; "Member Statistics FactBox")
            {
                Caption = 'Member Statistics FactBox';
                SubPageLink = "No." = field("Member No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';
                action("Member is  a Guarantor")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans Guaranteed';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;

                    trigger OnAction()
                    begin

                        cust.Reset;
                        cust.SetRange(cust."No.", "Member No.");
                        if cust.Find('-') then begin
                            //Report.run(50503, true, false, cust);
                        end;

                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        TESTFIELD("FOSA Account No.");
                        if "Mode Of Disbursement" = "Mode Of Disbursement"::Cheque then begin
                            TestField("Cheque No.");
                        end;
                        if Status <> Status::Open then
                            Error(text001);
                        GenSetUp.Get();
                        //..................Send Withdrawal Approval request
                        //FnSendWithdrawalApplicationSMS();
                        //...................................................
                        Status := Status::Approved;
                        Modify();
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel A&pproval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                    begin
                        if Status <> Status::Open then
                            Error(text001);

                    end;
                }
                action("Account closure Slip")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        cust.Reset;
                        cust.SetRange(cust."No.", "Member No.");
                        if cust.Find('-') then
                            Report.run(51516250, true, false, cust);
                    end;
                }
                action("Post Membership Exit")
                {
                    ApplicationArea = Basic;
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                    begin
                        TemplateName := 'GENERAL';
                        BatchName := 'Closure';
                        case "Closure Type" of
                            "closure type"::"Member Exit - Normal":
                                FnRunPostNormalExitApplication("Member No.");
                            "closure type"::"Member Exit - Deceased":
                                FnRunPostNormalExitApplication("Member No.");
                        end;
                        FnSendWithdrawalApplicationSMS
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateControl();
        ShareCapitalTransferVisible := false;
        ShareCapSellPageVisible := false;
        if "Sell Share Capital" = true then begin
            ShareCapitalTransferVisible := true;
            ShareCapSellPageVisible := true;
        end;

        UpdateControl();
    end;

    trigger OnOpenPage()
    begin
        UpdateControl();
    end;

    var
        Closure: Integer;
        Text001: label 'Not Approved';
        cust: Record Customer;
        UBFRefund: Decimal;
        Generalsetup: Record "Sacco General Set-Up";
        Totalavailable: Decimal;
        UnpaidDividends: Decimal;
        TotalOustanding: Decimal;
        Vend: Record Vendor;
        value2: Decimal;
        Gnljnline: Record "Gen. Journal Line";
        Totalrecovered: Decimal;
        Advice: Boolean;
        TotalDefaulterR: Decimal;
        AvailableShares: Decimal;
        Loans: Record "Loans Register";
        Value1: Decimal;
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        Vendno: Code[20];
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ","Purchase Requisition",RFQ,"Store Requisition","Payment Voucher",MembershipApplication,LoanApplication,LoanDisbursement,ProductApplication,StandingOrder,MembershipWithdrawal,ATMCard,GuarantorRecovery,ChangeRequest,TreasuryTransactions,FundsTransfer,SaccoTransfers,ChequeDiscounting,ImprestRequisition,ImprestSurrender,LeaveApplication,BulkWithdrawal,PackageLodging,PackageRetrieval;
        MNoEditable: Boolean;
        ClosingDateEditable: Boolean;
        ClosureTypeEditable: Boolean;
        PostingDateEditable: Boolean;
        TotalFOSALoan: Decimal;
        TotalInsuarance: Decimal;
        DActivity: Code[30];
        DBranch: Code[30];
        LineNo: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        "Remaining Amount": Decimal;
        LoansR: Record "Loans Register";
        "AMOUNTTO BE RECOVERED": Decimal;
        PrincipInt: Decimal;
        TotalLoansOut: Decimal;
        ClosureR: Record "Membership Exist";
        Table_id: Integer;
        Doc_No: Code[20];
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ","Purchase Requisition",RFQ,"Store Requisition","Payment Voucher",MembershipApplication,LoanApplication,LoanDisbursement,ProductApplication,StandingOrder,MembershipWithdrawal,ATMCard,GuarantorRecovery,ChangeRequest,TreasuryTransactions,FundsTransfer,SaccoTransfers,ChequeDiscounting,ImprestRequisition,ImprestSurrender,LeaveApplication,BulkWithdrawal,PackageLodging,PackageRetrieval;
        PTEN: Text;
        DataSheet: Record "Data Sheet Main";
        Customer: Record Customer;
        GenSetUp: Record "Sacco General Set-Up";
        compinfo: Record "Company Information";
        SMSMessage: Record "SMS Messages";
        iEntryNo: Integer;
        ShareCapitalTransferVisible: Boolean;
        ShareCapSellPageVisible: Boolean;
        // ObjShareCapSell: Record "Share Capital Sell";
        SurestepFactory: Codeunit "SURESTEP Factory";
        JVTransactionType: Option " ","Registration Fee","Share Capital","Interest Paid","Loan Repayment","Deposit Contribution","Insurance Contribution","Benevolent Fund",Loan,"Unallocated Funds",Dividend,"FOSA Account","Loan Insurance Charged","Loan Insurance Paid","Recovery Account","FOSA Shares","Additional Shares";
        JVAccountType: Enum "Gen. Journal Account Type";
        TemplateName: Code[20];
        BatchName: Code[20];
        JVBalAccounttype: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        JVBalAccountNo: Code[20];
        TransferFee: Decimal;
        AvailableBal: Decimal;
        ObjMember: Record Customer;
        VarMemberAvailableAmount: Decimal;
        ObjCust: Record Customer;
        ObjGensetup: Record "Sacco General Set-Up";
        VarWithdrawalFee: Decimal;
        VarTaxonWithdrawalFee: Decimal;
        VarShareCapSellFee: Decimal;
        VarTaxonShareCapSellFee: Decimal;
        ObjNoSeries: Record "Sacco No. Series";
        VarDocumentNo: Code[30];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        VarShareCapitalFee: Decimal;
        VarShareCapitaltoSell: Decimal;
        EnableCheque: Boolean;
        GenBatch: Record "Gen. Journal Batch";

    procedure UpdateControl()
    begin
        if "Mode Of Disbursement" = "Mode Of Disbursement"::Cheque then begin
            EnableCheque := true;
        end else
            if "Mode Of Disbursement" <> "Mode Of Disbursement"::Cheque then begin
                EnableCheque := false;
            end;
        if Status = Status::Open then begin
            MNoEditable := true;
            ClosingDateEditable := false;
            ClosureTypeEditable := true;
            PostingDateEditable := false;
        end;

        if Status = Status::Pending then begin
            MNoEditable := false;
            ClosingDateEditable := false;
            ClosureTypeEditable := false;
            PostingDateEditable := false;
        end;

        if Status = Status::Rejected then begin
            MNoEditable := false;
            ClosingDateEditable := false;
            ClosureTypeEditable := false;
            PostingDateEditable := false;
        end;

        if Status = Status::Approved then begin
            MNoEditable := false;
            ClosingDateEditable := true;
            ClosureTypeEditable := false;
            PostingDateEditable := true;
        end;
    end;


    procedure FnSendWithdrawalApplicationSMS()
    begin

        GenSetUp.Get;
        compinfo.Get;



        //SMS MESSAGE
        SMSMessage.Reset;
        if SMSMessage.Find('+') then begin
            iEntryNo := SMSMessage."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;


        SMSMessage.Init;
        SMSMessage."Entry No" := iEntryNo;
        SMSMessage."Batch No" := "No.";
        SMSMessage."Document No" := "No.";
        SMSMessage."Account No" := "Member No.";
        SMSMessage."Date Entered" := Today;
        SMSMessage."Time Entered" := Time;
        SMSMessage.Source := 'MEMBERSHIPWITH';
        SMSMessage."Entered By" := UserId;
        SMSMessage."Sent To Server" := SMSMessage."sent to server"::No;
        SMSMessage."SMS Message" := 'Dear Member,Your Membership Withdrawal Application has been received and is being Processed '
        + compinfo.Name + ' ' + GenSetUp."Customer Care No";
        cust.Reset;
        cust.SetRange(cust."No.", "Member No.");
        if cust.Find('-') then begin
            SMSMessage."Telephone No" := cust."Mobile Phone No";
        end;
        if cust."Mobile Phone No" <> '' then
            SMSMessage.Insert;
    end;

    local procedure FnRunPostNormalExitApplication(MemberNo: Code[20])
    Var
        Gnljnline: Record "Gen. Journal Line";
        TotalAmount: Decimal;
        NetMemberAmounts: Decimal;
        Doc_No: Code[20];
        DActivity: code[20];
        DBranch: Code[50];
        Cust: Record customer;
        Generalsetup: Record "Sacco General Set-Up";
        RunningBal: Decimal;
        SFactory: Codeunit "SURESTEP Factory";
        InterestTobeRecovered: Decimal;
        LoanTobeRecovered: Decimal;
    begin
        GenSetUp.Get;
        IF Cust.get(MemberNo) then begin
            if Confirm('Proceed With Account Closure ?', false) = false then begin
                exit;
            end else begin
                //....................Ensure that If Batch doesnt exist then create
                IF NOT GenBatch.GET(TemplateName, BatchName) THEN BEGIN
                    GenBatch.INIT;
                    GenBatch."Journal Template Name" := TemplateName;
                    GenBatch.Name := BatchName;
                    GenBatch.INSERT;
                END;
                //....................Reset General Journal Lines
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name", TemplateName);
                GenJournalLine.SETRANGE("Journal Batch Name", BatchName);
                GenJournalLine.DELETEALL;
                //....................Loan Posting Lines
                NetMemberAmounts := 0;
                InterestTobeRecovered := 0;
                GenSetUp.Validate(GenSetUp."Banks Charges");
                //................................................
                DActivity := Cust."Global Dimension 1 Code";
                DBranch := Cust."Global Dimension 2 Code";
                //.................................
                RunningBal := 0;
                RunningBal := "Member Deposits";
                Doc_No := Rec."No.";

                Loans.Reset;
                Loans.SetRange(Loans."Client Code", MemberNo);
                Loans.CalcFields(Loans."Outstanding Balance", Loans."Outstanding Interest");

                if Loans.Find('-') then begin
                    repeat
                        if Loans."Oustanding Interest" > 0 then begin
                            //...........................Recover Loan Interest
                            if Loans."Oustanding Interest" > RunningBal then
                                InterestTobeRecovered := RunningBal else
                                InterestTobeRecovered := Loans."Oustanding Interest";

                            LineNo := LineNo + 10000;
                            SFactory.FnCreateGnlJournalLine(TemplateName, BatchName, Doc_No, LineNo, GenJournalLine."Transaction Type"::"Interest Paid", GenJournalLine."Account Type"::Customer, Loans."Client Code", "Posting Date", InterestTobeRecovered * -1, 'BOSA', Loans."Loan  No.", 'Interest Due Paid on Exit - ', Loans."Loan  No.");
                            //Loans Recovered On Exit
                        end;

                        if Loans."Outstanding Balance" > 0 then begin
                            if Loans."Outstanding Balance" > RunningBal then
                                LoanTobeRecovered := RunningBal else
                                LoanTobeRecovered := Loans."Outstanding Balance";
                            LineNo := LineNo + 10000;
                            SFactory.FnCreateGnlJournalLine(TemplateName, BatchName, Doc_No, LineNo, GenJournalLine."Transaction Type"::Repayment, GenJournalLine."Account Type"::Customer, Loans."Client Code", "Posting Date", LoanTobeRecovered * -1, 'BOSA', Loans."Loan  No.", 'Loan Balance paid on exit - ' + Loans."Loan  No.", Loans."Loan  No.");
                        end;

                        RunningBal := RunningBal - (InterestTobeRecovered + LoanTobeRecovered);
                    until Loans.Next = 0;
                end;

                //Bank Charges
                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(TemplateName, BatchName, Doc_No, LineNo, GenJournalLine."Transaction Type"::" ", GenJournalLine."Account Type"::"G/L Account", GenSetUp."Banks Charges", "Posting Date", "EFT Charge" * -1, 'BOSA', MemberNo, 'Bank Charges for exit', '');
                RunningBal := RunningBal - "EFT Charge";

                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(TemplateName, BatchName, Doc_No, LineNo, GenJournalLine."Transaction Type"::" ", GenJournalLine."Account Type"::"Bank Account", "Paying Bank", "Posting Date", RunningBal * -1, 'BOSA', MemberNo, 'credit Bank Member Exit', '');
            end;

        end;
        //............................Post Lines
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", TemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", BatchName);
        IF GenJournalLine.FIND('-') THEN BEGIN
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
            //Exit Member
            Cust.Reset();
            cust.SETRANGE(cust."No.", "Member No.");
            IF cust.FIND('-') THEN BEGIN
                if (Cust."Outstanding Balance" <= 0) and (Cust."Outstanding Interest" <= 0) then begin
                    cust.Status := cust.Status::Withdrawal;
                    cust.Blocked := cust.Blocked::All;
                    if cust.Modify(true) then begin
                        Posted := true;
                        "Closed By" := UserId;
                        "Closing Date" := Today;
                        "Branch Code" := Cust."Global Dimension 2 Code";
                        "Closed On" := Today;
                        Status := Status::Closed;
                        Modify(true);
                        Message('Member Account Closure was successful');
                        CurrPage.Close();
                    end;
                end else
                    Message('The Member cannot be withdrawn because of pending Balances');

            END;
        end;
    END;


    //......................................

}

