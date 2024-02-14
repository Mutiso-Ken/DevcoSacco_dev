report 51516022 "Mark as Processed"
{
    ApplicationArea = All;
    Caption = 'Mark as Processed';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(SalaryProcessingLines; "Salary Processing Lines")
        {
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
