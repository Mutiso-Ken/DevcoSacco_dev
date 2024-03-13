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
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                InputDate: Date;
                DateFormula: Text;
                DateExpr: Text;

            begin
                DateFormula := '<-CY-1D>';
                DateExpr := '<-1y>';
                InputDate := Asat;

                EndofLastyear := CalcDate(DateFormula, Asat);
                CurrentYear := Date2DMY(EndofLastyear, 3);
                LastYearButOne := CalcDate(DateExpr, EndofLastyear);
                PreviousYear := CurrentYear - 1;
            end;
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