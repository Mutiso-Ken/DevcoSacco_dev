page 51516083 "Tea Processing Header"
{
    ApplicationArea = All;
    Caption = 'Tea Processing Header';
    PageType = Card;
    SourceTable = "Periodics Processing Header";
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document No"; Rec."Document No")
                {
                    Editable = false;
                }
                field("Processing Type"; Rec."Processing Type")
                {
                    Editable = false;
                }
                field("Posting Document No"; "Posting Document No")
                {
                }
                field("Entered By"; Rec."Entered By")
                {
                    Editable = false;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                }
                field("Posted By"; Rec."Posted By")
                {
                    Editable = false;
                }
                field("Notify Member(s)"; Rec."Notify Member(s)")
                {
                }
            }
            part("Tea Processing Lines"; "Tea Processing Lines")
            {
                Caption = 'Tea Processing Lines';
                SubPageLink = "Document No" = field("Document No");
                Editable = true;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ImportSalary)
            {
                RunObject = xmlport "Import Tea Periodics";
                Caption = 'Import Tea';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ImportExcel;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
            action(ResetLines)
            {
                Caption = 'Reset Lines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ReceivablesPayablesSetup;
                trigger OnAction()
                var
                    SalaryImportedLines: Record "Periodics Processing Lines";
                begin
                    if Confirm('Reset Tea Processing Lines  for Document No ?', false) = false then begin
                        exit;
                    end else begin
                        SalaryImportedLines.Reset();
                        SalaryImportedLines.SetRange(SalaryImportedLines."Document No", "Document No");
                        if SalaryImportedLines.Find('-') then begin
                            SalaryImportedLines.DeleteAll();
                        end;
                        Message('Done');
                    end;
                    CurrPage.Update();
                end;
            }
            action(Validate)
            {
                Caption = 'Validate Account Details';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ValidateEmailLoggingSetup;
                trigger OnAction()
                var
                    SalaryImportedLines: Record "Periodics Processing Lines";
                    Vendor: Record Vendor;
                begin
                    SalaryImportedLines.Reset();
                    SalaryImportedLines.SetRange(SalaryImportedLines."Document No", "Document No");
                    if SalaryImportedLines.Find('-') then begin
                        repeat
                            Vendor.Reset();
                            Vendor.SetRange(Vendor."Grower No", SalaryImportedLines."Grower No");
                            if Vendor.Find('-') = true then begin
                                SalaryImportedLines."Account Found" := true;
                                SalaryImportedLines."Member Name" := Vendor.Name;
                                SalaryImportedLines."Account No" := Vendor."No.";
                                SalaryImportedLines."Member No" := Vendor."BOSA Account No";
                                SalaryImportedLines."Staff No" := Vendor."Employer P/F";
                                if Vendor.Blocked = Vendor.Blocked::All then begin
                                    SalaryImportedLines."Account Is Blocked" := true;
                                end else
                                    if Vendor.Blocked = Vendor.Blocked::" " then begin
                                        SalaryImportedLines."Account Is Blocked" := false;
                                    end;
                            end;
                            SalaryImportedLines.Modify(true);
                        until SalaryImportedLines.Next = 0;
                    end;
                    CurrPage.Update();
                end;
            }

            action(GenerateLines)
            {
                Caption = 'Generate Journal Lines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ValidateEmailLoggingSetup;
                trigger OnAction()
                var
                    SalaryImportedLines: Record "Periodics Processing Lines";
                    Vendor: Record Vendor;
                    PeriodicProcessingLines: Record "Periodics Processing Lines";
                    teabufferringtable: record "Tea Bufferring Table";
                begin
                    SalaryImportedLines.Reset();
                    SalaryImportedLines.SetRange(SalaryImportedLines."Document No", "Document No");
                    IF SalaryImportedLines.Find('-') THEN begin
                        repeat
                            IF Vendor.Get(SalaryImportedLines."Account No") THEN begin
                                IF Vendor.Blocked = Vendor.Blocked::All THEN begin
                                    Error('Account ' + Format(SalaryImportedLines."Account No") + ' is blocked with type All');
                                end;
                            end;
                        until SalaryImportedLines.Next = 0;
                    end;
                    // teabufferringtable.Reset();
                    // if teabufferringtable.Find('-') then begin
                    //     teabufferringtable.DeleteAll();
                    // end;
                    // //..............................................................Insert To Table
                    // PeriodicProcessingLines.Reset();
                    // PeriodicProcessingLines.SetRange(PeriodicProcessingLines."Document No", "Document No");
                    // if PeriodicProcessingLines.Find('-') then begin
                    //     repeat
                    //         teabufferringtable.Reset();
                    //         teabufferringtable.SetRange(teabufferringtable."Account No", PeriodicProcessingLines."Account No");
                    //         if teabufferringtable.Find('-') = false then begin
                    //             teabufferringtable.Init();
                    //             teabufferringtable."Document No" := PeriodicProcessingLines."Document No";
                    //             teabufferringtable."Account No" := PeriodicProcessingLines."Account No";
                    //             teabufferringtable.Amount := PeriodicProcessingLines.Amount;
                    //             teabufferringtable.Insert(true);
                    //         end else
                    //             if teabufferringtable.Find('-') = true then begin
                    //                 teabufferringtable.Amount := teabufferringtable.Amount + PeriodicProcessingLines.Amount;
                    //                 teabufferringtable.Modify(true);
                    //             end;
                    //     until PeriodicProcessingLines.Next = 0;
                    // end;
                    //..............................................................
                    SalaryImportedLines.Reset();
                    SalaryImportedLines.SetRange(SalaryImportedLines."Document No", "Document No");
                    if SalaryImportedLines.Find('-') then begin
                        Report.Run(51516043, true, false, SalaryImportedLines);
                    end;
                end;
            }
            action(MarkAsPosted)
            {
                Caption = 'Mark As Posted';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = MakeOrder;
                trigger OnAction()
                var
                    SMSBody: Text;
                    SurestepFactory: Codeunit "SURESTEP Factory";
                    PeriodicProcessingLines: Record "Periodics Processing Lines";
                Begin
                    if Confirm('Are you sure you want to Mark this card as posted?', false) = false then begin
                        exit;
                    end else begin
                        //.................................................
                        IF "Notify Member(s)" = true THEN begin
                            PeriodicProcessingLines.Reset();
                            PeriodicProcessingLines.SetRange(PeriodicProcessingLines."Document No", "Document No");
                            if PeriodicProcessingLines.Find('-') then begin
                                repeat
                                    SMSBody := 'Dear ' + Format(PeriodicProcessingLines."Member Name") + ' your account ' + Format(PeriodicProcessingLines."Account No") + ' has been credited with Ksh. ' + Format(PeriodicProcessingLines.Amount) + '.Thank you for banking with us.';
                                    SurestepFactory.FnSendSMS('MOBILETRAN', SMSBody, PeriodicProcessingLines."Account No", FnGetMobilePhone(PeriodicProcessingLines."Account No"));
                                    PeriodicProcessingLines.Posted := true;
                                    PeriodicProcessingLines."Posting Date" := Today;
                                    PeriodicProcessingLines.Modify();
                                until PeriodicProcessingLines.Next = 0;
                            end;
                            //..................
                            Posted := true;
                            "Posted By" := UserId;
                            Status := Status::Closed;
                            Modify();
                        end else
                            IF "Notify Member(s)" = false THEN begin
                                PeriodicProcessingLines.Reset();
                                PeriodicProcessingLines.SetRange(PeriodicProcessingLines."Document No", "Document No");
                                if PeriodicProcessingLines.Find('-') then begin
                                    repeat
                                        PeriodicProcessingLines.Posted := true;
                                        PeriodicProcessingLines."Posting Date" := Today;
                                        PeriodicProcessingLines.Modify();
                                    until PeriodicProcessingLines.Next = 0;
                                end;
                                //..................
                                Posted := true;
                                "Posted By" := UserId;
                                Status := Status::Closed;
                                Modify();
                            end;
                    end;
                End;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Processing Type" := "Processing Type"::Tea;
        "Posting Date" := Today;
    end;

    local procedure FnGetMobilePhone(AccountNo: Code[100]): Text
    var
        VendorTable: Record Vendor;
    begin
        VendorTable.Reset();
        VendorTable.SetRange(VendorTable."No.", AccountNo);
        if VendorTable.Find('-') then begin
            if (VendorTable."Phone No.") <> '' then begin
                exit(VendorTable."Phone No.");
            end;
            if (VendorTable."Mobile Phone No.") <> '' then begin
                exit(VendorTable."Mobile Phone No.");
            end;
        end;
    end;
}
