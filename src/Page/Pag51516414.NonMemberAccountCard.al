#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516414 "NonMember Account Card"
{
    ApplicationArea = Basic;
    Caption = 'NonMember Card';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'Process,Reports,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = Customer;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = true;
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("ID No."; "ID No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID Number';
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile No.';
                    Editable = false;
                    Style = StrongAccent;
                }

                field(Gender; Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field(txtMarital; "Marital Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Marital Status';
                    Editable = false;
                    Visible = txtMaritalVisible;
                }
                field("Date of Birth"; "Date of Birth")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date of Birth';
                    Editable = false;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                // field("FOSA Account"; "FOSA Account")
                // {
                //     ApplicationArea = Basic;
                //     Editable = false;

                //     trigger OnValidate()
                //     begin
                //         FosaName := '';

                //         if "FOSA Account" <> '' then begin
                //             if Vend.Get("FOSA Account") then begin
                //                 FosaName := Vend.Name;
                //             end;
                //         end;
                //     end;
                // }
                // field(FosaName; FosaName)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'FOSA Account Name';
                //     Editable = false;
                // }
                field("Account Category"; "Account Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payroll/Staff No"; "Payroll/Staff No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employer Code"; "Employer Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer';
                    Editable = false;
                }

                field("Passport No."; "Passport No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Address; Address)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Location';
                    Editable = false;
                }
                field("Village/Residence"; "Village/Residence")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Physical States"; "Physical States")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(City; City)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }

                field("Job Title"; "Job title")
                {
                    ApplicationArea = Basic;
                    Caption = 'Title';
                    Editable = false;
                    Visible = false;
                }
                field(PIN; Pin)
                {
                    ApplicationArea = Basic;
                    Caption = 'KRA PIN';
                    Editable = false;
                }
                field("Registration Date"; "Registration Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code"
                )
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code"
                )
                {
                    ApplicationArea = Basic;
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        StatusPermissions.Reset;
                        StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
                        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Overide Defaulters");
                        if StatusPermissions.Find('-') = false then
                            Error('You do not have permissions to change the account status.');
                    end;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Sms Notification"; "Sms Notification")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Member Risk Rating")
            {
                Editable = false;
                Visible = false;
                group("Member Risk Rate")
                {
                    field("Individual Category"; "Individual Category")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Member Residency Status"; "Member Residency Status")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Entities; Entities)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Industry Type"; "Industry Type")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Length Of Relationship"; "Length Of Relationship")
                    {
                        ApplicationArea = Basic;
                    }
                    field("International Trade"; "International Trade")
                    {
                        ApplicationArea = Basic;
                    }
                }
                group("Product Risk Rating")
                {
                    field("Electronic Payment"; "Electronic Payment")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Accounts Type Taken"; "Accounts Type Taken")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Cards Type Taken"; "Cards Type Taken")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Others(Channels)"; "Others(Channels)")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Member Risk Level"; "Member Risk Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Risk Level';
                        Editable = false;
                        StyleExpr = CoveragePercentStyle;
                    }
                    field("Due Diligence Measure"; "Due Diligence Measure")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        StyleExpr = CoveragePercentStyle;
                    }
                }
                part(Control39; "Member Due Diligence Measure")
                {
                    Caption = 'Due Diligence Measure';
                    SubPageLink = "Member No" = field("No.");
                    SubPageView = sorting("Due Diligence No");
                }
            }
            group("Other Details")
            {
                Caption = 'Other Details';
                Editable = true;
                field("Contact Person"; "Contact Person")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Contact Person Phone"; "Contact Person Phone")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field(Board; Board)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(staff; staff)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }

                field("Home Page"; "Home Page")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Physical Address';
                    Editable = false;
                    Visible = false;
                }
                field("Mode of Dividend Payment"; "Mode of Dividend Payment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Recruited By"; "Recruited By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
            }
            group("Member Withdrawal Details")
            {
                Caption = 'Member Withdrawal Details';
                visible = false;
                field("Withdrawal Application Date"; "Withdrawal Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Date"; "Withdrawal Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Withdrawal Fee"; "Withdrawal Fee")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Status - Withdrawal App."; "Status - Withdrawal App.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Withdrawal Status';
                    Editable = false;
                }
            }
            group("Bank Details")
            {
                visible = false;
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Code"; "Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name"; "Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Branch"; "Bank Branch")
                {
                    ApplicationArea = Basic;
                }
            }
            group("File Movement Tracker")
            {
                Caption = 'File Movement Tracker';
                visible = false;
                field(Filelocc; Filelocc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current File Location';
                    Editable = false;
                }
                field("Loc Description"; "Loc Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Move to"; "Move to")
                {
                    ApplicationArea = Basic;
                    Caption = 'Dispatch to:';
                }
                field("Move to description"; "Move to description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(User; User)
                {
                    ApplicationArea = Basic;
                }
                field("File Movement Remarks"; "File Movement Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("File MVT User ID"; "File MVT User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("File MVT Date"; "File MVT Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("File MVT Time"; "File MVT Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("file Received"; "file Received")
                {
                    ApplicationArea = Basic;
                    Caption = 'File Received';
                    Editable = false;
                }
                field("file received date"; "file received date")
                {
                    ApplicationArea = Basic;
                    Caption = 'File received date';
                    Editable = false;
                }
                field("File received Time"; "File received Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("File Received by"; "File Received by")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No Of Days"; "No Of Days")
                {
                    ApplicationArea = Basic;
                    Caption = 'No of Days in Current Locaton';
                    Editable = false;
                }
                field("Reason for file overstay"; "Reason for file overstay")
                {
                    ApplicationArea = Basic;
                }
                field("File Movement Remarks1"; "File Movement Remarks1")
                {
                    ApplicationArea = Basic;
                    Caption = 'File MV General Remarks';
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000021; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Member")
            {
                Caption = '&Member';
                action("Member Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member Ledger Entries';
                    Image = CustomerLedger;
                    RunObject = Page "Member Ledger Entries";
                    RunPageLink = "Customer No." = field("No.");
                    RunPageView = sorting("Customer No.");
                    Promoted = true;
                    PromotedCategory = process;

                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "No." = field("No.");
                    visible = false;
                }
                action("Bank Account")
                {
                    ApplicationArea = Basic;
                    Image = Card;
                    RunObject = Page "Customer Bank Account Card";
                    RunPageLink = "Customer No." = field("No.");
                    visible = false;
                }
                action(Contacts)
                {
                    ApplicationArea = Basic;
                    Image = ContactPerson;
                    visible = false;

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
            }
            group(ActionGroup1102755023)
            {
                action("Member Card")
                {
                    ApplicationArea = Basic;
                    Image = Card;
                    Promoted = true;

                    PromotedCategory = Report;

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.FindFirst then begin
                            Report.Run(51516279, true, false, Cust);
                        end;
                    end;
                }

                action("Account Page")
                {
                    ApplicationArea = Basic;
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Account Card";
                    RunPageLink = "No." = field("FOSA Account");
                }
                action("Members Kin Details List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Members Kin Details';
                    Image = Relationship;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Members Kin Details List";
                    RunPageLink = "Account No" = field("No.");
                }
                action("Account Signatories")
                {
                    ApplicationArea = Basic;
                    Caption = 'Signatories Details';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Member Account Signatory list";
                    RunPageLink = "Account No" = field("No.");
                }
                action("Members Statistics")
                {
                    ApplicationArea = Basic;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Members Statistics";
                    RunPageLink = "No." = field("No.");
                }
                action("Member is  a Guarantor")
                {
                    ApplicationArea = Basic;
                    visible = false;
                    Caption = 'Member is  a Guarantor';
                    Image = "Report";

                    trigger OnAction()
                    begin

                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then
                            Report.Run(51516226, true, false, Cust);
                    end;
                }
                action("Member is  Guaranteed")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member is  Guaranteed';
                    Image = "Report";
                    visible = false;

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then
                            Report.Run(51516225, true, false, Cust);
                    end;
                }
                action("Monthly Contributions")
                {
                    ApplicationArea = Basic;
                    Image = Setup;
                    Promoted = true;
                    Visible = false;
                    PromotedCategory = Process;
                    RunObject = Page "Member Monthly Contributions";
                    RunPageLink = "No." = field("No.");
                }
                group(ActionGroup1102755018)
                {
                }
                action("Detailed Statement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed Statement';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then
                            Report.Run(51516223, true, false, Cust);
                    end;
                }
                action("Deposit Statement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Deposit Statement';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then begin
                            Report.Run(51516224, true, false, Cust);
                        END;
                    end;
                }
                action("Shares Statement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then
                            Report.Run(51516225, true, false, Cust);
                    end;
                }
                action("Loans Statement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then
                            Report.Run(51516227, true, false, Cust);
                    end;
                }
                action("Loans Perfomance Statement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    var
                        LoansReg: Record "Loans Register";
                    begin
                        LoansReg.Reset;
                        LoansReg.SetRange(LoansReg."Client Code", "No.");
                        if LoansReg.Find('-') then
                            Report.Run(51516207, true, false, LoansReg);
                    end;
                }
                action("Member Shares Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member Shares Status';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    Visible = false;

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then
                            Report.Run(137, true, false, Cust);
                    end;
                }
                action("Loans Guaranteed Statement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans Guaranteed Statement';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then begin
                            Report.Run(64, true, false, Cust);
                        END;
                    end;
                }
                action("Recover Loans from Gurantors")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recover Loans from Gurantors';
                    Image = "Report";
                    visible = false;

                    trigger OnAction()
                    begin

                        if ("Current Shares" * -1) > 0 then
                            Error('Please recover the loans from the members shares before recovering from gurantors.');

                        if Confirm('Are you absolutely sure you want to recover the loans from the guarantors as loans?') = false then
                            exit;

                        RoundingDiff := 0;

                        //delete journal line
                        Gnljnline.Reset;
                        Gnljnline.SetRange("Journal Template Name", 'GENERAL');
                        Gnljnline.SetRange("Journal Batch Name", 'LOANS');
                        Gnljnline.DeleteAll;
                        //end of deletion

                        TotalRecovered := 0;

                        DActivity := "Global Dimension 1 Code";
                        DBranch := "Global Dimension 2 Code";

                        CalcFields("Outstanding Balance", "Accrued Interest", "Insurance Fund", "Current Shares");


                        if "Closing Deposit Balance" = 0 then
                            "Closing Deposit Balance" := "Current Shares" * -1;
                        if "Closing Loan Balance" = 0 then
                            "Closing Loan Balance" := "Outstanding Balance" + "FOSA Outstanding Balance";
                        if "Closing Insurance Balance" = 0 then
                            "Closing Insurance Balance" := "Insurance Fund" * -1;
                        "Withdrawal Posted" := true;
                        Modify;


                        CalcFields("Outstanding Balance", "Accrued Interest", "Current Shares");



                        LoansR.Reset;
                        LoansR.SetRange(LoansR."Client Code", "No.");
                        LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                        if LoansR.Find('-') then begin
                            repeat

                                LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest", LoansR."No. Of Guarantors");

                                //No Shares recovery
                                if LoansR."Recovered Balance" = 0 then begin
                                    LoansR."Recovered Balance" := LoansR."Outstanding Balance";
                                end;
                                LoansR."Recovered From Guarantor" := true;
                                LoansR."Guarantor Amount" := LoansR."Outstanding Balance";
                                LoansR.Modify;

                                if ((LoansR."Outstanding Balance" + LoansR."Oustanding Interest") > 0) and (LoansR."No. Of Guarantors" > 0) then begin

                                    LoanAllocation := ROUND((LoansR."Outstanding Balance") / LoansR."No. Of Guarantors", 0.01) +
                                                    ROUND((LoansR."Oustanding Interest") / LoansR."No. Of Guarantors", 0.01);


                                    LGurantors.Reset;
                                    LGurantors.SetRange(LGurantors."Loan No", LoansR."Loan  No.");
                                    LGurantors.SetRange(LGurantors.Substituted, false);
                                    if LGurantors.Find('-') then begin
                                        repeat


                                            Loans.Reset;
                                            Loans.SetRange(Loans."Client Code", LGurantors."Member No");
                                            Loans.SetRange(Loans."Loan Product Type", 'L07');
                                            Loans.SetRange(Loans.Posted, false);
                                            if Loans.Find('-') then
                                                Loans.DeleteAll;


                                            Loans.Init;
                                            Loans."Loan  No." := '';
                                            Loans.Source := Loans.Source::BOSA;
                                            Loans."Client Code" := LGurantors."Member No";
                                            Loans."Loan Product Type" := 'L07';
                                            Loans.Validate(Loans."Client Code");
                                            Loans."Application Date" := Today;
                                            Loans.Validate(Loans."Loan Product Type");
                                            if (LoansR."Approved Amount" > 0) and (LoansR.Installments > 0) then
                                                Loans.Installments := ROUND((LoansR."Outstanding Balance")
                                                                          / (LoansR."Approved Amount" / LoansR.Installments), 1, '>');
                                            Loans."Requested Amount" := LoanAllocation;
                                            Loans."Approved Amount" := LoanAllocation;
                                            Loans.Validate(Loans."Approved Amount");
                                            Loans."Loan Status" := Loans."loan status"::Approved;
                                            Loans."Issued Date" := Today;
                                            Loans."Loan Disbursement Date" := Today;
                                            Loans."Repayment Start Date" := Today;
                                            Loans."Batch No." := "Batch No.";
                                            Loans."BOSA No" := LGurantors."Member No";
                                            Loans."Recovered Loan" := LoansR."Loan  No.";
                                            Loans.Insert(true);

                                            Loans.Reset;
                                            Loans.SetRange(Loans."Client Code", LGurantors."Member No");
                                            Loans.SetRange(Loans."Loan Product Type", 'L07');
                                            Loans.SetRange(Loans.Posted, false);
                                            if Loans.Find('-') then begin

                                                LineNo := LineNo + 10000;

                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'LOANS';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Document No." := 'GL-' + LoansR."Client Code";
                                                GenJournalLine."Posting Date" := Today;
                                                GenJournalLine."External Document No." := LoansR."Loan  No.";
                                                GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                                GenJournalLine."Account No." := LGurantors."Member No";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine.Description := 'Principle Amount';
                                                GenJournalLine.Amount := LoanAllocation;
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Loan;
                                                GenJournalLine."Loan No" := Loans."Loan  No.";
                                                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;


                                                Loans.Posted := true;
                                                Loans.Modify;


                                                //Off Set BOSA Loans

                                                //Principle
                                                LineNo := LineNo + 10000;

                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'LOANS';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Document No." := 'GL-' + LoansR."Client Code";
                                                GenJournalLine."Posting Date" := Today;
                                                GenJournalLine."External Document No." := Loans."Loan  No.";
                                                GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                                GenJournalLine."Account No." := LoansR."Client Code";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine.Description := 'Cleared by Guarantor loan: ' + Loans."Loan  No.";
                                                GenJournalLine.Amount := -ROUND(LoansR."Outstanding Balance" / LoansR."No. Of Guarantors", 0.01);
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                                                GenJournalLine."Loan No" := LoansR."Loan  No.";
                                                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;



                                                //Interest
                                                LineNo := LineNo + 10000;

                                                GenJournalLine.Init;
                                                GenJournalLine."Journal Template Name" := 'GENERAL';
                                                GenJournalLine."Journal Batch Name" := 'LOANS';
                                                GenJournalLine."Line No." := LineNo;
                                                GenJournalLine."Document No." := 'GL-' + LoansR."Client Code";
                                                GenJournalLine."Posting Date" := Today;
                                                GenJournalLine."External Document No." := Loans."Loan  No.";
                                                GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                                GenJournalLine."Account No." := LoansR."Client Code";
                                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                                GenJournalLine.Description := 'Cleared by Guarantor loan: ' + Loans."Loan  No.";
                                                GenJournalLine.Amount := -ROUND(LoansR."Oustanding Interest" / LoansR."No. Of Guarantors", 0.01);
                                                GenJournalLine.Validate(GenJournalLine.Amount);
                                                GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";
                                                GenJournalLine."Loan No" := LoansR."Loan  No.";
                                                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                                if GenJournalLine.Amount <> 0 then
                                                    GenJournalLine.Insert;



                                                LoansR.Advice := true;
                                                LoansR.Modify;

                                            end;

                                        until LGurantors.Next = 0;
                                    end;
                                end;

                            until LoansR.Next = 0;
                        end;


                        "Defaulted Loans Recovered" := true;
                        Modify;


                        //Post New
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'LOANS');
                        if GenJournalLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
                        end;



                        Message('Loan recovery from guarantors posted successfully.');
                    end;
                }
                action("Recover Loans from Deposit")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Caption = 'Recover Loans from Deposit';

                    trigger OnAction()
                    begin
                        if Confirm('Are you absolutely sure you want to recover the loans from member deposit') = false then
                            exit;

                        //"Withdrawal Fee":=1000;

                        //delete journal line
                        Gnljnline.Reset;
                        Gnljnline.SetRange("Journal Template Name", 'GENERAL');
                        Gnljnline.SetRange("Journal Batch Name", 'Recoveries');
                        Gnljnline.DeleteAll;
                        //end of deletion

                        TotalRecovered := 0;
                        TotalInsuarance := 0;

                        DActivity := "Global Dimension 1 Code";
                        DBranch := "Global Dimension 2 Code";
                        CalcFields("Outstanding Balance", "Accrued Interest", "Current Shares");

                        CalcFields("Outstanding Balance", "Outstanding Interest", "FOSA Outstanding Balance", "Accrued Interest", "Insurance Fund", "Current Shares");
                        TotalOustanding := "Outstanding Balance" + "Outstanding Interest";
                        // GETTING WITHDRAWAL FEE
                        if (0.15 * ("Current Shares")) > 1000 then begin
                            "Withdrawal Fee" := 1000;
                        end else begin
                            "Withdrawal Fee" := 0.15 * ("Current Shares");
                        end;
                        /*
                       // END OF GETTING WITHDRWAL FEE
                       LineNo:=LineNo+10000;

                       GenJournalLine.INIT;
                       GenJournalLine."Journal Template Name":='GENERAL';
                       GenJournalLine."Journal Batch Name":='Recoveries';
                       GenJournalLine."Line No.":=LineNo;
                       GenJournalLine."Document No.":="No.";
                       GenJournalLine."Posting Date":=TODAY;
                       GenJournalLine."External Document No.":="No.";
                       GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                       GenJournalLine."Account No.":="No.";
                       GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                       GenJournalLine.Description:='WITHDRAWAL FEE';
                       GenJournalLine.Amount:="Withdrawal Fee";
                       GenJournalLine.VALIDATE(GenJournalLine.Amount);
                       GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                       GenJournalLine."Bal. Account No." :='103102';
                       GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                       GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                       GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                       GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                       GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                       IF GenJournalLine.Amount<>0 THEN
                       GenJournalLine.INSERT;


                       TotalRecovered:=TotalRecovered+GenJournalLine.Amount;
                       */

                        "Closing Deposit Balance" := ("Current Shares");


                        if "Closing Deposit Balance" > 0 then begin
                            "Remaining Amount" := "Closing Deposit Balance";

                            LoansR.Reset;
                            LoansR.SetRange(LoansR."Client Code", "No.");
                            LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                            if LoansR.Find('-') then begin
                                repeat
                                    //"AMOUNTTO BE RECOVERED":=0;
                                    LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest", LoansR."Loans Insurance");
                                    TotalInsuarance := TotalInsuarance + LoansR."Loans Insurance";
                                until LoansR.Next = 0;
                            end;

                            LoansR.Reset;
                            LoansR.SetRange(LoansR."Client Code", "No.");
                            LoansR.SetRange(LoansR.Source, LoansR.Source::BOSA);
                            if LoansR.Find('-') then begin
                                repeat
                                    "AMOUNTTO BE RECOVERED" := 0;
                                    LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest", LoansR."Loans Insurance");



                                    //Loan Insurance
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Recoveries';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                    GenJournalLine."Account No." := "No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'Cleared by deposits: ' + "No.";
                                    GenJournalLine.Amount := -ROUND(LoansR."Loans Insurance");
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Insurance Paid";
                                    GenJournalLine."Loan No" := LoansR."Loan  No.";
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    /*
                                    LineNo:=LineNo+10000;
                                    GenJournalLine.INIT;
                                    GenJournalLine."Journal Template Name":='GENERAL';
                                    GenJournalLine."Journal Batch Name":='LOANS';
                                    GenJournalLine."Line No.":=LineNo;
                                    GenJournalLine."Document No.":="No.";
                                    GenJournalLine."Posting Date":=TODAY;
                                    GenJournalLine."External Document No.":="No.";
                                    GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                    GenJournalLine."Account No.":="No.";
                                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                    GenJournalLine.Description:='Cleared by deposits: ' + "No.";
                                    GenJournalLine.Amount:=ROUND(LoansR."Loans Insurance");
                                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                    GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                    GenJournalLine."Loan No":=LoansR."Loan  No.";
                                    GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                    IF GenJournalLine.Amount<>0 THEN
                                    GenJournalLine.INSERT;*/



                                    /*LoansR.RESET;
                                    LoansR.SETRANGE(LoansR."Client Code","No.");
                                    LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                    IF LoansR.FIND('-') THEN BEGIN
                                    //REPEAT
                                    "AMOUNTTO BE RECOVERED":=0;
                                    LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");*/


                                    //Off Set BOSA Loans
                                    //Interest
                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Recoveries';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                    GenJournalLine."Account No." := "No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'Interest Capitalized: ' + "No.";
                                    GenJournalLine.Amount := -ROUND(LoansR."Oustanding Interest");
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";
                                    GenJournalLine."Loan No" := LoansR."Loan  No.";
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;


                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Journal Batch Name" := 'Recoveries';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Document No." := "No.";
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."External Document No." := "No.";
                                    GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                    GenJournalLine."Account No." := "No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine.Description := 'Interest Capitalized: ' + "No.";
                                    GenJournalLine.Amount := ROUND(LoansR."Oustanding Interest");
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Loan;
                                    GenJournalLine."Loan No" := LoansR."Loan  No.";
                                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    PrincipInt := 0;
                                    TotalLoansOut := 0;
                                    "Closing Deposit Balance" := ("Current Shares" - TotalInsuarance);

                                    if "Remaining Amount" > 0 then begin
                                        PrincipInt := (LoansR."Outstanding Balance" + LoansR."Oustanding Interest");
                                        TotalLoansOut := ("Outstanding Balance" + "Outstanding Interest");

                                        //Principle
                                        LineNo := LineNo + 10000;
                                        //"AMOUNTTO BE RECOVERED":=ROUND(((LoansR."Outstanding Balance"+LoansR."Oustanding Interest")/("Outstanding Balance"+"Outstanding Interest")))*"Closing Deposit Balance";
                                        "AMOUNTTO BE RECOVERED" := ROUND((PrincipInt / TotalLoansOut) * "Closing Deposit Balance", 0.01, '=');
                                        GenJournalLine.Init;
                                        GenJournalLine."Journal Template Name" := 'GENERAL';
                                        GenJournalLine."Journal Batch Name" := 'Recoveries';
                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Document No." := "No.";
                                        GenJournalLine."Posting Date" := Today;
                                        GenJournalLine."External Document No." := "No.";
                                        GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                                        GenJournalLine."Account No." := "No.";
                                        GenJournalLine.Validate(GenJournalLine."Account No.");
                                        GenJournalLine.Description := 'Loan Against Deposits: ' + "No.";
                                        if "AMOUNTTO BE RECOVERED" > (LoansR."Outstanding Balance" + LoansR."Oustanding Interest") then begin
                                            if "Remaining Amount" > (LoansR."Outstanding Balance" + LoansR."Oustanding Interest") then begin
                                                GenJournalLine.Amount := -ROUND(LoansR."Outstanding Balance" + LoansR."Oustanding Interest");
                                            end else begin
                                                GenJournalLine.Amount := -"Remaining Amount";

                                            end;

                                        end else begin
                                            if "Remaining Amount" > "AMOUNTTO BE RECOVERED" then begin
                                                GenJournalLine.Amount := -"AMOUNTTO BE RECOVERED";
                                            end else begin
                                                GenJournalLine.Amount := -"Remaining Amount";
                                            end;
                                        end;
                                        GenJournalLine.Validate(GenJournalLine.Amount);
                                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                                        GenJournalLine."Loan No" := LoansR."Loan  No.";
                                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert;
                                        "Remaining Amount" := "Remaining Amount" + GenJournalLine.Amount;

                                        TotalRecovered := TotalRecovered + ((GenJournalLine.Amount));

                                    end;




                                until LoansR.Next = 0;
                            end;
                        end;
                        //Deposit
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'GENERAL';
                        GenJournalLine."Journal Batch Name" := 'Recoveries';
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Document No." := "No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine."External Document No." := "No.";
                        GenJournalLine."Account Type" := GenJournalLine."bal. account type"::Customer;
                        GenJournalLine."Account No." := "No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine.Description := 'Defaulted Loans Against Deposits';
                        GenJournalLine.Amount := (TotalRecovered - TotalInsuarance) * -1;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;



                        "Defaulted Loans Recovered" := true;
                        Modify;


                        //Post New
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'Recoveries');
                        if GenJournalLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
                        end;



                        Message('Loan recovery from Deposits posted successfully.');

                    end;
                }
                action("FOSA Statement")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Vend.Reset;
                        Vend.SetRange(Vend."BOSA Account No", "No.");
                        if Vend.Find('-') then
                            Report.Run(51516248, true, false, Vend);
                    end;


                }
                action("Shares Certificate")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "No.");
                        if Cust.Find('-') then
                            Report.Run(51516303, true, false, Cust);
                    end;
                }


            }
        }



    }

    trigger OnAfterGetRecord()
    begin
        FosaName := '';
        if "Physical States" = "physical states"::Deaf then begin
            Message('This Member is Deaf')
        end else
            if "Physical States" = "physical states"::Blind then begin
                Message('This Member is Deaf')
            end;

        // if "FOSA Account" <> '' then begin
        //     if Vend.Get("FOSA Account") then begin
        //         FosaName := Vend.Name;
        //     end;
        // end;

        // lblIDVisible := true;
        // lblDOBVisible := true;
        // lblRegNoVisible := false;
        // lblRegDateVisible := false;
        // lblGenderVisible := true;
        // txtGenderVisible := true;
        // lblMaritalVisible := true;
        // txtMaritalVisible := true;

        // if "Account Category" <> "account category"::SINGLE then begin
        //     lblIDVisible := false;
        //     lblDOBVisible := false;
        //     lblRegNoVisible := true;
        //     lblRegDateVisible := true;
        //     lblGenderVisible := false;
        //     txtGenderVisible := false;
        //     lblMaritalVisible := false;
        //     txtMaritalVisible := false;

        // end;
        OnAfterGetCurrRec;

        Statuschange.Reset;
        Statuschange.SetRange(Statuschange."User Id", UserId);
        Statuschange.SetRange(Statuschange."Function", Statuschange."function"::"Account Status");
        if not Statuschange.Find('-') then
            CurrPage.Editable := false
        else
            CurrPage.Editable := true;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        RecordFound: Boolean;
    begin
        RecordFound := Find(Which);
        CurrPage.Editable := RecordFound or (GetFilter("No.") = '');
        exit(RecordFound);
    end;

    trigger OnInit()
    begin
        txtMaritalVisible := true;
        lblMaritalVisible := true;
        txtGenderVisible := true;
        lblGenderVisible := true;
        lblRegDateVisible := true;
        lblRegNoVisible := true;
        lblDOBVisible := true;
        lblIDVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Customer Type" := "customer type"::Member;
        Status := Status::Active;
        "Customer Posting Group" := 'BOSA';
        "Registration Date" := Today;
        Advice := true;
        "Advice Type" := "advice type"::"New Member";
        if GeneralSetup.Get(0) then begin
            "Insurance Contribution" := GeneralSetup."Welfare Contribution";
            "Registration Fee" := GeneralSetup."Registration Fee";

        end;
        OnAfterGetCurrRec;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        ActivateFields;
        /*
        IF NOT MapMgt.TestSetup THEN
          CurrForm.MapPoint.VISIBLE(FALSE);
        */

    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        Text001: label 'Do you want to allow payment tolerance for entries that are currently open?';
        CustomizedCalendar: Record "Customized Calendar Change";
        Text002: label 'Do you want to remove payment tolerance from entries that are currently open?';
        CalendarMgmt: Codeunit "Calendar Management";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        PictureExists: Boolean;
        GenJournalLine: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        StatusPermissions: Record "Status Change Permision";
        Charges: Record Charges;
        Vend: Record Vendor;
        Cust: Record Customer;
        LineNo: Integer;
        UsersID: Record User;
        GeneralSetup: Record "Sacco General Set-Up";
        Loans: Record "Loans Register";
        AvailableShares: Decimal;
        Gnljnline: Record "Gen. Journal Line";
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        TotalRecovered: Decimal;
        LoanAllocation: Decimal;
        LGurantors: Record "Loans Guarantee Details";
        LoansR: Record "Loans Register";
        DActivity: Code[20];
        DBranch: Code[20];
        Accounts: Record Vendor;
        FosaName: Text[50];
        [InDataSet]
        lblIDVisible: Boolean;
        [InDataSet]
        lblDOBVisible: Boolean;
        [InDataSet]
        lblRegNoVisible: Boolean;
        [InDataSet]
        lblRegDateVisible: Boolean;
        [InDataSet]
        lblGenderVisible: Boolean;
        [InDataSet]
        txtGenderVisible: Boolean;
        [InDataSet]
        lblMaritalVisible: Boolean;
        [InDataSet]
        txtMaritalVisible: Boolean;
        AccNo: Code[20];
        Vendor: Record Vendor;
        TotalAvailable: Decimal;
        TotalFOSALoan: Decimal;
        TotalOustanding: Decimal;
        TotalDefaulterR: Decimal;
        value2: Decimal;
        Value1: Decimal;
        RoundingDiff: Decimal;
        Statuschange: Record "Status Change Permision";
        "WITHDRAWAL FEE": Decimal;
        "AMOUNTTO BE RECOVERED": Decimal;
        "Remaining Amount": Decimal;
        TotalInsuarance: Decimal;
        PrincipInt: Decimal;
        TotalLoansOut: Decimal;
        FileMovementTracker: Record "File Movement Tracker";
        EntryNo: Integer;
        ApprovalsSetup: Record "Approvals Set Up";
        MovementTracker: Record "Movement Tracker";
        ApprovalUsers: Record "Approvals Users Set Up";
        "Change Log": Integer;
        openf: File;
        FMTRACK: Record "File Movement Tracker";
        CurrLocation: Code[30];
        "Number of days": Integer;
        Approvals: Record "Approvals Set Up";
        Description: Text[30];
        Section: Code[10];
        station: Code[10];
        CoveragePercentStyle: Text;


    procedure ActivateFields()
    begin
    end;

    local procedure OnAfterGetCurrRec()
    begin
        xRec := Rec;
        ActivateFields;
        SetStyles();
    end;

    local procedure SetStyles()
    begin
        CoveragePercentStyle := 'Strong';
        if "Member Risk Level" <> "member risk level"::"Low Risk" then
            CoveragePercentStyle := 'Unfavorable';
        if "Member Risk Level" = "member risk level"::"Low Risk" then
            CoveragePercentStyle := 'Favorable';
    end;
}

