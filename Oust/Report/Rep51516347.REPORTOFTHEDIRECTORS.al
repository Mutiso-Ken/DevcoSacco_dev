report 51516347 "REPORT OF THE DIRECTORS"

{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Reportofthedirectors.rdlc';

    dataset
    {
        dataitem("Sacco Information"; "Sacco Information")
        {
            column(Code; Code)
            {

            }
            column(Independent_Auditor; "Independent Auditor")
            {

            }
            column(Asat; Asat)
            {


            }
            column(CurrentYear; CurrentYear)
            {

            }
            column(PreviousYear; PreviousYear)
            {

            }
            column(EndofLastyear; EndofLastyear)
            {

            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                InputDate: Date;
                DateFormula: Text;
            begin
                DateFormula := '<-CY-1D>';
                InputDate := Asat;
                EndofLastyear := CalcDate(DateFormula, Asat);
                CurrentYear := Date2DMY(EndofLastyear, 3);
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
        myInt: Integer;
        Asat: Date;
        CurrentYear: Integer;
        PreviousYear: Integer;
        EndofLastyear: date;
}
