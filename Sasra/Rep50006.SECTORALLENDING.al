#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50006 "SECTORAL LENDING"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SECTORAL LENDING.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
#pragma warning disable AL0275
        dataitem(Company;"Company Information")
#pragma warning restore AL0275
        {
            column(ReportForNavId_1120054004; 1120054004)
            {
            }
            column(name;Company.Name)
            {
            }
            column(startdate;StartDate)
            {
            }
            column(enddate;EndDate)
            {
            }
            column(DateTday;DateTday)
            {
            }
            column(DateTo;DateTo)
            {
            }
            column(FinacialYear;FinacialYear)
            {
            }
        }
        dataitem("Main Sector";"Main Sector")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Code_MainSector;"Main Sector".Code)
            {
            }
            column(Description_MainSector;"Main Sector".Description)
            {
            }
            dataitem("Sub Sector";"Sub-Sector")
            {
                DataItemLink = No=field(Code);
                column(ReportForNavId_4; 4)
                {
                }
                column(Code_SubSector;"Sub Sector".Code)
                {
                }
                column(Description_SubSector;"Sub Sector".Description)
                {
                }
                dataitem("Specific Sector";"Specific-Sector")
                {
                    DataItemLink = No=field(Code);
                    column(ReportForNavId_7; 7)
                    {
                    }
                    column(Code_SpecificSector;"Specific Sector".Code)
                    {
                    }
                    column(Description_SpecificSector;"Specific Sector".Description)
                    {
                    }
                    column(AMount;AMount)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //  AMount:=0;
                        //  LoansR.Reset;
                        //  LoansR.SetRange("Other Loans Repayments","Specific Sector".Code);
                        //  LoansR.SetFilter("Issued Date",Datefilter);
                        //  if LoansR.FindFirst then begin
                        //   repeat
                        //     LoansR.CalcFields("Outstanding Balance");
                        //     AMount:=AMount+LoansR."Outstanding Balance";
                        //    until LoansR.Next=0;
                        //   end;
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate;StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Starting Date';
                }
                field(EndDate;EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Datefilter:=Format(StartDate)+'..'+Format(EndDate);
        GenLedgerSetup.Get();
        DateTday:=Format(GenLedgerSetup."Allow Posting From");
        DateTo:=Format(GenLedgerSetup."Allow Posting To");
        FinacialYear:=Date2dmy(StartDate,3);
    end;

    var
        LoansR: Record "Loans Register";
        AMount: Decimal;
        StartDate: Date;
        EndDate: Date;
        Datefilter: Text;
#pragma warning disable AL0275
        GenLedgerSetup: Record "General Ledger Setup";
#pragma warning restore AL0275
        DateTday: Text;
        DateTo: Text;
        FinacialYear: Integer;
}

