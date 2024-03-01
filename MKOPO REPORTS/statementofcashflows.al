report 50039 cashFlows
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'satement of changes in equity Previous Period';
    RDLCLayout = './Layout/cashflowsreport.rdlc';

    dataset
    {
        dataitem("Sacco Information"; "Sacco Information")
        {
            column(Code; Code)
            {

            }
            column(PreviousYear; PreviousYear)
            {

            }
            column(CurrentYear; CurrentYear)
            {

            }
            column(EndofLastyear; EndofLastyear)
            {

            }
            column(LastYearButOne; LastYearButOne)
            {

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Asat; Asat)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        AsAt: Date;
        PreviousYear: Integer;
        CurrentYear: Integer;
        EndofLastyear: date;
        LastYearButOne: Date;
}