page 50310 "Payroll Employee Card."
{
    // version Payroll ManagementV1.0(Surestep Systems)
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Payroll Employee.";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Payroll No"; "Payroll No")
                {
                    ApplicationArea = All;
                    Caption = 'Sacco Member No.';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Caption = 'Staff No';
                }

                field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Employee Email"; "Employee Email")
                {
                    ApplicationArea = All;
                }
                field("Joining Date"; "Joining Date")
                {
                    ApplicationArea = All;
                    Caption = 'Appointment Date';
                    ShowMandatory = true;
                }
                field("Last Increment Date"; "Last Increment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Last Increment Date';
                    Enabled = false;
                    Visible = false;
                }
                field("Next Increment Date"; "Next Increment Date") //transaction priod month
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Date of Birth"; "Date of Birth")
                {
                    ApplicationArea = All;
                }
                field(Age; Age)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date Of Retirement"; "Date Of Retirement")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dimension 2"; "Global Dimension 2")
                {
                    ApplicationArea = All;
                    Caption = '"Global Dimension 2"';
                    Visible = false;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("National ID No"; "National ID No")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("NSSF No"; "NSSF No")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("NHIF No"; "NHIF No")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("PIN No"; "PIN No")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Organization; Organization)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Category; Category)
                {
                    ApplicationArea = All;
                }
                field("Living with disability"; "Living with disability")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Is Management"; "Is Management")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payroll Categories"; "Payroll Categories")
                {
                    ApplicationArea = All;
                }
                field("Work Station"; "Work Station")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                }
                field(Department; Department)
                {
                    applicationarea = all;
                    editable = true;
                }
                field(Designation; Designation)
                {
                    ApplicationArea = All;
                }
            }
            group("Pay Details")
            {
                field("Basic Pay"; "Basic Pay")
                {
                    ApplicationArea = All;
                }
                field("Paid per Hour"; "Paid per Hour")
                {
                    ApplicationArea = All;
                }
                field("Pays PAYE"; "Pays PAYE")
                {
                    ApplicationArea = All;
                }
                field("Pays NSSF"; "Pays NSSF")
                {
                    ApplicationArea = All;
                }
                field("Pays NHIF"; "Pays NHIF")
                {
                    ApplicationArea = All;
                }
                field("Payment Mode"; "Payment Mode")
                {
                    ApplicationArea = All;
                }
                field("Insurance Premium"; "Insurance Premium")
                {
                    ApplicationArea = All;
                }
                field(NITA; NITA)
                {
                    ApplicationArea = All;
                }
                field("Pays Pension"; "Pays Pension")
                {
                    ApplicationArea = All;
                }
            }
            group("Bank Details")
            {
                field("Bank Code"; "Bank Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Visible = true;
                }
                field("Bank Name"; "Bank Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                // field("Branch Code"; "Branch Code")
                // {
                //     ApplicationArea = All;
                //     ShowMandatory = true;
                // }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                // field("Bank Location"; "Bank Location")
                // {
                //     ApplicationArea = All;
                //     ShowMandatory = true;
                // }
                field("Bank Account No"; "Bank Account No")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
            }
            group("Other Details")
            {
                field("Payslip Message"; "Payslip Message")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
            }
            group("Cummulative Figures")
            {
                Editable = false;

                field("Cummulative Basic Pay"; "Cummulative Basic Pay")
                {
                    ApplicationArea = All;
                }
                field("Cummulative Gross Pay"; "Cummulative Gross Pay")
                {
                    ApplicationArea = All;
                }
                /*  field("Cummulative Allowances"; "Cummulative Allowances")
                  {
                  }*/
                field("Cummulative Deductions"; "Cummulative Deductions")
                {
                    ApplicationArea = All;
                }
                field("Cummulative Net Pay"; "Cummulative Net Pay")
                {
                    ApplicationArea = All;
                }
                field("Cummulative PAYE"; "Cummulative PAYE")
                {
                    ApplicationArea = All;
                }
                field("Cummulative NSSF"; "Cummulative NSSF")
                {
                    ApplicationArea = All;
                }
                field("Cummulative Pension"; "Cummulative Pension")
                {
                    ApplicationArea = All;
                }
                field("Cummulative HELB"; "Cummulative HELB")
                {
                    ApplicationArea = All;
                }
                field("Cummulative NHIF"; "Cummulative NHIF")
                {
                    ApplicationArea = All;
                }
            }
            group("Suspension of Payment")
            {
                field("Suspend Pay"; "Suspend Pay")
                {
                    ApplicationArea = All;
                }
                field("Suspend Date"; "Suspend Date")
                {
                    ApplicationArea = All;
                }
                field("Suspend Reason"; "Suspend Reason")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(creation)
        {
            action("Process Current Employee")
            {
                ApplicationArea = All;
                Caption = 'Generate Current Employee';
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                    PayrollEmployDed: Record "Payroll Employee Transactions.";
                begin
                    ContrInfo.Reset;
                    objPeriod.Reset;
                    objPeriod.SetRange(objPeriod.Closed, false);
                    if objPeriod.Find('-') then begin
                        SelectedPeriod := objPeriod."Date Opened";
                        varPeriodMonth := objPeriod."Period Month";
                        SalCard.Get("No.");
                    end;
                    //For Multiple Payroll
                    if ContrInfo."Multiple Payroll" then begin
                        PayrollDefined := '';
                        PayrollType.Reset;
                        PayrollType.SetCurrentKey(EntryNo);
                        if PayrollType.FindFirst then begin
                            NoofRecords := PayrollType.Count;
                            i := 0;
                            repeat
                                i += 1;
                                PayrollDefined := PayrollDefined + '&' + PayrollType."Payroll Code";
                                if i < NoofRecords then PayrollDefined := PayrollDefined + ',' until PayrollType.Next = 0;
                        end;
                        //Selection := STRMENU(PayrollDefined,NoofRecords);
                        PayrollType.Reset;
                        PayrollType.SetRange(PayrollType.EntryNo, Selection);
                        if PayrollType.Find('-') then begin
                            //PayrollCode:=PayrollType."Payroll Code";
                            PayrollCode := HrEmployee."Posting Group";
                        end;
                    end;
                    //Delete all Records from the prPeriod Transactions for Reprocessing
                    objPeriod.Reset;
                    objPeriod.SetRange(objPeriod.Closed, false);
                    if objPeriod.FindFirst then begin
                        //IF ContrInfo."Multiple Payroll" THEN BEGIN
                        ObjPayrollTransactions.Reset;
                        ObjPayrollTransactions.SetRange(ObjPayrollTransactions."Payroll Period", objPeriod."Date Opened");
                        ObjPayrollTransactions.SetRange("Employee Code", "No.");
                        if ObjPayrollTransactions.Find('-') then begin
                            ObjPayrollTransactions.DeleteAll;
                        end;
                    end;
                    PayrollEmployerDed.Reset;
                    PayrollEmployerDed.SetRange(PayrollEmployerDed."Payroll Period", SelectedPeriod);
                    PayrollEmployerDed.SetRange("Employee Code", "No.");
                    if PayrollEmployerDed.Find('-') then PayrollEmployerDed.DeleteAll;
                    //*********************************************************************************************add interest
                    PayrollEmployDed.Reset;
                    PayrollEmployDed.SetRange(PayrollEmployDed."No.", "No.");
                    PayrollEmployDed.SetRange(PayrollEmployDed."IsCoop/LnRep", true);
                    if PayrollEmployDed.FindSet() then begin
                        repeat
                            PayrollEmployDed."Interest Charged" := Round(PayrollEmployDed.Balance * PayrollEmployDed."Interest Rate" / 12 / 100, 1, '=');
                            //Message('Interest%1', Format(PayrollEmployDed."Interest Charged"));
                            PayrollEmployDed.Modify;
                        until PayrollEmployDed.Next = 0;
                    end;
                    // if ContrInfo."Multiple Payroll" then
                    //                    //*********************************************************************************************add interest
                    HrEmployee.Reset;
                    HrEmployee.SetRange(HrEmployee.Status, HrEmployee.Status::Active);
                    HrEmployee.SetRange(HrEmployee."No.", "No.");
                    if HrEmployee.Find('-') then begin
                        ProgressWindow.Open('Processing Salary for Employee No. #1#######');
                        repeat
                            Sleep(100);
                            if not SalCard."Suspend Pay" then begin
                                ProgressWindow.Update(1, HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' + HrEmployee."Middle Name" + ' ' + HrEmployee.Surname);
                                if SalCard.Get(HrEmployee."No.") then ProcessPayroll.fnProcesspayroll(HrEmployee."No.", HrEmployee."Joining Date", SalCard."Basic Pay", SalCard."Pays PAYE", SalCard."Pays NSSF", SalCard."Pays NHIF", SelectedPeriod, SelectedPeriod, HrEmployee."Payroll No", '', HrEmployee."Date of Leaving", true, HrEmployee."Branch Code", PayrollCode);
                            end;
                        until HrEmployee.Next = 0;
                        ProgressWindow.Close;
                    end;
                    Message('Payroll processing completed successfully.');
                end;
            }
            action("Employee Earnings")
            {
                ApplicationArea = All;
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Payroll Employee Earnings.";
                RunPageLink = "No." = FIELD("No.");
                RunPageView = WHERE("Transaction Type" = FILTER(Income));
            }
            action("Employee Deductions")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Payroll Employee Deductions.";
                RunPageLink = "No." = FIELD("No.");
                RunPageView = WHERE("Transaction Type" = FILTER(Deduction));
            }
            action("Employee Assignments")
            {
                ApplicationArea = All;
                Image = Apply;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Payroll Employee Assignments.";
                RunPageLink = "No." = FIELD("No.");
            }
            action("Employee Cummulatives")
            {
                ApplicationArea = All;
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Payroll Employee Cummulatives.";
                RunPageLink = "No." = FIELD("No.");
            }
            action("Send Payslip Via Email")
            {
                ApplicationArea = All;
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Payroll Employee Cummulatives.";
                RunPageLink = "No." = FIELD("No.");
            }
            action("View PaySlip")
            {
                ApplicationArea = All;
                Image = PaymentHistory;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    PayrollEmp.Reset;
                    PayrollEmp.SetRange(PayrollEmp."No.", "No.");
                    if PayrollEmp.FindFirst then begin
                        REPORT.Run(50010, true, false, PayrollEmp);
                    end;
                end;
            }
            action("Living with Disability2")
            {
                ApplicationArea = All;
                Caption = 'Living with Disability';
                Image = Employee;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    "Living with disability" := true;
                    Modify;
                end;
            }
        }
    }
    var
        PayrollEmp: Record "Payroll Employee.";
        PayrollManager: Codeunit "Payroll Management";
        "Payroll Period": Date;
        PayrollCalender: Record "Payroll Calender.";
        // PayrollMonthlyTrans: Record "Payroll Monthly Transactions.";
        //  PayrollEmployeeDed: Record "Payroll Employee Deductions.";
        PayrollEmployerDed: Record "Payroll Employer Deductions.";
        objEmp: Record "Salary Processing Header";
        SalCard: Record "Payroll Employee.";
        objPeriod: Record "Payroll Calender.";
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodMonth: Integer;
        PeriodYear: Integer;
        ProcessPayroll: Codeunit "Payroll Processing";
        HrEmployee: Record "Payroll Employee.";
        ProgressWindow: Dialog;
        // prPeriodTransactions: Record "prPeriod Transactions..";
        prEmployerDeductions: Record "Payroll Employer Deductions.";
        PayrollType: Record "Payroll Type.";
        Selection: Integer;
        PayrollDefined: Text[30];
        PayrollCode: Code[10];
        NoofRecords: Integer;
        i: Integer;
        ContrInfo: Record "Control-Information.";
        UserSetup: Record "User Setup";
        ObjPayrollTransactions: Record "prPeriod Transactions.";
        varPeriodMonth: Integer;
    //Scale: Record "MSEA Salary Scales";
    local procedure RemoveTrans(EmpNo: Code[20]; PayrollPeriod: Date)
    begin
    end;

    procedure FnSendReceiptviaEmail(TransactionNo: Code[30])
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
        Receipt: Record "Payroll Employee.";
        MailToSend: Codeunit "Email Message";
        GenerateDoc: InStream; //Generate PDF/Document to be sent 
        EncodeStream: Codeunit "Base64 Convert"; //To encode the stream of data form GenerateDoc
        FnEmail: Codeunit Email;
        DialogBox: Dialog;
        reportrun: Report "Payroll Payslip";
        reportparameters: text;
        ReportTable: Record "Payroll Employee.";
    begin
        DialogBox.Open('Sending Payslip to  ' + Format(Receipt.Surname) + ' for period' + Format(Receipt."Selected Period"));
        //------------------->Get Key Details of Send Email
        SendEmailTo := '';
        SendEmailTo := FnGetClientCodeEmail("No.");
        EmailSubject := '';
        EmailSubject := 'Payslip for ' + Format("Selected Period");
        EmailBody := '';
        EmailBody := 'Dear ' + Format(Surname) + '  We hope this email finds you well. Please find attached your Payslip.';
        //------------------->Generate The Report Attachments To Send
        //---------Attachment 1
        //reportparameters := reportrun.RunRequestPage();
        reportparameters := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Payroll Payslip" id="50010"><DataItems><DataItem name="Payslip &amp; Payments">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + format("No.") + '))</DataItem><DataItem name="Receipt Allocation">VERSION(1) SORTING(Field1,Field3,Field5,Field51516161,Field51516160,Field2)</DataItem></DataItems></ReportParameters>';
        FileName := Format("Selected Period") + '-Payslip.pdf';
        TempBlob.CreateOutStream(Outstr);
        Report.SaveAs(Report::"Payroll Payslip", reportparameters, ReportFormat::Pdf, Outstr);
        TempBlob.CreateInStream(Instr);
        //------------------->Create Emails Start
        MailToSend.Create(SendEmailTo, EmailSubject, EmailBody);
        MailToSend.AddAttachment(FileName, FileType, Instr);
        //.........................................
        FnEmail.Send(MailToSend);
        DialogBox.Close();
    end;

    local procedure FnGetClientCodeEmail(ClientCode: Code[50]): Text[100]
    var
        PayrollEmp: Record "Payroll Employee.";
        receipt: Record "Payroll Employee.";
    begin
        PayrollEmp.Reset();
        PayrollEmp.SetRange(PayrollEmp."No.", ClientCode);
        if PayrollEmp.Find('-') then begin
            exit(PayrollEmp."Employee Email");
        end;
    end;
}
