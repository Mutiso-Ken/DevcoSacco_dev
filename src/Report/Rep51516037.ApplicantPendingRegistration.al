report 51516037 "Applicant Pending Registration"
{
    ApplicationArea = All;
    Caption = 'Approved Applicants Pending Registration';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/ApprovedApplicantsPendingRegistration.rdlc';
    dataset
    {
        dataitem(MembershipApplications; "Membership Applications")
        {
            DataItemTableView = sorting("No.") where(Status = const(Approved));
            RequestFilterFields = "Registration Date";
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(Address; Address)
            {
            }
            column(Address2; "Address 2")
            {
            }
            column(Address3; Address3)
            {
            }
            column(Age; Age)
            {
            }
            column(ApprovedBy; "Approved By")
            {
            }
            column(AssignedNo; "Assigned No.")
            {
            }
            column(BOSAAccountNo; "BOSA Account No.")
            {
            }
            column(BankAccountNo; "Bank Account No")
            {
            }
            column(BankCode; "Bank Code")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(Category; Category)
            {
            }
            column(City; City)
            {
            }
            column(ContactPerson; "Contact Person")
            {
            }
            column(ContactPersonPhone; "Contact Person Phone")
            {
            }
            // column(Contactpersonage; "Contact person age")
            // {
            // }
            // column(ContactPersonOccupation; "ContactPerson Occupation")
            // {
            // }
            column(ContactPersonRelation; "ContactPerson Relation")
            {
            }
            column(Converted; Converted)
            {
            }
            column(CopyofCurrentPayslip; "Copy of Current Payslip")
            {
            }
            // column(CopyofKRAPin; "Copy of KRA Pin")
            // {
            // }
            column(Copyofconstitution; "Copy of constitution")
            {
            }
            column(CountryRegionCode; "Country/Region Code")
            {
            }
            column(County; County)
            {
            }
            column(Created; Created)
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(CurrentFileLocation; "Current File Location")
            {
            }
            column(CustomerPostingGroup; "Customer Posting Group")
            {
            }
            column(CustomerPriceGroup; "Customer Price Group")
            {
            }
            column(CustomerType; "Customer Type")
            {
            }
            column(DateEstablish; "Date Establish")
            {
            }
            column(DateofBirth; "Date of Birth")
            {
            }
            column(DateofBirth2; "Date of Birth2")
            {
            }
            column(Department; Department)
            {
            }
            column(Designation; Designation)
            {
            }
            // column(Dioces; Dioces)
            // {
            // }
            // column(District; District)
            // {
            // }
            column(DividendAmount; "Dividend Amount")
            {
            }
            column(EMailPersonal; "E-Mail (Personal)")
            {
            }
            column(EMailPersonal2; "E-Mail (Personal2)")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(EmployerCode2; "Employer Code2")
            {
            }
            column(EmployerName; "Employer Name")
            {
            }
            column(EmployerName2; "Employer Name2")
            {
            }
            column(FOSAAccountType; "FOSA Account Type")
            {
            }
            column(FileMovementRemarks; "File Movement Remarks")
            {
            }
            column(Firstmembername; "First member name")
            {
            }
            column(Gender; Gender)
            {
            }
            column(Gender2; Gender2)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
           
            column(GroupAccountName; "Group Account Name")
            {
            }
            column(GroupAccountNo; "Group Account No")
            {
            }
            column(HomeAddress; "Home Address")
            {
            }
            column(HomePostalCode; "Home Postal Code")
            {
            }
            column(HomePostalCode2; "Home Postal Code2")
            {
            }
            column(HomeTown; "Home Town")
            {
            }
            column(HomeTown2; "Home Town2")
            {
            }
            column(IDNOPassport2; "ID NO/Passport 2")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(IncompleteApplication; "Incomplete Application")
            {
            }
            // column(InsuranceContribution; "Insurance Contribution")
            // {
            // }
            column(InvestmentBF; "Investment B/F")
            {
            }
            column(KRAPin; "KRA Pin")
            {
            }
            column(Location; Location)
            {
            }
            column(MaritalStatus; "Marital Status")
            {
            }
            column(MaritalStatus2; "Marital Status2")
            {
            }
            column(MemberRegistrationFeeReceiv; "Member Registration Fee Receiv")
            {
            }
            column(MicroGroupCode; "Micro Group Code")
            {
            }
            column(MobileNo2; "Mobile No. 2")
            {
            }
            column(MobileNo3; "Mobile No. 3")
            {
            }
            column(MobilePhoneNo; "Mobile Phone No")
            {
            }
            column(MonthlyContribution; "Monthly Contribution")
            {
            }
            column(Name; Name)
            {
            }
            column(Name2; "Name 2")
            {
            }
            column(NameofChief; "Name of Chief")
            {
            }
            column(No; "No.")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(Occupation; Occupation)
            {
            }
            column(OfficeBranch; "Office Branch")
            {
            }
            column(OfficeTelephoneNo; "Office Telephone No.")
            {
            }
            column(PassportNo; "Passport No.")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No")
            {
            }
            column(PayrollStaffNo2; "Payroll/Staff No2")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(Picture; Picture)
            {
            }
            column(Picture2; "Picture 2")
            {
            }
            column(PostalCode; "Postal Code")
            {
            }
            // column(Province; Province)
            // {
            // }
            column(Received1CopyOfID; "Received 1 Copy Of ID")
            {
            }
            column(Received1CopyOfPassport; "Received 1 Copy Of Passport")
            {
            }
            column(RecruitedBy; "Recruited By")
            {
            }
            column(RecruiterName; "Recruiter Name")
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(RegistrationNo; "Registration No")
            {
            }
            column(Registrationoffice; "Registration office")
            {
            }
            column(ResponsibilityCentre; "Responsibility Centre")
            {
            }
            column(SalesCode; "Sales Code")
            {
            }
            column(SalespersonName; "Salesperson Name")
            {
            }
            column(SearchName; "Search Name")
            {
            }
            column(Section; Section)
            {
            }
            column(SentforApprovalBy; "Sent for Approval By")
            {
            }
            column(Signature; Signature)
            {
            }
            column(Signature2; "Signature  2")
            {
            }
            column(SmsNotification; "Sms Notification")
            {
            }
            column(Source; Source)
            {
            }
            column(SpecimenSignature; "Specimen Signature")
            {
            }
            column(StationDepartment; "Station/Department")
            {
            }
            column(Status; Status)
            {
            }
            // column(SubLocation; "Sub-Location")
            // {
            // }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TermsofEmployment; "Terms of Employment")
            {
            }
            // column(Title; Title)
            // {
            // }
            // column(Title2; Title2)
            // {
            // }
            column(EntryNo; EntryNo)
            {
            }
            column(UserID; "User ID")
            {
            }
            column(CompanyName; CompanyInfo.Name)
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

            trigger OnAfterGetRecord();
            begin
                EntryNo := EntryNo + 1;
            end;
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
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);


    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        EntryNo: Integer;
        CompanyInfo: Record "Company Information";
}
