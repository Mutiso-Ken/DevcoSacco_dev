page 51516138 "Posted Periodics Header"
{
    ApplicationArea = All;
    Caption = 'Posted Periodics Header';
    PageType = Card;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    SourceTable = "Periodics Processing Header";

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
            part("Salary Processing Lines"; "Salary Processing Lines")
            {
                Caption = 'Salary Processing Lines';
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
                RunObject = xmlport "Import Salary Periodics";
                Caption = 'Import Salary';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = false;
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
                Enabled = false;
                Image = ReceivablesPayablesSetup;
                trigger OnAction()
                var
                    SalaryImportedLines: Record "Periodics Processing Lines";
                begin
                    if Confirm('Reset Salary Processing Lines  for Document No ?', false) = false then begin
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
                Enabled = false;
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
                            SalaryImportedLines."Account Found" := false;
                            SalaryImportedLines."Member Name" := '';
                            SalaryImportedLines."Member No" := '';
                            SalaryImportedLines."Staff No" := '';
                            Vendor.Reset();
                            Vendor.SetRange(Vendor."No.", SalaryImportedLines."Account No");
                            if Vendor.Find('-') then begin
                                SalaryImportedLines."Account Found" := true;
                                SalaryImportedLines."Member Name" := Vendor.Name;
                                SalaryImportedLines."Member No" := Vendor."BOSA Account No";
                                SalaryImportedLines."Staff No" := Vendor."Employer P/F";
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
                Enabled = false;
                Image = ValidateEmailLoggingSetup;
                trigger OnAction()
                var
                    SalaryImportedLines: Record "Periodics Processing Lines";
                    Vendor: Record Vendor;
                begin
                    SalaryImportedLines.Reset();
                    SalaryImportedLines.SetRange(SalaryImportedLines."Document No", "Document No");
                    if SalaryImportedLines.Find('-') then begin
                        Report.Run(51516042, true, false, SalaryImportedLines);
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
                Enabled = false;
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
                                // PeriodicProcessingLines.Modify();
                                until PeriodicProcessingLines.Next = 0;
                            end;
                            //..................
                            Posted := true;
                            "Posted By" := UserId;
                            Status := Status::Closed;
                            //Modify();
                        end;
                    end;
                End;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Processing Type" := "Processing Type"::Salary;
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

    trigger OnOpenPage()
    var
        PeriodicProcessingLines: Record "Periodics Processing Header";
    begin
        SetRange("Entered By", UserId);
    end;
}
