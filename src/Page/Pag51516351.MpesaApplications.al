#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516351 "Mpesa Applications"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "MPESA Applications";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Type"; "Application Type")
                {
                    ApplicationArea = Basic;
                }
                field("Application No"; "Application No")
                {
                    ApplicationArea = Basic;
                }
                field("Document Serial No"; "Document Serial No")
                {
                    ApplicationArea = Basic;
                    Editable = DocSNo;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = DocDate;
                }
                field("Customer ID No"; "Customer ID No")
                {
                    ApplicationArea = Basic;
                    Editable = CustID;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = CustName;

                    trigger OnValidate()
                    begin

                        MPESAApplications.Reset;
                        MPESAApplications.SetRange(MPESAApplications."Customer ID No", "Customer ID No");
                        MPESAApplications.SetRange(MPESAApplications.Status, MPESAApplications.Status::Approved);
                        if MPESAApplications.FindFirst then begin
                            Error('ID Number is used');
                        end;
                    end;
                }
                field("MPESA Mobile No"; "MPESA Mobile No")
                {
                    ApplicationArea = Basic;
                    Editable = MpesaNo;
                }
                field("Old Telephone No"; "Old Telephone No")
                {
                    ApplicationArea = Basic;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = Basic;
                    Editable = Comms;
                }
                field("Date Entered"; "Date Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Entered"; "Time Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Entered By"; "Entered By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Withdrawal Limit Code"; "Withdrawal Limit Code")
                {
                    ApplicationArea = Basic;
                    Editable = WithLimit;
                }
                field("Withdrawal Limit Amount"; "Withdrawal Limit Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102755018; "Mpesa Applications Page Part")
            {
                Editable = MpesaPagePart;
                SubPageLink = "Application No" = field(No);
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
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := Documenttype::"MSacco Applications";
                        ApprovalEntries.SetRecordFilters(Database::"MPESA Applications", DocumentType, No);
                        ApprovalEntries.Run;
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                    //ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Status <> Status::Open then
                            //Created,Open,Canceled,Rejected,Approved
                            Error(text001);

                        TestField("Document Serial No");
                        TestField("Document Date");
                        TestField("Customer ID No");
                        TestField("Customer Name");
                        //TESTFIELD("MPESA Mobile No");

                        if "Application Type" <> "application type"::Change then begin
                            TestField("MPESA Mobile No");
                        end;

                        TestField("Withdrawal Limit Code");
                        TestField("Withdrawal Limit Amount");
                        //TESTFIELD("Responsibility Center");

                        StrTel := CopyStr("MPESA Mobile No", 1, 4);

                        if "Application Type" <> "application type"::Change then begin

                            if StrTel <> '+254' then begin
                                Error('The MPESA Mobile Phone No. should be in the format +254XXXYYYZZZ.');
                            end;


                            if StrLen("MPESA Mobile No") <> 13 then begin
                                Error('Invalid MPESA mobile phone number. Please enter the correct mobile phone number.');
                            end;

                            MPESAAppDetails.Reset;
                            MPESAAppDetails.SetRange(MPESAAppDetails."Application No", No);
                            if MPESAAppDetails.Find('-') then begin
                                //Exists
                            end
                            else begin
                                Error('The MPESA application must have atleast one FOSA or BOSA Account.');
                            end;

                        end;
                        Status := Status::Approved;
                        Modify;
                        Message('Application Approved Succesfuly');
                        //End allocate batch number
                        //IF ApprovalMgt.SendMsaccoAppApprovalRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel A&pproval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                    // ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Status <> Status::Pending then
                            Error(text002);

                        //End allocate batch number
                        //IF ApprovalMgt.CancelMsaccoAppApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                action("Create S-SACCO Application")
                {
                    ApplicationArea = Basic;
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if Status <> Status::Approved then
                            Error('This application has not yet been approved');


                        if Confirm('Are you sure you would like to Create the application?') = true then begin
                            //FOSA
                            MPESAAppDetails.Reset;
                            MPESAAppDetails.SetRange(MPESAAppDetails."Application No", No);
                            MPESAAppDetails.SetRange(MPESAAppDetails."Account Type", MPESAAppDetails."account type"::Vendor);
                            if MPESAAppDetails.Find('-') then begin
                                repeat
                                    Vend.Reset;
                                    Vend.SetRange(Vend."No.", MPESAAppDetails."Account No.");
                                    if Vend.Find('-') then begin
                                        if "Application Type" <> "application type"::Initial then begin
                                            if Vend."MPESA Mobile No" <> '' then begin
                                                Error('The FOSA Account No. ' + Vend."No." + ' has already been registered for M-SACCO.');
                                                exit;
                                            end;
                                        end;
                                        Vend."MPESA Mobile No" := "MPESA Mobile No";
                                        Vend.Modify;
                                    end;
                                until MPESAAppDetails.Next = 0;
                            end;

                            //BOSA

                            MPESAAppDetails.Reset;
                            MPESAAppDetails.SetRange(MPESAAppDetails."Application No", No);
                            MPESAAppDetails.SetRange(MPESAAppDetails."Account Type", MPESAAppDetails."account type"::Customer);
                            if MPESAAppDetails.Find('-') then begin
                                repeat
                                    Cust.Reset;
                                    Cust.SetRange(Cust."No.", MPESAAppDetails."Account No.");
                                    if Cust.Find('-') then begin
                                        if "Application Type" <> "application type"::Initial then begin
                                            if Cust."MPESA Mobile No" <> '' then begin
                                                Error('The BOSA Account No. ' + Cust."No." + ' has already been registered for M-SACCO.');
                                                exit;
                                            end;
                                        end;
                                        Cust."MPESA Mobile No" := "MPESA Mobile No";
                                        Cust.Modify;
                                    end;
                                until MPESAAppDetails.Next = 0;
                            end;

                            MPesaCharges := 0;
                            MPesaChargesAccount := '';

                            //CHARGES
                            GenLedgerSetup.Reset;
                            GenLedgerSetup.Get;
                            GenLedgerSetup.TestField(GenLedgerSetup."M-SACCO Registration Charge");
                            Charges.Reset;
                            Charges.SetRange(Charges.Code, GenLedgerSetup."M-SACCO Registration Charge");
                            if Charges.Find('-') then begin
                                //Charges.TESTFIELD(Charges."Charge Amount");
                                Charges.TestField(Charges."GL Account");
                                MPesaCharges := Charges."Charge Amount";
                                MPesaChargesAccount := Charges."GL Account";
                            end;


                            MPESAAppDetails.Reset;
                            MPESAAppDetails.SetRange(MPESAAppDetails."Application No", No);
                            MPESAAppDetails.SetRange(MPESAAppDetails."Account Type", MPESAAppDetails."account type"::Vendor);
                            if MPESAAppDetails.Find('-') then begin
                                //DELETE
                                GenJournalLine.Reset;
                                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                                GenJournalLine.SetRange("Journal Batch Name", 'MPESA');
                                GenJournalLine.DeleteAll;
                                //end of deletion

                                GenBatches.Reset;
                                GenBatches.SetRange(GenBatches."Journal Template Name", 'GENERAL');
                                GenBatches.SetRange(GenBatches.Name, 'MPESA');
                                if GenBatches.Find('-') = false then begin
                                    GenBatches.Init;
                                    GenBatches."Journal Template Name" := 'GENERAL';
                                    GenBatches.Name := 'MPESA';
                                    GenBatches.Description := 'M-SACCO Registration';
                                    GenBatches.Validate(GenBatches."Journal Template Name");
                                    GenBatches.Validate(GenBatches.Name);
                                    GenBatches.Insert;
                                end;


                                repeat
                                    Acct.Reset;
                                    Acct.SetRange(Acct."No.", MPESAAppDetails."Account No.");
                                    if Acct.Find('-') then begin

                                        //POST CHARGES

                                        //DR Member - total Charges
                                        LineNo := LineNo + 10000;

                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'MPESA';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                        GenJournalLine."Account No." := MPESAAppDetails."Account No.";
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := No;
                                        GenJournalLine."Posting Date" := "Date Entered";
                                        GenJournalLine.Description := 'M-SACCO Registration Charges';
                                        GenJournalLine.Amount := MPesaCharges;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := Acct."Global Dimension 1 Code";
                                        GenJournalLine."Shortcut Dimension 2 Code" := Acct."Global Dimension 2 Code";
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");

                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;

                                        //CR Revenue

                                        LineNo := LineNo + 10000;

                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'MPESA';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                        GenJournalLine."Account No." := MPesaChargesAccount;
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine."Document No." := No;
                                        GenJournalLine."Posting Date" := "Date Entered";
                                        GenJournalLine.Description := 'M-SACCO Registration Charges';
                                        GenJournalLine.Amount := MPesaCharges * -1;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Shortcut Dimension 1 Code" := Acct."Global Dimension 1 Code";
                                        GenJournalLine."Shortcut Dimension 2 Code" := Acct."Global Dimension 2 Code";
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;
                                    end;
                                until MPESAAppDetails.Next = 0;
                            end;


                            //Post
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'MPESA');
                            if GenJournalLine.Find('-') then begin
                                // repeat
                                // GLPosting.Run(GenJournalLine);
                                // until GenJournalLine.Next = 0;
                                Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);
                            end;


                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'MPESA');
                            GenJournalLine.DeleteAll;
                            //Post


                            "App Status" := "app status"::Approved;
                            "Date Approved" := Today;
                            "Time Approved" := Time;
                            "Approved By" := UserId;
                            Modify;

                            Message('M-SACCO activated for Customer ' + "Customer Name" + '. The Customer will receive a confirmation SMS shortly.');

                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
    end;

    var
        StrTel: Text[30];
        text001: label 'This application must be open';
        ApprovalEntries: Page "Approval Entries";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation",Overdraft,ImprestSurrender,"MSacco Applications";
        Vend: Record Vendor;
        Cust: Record Customer;
        MPESAAppDetails: Record "MPESA Application Details";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Acct: Record Vendor;
        ATMCharges: Decimal;
        BankCharges: Decimal;
        GenBatches: Record "Gen. Journal Batch";
        // GLPosting: Codeunit "Gen. Jnl.-Post Line";
        BankCode: Code[20];
        PDate: Date;
        RevFromDate: Date;
        MPESATRANS: Record "MPESA Transactions";
        GenLedgerSetup: Record "General Ledger Setup";
        MPesaAccount: Code[50];
        MPesaCharges: Decimal;
        MPesaChargesAccount: Code[50];
        MPesaLiabilityAccount: Code[50];
        TotalCharges: Decimal;
        TariffHeader: Record "Tarrif Header";
        TariffDetails: Record "Tariff Details";
        Charges: Record Charges;
        TariffCharges: Decimal;
        DocSNo: Boolean;
        DocDate: Boolean;
        CustID: Boolean;
        CustName: Boolean;
        MpesaNo: Boolean;
        Comms: Boolean;
        WithLimit: Boolean;
        MpesaPagePart: Boolean;
        text002: label 'Application must be pending approval';
        MPESAApplications: Record "MPESA Applications";


    procedure UpdateControl()
    begin

        if Status = Status::Open then begin
            DocSNo := true;
            DocDate := true;
            CustID := true;
            CustName := true;
            MpesaNo := true;
            Comms := true;
            WithLimit := true;
            MpesaPagePart := true;
        end;

        if Status = Status::Pending then begin
            DocSNo := false;
            DocDate := false;
            CustID := false;
            CustName := false;
            MpesaNo := false;
            Comms := false;
            WithLimit := false;
            MpesaPagePart := false;
        end;

        if Status = Status::Rejected then begin
            DocSNo := false;
            DocDate := false;
            CustID := false;
            CustName := false;
            MpesaNo := false;
            Comms := false;
            WithLimit := false;
            MpesaPagePart := false;
        end;

        if Status = Status::Approved then begin
            DocSNo := false;
            DocDate := false;
            CustID := false;
            CustName := false;
            MpesaNo := false;
            Comms := false;
            WithLimit := false;
            MpesaPagePart := false;
        end;
    end;
}

