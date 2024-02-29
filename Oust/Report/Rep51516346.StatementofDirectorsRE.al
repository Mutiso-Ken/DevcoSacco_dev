report 51516346 "Statement of Directors'RE"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './Layout/statementofDirectors.docx';


    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Name; Name)
            {

            }
        }

    }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin

    end;

    var
    r:Report "Chart of Accounts";
        myInt: Integer;
}