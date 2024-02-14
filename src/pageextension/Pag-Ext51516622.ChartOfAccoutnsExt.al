pageextension 51516622 "ChartOfAccoutnsExt" extends "Chart of Accounts"
{

    layout
    {
        addbefore(Name)
        {
            field(Debit; "Debit Amount")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(Credit; "Credit Amount")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
         



        }
        modify("Account Subcategory Descript.")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify("Cost Type No.")
        {
            Visible = false;
        }

        modify(Control1900383207)
        {
            Visible = false;
        }
        modify(Control1905767507)
        {
            Visible = false;
        }
    }
    trigger OnOpenPage()
    begin
        AuditLog.FnReadingsMadeAudit(UserId, 'Accessed and read the chart of accounts listing page');
    end;

    trigger OnClosePage()
    begin
        AuditLog.FnReadingsMadeAudit(UserId, 'Closed chart of accounts listing page');
    end;

    var
        AuditLog: Codeunit "Audit Log Codeunit";
}