report 50013 "Sacco Information"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Sacco Information Report';
    DefaultLayout = RDLC;
    RDLCLayout = 'Layouts/SaccoInformationReport.rdlc';


    dataset
    {
        dataitem("Sacco Information"; "Sacco Information")

        {
           
            column(Sacco_CEO_Name; "Sacco CEO Name") { }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(Date_Filter; "Date Filter")
            {

            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPic; CompanyInfo.Picture)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(Floor_Number; "Floor Number")
            {

            }
            column(Building_Number; "Building Number")
            {

            }
            column(Street_Road; "Street/Road")
            {

            }
            column(P_O_Box; "P.O Box")
            {

            }
            column(PrincipalBankBox; PrincipalBankBox)
            {

            }
            column(IndAuditorBOX; IndAuditorBOX)
            {

            }
            column(Independent_Auditor; "Independent Auditor")
            {

            }
            column(PrincipalBankers; PrincipalBankers)
            {

            }
            column(LegalAdvisorsName; LegalAdvisorsName)
            {

            }
        }
        dataitem("Board of Directors"; "Board of Directors")
        {
            column(NameDirectors; Name)
            {

            }
        }
        dataitem("Supervisory Commitee"; "Supervisory Commitee")
        {
            column(NameSupervisory; Name)
            {

            }
        }

    }
    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

