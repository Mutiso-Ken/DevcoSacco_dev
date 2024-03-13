pageextension 51516622 "ChartOfAccoutnsExt" extends "Chart of Accounts"
{

    layout
    {
        addafter(Balance)
        {
          
            field("Budgeted Amount"; "Budgeted Amount")
            {
                ApplicationArea = Basic;
                Editable=false;
            }
         
            field("Budget Controlled";"Budget Controlled")
            {
                ApplicationArea = Basic;
                Editable=false;
            }
           
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                GLEntry.SetRange("G/L Account No.", "No.");
                if GLEntry.FindSet() then begin
                    Enable := false;
                end;
            end;
        }
        modify(Name)
        {
            Editable = Enable;
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
        GLEntry.Reset();




    end;

    trigger OnClosePage()
    begin
        AuditLog.FnReadingsMadeAudit(UserId, 'Closed chart of accounts listing page');
    end;

    var

        GLEntry: Record "G/L Entry";
        AuditLog: Codeunit "Audit Log Codeunit";
        Enable: Boolean;
        Text000: Label 'Not Editable';

}