report 50028 StatchangesinequityPrevious
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'satement of changes in equity Previous Period';
    RDLCLayout = './Layout/Statementofchangesinequityprevious.rdlc';

    dataset
    {
        dataitem("Sacco Information"; "Sacco Information")
        {
            column(Code; Code)
            {

            }
            column(EndofLastyear; EndofLastyear)
            {

            }
            column(LastYearButOne; LastYearButOne)
            {

            }
            column(PreviousYear; PreviousYear)
            {

            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                DateExpr: Text;
                InputDate: Date;
                DateFormula: Text;

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
                    field(AsAt; AsAt)
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