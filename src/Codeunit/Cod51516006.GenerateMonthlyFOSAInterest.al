codeunit 51516006 "Generate Monthly FOSA Interest"
{
    trigger OnRun()
    var

    begin
        FnGenerateFOSAInterest();
    end;

    procedure FnGenerateFOSAInterest()
    var
        VendorTable: Record Vendor;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Vendor: Record Vendor;
        AccountTypesSetup: Record "Account Types-Saving Products";
        PeriodFilter: Date;
        AuthenticationPage: page "Process Interest Picker";
        DialogBox: Dialog;
        counter: Integer;
        outof: Integer;
        PreviousMonthEndDate: Date;
        InterestEarnedBD: Decimal;
        LoopInterestEarned: Decimal;
        NoOfLoops: Integer;
        LoopsMade: integer;
        TotalInterestEarned: Decimal;
        DateUsed: date;
        LineNo: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        InterestBuffer: Record "Interest Buffer";
        IntBufferNo: Integer;
    begin
        if Confirm('Are you sure you want to Generate Interest Earned for FOSA Accounts?', false) = false then begin
            exit;
        end else begin

            //...................................Get the period Start & Period End
            Clear(AuthenticationPage);
            IF AuthenticationPage.RUNMODAL <> ACTION::OK THEN begin
                exit;
            end else begin
                PeriodFilter := AuthenticationPage.GetDateFilterEntered();
                IF PeriodFilter = 0D THEN begin
                    PeriodFilter := Today;
                end;
            end;

            //...................................Calculate Interest Earned
            VendorTable.Reset();
            VendorTable.SetFilter(VendorTable."Account Type", '%1|%2|%3', 'ORDINARY', 'JUNIOR', 'JAZA');
            VendorTable.SetRange(VendorTable.Status, VendorTable.Status::Active);
            if VendorTable.Find('-') then begin

                counter := 0;
                outof := VendorTable.Count();
                //----------------------------------Reset GL Lines
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'INT_EARNED');
                IF GenJournalLine.Find('-') THEN begin
                    GenJournalLine.DELETEALL();
                end;
                InterestBuffer.reset;
                IF InterestBuffer.Find('-') THEN begin
                    InterestBuffer.DELETEALL();
                end;
                repeat
                    PreviousMonthEndDate := 0D;
                    PreviousMonthEndDate := CalcDate('-1M', CalcDate('CM', PeriodFilter));
                    NoOfLoops := 0;
                    NoOfLoops := (PeriodFilter - CalcDate('-CM', PeriodFilter)) + 1;
                    LoopsMade := 0;
                    TotalInterestEarned := 0;
                    LoopInterestEarned := 0;
                    if AccountTypesSetup.Get(VendorTable."Account Type") then begin
                        AccountTypesSetup.SetRange(AccountTypesSetup."Earns Interest", true);
                        counter := counter + 1;
                        //-----------------------------------------------
                        DialogBox.Open('Processing ' + Format(VendorTable."No.") + ' Interest Earned in account ' + Format(VendorTable."Account Type") + ' ' + Format(counter) + '/' + Format(outof));
                        //Get Earned Interest Upto Last Month
                        Vendor.Reset();
                        Vendor.SetRange(VENDOR."No.", VendorTable."No.");
                        Vendor.SetFilter(Vendor."Date Filter", '..' + Format(PreviousMonthEndDate));
                        IF Vendor.Find('-') THEN begin
                            Vendor.CalcFields(Vendor."FOSA Balance");
                            InterestEarnedBD := 0;
                            IF Vendor."FOSA Balance" > 0 then begin
                                InterestEarnedBD := Vendor."FOSA Balance" * (AccountTypesSetup."Interest Rate" / 100);
                            end;
                        end;
                        //Get Interest Earned Prorated current month
                        //No of loops to make
                        repeat
                            LoopsMade := LoopsMade + 1;
                            DateUsed := 0D;
                            DateUsed := DMY2DATE(LoopsMade, DATE2DMY(PeriodFilter, 2), DATE2DMY(PeriodFilter, 3));
                            Vendor.SetRange(VENDOR."No.", VendorTable."No.");
                            Vendor.SetRange(Vendor."Date Filter", DateUsed);
                            IF Vendor.Find('-') THEN begin
                                Vendor.CalcFields(Vendor."FOSA Balance");
                                IF Vendor."FOSA Balance" > 0 then begin
                                    LoopInterestEarned := (LoopInterestEarned) + Vendor."FOSA Balance" * (AccountTypesSetup."Interest Rate" / 100);
                                end;
                            end;
                        until LoopsMade = NoOfLoops;
                        TotalInterestEarned := 0;
                        TotalInterestEarned := InterestEarnedBD + LoopInterestEarned;
                        //----------------------Insert Into GL's
                        if TotalInterestEarned > 0 then begin
                            LineNo := LineNo + 10000;
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Journal Batch Name" := 'INT_EARNED';
                            GenJournalLine."Document No." := 'MONTH INT-' + Format(PeriodFilter);
                            GenJournalLine."External Document No." := Vendor."No.";
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                            GenJournalLine."Account No." := Vendor."No.";
                            // GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                            // GenJournalLine."Account No." := AccountTypesSetup."Interest Expense Account";
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := CalcDate('-1D', Today);
                            GenJournalLine.Description := 'Monthly Interest Earned On Account ' + Format(Vendor."Account Type") + '-' + Format(PeriodFilter);
                            GenJournalLine.Amount := -TotalInterestEarned;
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := AccountTypesSetup."Interest Expense Account";
                            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                            GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                            IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN
                                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            IF GenJournalLine.Amount <> 0 THEN
                                GenJournalLine.INSERT;
                            //......................Deduct withholding tax
                            LineNo := LineNo + 10000;
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Journal Batch Name" := 'INT_EARNED';
                            GenJournalLine."Document No." := 'MONTH INT-' + Format(PeriodFilter);
                            GenJournalLine."External Document No." := Vendor."No.";
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                            GenJournalLine."Account No." := Vendor."No.";
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := CalcDate('-1D', Today);

                            GenJournalLine.Description := 'Withholding tax on Interest Earned On Account ' + Format(Vendor."Account Type") + '-' + Format(PeriodFilter);
                            GenJournalLine.Amount := Round(((TotalInterestEarned) * AccountTypesSetup."Tax On Interest" / 100), 0.05, '>');
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := AccountTypesSetup."Interest Tax Account";
                            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                            GenJournalLine."Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                            IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN
                                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            IF GenJournalLine.Amount <> 0 THEN
                                GenJournalLine.INSERT;
                            //.........................Insert Data To A storage Table
                            InterestBuffer.RESET;
                            IF InterestBuffer.FIND('+') THEN begin
                                IntBufferNo := InterestBuffer.No;
                            end;
                            IntBufferNo := IntBufferNo + 1;
                            InterestBuffer.INIT;
                            InterestBuffer.No := IntBufferNo;
                            InterestBuffer."Account No" := Vendor."No.";
                            InterestBuffer."Account Type" := Vendor."Account Type";
                            InterestBuffer."Interest Date" := PeriodFilter;
                            InterestBuffer."Interest Amount" := TotalInterestEarned;
                            InterestBuffer."User ID" := USERID;
                            InterestBuffer."Document No" := vendor.Name;
                            InterestBuffer.Description := 'Monthly Interest Earned On Account ' + Format(Vendor."Account Type") + ' -' + Format(PeriodFilter);
                            IF InterestBuffer."Interest Amount" <> 0 THEN
                                InterestBuffer.INSERT(TRUE);
                        end;
                    end;
                until VendorTable.Next = 0;
                DialogBox.Close();
                //....................................Autopost Entries
                // GenJournalLine.RESET;
                // GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                // GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'INT_EARNED');
                // IF GenJournalLine.Find('-') THEN begin
                //     REPEAT
                //         GLPosting.RUN(GenJournalLine);
                //     UNTIL GenJournalLine.NEXT = 0;
                // end;
                //...................................Delete Entries
                // GenJournalLine.RESET;
                // GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", 'GENERAL');
                // GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", 'INT_EARNED');
                // IF GenJournalLine.Find('-') THEN begin
                //     GenJournalLine.DeleteAll();
                // end;
                //....................................Email Excel
                // FnSendEmail(PeriodFilter);
                //....................................
                Message('Done');
            end;
        end;
    end;

    local procedure FnSendEmail(PeriodFilter: Date)
    var
        MemberReg: Record Customer;
        FileName: Text[200];
        FileName2: Text[200];
        FileType: Text[100];
        SendEmailTo: Text[100];
        EmailBody: Text[1000];
        EmailSubject: Text[100];
        membersreg: Record Customer;
        Outstr: OutStream;
        Instr: InStream;

        Outstr2: OutStream;
        Instr2: InStream;
        TempBlob: Codeunit "Temp Blob";

        MailToSend: Codeunit "Email Message";
        GenerateDoc: InStream;//Generate PDF/Document to be sent 
        EncodeStream: Codeunit "Base64 Convert";//To encode the stream of data form GenerateDoc
        FnEmail: Codeunit Email;
        DialogBox: Dialog;
    begin
        //------------------->Get Key Details of Send Email
        SendEmailTo := '';
        SendEmailTo := 'amutuma@surestep.co.ke';//"E-Mail (Personal)"
        EmailSubject := '';
        EmailSubject := 'GENERATED AND POSTED FOSA INTEREST EARNED';

        EmailBody := '';
        EmailBody := 'Dear ' + Format('team') + '  We hope this email finds you well.Please find the attached excel document for the the generated and posted FOSA Interests for the period ending ' + Format(PeriodFilter);
        //------------------->Generate The Report Attachments To Send
        //---------Attachment 1
        FileName := Format(PeriodFilter) + '-FOSAInterestPosted.XLSX';
        TempBlob.CreateOutStream(Outstr);
        Report.SaveAs(Report::"FOSA Interest Generated", '', ReportFormat::Excel, Outstr);
        TempBlob.CreateInStream(Instr);
        //------------------->Create Emails Start
        MailToSend.Create(SendEmailTo, EmailSubject, EmailBody);
        MailToSend.AddAttachment(FileName, FileType, Instr);
        FnEmail.Send(MailToSend, Enum::"Email Scenario"::Default);
        Message('The Process has completed successfully. Please Check your email for more details');

    end;

}
