#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516354 "Mpesa Applications Approval"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "MPESA Applications";
    SourceTableView = where(Status=const(Pending));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document Serial No";"Document Serial No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer ID No";"Customer ID No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer Name";"Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Old Telephone No";"Old Telephone No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("MPESA Mobile No";"MPESA Mobile No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Rejection Reason";"Rejection Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Date Entered";"Date Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Entered";"Time Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Entered By";"Entered By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Sent To Server";"Sent To Server")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Approved";"Date Approved")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Approved";"Time Approved")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approved By";"Approved By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Rejected";"Date Rejected")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Rejected";"Time Rejected")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Rejected By";"Rejected By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Withdrawal Limit Amount";"Withdrawal Limit Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Mpesa Applications")
            {
                Caption = 'Mpesa Applications';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        
                        if Confirm('Are you sure you would like to approve the application?') = true then begin
                        
                          //FOSA
                          /*
                          MPESAAppDetails.RESET;
                          MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                          MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Vendor);
                          IF MPESAAppDetails.FIND('-') THEN BEGIN
                            REPEAT
                              Vend.RESET;
                              Vend.SETRANGE(Vend."No.",MPESAAppDetails."Account No.");
                              IF Vend.FIND('-') THEN BEGIN
                                IF "Application Type"<>"Application Type"::Initial THEN BEGIN
                                  IF Vend."MPESA Mobile No"<>'' THEN BEGIN
                                   // ERROR('The FOSA Account No. ' + Vend."No." + ' has already been registered for M-SACCO.');
                                    EXIT;
                                  END;
                                END;
                                Vend."MPESA Mobile No":='';
                                Vend.MODIFY;
                              END;
                            UNTIL MPESAAppDetails.NEXT=0;
                          END;
                        */
                        
                        
                        MPESAAppDetails.Reset;
                        MPESAAppDetails.SetRange(MPESAAppDetails."Application No",No);
                        MPESAAppDetails.SetRange(MPESAAppDetails."Account Type",MPESAAppDetails."account type"::Vendor);
                        if MPESAAppDetails.Find('-') then begin
                        repeat
                        Vend.Reset;
                        Vend.SetRange(Vend."No.",MPESAAppDetails."Account No.");
                        if Vend.Find('-') then begin
                            /*
                             IF Vend."MPESA Mobile No"<>'' THEN BEGIN
                               ERROR('The FOSA Account No. ' + Vend."No." + ' has already been registered for M-SACCO.');
                               EXIT;
                            END;
                            */
                        Vend."MPESA Mobile No":="MPESA Mobile No";
                        Vend.Modify;
                        end;
                        until MPESAAppDetails.Next=0;
                        end;
                        
                        
                        
                        
                        //BOSA
                        /*
                        MPESAAppDetails.RESET;
                        MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                        MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Customer);
                        IF MPESAAppDetails.FIND('-') THEN BEGIN
                          REPEAT
                            Cust.RESET;
                            Cust.SETRANGE(Cust."No.",MPESAAppDetails."Account No.");
                            IF Cust.FIND('-') THEN BEGIN
                              IF "Application Type"="Application Type"::Initial THEN BEGIN
                                IF Cust."MPESA Mobile No"<>'' THEN BEGIN
                                  ERROR('The BOSA Account No. ' + Cust."No." + ' has already been registered for M-SACCO.');
                                  EXIT;
                                END;
                              END;
                              Cust."MPESA Mobile No":="MPESA Mobile No";
                              Cust.MODIFY;
                            END;
                          UNTIL MPESAAppDetails.NEXT=0;
                        END;
                        */
                        
                        MPesaCharges:=0;
                        MPesaChargesAccount:='';
                        
                        //CHARGES
                        GenLedgerSetup.Reset;
                        GenLedgerSetup.Get;
                        GenLedgerSetup.TestField(GenLedgerSetup."M-SACCO Registration Charge");
                        Charges.Reset;
                        Charges.SetRange(Charges.Code,GenLedgerSetup."M-SACCO Registration Charge");
                        if Charges.Find('-') then begin
                        //Charges.TESTFIELD(Charges."Charge Amount");
                        Charges.TestField(Charges."GL Account");
                        MPesaCharges:=Charges."Charge Amount";
                        MPesaChargesAccount:=Charges."GL Account";
                        end;
                        
                        
                        MPESAAppDetails.Reset;
                        MPESAAppDetails.SetRange(MPESAAppDetails."Application No",No);
                        MPESAAppDetails.SetRange(MPESAAppDetails."Account Type",MPESAAppDetails."account type"::Vendor);
                        if MPESAAppDetails.Find('-') then begin
                        //DELETE
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name",'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name",'MPESA');
                        GenJournalLine.DeleteAll;
                        //end of deletion
                        
                        GenBatches.Reset;
                        GenBatches.SetRange(GenBatches."Journal Template Name",'GENERAL');
                        GenBatches.SetRange(GenBatches.Name,'MPESA');
                        if GenBatches.Find('-') = false then begin
                        GenBatches.Init;
                        GenBatches."Journal Template Name":='GENERAL';
                        GenBatches.Name:='MPESA';
                        GenBatches.Description:='M-SACCO Registration';
                        GenBatches.Validate(GenBatches."Journal Template Name");
                        GenBatches.Validate(GenBatches.Name);
                        GenBatches.Insert;
                        end;
                        
                        
                        repeat
                        Acct.Reset;
                        Acct.SetRange(Acct."No.",MPESAAppDetails."Account No.");
                        if Acct.Find('-') then begin
                        
                        //POST CHARGES
                        
                               //DR Member - total Charges
                            LineNo:=LineNo+10000;
                        
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name":='GENERAL';
                            GenJournalLine."Journal Batch Name":='MPESA';
                            GenJournalLine."Line No.":=LineNo;
                            GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No.":=MPESAAppDetails."Account No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No.":=No;
                            GenJournalLine."Posting Date":="Date Entered";
                            GenJournalLine.Description:='M-SACCO Registration Charges';
                            GenJournalLine.Amount:=MPesaCharges;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code":=Acct."Global Dimension 1 Code";
                            GenJournalLine."Shortcut Dimension 2 Code":=Acct."Global Dimension 2 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        
                            if GenJournalLine.Amount<>0 then
                            GenJournalLine.Insert;
                        
                        //CR Revenue
                        
                        LineNo:=LineNo+10000;
                        
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name":='GENERAL';
                            GenJournalLine."Journal Batch Name":='MPESA';
                            GenJournalLine."Line No.":=LineNo;
                            GenJournalLine."Account Type":=GenJournalLine."account type"::"G/L Account";
                            GenJournalLine."Account No.":=MPesaChargesAccount;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Document No.":=No;
                            GenJournalLine."Posting Date":="Date Entered";
                            GenJournalLine.Description:='M-SACCO Registration Charges';
                            GenJournalLine.Amount:=MPesaCharges*-1;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code":=Acct."Global Dimension 1 Code";
                            GenJournalLine."Shortcut Dimension 2 Code":=Acct."Global Dimension 2 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount<>0 then
                            GenJournalLine.Insert;
                        end;
                        until MPESAAppDetails.Next=0;
                        end;
                        
                        
                        //Post
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name",'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name",'MPESA');
                        if GenJournalLine.Find('-') then begin
                        // repeat
                        // GLPosting.Run(GenJournalLine);
                        // until GenJournalLine.Next = 0;
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);
                        end;
                        
                        
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name",'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name",'MPESA');
                        GenJournalLine.DeleteAll;
                        //Post
                        
                        
                        Status:=Status::Approved;//Status:=Status::"1st Approval";
                        "Date Approved":=Today;
                        "Time Approved":=Time;
                        "Approved By":=UserId;
                        Modify;
                        
                        Message('M-SACCO activated for Customer ' + "Customer Name" + '. The Customer will receive a confirmation SMS shortly.');
                        
                        end;

                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        if Confirm('Are you sure you would like to reject the application?') = true then begin
                        TestField("Rejection Reason");
                        Status:=Status::Rejected;
                        "Date Rejected":=Today;
                        "Time Rejected":=Time;
                        "Rejected By":=UserId;
                        Modify;
                        Message('Application for ' + "Customer Name" +' has been rejected. The Customer will be notified via SMS of the rejection reason.'
                        );
                        end;
                    end;
                }
            }
        }
    }

    var
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
}

