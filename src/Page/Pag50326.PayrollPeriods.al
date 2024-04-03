page 50326 "Payroll Periods."
{
    ApplicationArea = Basic, Suite;
    Caption = 'Payroll Periods.';
    UsageCategory = Tasks;
    DeleteAllowed = true;
    Editable = true;
    PageType = Card;
    SourceTable = "Payroll Calender.";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Period Month"; "Period Month")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Period Year"; "Period Year")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Period Name"; "Period Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Date Opened"; "Date Opened")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Date Closed"; "Date Closed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Closed; Closed)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payroll Code"; "Payroll Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Close Period")
            {
                ApplicationArea = All;
                Caption = 'Close Period';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*
                    Warn user about the consequence of closure - operation is not reversible.
                    Ask if he is sure about the closure.
                    */

                    fnGetOpenPeriod;

                    Question := 'Once a period has been closed it can NOT be opened.\It is assumed that you have PAID out salaries.\'
                    + 'Still want to close [' + strPeriodName + ']';
                        PayrollDefined := '';
                        PayrollType.SetCurrentKey(EntryNo);
                        if PayrollType.FindFirst then begin
                            NoofRecords := PayrollType.Count;
                            repeat
                                i += 1;
                                PayrollDefined := PayrollDefined + '&' + PayrollType."Payroll Code";
                                if i < NoofRecords then
                                    PayrollDefined := PayrollDefined + ','
                            until PayrollType.Next = 0;
                        end;


                        Selection := StrMenu(PayrollDefined, 3);
                        PayrollType.Reset;
                        PayrollType.SetRange(PayrollType.EntryNo, Selection);
                        if PayrollType.Find('-') then begin
                            PayrollCode := PayrollType."Payroll Code";
                        end;
                    // end;
                    //End Multiple Payroll



                    Answer := DIALOG.Confirm(Question, false);
                    if Answer = true then begin
                        Clear(objOcx);
                        objOcx.fnClosePayrollPeriod(dtOpenPeriod, PayrollCode);
                        Message('Process Complete');
                    end else begin
                        Message('You have selected NOT to Close the period');
                    end

                end;
            }
            // action("Create Period")
            // {
            //     ApplicationArea = All;
            //     Visible = false;
            //     trigger OnAction()
            //     begin
            //         ContrInfo.Init();

            //         ContrInfo."Primary Key" := ' ';
            //         ContrInfo.Name := 'DEVCO';
            //         ContrInfo.Insert();
            //     end;
            // }
        }
    }

    var
        PayPeriod: Record "Payroll Calender.";
        strPeriodName: Text[30];
        Text000: Label '''Leave without saving changes?''';
        Text001: Label '''You selected %1.''';
        Question: Text[250];
        Answer: Boolean;
        objOcx: Codeunit "Payroll Processing";
        dtOpenPeriod: Date;
        PayrollType: Record "Payroll Type.";
        Selection: Integer;
        PayrollDefined: Text[30];
        PayrollCode: Code[10];
        NoofRecords: Integer;
        i: Integer;
        ContrInfo: Record "Control-Information.";

    procedure fnGetOpenPeriod()
    begin
        PayPeriod.SetRange(PayPeriod.Closed, false);
        if PayPeriod.Find('-') then begin
            strPeriodName := PayPeriod."Period Name";
            dtOpenPeriod := PayPeriod."Date Opened";
        end;
    end;
}

