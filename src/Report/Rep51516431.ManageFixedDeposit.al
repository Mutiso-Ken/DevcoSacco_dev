#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516431 "Manage Fixed Deposit"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = where("Account Type" = filter('FIXED'), Status = filter(<> Closed));
            RequestFilterFields = "No.", "FD Maturity Date";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Vendor."FD Maturity Instructions" = Vendor."fd maturity instructions"::"Transfer to Savings" then
                    FDManagement.RollOver(Vendor, RunDate)
                else
                    if Vendor."FD Maturity Instructions" = Vendor."fd maturity instructions"::"Transfer Interest & Renew" then
                        FDManagement.Renew(Vendor, RunDate)
                    else
                        if Vendor."FD Maturity Instructions" = Vendor."fd maturity instructions"::Renew then
                            FDManagement.CloseNonRenewable(Vendor, RunDate);
            end;

            trigger OnPreDataItem()
            begin

                if RunDate = 0D then
                    RunDate := Today;


                GenJournalLine.Reset;
                GenJournalLine.SetRange(GenJournalLine."Journal Template Name", 'PURCHASES');
                GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", 'FXDEP');
                if GenJournalLine.Find('-') then
                    GenJournalLine.DeleteAll;

                // if RunDate <> 0D then
                //     // RunDate := Today;

                //     Error('The Fixed Doposit is set to Mature on ', "FD Maturity Date");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        FDManagement: Codeunit FixedDepositManagement;
        RunDate: Date;
        GenJournalLine: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        FDDays: Integer;
}

