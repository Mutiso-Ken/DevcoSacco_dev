#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516521 "Crm log card"
{
    PageType = Card;
    SourceTable = "General Equiries";
    SourceTableView = where(Send=const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Calling As";"Calling As")
                {
                    ApplicationArea = Basic;
                }
                field("Calling For";"Calling For")
                {
                    ApplicationArea = Basic;
                }
                field("Contact Mode";"Contact Mode")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Lead Details")
            {
                Visible = AsNonmember;
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field(SurName;SurName)
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No";"Phone No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile No';
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Id Number";"Passport No")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Member Information")
            {
                Visible = Asmember;
                field("Member No";"Member No")
                {
                    ApplicationArea = Basic;
                }
                field("Member Name";"Member Name")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Balance";"Loan Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Share Capital";"Share Capital")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Current Deposits";"Current Deposits")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID No";"ID No")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Loan No";"Loan No")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Case Information")
            {
                Visible = Ascase;
                field("Type of cases";"Type of cases")
                {
                    ApplicationArea = Basic;
                }
                field("Case Description";Description)
                {
                    ApplicationArea = Basic;
                }
                field("Query Code";"Query Code")
                {
                    ApplicationArea = Basic;
                }
                field(Source;Source)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Caller Reffered To";"Caller Reffered To")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Employer Information")
            {
                Visible = AsEmployer;
                field("company No";"company No")
                {
                    ApplicationArea = Basic;
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic;
                }
                field("Company Address";"Company Address")
                {
                    ApplicationArea = Basic;
                }
                field("Company postal code";"Company postal code")
                {
                    ApplicationArea = Basic;
                }
                field("Company Telephone";"Company Telephone")
                {
                    ApplicationArea = Basic;
                }
                field("Company Email";"Company Email")
                {
                    ApplicationArea = Basic;
                }
                field("Company website";"Company website")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Detailed Member Page")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Checkoff Processing Lines-D";
                RunPageLink = "Staff/Payroll No"=field("Member No");
            }
            action(Forward)
            {
                ApplicationArea = Basic;
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //Get lead
                    if ("Calling As"="calling as"::"As Non Member")or ("Calling As"="calling as"::"As Others") then begin
                    LeadM.Init;
                    LeadM."No.":=No;
                    LeadM."First Name":="First Name";
                    LeadM."Middle Name":=SurName;
                    LeadM.Surname:="Last Name";
                    LeadM."member no":="Member No";
                    LeadM.Name:="Member Name";
                    LeadM.Address:=Address;
                    LeadM.City:=city;
                    LeadM."Phone No.":="Phone No";
                    LeadM."Company No.":="company No";
                    LeadM."Company Name":="Company Name";
                    LeadM.Name:="First Name"+ '' +SurName+'' + ''+"Last Name";
                    LeadM.Type:="Calling As";
                    LeadM."ID No":="ID No";
                    LeadM."Receive date":=Today;
                    LeadM."Receive Time":=Time;
                    LeadM."Received From":=UserId;
                    LeadM."Sent By":=UserId;
                    LeadM."Caller Reffered To":="Caller Reffered To";
                    LeadM.Description:=Description;
                    LeadM.Insert(true);
                    Send:=true;
                    Message('opportunity successfully generated');

                    end;
                    //categories lead

                      //get the CASE INFORMATION
                      if "Calling As"="calling as"::"As Member" then
                       begin
                         if ("Calling For"="calling for"::Complaint )or ("Calling For"="calling for"::Payment )or ("Calling For"="calling for"::Receipt )or ("Calling For"="calling for"::"Loan Form" )then
                           begin
                             TestField("Type of cases");
                             if "Type of cases"="type of cases"::Loan then
                              begin
                                TestField("Loan No");
                              end;
                             CASEM.Init;
                             CASEM."Case Number":=No;
                             CASEM."Member No":="Member No";
                             CASEM."Fosa Account":="Fosa account";
                             CASEM."Account Name":="Member Name";
                             CASEM."loan no":="Loan No";
                             CASEM."Date of Complaint":=Today;
                             CASEM."Type of cases":="Type of cases";
                             CASEM."Time Sent":=Time;
                             CASEM."Date Sent":=Today;
                             CASEM."Receive date":=Today;
                             CASEM."Caller Reffered To":="Caller Reffered To";
                             CASEM."Case Description":=Description;
                             if CASEM."Case Number"<>'' then
                               Message('Member Case created ');
                             Send:=true;
                             CASEM.Insert(true);
                         end else
                             CASEM.Init;
                             CASEM."Case Number":=No;
                             CASEM."Member No":="Member No";
                             CASEM."Fosa Account":="Fosa account";
                             CASEM."Account Name":="Member Name";
                             CASEM."loan no":="Loan No";
                             CASEM."Date of Complaint":=Today;
                             CASEM."Type of cases":="Type of cases";
                             CASEM."Time Sent":=Time;
                             CASEM."Date Sent":=Today;
                             CASEM."Receive date":=Today;
                             CASEM."Caller Reffered To":="Caller Reffered To";
                             CASEM."Case Description":=Description;
                             if CASEM."Case Number"<>'' then
                               Message('Member Case created ');
                             Send:=true;

                         CASEM.Insert(true);
                       end;

                     //company cases
                     if "Calling As"="calling as"::"As Employer" then begin
                      if ("Calling For"="calling for"::Complaint )or ("Calling For"="calling for"::Payment )or ("Calling For"="calling for"::Receipt )then begin
                    TestField("Type of cases");TestField("Query Code");
                        if "Type of cases"<>"type of cases"::"Payment/Receipt/Advice" then
                          Error('Case must be Payment/Receipt/Advice');
                          CASEM.Init;
                     CASEM."Case Number":=No;
                     CASEM."company No":="Query Code";
                     CASEM."Company Name":="Company Name";
                     CASEM."Company Address":="Company Address";
                     CASEM."Company Email":="Company Email";
                     CASEM."Date of Complaint":=Today;
                     CASEM."Company postal code":="Company postal code";
                     CASEM."Company Telephone":="Company Telephone";
                     CASEM."Type of cases":="Type of cases";
                     CASEM."Time Sent":=Time;
                     CASEM."Date Sent":=Today;
                     CASEM."Receive date":=Today;
                     CASEM."Caller Reffered To":="Caller Reffered To";
                     CASEM."Case Description":=Description;
                     if CASEM."Case Number"<>'' then
                       Send:=true;
                       Message('Employer Case created ');
                     end;
                     CASEM.Insert(true);
                        end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AsEmployer:=false;
        Asmember:=false;
        AsNonmember:=false;
        Asother:=false;
        Ascase:=false;
        if "Calling As"="calling as"::"As Member" then begin
          Asmember:=true;
          AsEmployer:=true;
          Ascase:=true;
          end;
          if "Calling As"="calling as"::"As Non Member" then begin
            AsNonmember:=true;
             Asother:=true;
            end;
            if "Calling As"="calling as"::"As Employer" then begin
              AsEmployer:=true;
              Asother:=true;
              Ascase:=true;
              end;
    end;

    trigger OnOpenPage()
    begin
        AsEmployer:=false;
        Asmember:=false;
        AsNonmember:=false;
        Asother:=false;
        Ascase:=false;
        if "Calling As"="calling as"::"As Member" then begin
          Asmember:=true;
          AsEmployer:=true;
          Ascase:=true;
          end;
          if "Calling As"="calling as"::"As Non Member" then begin
            AsNonmember:=true;
             Asother:=true;
            end;
            if "Calling As"="calling as"::"As Employer" then begin
              AsEmployer:=true;
              Ascase:=true;
              end;
    end;

    var
        Cust: Record Customer;
        PvApp: Record "Loans Register";
        CustCare: Record "General Equiries";
        CQuery: Record "General Equiries";
        employer: Record "Sacco Employers";
        membApp: Record "Membership Applications";
        LeadM: Record "Lead Management";
        entry: Integer;
        vend: Record Vendor;
        CASEM: Record "Cases Management";
        AsEmployer: Boolean;
        Asmember: Boolean;
        AsNonmember: Boolean;
        Asother: Boolean;
        Ascase: Boolean;
}

