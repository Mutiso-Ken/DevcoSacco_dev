#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516220 "Membership Applications"
{
    Caption = 'Member Application';
    DataCaptionFields = "No.", Name;
    DrillDownPageId = "Membership Application List";  //Important incase you are running to view a page e.g in approval
    LookupPageId = "Membership Application List";//Important incase you are running to view a page e.g in approval

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    NoSeriesMgt.TestManual(SalesSetup."Member Application Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
                Name := UpperCase(Name);
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';

            trigger OnValidate()
            begin
                Address := UpperCase(Address);
            end;
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';

            trigger OnValidate()
            begin
                "Address 2" := UpperCase("Address 2");
            end;
        }
        field(7; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            begin
                "Phone No." := UpperCase("Phone No.")
            end;
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(9; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            //TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
        field(10; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(12; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(68000; "Customer Type"; Option)
        {
            OptionCaption = ',Member,FOSA,Investments,Property,MicroFinance';
            OptionMembers = " ",Member,FOSA,Investments,Property,MicroFinance;
        }
        field(68001; "Registration Date"; Date)
        {
        }
        field(68002; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected,Closed';
            OptionMembers = Open,Pending,Approved,Rejected,Closed;
        }
        field(68003; "Employer Code"; Code[20])
        {
            TableRelation = "Sacco Employers";

            trigger OnValidate()
            begin
                Employer.Get("Employer Code");
                "Employer Name" := Employer.Description;
            end;
        }
        field(68004; "Date of Birth"; Date)
        {

            trigger OnValidate()
            begin
                if "Date of Birth" > Today then
                    Error('Date of birth cannot be greater than today');

                if "Account Category" <> "account category"::Junior then begin
                    if "Date of Birth" <> 0D then begin
                        if GenSetUp.Get() then begin
                            if CalcDate(GenSetUp."Min. Member Age", "Date of Birth") > Today then
                                Error('Applicant below the mininmum membership age of %1', GenSetUp."Min. Member Age");
                        end;
                    end;
                end;
                // Age := Dates.DetermineAge("Date of Birth", Today);
                if "Date of Birth" <> 0D then
                    Age := Round((Today - "Date of Birth") / 365, 1);
            end;
        }
        field(68005; "E-Mail (Personal)"; Text[50])
        {
        }
        field(68006; "Station/Department"; Code[20])
        {
            TableRelation = "Loans Guarantee Details"."Loan No" where(Name = field("Employer Code"));
        }
        field(68007; "Home Address"; Text[50])
        {

            trigger OnValidate()
            begin
                "Home Address" := UpperCase("Home Address");
            end;
        }
        field(68008; Location; Text[50])
        {
        }
        field(68009; "Sub-Location"; Text[50])
        {
        }
        field(68010; District; Text[50])
        {
        }
        field(68011; "Payroll/Staff No"; Code[20])
        {
        }
        field(68012; "ID No."; Code[50])
        {

            trigger OnValidate()
            begin

                if Cust."Customer Posting Group" <> 'PLAZA' then
                    if "ID No." <> '' then begin
                        Cust.Reset;
                        Cust.SetRange(Cust."ID No.", "ID No.");
                        Cust.SetRange(Cust."Customer Type", Cust."customer type"::Member);
                        if Cust.Find('-') then begin
                            if Cust."No." <> "No." then
                                Error('ID No. already exists');
                        end;
                    end;


                /*
                Vend2.RESET;
                Vend2.SETRANGE(Vend2."Creditor Type",Vend2."Creditor Type"::Account);
                Vend2.SETRANGE(Vend2."Staff No","Payroll/Staff No");
                IF Vend2.FIND('-') THEN BEGIN
                REPEAT
                Vend2."ID No.":="ID No.";
                Vend2.MODIFY;
                UNTIL Vend2.NEXT = 0;
                END;
                */

            end;
        }
        field(68013; "Mobile Phone No"; Code[50])
        {

            trigger OnValidate()
            begin
                /*
                Vend.RESET;
                Vend.SETRANGE(Vend."Staff No","Staff No");
                IF Vend.FIND('-') THEN
                Vend.MODIFYALL(Vend."Mobile Phone No","Mobile Phone No");
                
                Cust.RESET;
                Cust.SETRANGE(Cust."Staff No","Staff No");
                IF Cust.FIND('-') THEN
                Cust.MODIFYALL(Cust."Mobile Phone No","Mobile Phone No");
                */
                /*
                Vend.RESET;
                Vend.SETRANGE(Vend."Staff No","Payroll/Staff No");
                IF Vend.FIND('-') THEN BEGIN
                REPEAT
                Vend."Mobile Phone No":="Mobile Phone No";
                Vend.MODIFY;
                UNTIL Vend.NEXT=0;
                END;
                
                Cust.RESET;
                Cust.SETRANGE(Cust."Payroll/Staff No","Payroll/Staff No");
                IF Cust.FIND('-') THEN BEGIN
                REPEAT
                IF Cust."No." <> "No." THEN BEGIN
                Cust."Mobile Phone No":="Mobile Phone No";
                Cust.MODIFY;
                
                END;
                
                UNTIL Cust.NEXT = 0;
                END;
                 */

            end;
        }
        field(68014; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Divorced,Widower,Widow;
        }
        field(68015; Signature; Media)
        {
            ExtendedDatatype = Masked;
        }
        field(68016; "Passport No."; Code[50])
        {
        }
        field(68017; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
            //NotBlank = true;
        }
        field(68018; "Monthly Contribution"; Decimal)
        {
        }
        field(68019; "Investment B/F"; Decimal)
        {
        }
        field(68020; "Dividend Amount"; Decimal)
        {
        }
        field(68021; "Name of Chief"; Text[50])
        {
        }
        field(68022; "Office Telephone No."; Code[50])
        {
        }
        field(68023; "Extension No."; Code[30])
        {
        }
        field(68024; "Insurance Contribution"; Decimal)
        {
        }
        field(68025; Province; Code[50])
        {
        }
        field(68026; "Current File Location"; Code[50])
        {
            CalcFormula = max("File Movement Tracker".Station where("Member No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(68027; "Village/Residence"; Text[50])
        {
        }
        field(68028; "File Movement Remarks"; Text[150])
        {
        }
        field(68029; "Office Branch"; Code[20])
        {
        }
        field(68030; Department; Code[20])
        {
            TableRelation = "Member Departments"."No.";
            trigger OnValidate()
            var
                Dep: Record "Member Departments";
            begin
                Dep.Reset;
                Dep.SetRange(Dep."No.", Department);

                if Dep.FindSet then begin
                    if Dep.FindFirst then begin
                        Department := Dep.Department;
                    end;
                end;
            end;
        }
        field(68031; Section; Code[20])
        {
            TableRelation = "Member Section"."No.";
        }
        field(68032; "No. Series"; Code[10])
        {
        }
        field(68033; Occupation; Text[30])
        {
        }
        field(68034; Designation; Text[30])
        {
        }
        field(68035; "Terms of Employment"; Option)
        {
            OptionMembers = " ",Permanent,Contract,Casual;
        }
        field(68036; Category; Code[20])
        {
        }
        field(68037; Picture; Media)
        {
            ExtendedDatatype = Person;
        }
        field(68038; "Postal Code"; Code[20])
        {
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                PostCode.Reset;
                PostCode.SetRange(PostCode.Code, "Postal Code");
                if PostCode.Find('-') then begin
                    Town := PostCode.City
                end;
            end;
        }
        field(68039; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(68040; "Contact Person"; Code[20])
        {
        }
        field(68041; "Approved By"; Code[100])
        {
        }
        field(68042; "Sent for Approval By"; Code[20])
        {
        }
        field(68043; "Responsibility Centre"; Code[20])
        {
        }
        field(68044; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                //IF ("Country/Region Code" <> xRec."Country/Region Code") AND (xRec."Country/Region Code" <> '') THEN
                //PostCode.ClearFields(City,"Post Code",County);
            end;
        }
        field(68045; County; Text[30])
        {
            Caption = 'County';
        }
        field(68046; "Bank Code"; Code[100])
        {
            TableRelation = Banks."Bank Code";
            trigger OnValidate()
            var
                Banks: Record Banks;
            begin
                Banks.Reset;
                Banks.SetRange(Banks."Bank Code", "Bank Code");

                if Banks.FindSet then begin
                    if Banks.FindFirst then begin
                        "Bank Code" := Banks."Bank Name";
                        // "Bank Name" := BanksVer2."Bank Name";
                        // "Bank Branch Code" := BanksVer2."Branch Code";
                        // "Bank Branch Name" := BanksVer2."Branch Name";

                    end;
                end;
            end;
        }
        field(68047; "Bank Name"; Code[120])
        {
        }
        field(68048; "Bank Account No"; Code[120])
        {
        }
        field(68049; "Contact Person Phone"; Code[130])
        {
        }
        field(68050; "ContactPerson Relation"; Code[20])
        {
            TableRelation = "Relationship Types";
        }
        field(68051; "Recruited By"; Code[120])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                Cust.Reset;
                Cust.SetRange(Cust."No.", "Recruited By");
                if Cust.Find('-') then begin
                    "Recruiter Name" := Cust.Name;
                end;
            end;
        }
        field(68052; "ContactPerson Occupation"; Code[20])
        {
        }
        field(68053; Dioces; Code[30])
        {
        }
        field(68054; "Mobile No. 2"; Code[20])
        {
        }
        field(68055; "Employer Name"; Code[50])
        {
        }
        field(68056; Title; Option)
        {
            OptionCaption = ' ,Mr.,Mrs.,Miss.,DR.,Prof.,Fr.,Sr.,Bro.';
            OptionMembers = " ","Mr.","Mrs.","Miss.","DR.","Prof.","Fr.","Sr.","Bro.";
        }
        field(68057; Town; Code[30])
        {
        }
        field(68058; "Received 1 Copy Of ID"; Boolean)
        {
        }
        field(68059; "Received 1 Copy Of Passport"; Boolean)
        {
        }
        field(68060; "Specimen Signature"; Boolean)
        {
        }
        field(68061; "Home Postal Code"; Code[20])
        {
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                PostCode.Reset;
                PostCode.SetRange(PostCode.Code, "Home Postal Code");
                if PostCode.Find('-') then begin
                    "Home Town" := PostCode.City
                end;
            end;
        }
        field(68062; Created; Boolean)
        {
        }
        field(68063; "Incomplete Application"; Boolean)
        {
        }
        field(68064; "Created By"; Text[60])
        {
        }
        field(68065; "Assigned No."; Code[30])
        {
        }
        field(68066; "Home Town"; Text[60])
        {
        }
        field(68067; "Recruiter Name"; Text[50])
        {
        }
        field(68068; "Copy of Current Payslip"; Boolean)
        {
        }
        field(68069; "Member Registration Fee Receiv"; Boolean)
        {
        }
        field(68070; "Account Category"; Option)
        {

            OptionMembers = Single,Joint,"Group Account",Junior;
            OptionCaption = 'Individual Account,Joint Account,Group Account, Junior Account';
        }
        field(68071; "Copy of KRA Pin"; Boolean)
        {
        }
        field(68072; "Contact person age"; Date)
        {

            trigger OnValidate()
            begin
                /*IF "Contact person age" > TODAY THEN
                ERROR('Age cannot be greater than today');


               IF "Contact person age" <> 0D THEN BEGIN
               IF GenSetUp.GET() THEN BEGIN
               IF CALCDATE(GenSetUp."Min. Member Age","Contact person age") > TODAY THEN
               ERROR('Contact person should be atleast 18years and above %1',GenSetUp."Min. Member Age");
               END;
               END;
               */

            end;
        }
        field(68073; "Second Member Name"; Text[30])
        {
        }
        field(68075; "Date Establish"; Date)
        {
        }
        field(68076; "Registration No"; Code[30])
        {
        }
        field(68077; "ID NO/Passport 2"; Code[30])
        {
        }
        field(68079; "Registration office"; Text[30])
        {
            TableRelation = Location.Code;
        }
        field(68080; "Picture 2"; Blob)
        {
            SubType = Bitmap;
        }
        field(68081; "Signature  2"; Blob)
        {
            SubType = Bitmap;
        }
        field(68082; Title2; Option)
        {
            OptionCaption = ' ,Mr.,Mrs.,Miss.,DR.,Prof.,Fr.,Sr.,Bro.';
            OptionMembers = " ","Mr.","Mrs.","Miss.","DR.","Prof.","Fr.","Sr.","Bro.";
        }
        field(68083; "Mobile No. 3"; Code[20])
        {
        }
        field(68084; "Date of Birth2"; Date)
        {

            trigger OnValidate()
            begin
                if "Date of Birth" > Today then
                    Error('Date of birth cannot be greater than today');


                if "Date of Birth" <> 0D then begin
                    if GenSetUp.Get() then begin
                        if CalcDate(GenSetUp."Min. Member Age", "Date of Birth") > Today then
                            Error('Applicant below the mininmum membership age of %1', GenSetUp."Min. Member Age");
                    end;
                end;
            end;
        }
        field(68085; "Marital Status2"; Option)
        {
            OptionMembers = " ",Single,Married,Devorced,Widower,Widow;
        }
        field(68086; Gender2; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(68087; Address3; Code[30])
        {
        }
        field(68088; "Home Postal Code2"; Code[20])
        {
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                PostCode.Reset;
                PostCode.SetRange(PostCode.Code, "Home Postal Code");
                if PostCode.Find('-') then begin
                    "Home Town" := PostCode.City
                end;
            end;
        }
        field(68089; "Home Town2"; Text[60])
        {
        }
        field(68090; "Payroll/Staff No2"; Code[20])
        {
        }
        field(68100; "Employer Code2"; Code[20])
        {
            TableRelation = "Sacco Employers";

            trigger OnValidate()
            begin
                Employer.Get("Employer Code");
                "Employer Name" := Employer.Description;
            end;
        }
        field(68101; "Employer Name2"; Code[50])
        {
        }
        field(68102; "E-Mail (Personal2)"; Text[50])
        {
        }
        field(68103; Age; Integer)
        {
        }
        field(68104; "Copy of constitution"; Boolean)
        {
        }
        field(68105; "KRA Pin"; Code[30])
        {
        }
        field(68106; Converted; Boolean)
        {
        }
        field(68107; "Fosa Account No"; Code[20])
        {
            TableRelation = Vendor."No.";
        }
        field(68108; "Sms Notification"; Boolean)
        {
        }
        field(68109; "Group Account"; Boolean)
        {
        }
        field(68110; "Account Type"; Option)
        {
            OptionCaption = ' ,Single,Group';
            OptionMembers = " ",Single,Group;
        }
        field(68111; "FOSA Account Type"; Code[30])
        {
            Editable = false;
            TableRelation = "Account Types-Saving Products".Code;
        }
        field(68112; "Sales Code"; Code[10])
        {
            //TableRelation = "Loan Officers Details";

            trigger OnValidate()
            begin
                /*
                Name:='';
                IF "Sales Code Type" IN ["Sales Code Type"::Staff,"Sales Code Type"::Delegate,"Sales Code Type"::"Board Member",
                "Sales Code Type"::"Direct Marketers","Sales Code Type"::Others]   THEN

               CASE "Sales Code Type"  OF
               "Sales Code Type"::Staff:
               BEGIN
               HR.GET("Sales Code Type");
               Name:=HR."First Name";
               END;

               "Sales Code Type"::Delegate:
                 BEGIN
                 Cust.GET("Sales Code Type");
                 Name:=Cust.Name;
                 END;

               "Sales Code Type"::"Board Member":
               BEGIN
               Cust.GET("Sales Code Type");
               Name:=Cust.Name;
               END;
               END;
                */

                /*HREmp.RESET;
                IF  THEN BEGIN
                HREmp."First Name":="Salesperson Name";
                
                END;*/
                // HREmp.Reset;
                // HREmp.SetRange(HREmp."No.", "Sales Code");
                // if HREmp.Find('-') then begin
                //     "Salesperson Name" := HREmp."Full Name";
                // end;

            end;
        }
        field(68113; "Salesperson Name"; Code[50])
        {
            Caption = 'Business Loan Officer Name';
        }
        field(68114; "Group Account No"; Code[50])
        {
            TableRelation = Customer."No." where("Customer Posting Group" = const('MICRO'));

            trigger OnValidate()
            begin
                "Group Account Name" := '';
                MemberAppl.Reset;
                if MemberAppl.Get("Group Account No") then begin
                    if MemberAppl."Group Account" = true then
                        "Group Account Name" := MemberAppl.Name;
                    "Recruited By" := MemberAppl."Recruited By";
                    "Salesperson Name" := MemberAppl."Loan Officer Name";
                end;

                /*
                GenSetUp.GET;
                 IF "Group Account No" = '5000' THEN BEGIN
                  "Monthly Contribution":=GenSetUp."Business Min. Shares";
                 END;
                 */
                /*
                MemberAppl.SETRANGE(MemberAppl."Group Account No","BOSA Account No.");
                MemberAppl.SETRANGE(MemberAppl."Group Account",TRUE);
                IF MemberAppl.FIND('-') THEN BEGIN
                "Group Account Name":=MemberAppl.Name;
                END
                */

            end;
        }
        field(68116; "Group Account Name"; Code[50])
        {
        }
        field(68117; "BOSA Account No."; Code[30])
        {
            TableRelation = Customer where("Customer Posting Group" = const('MEMBER'));

            trigger OnValidate()
            begin
                GenSetUp.Get();

                CustMember.Reset;
                CustMember.SetRange(CustMember."No.", "BOSA Account No.");
                if CustMember.Find('-') then
                    CustMember.TestField(CustMember."FOSA Account");
                //CustMember.TESTFIELD(CustMember."Member Category");
                //CustMember.TESTFIELD(CustMember."ID No.");
                //CustMember.TESTFIELD(CustMember."Date of Birth");
                CustMember.TestField(CustMember."Global Dimension 2 Code");

                if CustMember.Status <> CustMember.Status::Active then begin
                    Error(Text0024, CustMember.Status);
                end;


                Name := CustMember.Name;
                "Payroll/Staff No" := CustMember."Payroll/Staff No";
                "ID No." := CustMember."ID No.";
                "FOSA Account No." := CustMember."FOSA Account";
                "Account Category" := CustMember."Account Category";
                "Postal Code" := CustMember."Post Code";
                "Phone No." := CustMember."Phone No.";
                "Employer Code" := CustMember."Employer Code";
                "Date of Birth" := CustMember."Date of Birth";
                "Mobile Phone No" := CustMember."Mobile Phone No";
                "Phone No." := CustMember."Phone No.";
                "Marital Status" := CustMember."Marital Status";
                Gender := CustMember.Gender;
                "E-Mail (Personal)" := CustMember."E-Mail";
                "Global Dimension 2 Code" := CustMember."Global Dimension 2 Code";
                //"Member Category":=CustMember."Member Category";
                "Bank Code" := CustMember."Bank Code";
                //"Bank Name":=CustMember."Bank Branch Code";
                "Bank Account No" := CustMember."Bank Account No.";

                /*IF "Business Loan Appl Type"="Business Loan Appl Type"::Individual THEN BEGIN
                "Monthly Contribution":=GenSetUp."Bus.Loans Group Appl Amount";
                END ELSE
                "Monthly Contribution":=GenSetUp."Min. Contribution Bus Loan";
                */
                /*
                GetMemberCust.RESET;
                GetMemberCust.SETRANGE(GetMemberCust."ID No.","ID No.");
                IF GetMemberCust.FINDFIRST THEN BEGIN
                ERROR(Text0023,GetMemberCust."No.");
                END;
                
                CustContributions.RESET;
                CustContributions.SETRANGE(CustContributions."No.","BOSA Account No.");
                IF CustContributions.FIND('-') THEN
                REPEAT
                IF CustContributions.Type=CustContributions.Type::"Deposit Contribution" THEN BEGIN
                "Monthly Contribution":=CustContributions.Amount;
                END;
                UNTIL CustContributions.NEXT=0;
                */

                CustMember.Reset;
                CustMember.SetRange(CustMember."No.", "BOSA Account No.");
                if CustMember.Find('-') then begin
                    "Customer Posting Group" := 'MICRO';
                    "Global Dimension 1 Code" := 'MICRO';
                    Modify;
                end;

            end;
        }
        field(68118; "FOSA Account No."; Code[30])
        {
        }
        field(68119; "Micro Group Code"; Code[50])
        {
        }
        field(68120; Source; Option)
        {
            Editable = false;
            OptionCaption = 'Bosa,Business Loans';
            OptionMembers = Bosa,Micro;
        }
        field(68121; "User ID"; Code[40])
        {

            trigger OnValidate()
            begin
                "User ID" := UserId;
            end;
        }
        field(68123; "AutoFill Agency Details"; Boolean)
        {
        }
        field(68122; "AutoFill Mobile Details"; Boolean)
        {
        }
        field(69193; "Individual Category"; Text[40])
        {
            Description = 'What is the customer category?';
            TableRelation = "Customer Risk Rating"."Sub Category" where(Category = filter(Individuals));
            ValidateTableRelation = false;
        }
        field(69192; "Member Residency Status"; Text[20])
        {
            Description = 'What is the customer''s residency status?';
            TableRelation = "Customer Risk Rating"."Sub Category" where(Category = filter("Residency Status"));
            ValidateTableRelation = false;
        }
        field(69194; Entities; Text[30])
        {
            Description = 'What is the Entity Type?';
            TableRelation = "Customer Risk Rating"."Sub Category" where(Category = filter(Entities));
            ValidateTableRelation = false;
        }
        field(69195; "Industry Type"; Text[30])
        {
            Description = 'What Is the Industry Type?';
            TableRelation = "Customer Risk Rating"."Sub Category" where(Category = filter(Industry));
            ValidateTableRelation = false;
        }
        field(69196; "Length Of Relationship"; Text[30])
        {
            Description = 'What Is the Lenght Of the Relationship';
            TableRelation = "Customer Risk Rating"."Sub Category" where(Category = filter("Length Of Relationship"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(69197; "International Trade"; Text[30])
        {
            Description = 'Is the customer involved in International Trade?';
            TableRelation = "Customer Risk Rating"."Sub Category" where(Category = filter("International Trade"));

            ValidateTableRelation = false;
        }
        field(69198; "Electronic Payment"; Text[30])
        {
            Description = 'Does the customer engage in electronic payments?';
            TableRelation = "Product Risk Rating"."Product Type Code" where("Product Category" = filter("Electronic Payment"));
            ValidateTableRelation = false;
        }
        field(69199; "Accounts Type Taken"; Text[40])
        {
            Description = 'Which account type is the customer taking?';
            TableRelation = "Product Risk Rating"."Product Type Code" where("Product Category" = filter(Accounts));
            ValidateTableRelation = false;
        }
        field(69200; "Cards Type Taken"; Text[20])
        {
            Description = 'Which card is the customer taking?';
            TableRelation = "Product Risk Rating"."Product Type Code" where("Product Category" = filter(Cards));
            ValidateTableRelation = false;
        }
        field(69201; "Others(Channels)"; Text[50])
        {
            Description = 'Which products or channels is the customer taking?';
            TableRelation = "Product Risk Rating"."Product Type Code" where("Product Category" = filter(Others));
            ValidateTableRelation = false;
        }
        field(69206; "Member Risk Level"; Option)
        {
            OptionCaption = 'Low Risk,Medium Risk,High Risk';
            OptionMembers = "Low Risk","Medium Risk","High Risk";
        }
        field(69207; "Due Diligence Measure"; Text[50])
        {
        }
        field(69208; "Referee Member No"; Code[20])
        {

        }
        field(69209; IPRS; Code[20])
        {

        }
        field(69210; "First Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(69211; "Second Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(69212; "Last Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(69213; "Bank Branch"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(69214; "Official Designation"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(69215; "Date Employed"; Date)
        {

        }
        field(69216; Nationality; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Kenyan,"Non-Kenyan";
        }
        field(69217; "Guardian No."; Code[50])
        {
            TableRelation = Customer."No.";
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Cust.Reset;
                Cust.SetRange(Cust."No.", "Guardian No.");
                if Cust.Find('-') then begin
                    "Guardian Name" := Cust.Name;
                end;
            end;
        }
        field(69218; "Guardian Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(69219; "Client Computer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(69220; "Share Of Ownership One"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(69221; "Source of Income Member One"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(69222; "Source of IncomeMember Two"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(69223; JointRelationship; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(69224; "Reasontocreatingajointaccount"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(69225; "Birth Certficate No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(69226; "Share Of Ownership Two"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(69227; "Nature of Business"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; Name, Address, "Phone No.")
        {
        }
        key(Key4; Name)
        {
        }
        key(Key5; "Phone No.")
        {
        }
        key(Key6; "Global Dimension 2 Code")
        {
        }
        key(Key7; "Global Dimension 1 Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, "Phone No.", "Global Dimension 2 Code", "Global Dimension 1 Code")
        {
        }
    }

    trigger OnDelete()
    var
        CampaignTargetGr: Record "Campaign Target Group";
        ContactBusRel: Record "Contact Business Relation";
        Job: Record Job;
        CampaignTargetGrMgmt: Codeunit "Campaign Target Group Mgt";
        StdCustSalesCode: Record "Standard Customer Sales Code";
    begin
        if (Status = Status::Approved) or (Status = Status::Rejected) then
            Message('You cannot DELETE an application');
    end;

    trigger OnInsert()
    var
        Activesesion: record "Active Session";
    begin

        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Member Application Nos");
            NoSeriesMgt.InitSeries(SalesSetup."Member Application Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        // if ("Account Category" = "account category"::Group) then begin
        //     "Customer Posting Group" := 'MICRO';
        //     "Global Dimension 1 Code" := 'MICRO';
        // end else
        "Customer Posting Group" := 'MEMBER';
        "Global Dimension 1 Code" := 'BOSA';

        "Registration Date" := Today;
        "User ID" := UpperCase(UserId);
        Activesesion.Reset();
        Activesesion.SetRange(Activesesion."User ID", "User ID");
        if Activesesion.FindLast() then begin
            "Client Computer Name" := Activesesion."Client Computer Name";
        end;



    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        Text000: label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.';
        Text002: label 'Do you wish to create a contact for %1 %2?';
        SalesSetup: Record "Sacco No. Series";
        Text003: label 'Contact %1 %2 is not related to customer %3 %4.';
        Text004: label 'post';
        Text005: label 'create';
        Text006: label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        Text007: label 'You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.';
        Text008: label 'Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?';
        Text009: label 'Cannot delete customer.';
        Text010: label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.';
        Text011: label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
        Text012: label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
        Text013: label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';
        Text014: label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text015: label 'You cannot delete %1 %2 because there is at least one %3 associated to this customer.';
        GenSetUp: Record "Sacco General Set-Up";
        MinShares: Decimal;
        MovementTracker: Record "Movement Tracker";
        Cust: Record Customer;
        Vend: Record Vendor;
        CustFosa: Code[20];
        Vend2: Record Vendor;
        FOSAAccount: Record Vendor;
        StatusPermissions: Record "Status Change Permision";
        RefundsR: Record Refunds;
        Text016: label 'You cannot change the contents of the %1 field because this %2 has one or more posted ledger entries.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PostCode: Record "Post Code";
        User: Record User;
        Employer: Record "Sacco Employers";
        Dates: Codeunit "Dates Calculation";
        DAge: DateFormula;
        // HREmp: Record "HR Employee";
        CustMember: Record Customer;
        Text0024: label 'This Member Status is %1, Therefore not eligible for enrollment';
        MemberAppl: Record Customer;
}

