pageextension 51516628 "ChartOfAccountsCardExt" extends "G/L Account Card"
{

    layout
    {
      
        addafter(Reporting)
        {
            group(Budgetary)
            {
                field("Balance at Date"; "Balance at Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Budgeted Amount"; "Budgeted Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Budget Filter"; "Budget Filter")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Budgeted Credit Amount"; "Budgeted Credit Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Budgeted Debit Amount"; "Budgeted Debit Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("SASRA REPORTS SETUP")
            {
                Caption = 'SASRA REPORTS SETUP';
                field(StatementOfFP; StatementOfFP)
                {
                    ApplicationArea = Basic;
                }
                field(StatementOfFP2; StatementOfFP2)
                {
                    ApplicationArea = Basic;
                }
                field("Form2F(Statement of C Income)"; "Form2F(Statement of C Income)")
                {
                    ApplicationArea = Basic;
                }
                field("Form2F1(Statement of C Income)"; "Form2F1(Statement of C Income)")
                {
                    ApplicationArea = Basic;
                }
                field("Capital adequecy"; "Capital adequecy")
                {
                    ApplicationArea = Basic;
                }
                field(Liquidity; Liquidity)
                {
                    ApplicationArea = Basic;
                }
                field("Form2E(investment)"; "Form2E(investment)")
                {
                    ApplicationArea = Basic;
                }
                field("Form 2H other disc"; "Form 2H other disc")
                {
                    ApplicationArea = Basic;
                }
                field("Form2E(investment)New"; "Form2E(investment)New")
                {
                    ApplicationArea = Basic;
                }
                field("Form2E(investment)Land"; "Form2E(investment)Land")
                {
                    ApplicationArea = Basic;
                }
                field(ChangesInEquity; ChangesInEquity)
                {
                    ApplicationArea = Basic;
                }
                field("Financial Assets"; "Financial Assets")
                {
                    ApplicationArea = basic;
                }
            }
        }

    }
    trigger OnOpenPage()
    begin
        AuditLog.FnReadingsMadeAudit(UserId, 'Accessed and read the G/L account page no-' + Format("No.") + ' Name-' + Format(Name));
    end;

    trigger OnClosePage()
    begin
        AuditLog.FnReadingsMadeAudit(UserId, 'Closed G/L account page no-' + Format("No.") + ' Name-' + Format(Name));
    end;

    var
        AuditLog: Codeunit "Audit Log Codeunit";
        GlEntry: Record "G/L Entry";
        Edit: Boolean;
}