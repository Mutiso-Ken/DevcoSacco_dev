#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50016 "Next of Kin Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Next of Kin Report.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Members Next Kin Details"; "Members Next Kin Details")
        {
            column(ReportForNavId_1120054000; 1120054000)
            {
            }
            column(DateofBirth; "Members Next Kin Details"."Date of Birth")
            {
            }
            column(Address; "Members Next Kin Details".Address)
            {
            }
            column(Telephone; "Members Next Kin Details".Telephone)
            {
            }
            column(Email; "Members Next Kin Details".Email)
            {
            }
            column(AccountNo; "Members Next Kin Details"."Account No")
            {
            }
            column(IDNo; "Members Next Kin Details"."ID No.")
            {
            }
            column(Relationship; "Members Next Kin Details".Relationship)
            {
            }
            column(Name_MembersNextKinDetails; "Members Next Kin Details".Name)
            {
            }
            column(Name; Name)
            {
            }
            column(Test; Test)
            {
            }
            column(CIName; CI.Name)
            {
            }
            column(CIPicture; CI.Picture)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // MembersRegister.Reset;
                // MembersRegister.SetRange(MembersRegister."No.", "Account No");
                // // MembersRegister.SetAutocalcFields(MembersRegister."Shares Retained");
                // // MembersRegister.SetFilter(MembersRegister."Shares Retained", '>%1', 1);
                // if MembersRegister.find('-') then begin
                //     //IF "Members Next Kin Details".GET("Members Next Kin Details"."Account No") THEN
                //     Test := MembersRegister.Name;
                //     //MESSAGE(FORMAT(MembersRegister."Shares Retained"));
                // end else
                //     CurrReport.Skip;
            end;
        }
    }

    // requestpage
    // {

    //     layout
    //     {
    //     }

    //     actions
    //     {
    //     }
    // }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CI.Get();
        CI.CalcFields(CI.Picture);
    end;

    var
        MembersRegister: Record Customer;
        Name: Text[100];
        Test: Text[100];
#pragma warning disable AL0275
        CI: Record "Company Information";
#pragma warning restore AL0275
}

