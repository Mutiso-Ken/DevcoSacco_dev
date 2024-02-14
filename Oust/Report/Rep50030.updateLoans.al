report 50030 updateLoans
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            column(Loan__No_; "Loan  No.")
            {

            }
            trigger OnAfterGetRecord()
            var
                Loans: Record "Loans Register";
                Cust: Record Customer;
            begin
                Loans.SetRange(Loans."Client Code", Cust."No.");
                If cust.get("Client Code") then begin
                    "Client Name" := Cust.Name;
                    "Loans Register".Modify(true);
                end;
            end;
        }
    }



}