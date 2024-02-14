#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516221 "Membership Application Card"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Membership Applications";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field("Account Type"; "Account Category")
            {
                ApplicationArea = Basic;
                Caption = 'Account Type';
                // Enabled = membertypeEditable;
                ShowMandatory = true;
                ColumnSpan = 0;
                RowSpan = 0;

                Editable = TitleEditable;
                // Visible = false;

                trigger OnValidate()
                begin
                    UpdateControls();
                end;
            }
            group(General)
            {
                Caption = 'General';
                Visible = Individual;
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Title; Title)
                {
                    ApplicationArea = Basic;
                    Editable = TitleEditable;
                    ShowMandatory = true;
                }

                field("First Name"; "First Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin

                        Name := "First Name";
                    end;

                }

                field("Second Name"; "Second Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin
                        Name := "First Name" + ' ' + "Second Name";
                    end;

                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin
                        Name := "First Name" + ' ' + "Second Name" + ' ' + "Last Name";
                    end;

                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    ShowMandatory = true;
                }
                field("Registration No"; "Registration No")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;
                    Visible = false;

                }
                field(Address; Address)
                {
                    ApplicationArea = Basic;
                    Editable = AddressEditable;

                }
                field("Postal Code"; "Postal Code")
                {
                    ApplicationArea = Basic;
                    Editable = PostalCodeEditable;
                    Importance = Promoted;
                }
                field(Nationality; Nationality)
                {
                    ApplicationArea = Basic;
                    Editable = CityEditable;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        If Nationality = Nationality::Kenyan then
                            NationalRe := false
                        else
                            NationalRe := true;
                    end;
                }
                field(Town; Town)
                {
                    ApplicationArea = Basic;
                    Caption = 'Town';
                    Editable = CityEditable;
                }
                field(IPRS; IPRS)
                {
                    ApplicationArea = Basic;
                    Caption = 'IPRS';
                    Editable = CityEditable;
                }
                field("Mobile Phone No"; "Mobile Phone No")
                {
                    ApplicationArea = Basic;
                    Editable = PhoneEditable;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if StrLen("Mobile Phone No") <> 10 then
                            Error('Mobile No. Can not be more or less than 10 Characters');
                    end;
                }
                field("Mobile Phone No 2"; "Mobile No. 2")
                {
                    ApplicationArea = Basic;
                    Editable = PhoneEditable;

                    trigger OnValidate()
                    begin
                        if StrLen("Mobile No. 2") <> 10 then
                            Error('Mobile No. Can not be more or less than 15 Characters');
                    end;
                }

                field("ID No."; "ID No.")
                {
                    ApplicationArea = Basic;
                    Editable = IDNoEditable;
                    ShowMandatory = true;
                }
                field("Passport No."; "Passport No.")
                {
                    ApplicationArea = all;

                    Editable = IDNoEditable;
                }
                field("Date of Birth"; "Date of Birth")
                {
                    ApplicationArea = Basic;
                    Enabled = DOBEditable;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        DAge := Dates.DetermineAge("Date of Birth", Today);
                    end;
                }
                field(Age; DAge)
                {
                    ApplicationArea = Basic;
                    Editable = ageEditable;
                }
                field(Gender; Gender)
                {
                    Editable = GenderEditable;
                    ShowMandatory = true;
                }
                field("KRA Pin"; "KRA Pin")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    Editable = NameEditable;
                }
                field("Marital Status"; "Marital Status")
                {
                    ApplicationArea = Basic;
                    Editable = MaritalstatusEditable;
                }
                // field("Employer Code"; "Employer Code")
                // {
                //     ApplicationArea = Basic;
                //     Editable = EmployerCodeEditable;
                // }
                // field("Employer Name"; "Employer Name")
                // {
                //     ApplicationArea = Basic;
                //     Editable = false;
                // }
                // field("Payroll/Staff No"; "Payroll/Staff No")
                // {
                //     ApplicationArea = Basic;
                //     Editable = NameEditable;
                // }
                field("E-Mail (Personal)"; "E-Mail (Personal)")
                {
                    ApplicationArea = Basic;
                    Editable = EmailEdiatble;
                    ShowMandatory = false;
                }
                field("Recruited By"; "Recruited By")
                {
                    ApplicationArea = Basic;
                    Editable = RecruitedEditable;
                }
                field("Recruiter Name"; "Recruiter Name")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                }
                field(Location; Location)
                {
                    ApplicationArea = Basic;
                    Caption = 'Physical Location';
                    ShowMandatory = true;
                    Editable = NameEditable;
                }
                field("Received 1 Copy Of ID"; "Received 1 Copy Of ID")
                {
                    ApplicationArea = Basic;
                    Editable = CopyOFIDEditable;
                    ShowMandatory = true;
                }

                field("Copy of KRA Pin"; "Copy of KRA Pin")
                {
                    ApplicationArea = Basic;
                    Editable = CopyofKRAPinEditable;
                }
                field("AutoFill Mobile Details"; "AutoFill Mobile Details")
                {
                    ApplicationArea = Basic;
                    Editable = CopyofKRAPinEditable;
                    ShowMandatory = true;
                    Visible = false;
                }
                field("AutoFill Agency Details"; "AutoFill Agency Details")
                {
                    ApplicationArea = Basic;
                    Editable = CopyofKRAPinEditable;
                    ShowMandatory = true;
                    Visible = false;
                }
            }
            group(Junior)
            {
                Visible = Junior;
                field("JuniorNo."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field("JuniorFirst Name"; "First Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin

                        Name := "First Name";
                    end;

                }

                field("JuniorSecond Name"; "Second Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin
                        Name := "First Name" + ' ' + "Second Name";
                    end;

                }
                field("JuniorLast Name"; "Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin
                        Name := "First Name" + ' ' + "Second Name" + ' ' + "Last Name";
                    end;

                }
                field(JuniorName; Name)
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;
                    ShowMandatory = true;
                }
                field("Guardian No."; "Guardian No.")
                {
                    ApplicationArea = all;
                }
                field("Guardian Name"; "Guardian Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group("Member Two Details")
            {
                Caption = 'Member Two Details';
                Visible = Jooint;
                field("Member Title"; Title2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Title';
                    Editable = title2Editable;
                    ShowMandatory = true;
                }
                field("Member Name"; "First member name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    Editable = gender2editable;
                    ShowMandatory = true;
                }
                field("ID/Passport No"; "ID NO/Passport 2")
                {
                    ApplicationArea = Basic;
                    Editable = passpoetEditable;
                    ShowMandatory = true;
                }
                field("Member Gender"; Gender2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gender';
                    Editable = gender2editable;
                    ShowMandatory = true;
                }
                field("Marital Status2"; "Marital Status2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Marital Status';
                    Editable = MaritalstatusEditable;
                    ShowMandatory = true;
                }
                field("Date of Birth2"; "Date of Birth2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date of Birth';
                    Editable = gender2editable;
                    ShowMandatory = true;
                }
                field("Mobile No. 3"; "Mobile No. 3")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile No.';
                    Editable = mobile3editable;
                    ShowMandatory = true;
                }
                field("E-Mail (Personal2)"; "E-Mail (Personal2)")
                {
                    ApplicationArea = Basic;
                    Caption = 'E-Mail Adress';
                    Editable = emailaddresEditable;
                }
                field(Address3; Address3)
                {
                    ApplicationArea = Basic;
                    Caption = 'Physical Address';
                    Editable = address3Editable;
                }
                field("Home Postal Code2"; "Home Postal Code2")
                {
                    ApplicationArea = Basic;
                    Caption = ' Postal Code';
                    Editable = HomePostalCode2Editable;
                }
                field("Home Town2"; "Home Town2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Town';
                    Editable = town2Editable;
                }
                field("Payroll/Staff No2"; "Payroll/Staff No2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll/Staff No';
                    Editable = payrollno2editable;
                }
                field("Employer Code2"; "Employer Code2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer Code';
                }
                field("Employer Name2"; "Employer Name2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer Name';
                    Editable = Employername2Editable;
                }
            }
            group("Group Account Details")
            {
                Visible = groupAcc;
                field(GroupNo; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Group No.';
                }
                field(GroupName; Name)
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;
                    Caption = 'Group Name';
                    ShowMandatory = true;
                }
                field(GroupEmail; "E-Mail (Personal)")
                {
                    ApplicationArea = Basic;
                    Editable = EmailEdiatble;
                    caption = ' Group Email';
                    ShowMandatory = false;
                }
                field(GroupKRAPin; "KRA Pin")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    Editable = NameEditable;
                    Caption = 'Group KRA Pin';
                }
                field("Mobile Phone No Group"; "Mobile Phone No")
                {
                    ApplicationArea = Basic;
                    Editable = PhoneEditable;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if StrLen("Mobile Phone No") <> 10 then
                            Error('Mobile No. Can not be more or less than 10 Characters');
                    end;
                }
                field("Mobile Phone No 2 Group"; "Mobile No. 2")
                {
                    ApplicationArea = Basic;
                    Editable = PhoneEditable;

                    trigger OnValidate()
                    begin
                        if StrLen("Mobile No. 2") <> 10 then
                            Error('Mobile No. Can not be more or less than 15 Characters');
                    end;
                }
                field("Group Recruited By"; "Recruited By")
                {
                    ApplicationArea = Basic;
                    Editable = RecruitedEditable;
                }
                field("Group Recruiter Name"; "Recruiter Name")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                }


            }
            group("Bank Details")
            {

                field("Bank Code"; "Bank Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Name';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Bank Name"; "Bank Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bank Branch"; "Bank Branch")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account No"; "Bank Account No")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Employment Details")
            {
                field("Employer Code"; "Employer Code")
                {
                    ApplicationArea = Basic;
                    Editable = EmployerCodeEditable;
                }
                field("Employer Name"; "Employer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payroll/Staff No"; "Payroll/Staff No")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                }
                field(Department; Department)
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                }
                field("Office Branch"; "Office Branch")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                }
                field("Official Designation"; "Official Designation")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                }
                field("Date Employed"; "Date Employed")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                }
                field("Terms of Employment"; "Terms of Employment")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                }
            }


            group("Other Information")
            {
                Caption = 'Other Information';
                field("Monthly Contribution"; "Monthly Contribution")
                {
                    ApplicationArea = Basic;
                    Editable = MonthlyContributionEdit;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = StatusEditable;

                    trigger OnValidate()
                    begin
                        UpdateControls();
                    end;
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Editable = CustPostingGroupEdit;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = GlobalDim1Editable;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = GlobalDim2Editable;
                }
                field("Sms Notification"; "Sms Notification")
                {
                    ApplicationArea = Basic;
                }
                group("User Details")
                {
                    field("User ID"; "User ID")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                    field("Registration Date"; "Registration Date")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                    field("Client Computer Name"; "Client Computer Name")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                }
            }

            group("Member Risk Ratings")
            {
                group("Member Risk Rate")
                {
                    field("Individual Category"; "Individual Category")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                    field("Member Residency Status"; "Member Residency Status")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                    field(Entities; Entities)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Industry Type"; "Industry Type")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                    field("Length Of Relationship"; "Length Of Relationship")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                    field("International Trade"; "International Trade")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                }

                group("Product Risk Rating")
                {
                    field("Electronic Payment"; "Electronic Payment")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                    field("Accounts Type Taken"; "Accounts Type Taken")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                    field("Cards Type Taken"; "Cards Type Taken")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                    field("Others(Channels)"; "Others(Channels)")
                    {
                        ApplicationArea = Basic;
                        ShowMandatory = true;
                    }
                    field("Member Risk Level"; "Member Risk Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Risk Level';
                        Editable = false;
                        StyleExpr = CoveragePercentStyle;
                    }
                    field("Due Diligence Measure"; "Due Diligence Measure")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        StyleExpr = CoveragePercentStyle;
                    }
                }
                part(Control27; "Member Due Diligence Measure")
                {
                    Caption = 'Due Diligence Measure';
                    SubPageLink = "Member No" = field("No.");
                    SubPageView = sorting("Due Diligence No");
                }
            }
        }
        //factbox
        area(factboxes)
        {
            part(Control149; "Member Picture")
            {

                ApplicationArea = all;
                SubPageLink = "No." = FIELD("No.");
                Visible = true;

            }

            part(Control150; "Member Signature")
            {

                ApplicationArea = all;
                SubPageLink = "No." = FIELD("No.");
                Visible = true;
            }
        }

    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';
                action("Select Products")
                {
                    ApplicationArea = Basic;
                    Image = Accounts;
                    RunObject = page "Member Applied Products List";
                    RunPageLink = "Membership Applicaton No" = field("No.");
                    Enabled = true;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //on opening page,make sure that the accounts set as default are automatically filled in start
                        AccoutTypes.RESET;
                        AccoutTypes.SETRANGE(AccoutTypes."Default Account", TRUE);
                        IF AccoutTypes.Find('-') THEN BEGIN
                            REPEAT
                                IF AccoutTypes."Default Account" = TRUE THEN BEGIN
                                    ObjProductsApp.INIT;
                                    ObjProductsApp."Membership Applicaton No" := xRec."No.";
                                    ObjProductsApp."Applicant Name" := xRec.Name;
                                    ObjProductsApp."Applicant Age" := xRec.Age;
                                    ObjProductsApp."Applicant Gender" := xRec.Gender;
                                    ObjProductsApp."Applicant ID" := xRec."ID No.";
                                    ObjProductsApp."Product Code" := AccoutTypes.Code;
                                    ObjProductsApp."Product Name" := AccoutTypes.Description;
                                    ObjProductsApp."Product Category" := AccoutTypes."Activity Code";
                                    ObjProductsApp.INSERT;
                                    ObjProductsApp.VALIDATE(ObjProductsApp."Product Code");
                                    ObjProductsApp.MODIFY;
                                END;
                            UNTIL AccoutTypes.Next = 0;
                        END;
                        //on opening page,make sure that the accounts set as default are automatically filled in start


                    end;
                }
                action("Next of Kin")
                {
                    ApplicationArea = Basic;
                    Caption = 'Next of Kin';
                    Image = Relationship;
                    RunObject = Page "Membership App Kin Details";
                    RunPageLink = "Account No" = field("No.");
                }
                action("Account Signatories ")
                {
                    ApplicationArea = Basic;
                    Caption = 'Signatories';
                    Image = Group;
                    RunObject = Page "Membership App Signatories";
                    RunPageLink = "Account No" = field("No.");
                    Visible = groupAcc;

                }
                separator(Action6)
                {
                    Caption = '-';
                }

                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Enabled = (not OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND (not RecordApproved);

                    trigger OnAction()
                    var
                        Text001: label 'This request is already pending approval';
                    begin

                        if "ID No." <> '' then begin
                            Cust.Reset;
                            Cust.SetRange(Cust."ID No.", "ID No.");
                            Cust.SetRange(Cust."Customer Type", Cust."customer type"::Member);
                            if Cust.Find('-') then begin
                                if (Cust."No." <> "No.") and (Cust."Account Category" = Cust."account category"::Individual) then
                                    Error('Member has already been created. Kindly Confirm the ID Number to proceed.');
                            end;
                        end;

                        //*******************Check ID no.******************************
                        if ("ID No." = '') then
                            Error('You must specify ID No for the applicant');
                        //*******************Check ID no.******************************


                        if ("Account Category" = "account category"::Single) then begin
                            TestField(Name);
                            TestField("ID No.");
                            TestField("Mobile Phone No");
                            TestField(Picture);
                            TestField(Signature);
                            TestField(Gender);
                            TestField("Customer Posting Group");
                            TestField("Global Dimension 1 Code");
                            TestField("Global Dimension 2 Code");
                        end else

                            if ("Account Category" = "account category"::Group) or ("Account Category" = "account category"::Corporate) then begin
                                TestField(Name);
                                //TESTFIELD("Registration No");
                                //TESTFIELD("Copy of KRA Pin");
                                //TESTFIELD("Member Registration Fee Receiv");
                                ///TESTFIELD("Account Category");
                                TestField("Customer Posting Group");
                                TestField("Global Dimension 1 Code");
                                TestField("Global Dimension 2 Code");
                                //TESTFIELD("Copy of constitution");

                            end;

                        if ("Account Category" = "account category"::Single) or ("Account Category" = "account category"::Junior) or ("Account Category" = "account category"::Joint) then begin
                            NOkApp.Reset;
                            NOkApp.SetRange(NOkApp."Account No", "No.");
                            if NOkApp.Find('-') = false then begin
                                Error('Please Insert Next 0f kin Information');
                            end;
                        end;

                        if ("Account Category" = "account category"::Group) or ("Account Category" = "account category"::Corporate) then begin
                            AccountSignApp.Reset;
                            AccountSignApp.SetRange(AccountSignApp."Account No", "No.");
                            if AccountSignApp.Find('-') = false then begin
                                Error('Please insert Account Signatories');
                            end;
                        end;




                        if Status <> Status::Open then
                            Error(Text001);

                        //.................................
                        SrestepApprovalsCodeUnit.SendMembershipApplicationsRequestForApproval(rec."No.", Rec);
                        //.................................

                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Enabled = CanCancelApprovalForRecord;


                    trigger OnAction()
                    var
                    // Approvalmgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Confirm('Cancel Approval?', false) = true then begin
                            SrestepApprovalsCodeUnit.CancelMembershipApplicationsRequestForApproval(rec."No.", Rec);

                        end;
                    end;
                }
                separator(Action2)
                {
                    Caption = '       -';
                }
                action("Create Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Account';
                    Image = Customer;
                    Visible = true;
                    Enabled = CreateAccount;

                    trigger OnAction()
                    var
                        dialogBox: Dialog;
                    begin
                        if Status <> Status::Approved then
                            Error('This application has not been approved');
                        ///.................
                        if ("ID No." = '') and ("Account Category" <> "Account Category"::Junior) then begin
                            Error('ID No is Mandatory');
                        end;

                        if "Global Dimension 2 Code" = '' then begin

                            Error('Branch Code is Mandatory');

                        end;
                        Cust.Reset;
                        Cust.SetRange(Cust."ID No.", "ID No.");
                        Cust.SetRange(Cust."Customer Type", Cust."customer type"::Member);
                        if Cust.Find('-') then begin
                            if (Cust."No." <> "No.") and (Cust."Account Category" = Cust."account category"::Individual) then
                                Error('Member has already been created');
                        end;
                        if Confirm('Are you sure you want to create account application?', false) = false then begin
                            Message('Aborted');
                            exit;
                        end ELSE begin
                            dialogBox.Open('Creating New BOSA Account for applicant ' + Format(MembApp.Name));
                            FnCreateBOSAMemberAccounts();
                            dialogBox.Close();


                            GenSetUp.Get;
                            if GenSetUp."Auto Open FOSA Savings Acc." = true then begin
                                dialogBox.Open('Creating New BOSA Account for applicant ' + Format(MembApp.Name));
                                FnCreateFOSAMemberAccounts();
                                dialogBox.Close();
                            end;

                            dialogBox.Open('Registering Next Of Kin for ' + Format(MembApp.Name));
                            FnCreateNextOfKinDetails();
                            dialogBox.Close();

                            dialogBox.Open('Registering Account Signatories for ' + Format(MembApp.Name));
                            FnCreateAccountSignatories();
                            dialogBox.Close();

                            if rec."AutoFill Mobile Details" = true then begin
                                dialogBox.Open('Autofilling Mobile Application for ' + Format(MembApp.Name));
                                FnAutoCreateMobileApplication();
                                dialogBox.close();
                            end;
                            if rec."AutoFill Agency Details" = true then begin
                                dialogBox.Open('Autofilling Agency Application for ' + Format(MembApp.Name));
                                FnAutoCreateAgencyApplication();
                                dialogBox.close();
                            end;
                            //...............................Close The Card
                            //-----Send Email
                            FnSendMemberWelcomeEmailWithAttachment();
                            //-----Send SMS
                            FnSendSMSOnAccountOpening();
                            //-----
                            Message('Account created successfully.');
                            Message('The Member Sacco no is %1', Cust."No.");
                            Message('The Member FOSA Account no is %1', AcctNo);

                            //...............................modify the status of the application to closed
                            rec.Status := Status::Closed;
                            rec.Modify(true);
                            //.............................................................................
                        end;

                    end;
                }
                separator(Action3)
                {
                    Caption = '       -';
                }
                action("Member Risk Rating")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Member Risk Rating';
                    Image = Reconcile;
                    RunObject = Page "Individual Member Risk Rating";
                    RunPageLink = "Membership Application No" = field("No.");

                    trigger OnAction()
                    VAR
                        SFactory: Codeunit "SURESTEP Factory";
                    begin
                        SFactory.FnGetMemberApplicationAMLRiskRating("No.");
                    end;
                }


            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Select Products_Promoted"; "Select Products")
                {
                }
                actionref("Next of Kin_Promoted"; "Next of Kin")
                {
                }
                actionref("Account Signatories _Promoted"; "Account Signatories ")
                {
                }
                actionref("Create Account_Promoted"; "Create Account")
                {
                }
                actionref(MemberRiskRating_Promoted; "Member Risk Rating")
                {
                }
                actionref("Send Approval Request_Promoted"; "Send Approval Request")
                {
                }
                actionref("Cancel Approval Request_Promoted"; "Cancel Approval Request")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';


            }
            group(Category_Category5)
            {
                Caption = 'Budgetary Control', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category7_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Category10_caption', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControls();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RestrictInsert: ErrorInfo;
    begin
        "Responsibility Centre" := UserMgt.GetSalesFilter;
        //rec.Reset();
        // Rec.SetRange(rec.Status, Rec.Status::Open);
        // Rec.SetRange(Rec."User ID", UserId);
        // Rec.SetFilter(Rec.Name, '');
        // if rec.Find('-') then begin
        //     if Rec.Count > 3 then begin
        //         Error('Please use the unfinished Member Numbers' +
        //         'Use can Edit or First finish the open applications');
        //         //RestrictInsert.Message:=StrSubstNo('Use can Edit or First finish the open applications');

        //     end;
        // end;
    end;

    trigger OnOpenPage()
    var
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Centre", UserMgt.GetSalesFilter);
            FilterGroup(0);

        end;
        //Jooint := false;



    end;

    var
        Individual: Boolean;
        groupAcc: Boolean;
        Junior: Boolean;
        MemberAppliedProducts: Record "Membership Applied Products";
        ObjProductsApp: Record "Membership Applied Products";
        StatusPermissions: Record "Status Change Permision";
        Cust: Record Customer;
        Accounts: Record Vendor;
        AcctNo: Code[20];
        NextOfKinApp: Record "Member App Next Of kin";
        NextofKinFOSA: Record "Members Next Kin Details";
        AccountSign: Record "Member Account Signatories";
        AccountSignApp: Record "Member App Signatories";
        Acc: Record Vendor;
        UsersID: Record User;
        Nok: Record "Member App Next Of kin";
        NOKBOSA: Record "Members Next Kin Details";
        BOSAACC: Code[20];
        NextOfKin: Record "Members Next Kin Details";
        PictureExists: Boolean;
        text001: label 'Status must be open';
        UserMgt: Codeunit "User Setup Management";
        //Notification: Codeunit "SMTP Mail";
        NotificationE: Codeunit Mail;
        MailBody: Text[250];
        ccEmail: Text[1000];
        toEmail: Text[1000];
        GenSetUp: Record "Sacco General Set-Up";
        ClearingAcctNo: Code[20];
        AdvrAcctNo: Code[20];
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
        AccountTypes: Record "Account Types-Saving Products";
        DivAcctNo: Code[20];
        NameEditable: Boolean;
        AddressEditable: Boolean;
        NoEditable: Boolean;
        DioceseEditable: Boolean;
        HomeAdressEditable: Boolean;
        GlobalDim1Editable: Boolean;
        GlobalDim2Editable: Boolean;
        CustPostingGroupEdit: Boolean;
        PhoneEditable: Boolean;
        MaritalstatusEditable: Boolean;
        IDNoEditable: Boolean;
        RegistrationDateEdit: Boolean;
        OfficeBranchEditable: Boolean;
        DeptEditable: Boolean;
        SectionEditable: Boolean;
        OccupationEditable: Boolean;
        DesignationEdiatble: Boolean;
        EmployerCodeEditable: Boolean;
        DOBEditable: Boolean;
        EmailEdiatble: Boolean;
        StaffNoEditable: Boolean;
        GenderEditable: Boolean;
        MonthlyContributionEdit: Boolean;
        PostCodeEditable: Boolean;
        CityEditable: Boolean;
        WitnessEditable: Boolean;
        StatusEditable: Boolean;
        BankCodeEditable: Boolean;
        BranchCodeEditable: Boolean;
        BankAccountNoEditable: Boolean;
        VillageResidence: Boolean;
        SignatureExists: Boolean;
        NewMembNo: Code[30];
        Saccosetup: Record "Sacco No. Series";
        NOkApp: Record "Member App Next Of kin";
        TitleEditable: Boolean;
        PostalCodeEditable: Boolean;
        HomeAddressPostalCodeEditable: Boolean;
        HomeTownEditable: Boolean;
        RecruitedEditable: Boolean;
        ContactPEditable: Boolean;
        ContactPRelationEditable: Boolean;
        ContactPOccupationEditable: Boolean;
        CopyOFIDEditable: Boolean;
        CopyofPassportEditable: Boolean;
        SpecimenEditable: Boolean;
        ContactPPhoneEditable: Boolean;
        PictureEditable: Boolean;
        SignatureEditable: Boolean;
        PayslipEditable: Boolean;
        RegistrationFeeEditable: Boolean;
        CopyofKRAPinEditable: Boolean;
        membertypeEditable: Boolean;
        FistnameEditable: Boolean;
        dateofbirth2: Boolean;
        registrationeditable: Boolean;
        EstablishdateEditable: Boolean;
        RegistrationofficeEditable: Boolean;
        Signature2Editable: Boolean;
        Picture2Editable: Boolean;
        MembApp: Record "Membership Applications";
        title2Editable: Boolean;
        mobile3editable: Boolean;
        emailaddresEditable: Boolean;
        gender2editable: Boolean;
        postal2Editable: Boolean;
        town2Editable: Boolean;
        passpoetEditable: Boolean;
        maritalstatus2Editable: Boolean;
        payrollno2editable: Boolean;
        Employercode2Editable: Boolean;
        address3Editable: Boolean;
        HomePostalCode2Editable: Boolean;
        Employername2Editable: Boolean;
        ageEditable: Boolean;
        CopyofconstitutionEditable: Boolean;
        Table_id: Integer;
        Doc_No: Code[20];
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Account Opening";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        IncrementNo: Code[20];
        MpesaAppH: Record "MPESA Applications";
        MpesaAppD: Record "MPESA Application Details";
        MpesaAppNo: Code[20];
        ATMApp: Record "ATM Card Applications";
        MpesaMob: Boolean;
        MpesaCop: Boolean;
        CompInfo: Record "Company Information";
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
        SourceOfFunds: Boolean;
        RespCenter: Boolean;
        ShareCapContr: Boolean;
        AccoutTypes: Record "Account Types-Saving Products";
        Mtype: Boolean;
        TaxExemp: Boolean;
        AccountCategory: Boolean;
        DimensionValue: Record "Dimension Value";
        Dates: Codeunit "Dates Calculation";
        DAge: Text[100];
        NationalRe: Boolean;
        Jooint: Boolean;
        Vendor: Record Vendor;
        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
        OpenApprovalEntriesExist: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        RecordApproved: Boolean;
        CanCancelApprovalForRecord: Boolean;

        CreateAccount: Boolean;
        IEntry: integer;
        SMSToSend: Text[250];
        CoveragePercentStyle: Text;



    procedure UpdateControls()
    begin


        if "Account Category" = "account category"::Single then begin
            groupAcc := false;
            Individual := true;
            Junior := false;
            Jooint := false;
            NameEditable := true;
            AddressEditable := true;
            GlobalDim1Editable := false;
            GlobalDim2Editable := true;
            CustPostingGroupEdit := false;
            PhoneEditable := true;
            MaritalstatusEditable := true;
            IDNoEditable := true;
            PhoneEditable := true;
            RegistrationDateEdit := true;
            OfficeBranchEditable := true;
            DeptEditable := true;
            SectionEditable := true;
            OccupationEditable := true;
            DesignationEdiatble := true;
            EmployerCodeEditable := true;
            DOBEditable := true;
            EmailEdiatble := true;
            StaffNoEditable := true;
            GenderEditable := true;
            MonthlyContributionEdit := true;
            PostCodeEditable := true;
            CityEditable := true;
            WitnessEditable := true;
            BankCodeEditable := true;
            BranchCodeEditable := true;
            BankAccountNoEditable := true;
            VillageResidence := true;
            TitleEditable := true;
            PostalCodeEditable := true;
            HomeAddressPostalCodeEditable := true;
            HomeTownEditable := true;
            RecruitedEditable := true;
            ContactPEditable := true;
            ContactPRelationEditable := true;
            ContactPOccupationEditable := true;
            CopyOFIDEditable := true;
            CopyofPassportEditable := true;
            SpecimenEditable := true;
            ContactPPhoneEditable := true;
            HomeAdressEditable := true;
            PictureEditable := true;
            SignatureEditable := true;
            PayslipEditable := true;
            RegistrationFeeEditable := true;
            CopyofKRAPinEditable := true;
            membertypeEditable := true;
            FistnameEditable := true;
            registrationeditable := false;
            EstablishdateEditable := false;
            RegistrationofficeEditable := false;
            Picture2Editable := true;
            Signature2Editable := false;
            title2Editable := false;
            emailaddresEditable := false;
            gender2editable := false;
            HomePostalCode2Editable := false;
            town2Editable := false;
            passpoetEditable := false;
            maritalstatus2Editable := false;
            payrollno2editable := false;
            Employercode2Editable := false;
            address3Editable := false;
            Employername2Editable := false;
            ageEditable := false;
            CopyofconstitutionEditable := false;



        end else
            if "Account Category" = "account category"::Junior then begin
                groupAcc := false;
                Junior := true;
                Individual := true;
                Jooint := false;
            end
            else
                if "Account Category" = "account category"::Group then begin
                    Individual := false;
                    Jooint := false;
                    Junior := true;
                    groupAcc := true;
                    NameEditable := true;
                    AddressEditable := true;
                    GlobalDim1Editable := false;
                    GlobalDim2Editable := true;
                    CustPostingGroupEdit := false;
                    PhoneEditable := true;
                    MaritalstatusEditable := false;
                    IDNoEditable := false;
                    PhoneEditable := true;
                    RegistrationDateEdit := true;
                    OfficeBranchEditable := true;
                    DeptEditable := false;
                    SectionEditable := false;
                    OccupationEditable := false;
                    DesignationEdiatble := false;
                    EmployerCodeEditable := false;
                    DOBEditable := false;
                    EmailEdiatble := true;
                    StaffNoEditable := false;
                    GenderEditable := false;
                    MonthlyContributionEdit := true;
                    PostCodeEditable := true;
                    CityEditable := true;
                    WitnessEditable := true;
                    BankCodeEditable := true;
                    BranchCodeEditable := true;
                    BankAccountNoEditable := true;
                    VillageResidence := true;
                    TitleEditable := false;
                    PostalCodeEditable := true;
                    HomeAddressPostalCodeEditable := true;
                    HomeTownEditable := true;
                    RecruitedEditable := true;
                    ContactPEditable := true;
                    ContactPRelationEditable := true;
                    ContactPOccupationEditable := true;
                    CopyOFIDEditable := true;
                    CopyofPassportEditable := true;
                    SpecimenEditable := true;
                    ContactPPhoneEditable := true;
                    HomeAdressEditable := true;
                    PictureEditable := true;
                    SignatureEditable := false;
                    PayslipEditable := false;
                    RegistrationFeeEditable := true;
                    CopyofKRAPinEditable := true;
                    membertypeEditable := true;
                    registrationeditable := true;
                    EstablishdateEditable := true;
                    RegistrationofficeEditable := true;
                    Picture2Editable := false;
                    Signature2Editable := false;
                    FistnameEditable := false;
                    registrationeditable := true;
                    EstablishdateEditable := true;
                    RegistrationofficeEditable := true;
                    Picture2Editable := true;
                    Signature2Editable := false;
                    title2Editable := false;
                    emailaddresEditable := false;
                    gender2editable := false;
                    HomePostalCode2Editable := false;
                    town2Editable := false;
                    passpoetEditable := false;
                    maritalstatus2Editable := false;
                    payrollno2editable := false;
                    Employercode2Editable := false;
                    address3Editable := false;
                    Employername2Editable := false;
                    CopyofconstitutionEditable := true;



                end else
                    //Account types.
                    if "Account Category" = "account category"::Joint then begin
                        Individual := true;
                        groupAcc := false;
                        Junior := false;
                        Jooint := true;
                        NameEditable := true;
                        AddressEditable := true;
                        GlobalDim1Editable := false;
                        GlobalDim2Editable := true;
                        CustPostingGroupEdit := false;
                        PhoneEditable := true;
                        MaritalstatusEditable := true;
                        IDNoEditable := true;
                        PhoneEditable := true;
                        RegistrationDateEdit := true;
                        OfficeBranchEditable := true;
                        DeptEditable := true;
                        SectionEditable := true;
                        OccupationEditable := true;
                        DesignationEdiatble := true;
                        EmployerCodeEditable := true;
                        DOBEditable := true;
                        EmailEdiatble := true;
                        StaffNoEditable := true;
                        GenderEditable := true;
                        MonthlyContributionEdit := true;
                        PostCodeEditable := true;
                        CityEditable := true;
                        WitnessEditable := true;
                        BankCodeEditable := true;
                        BranchCodeEditable := true;
                        BankAccountNoEditable := true;
                        VillageResidence := true;
                        TitleEditable := false;
                        PostalCodeEditable := true;
                        HomeAddressPostalCodeEditable := true;
                        HomeTownEditable := true;
                        RecruitedEditable := true;
                        ContactPEditable := true;
                        ContactPRelationEditable := true;
                        ContactPOccupationEditable := true;
                        CopyOFIDEditable := true;
                        CopyofPassportEditable := true;
                        SpecimenEditable := true;
                        ContactPPhoneEditable := true;
                        HomeAdressEditable := true;
                        PictureEditable := true;
                        SignatureEditable := true;
                        PayslipEditable := true;
                        RegistrationFeeEditable := true;
                        CopyofKRAPinEditable := true;
                        membertypeEditable := true;
                        FistnameEditable := true;
                        registrationeditable := true;
                        EstablishdateEditable := true;
                        RegistrationofficeEditable := true;
                        Picture2Editable := true;
                        Signature2Editable := true;
                        registrationeditable := true;
                        EstablishdateEditable := true;
                        RegistrationofficeEditable := true;
                        Picture2Editable := true;
                        Signature2Editable := true;
                        title2Editable := true;
                        emailaddresEditable := true;
                        gender2editable := true;
                        HomePostalCode2Editable := true;
                        town2Editable := true;
                        passpoetEditable := true;
                        maritalstatus2Editable := true;
                        payrollno2editable := true;
                        Employercode2Editable := true;
                        address3Editable := true;
                        Employername2Editable := true;
                        mobile3editable := true;
                        CopyofconstitutionEditable := true;
                        IDNoEditable := true;
                        dateofbirth2 := true


                    end;
        //corporate account.
        if "Account Category" = "account category"::Corporate then begin
            Individual := false;
            groupAcc := true;
            Jooint := false;
            NameEditable := true;
            AddressEditable := true;
            GlobalDim1Editable := true;
            GlobalDim2Editable := true;
            CustPostingGroupEdit := false;
            PhoneEditable := true;
            MaritalstatusEditable := false;
            IDNoEditable := false;
            PhoneEditable := true;
            RegistrationDateEdit := true;
            OfficeBranchEditable := true;
            DeptEditable := false;
            SectionEditable := false;
            OccupationEditable := false;
            DesignationEdiatble := false;
            EmployerCodeEditable := false;
            DOBEditable := false;
            EmailEdiatble := true;
            StaffNoEditable := false;
            GenderEditable := false;
            MonthlyContributionEdit := true;
            PostCodeEditable := true;
            CityEditable := true;
            WitnessEditable := true;
            BankCodeEditable := true;
            BranchCodeEditable := true;
            BankAccountNoEditable := true;
            VillageResidence := true;
            TitleEditable := false;
            PostalCodeEditable := true;
            HomeAddressPostalCodeEditable := true;
            HomeTownEditable := true;
            RecruitedEditable := true;
            ContactPEditable := true;
            ContactPRelationEditable := true;
            ContactPOccupationEditable := true;
            CopyOFIDEditable := true;
            CopyofPassportEditable := true;
            SpecimenEditable := true;
            ContactPPhoneEditable := true;
            HomeAdressEditable := true;
            PictureEditable := true;
            SignatureEditable := false;
            PayslipEditable := false;
            RegistrationFeeEditable := true;
            CopyofKRAPinEditable := true;
            membertypeEditable := true;
            FistnameEditable := false;
            registrationeditable := true;
            EstablishdateEditable := true;
            RegistrationofficeEditable := true;
            Picture2Editable := false;
            Signature2Editable := false;
            title2Editable := false;
            emailaddresEditable := false;
            gender2editable := false;
            HomePostalCode2Editable := false;
            town2Editable := false;
            passpoetEditable := false;
            maritalstatus2Editable := false;
            payrollno2editable := false;
            Employercode2Editable := false;
            address3Editable := false;
            Employername2Editable := false;
            CopyofconstitutionEditable := true;
        end;

        if Status = Status::Approved then begin
            CreateAccount := false;
            CanCancelApprovalForRecord := false;
            NameEditable := false;
            NoEditable := false;
            AddressEditable := false;
            GlobalDim1Editable := false;
            GlobalDim2Editable := false;
            CustPostingGroupEdit := false;
            PhoneEditable := false;
            MaritalstatusEditable := false;
            IDNoEditable := false;
            PhoneEditable := false;
            RegistrationDateEdit := false;
            OfficeBranchEditable := false;
            DeptEditable := false;
            SectionEditable := false;
            OccupationEditable := false;
            DesignationEdiatble := false;
            EmployerCodeEditable := false;
            DOBEditable := false;
            EmailEdiatble := false;
            StaffNoEditable := false;
            GenderEditable := false;
            MonthlyContributionEdit := false;
            PostCodeEditable := false;
            CityEditable := false;
            WitnessEditable := false;
            BankCodeEditable := false;
            BranchCodeEditable := false;
            BankAccountNoEditable := false;
            VillageResidence := false;
            TitleEditable := false;
            PostalCodeEditable := false;
            HomeAddressPostalCodeEditable := false;
            HomeTownEditable := false;
            RecruitedEditable := false;
            ContactPEditable := false;
            ContactPRelationEditable := false;
            ContactPOccupationEditable := false;
            CopyOFIDEditable := false;
            CopyofPassportEditable := false;
            SpecimenEditable := false;
            ContactPPhoneEditable := false;
            HomeAdressEditable := false;
            PictureEditable := false;
            SignatureEditable := false;
            PayslipEditable := false;
            RegistrationFeeEditable := false;
            title2Editable := false;
            emailaddresEditable := false;
            gender2editable := false;
            HomePostalCode2Editable := false;
            town2Editable := false;
            passpoetEditable := false;
            maritalstatus2Editable := false;
            payrollno2editable := false;
            Employercode2Editable := false;
            address3Editable := false;
            Employername2Editable := false;
            ageEditable := false;
            CopyofconstitutionEditable := false;
            RecordApproved := true;
            CreateAccount := true;

        end;
        if Status = Status::Pending then begin
            CreateAccount := false;
            CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
            NameEditable := false;
            NoEditable := false;
            AddressEditable := false;
            GlobalDim1Editable := false;
            GlobalDim2Editable := false;
            CustPostingGroupEdit := false;
            PhoneEditable := false;
            MaritalstatusEditable := false;
            IDNoEditable := false;
            PhoneEditable := false;
            RegistrationDateEdit := false;
            OfficeBranchEditable := false;
            DeptEditable := false;
            SectionEditable := false;
            OccupationEditable := false;
            DesignationEdiatble := false;
            EmployerCodeEditable := false;
            DOBEditable := false;
            EmailEdiatble := false;
            StaffNoEditable := false;
            GenderEditable := false;
            MonthlyContributionEdit := false;
            PostCodeEditable := false;
            CityEditable := false;
            WitnessEditable := false;
            BankCodeEditable := false;
            BranchCodeEditable := false;
            BankAccountNoEditable := false;
            VillageResidence := false;
            TitleEditable := false;
            PostalCodeEditable := false;
            HomeAddressPostalCodeEditable := false;
            HomeTownEditable := false;
            RecruitedEditable := false;
            ContactPEditable := false;
            ContactPRelationEditable := false;
            ContactPOccupationEditable := false;
            CopyOFIDEditable := false;
            CopyofPassportEditable := false;
            SpecimenEditable := false;
            ContactPPhoneEditable := false;
            HomeAdressEditable := false;
            PictureEditable := false;
            SignatureEditable := false;
            PayslipEditable := false;
            RegistrationFeeEditable := false;
            title2Editable := false;
            emailaddresEditable := false;
            gender2editable := false;
            HomePostalCode2Editable := false;
            town2Editable := false;
            passpoetEditable := false;
            maritalstatus2Editable := false;
            payrollno2editable := false;
            Employercode2Editable := false;
            address3Editable := false;
            Employername2Editable := false;
            ageEditable := false;
            CopyofconstitutionEditable := false;



        end;


        if Status = Status::Open then begin
            CreateAccount := false;
            CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
            NameEditable := true;
            AddressEditable := true;
            GlobalDim1Editable := false;
            GlobalDim2Editable := true;
            CustPostingGroupEdit := false;
            PhoneEditable := true;
            MaritalstatusEditable := true;
            IDNoEditable := true;
            PhoneEditable := true;
            RegistrationDateEdit := true;
            OfficeBranchEditable := true;
            DeptEditable := true;
            SectionEditable := true;
            OccupationEditable := true;
            DesignationEdiatble := true;
            EmployerCodeEditable := true;
            DOBEditable := true;
            EmailEdiatble := true;
            StaffNoEditable := true;
            GenderEditable := true;
            MonthlyContributionEdit := true;
            PostCodeEditable := true;
            CityEditable := true;
            WitnessEditable := true;
            BankCodeEditable := true;
            BranchCodeEditable := true;
            BankAccountNoEditable := true;
            VillageResidence := true;
            TitleEditable := true;
            PostalCodeEditable := true;
            HomeAddressPostalCodeEditable := true;
            HomeTownEditable := true;
            RecruitedEditable := true;
            ContactPEditable := true;
            ContactPRelationEditable := true;
            ContactPOccupationEditable := true;
            CopyOFIDEditable := true;
            CopyofPassportEditable := true;
            SpecimenEditable := true;
            ContactPPhoneEditable := true;
            HomeAdressEditable := true;
            PictureEditable := true;
            SignatureEditable := true;
            PayslipEditable := true;
            RegistrationFeeEditable := true;
            title2Editable := true;
            emailaddresEditable := true;
            gender2editable := true;
            HomePostalCode2Editable := true;
            town2Editable := true;
            passpoetEditable := true;
            maritalstatus2Editable := true;
            payrollno2editable := true;
            Employercode2Editable := true;
            address3Editable := true;
            Employername2Editable := true;
            ageEditable := false;
            mobile3editable := true;
            CopyofconstitutionEditable := true;

        end;
    end;


    procedure SendSMS()
    begin
        CompInfo.Get();
        GenSetUp.Get();
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end else begin
            iEntryNo := 1;
        end;

        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := "No.";
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'MOBILETRAN';
        SMSMessages."Entered By" := UserId;
        SMSMessages."System Created Entry" := true;
        SMSMessages."Document No" := "No.";
        SMSMessages."Telephone No" := "Mobile Phone No";
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := 'Dear Member your account has been created successfully, your Account No is '
        + BOSAACC + '  Account Name ' + Name + ' .' + 'You can now Deposit Via PayBill 587649. Thank You For Choosing to Bank With Us';
        SMSMessages.Insert;

    end;


    procedure SendMail()
    begin

        GenSetUp.Get;

        if GenSetUp."Send Email Notifications" = true then begin

            // Notification.CreateMessage('Dynamics NAV',GenSetUp."Sender Address","E-Mail (Personal)",'Member Acceptance Notification',
            //                 'Member application '+ BOSAACC + ' has been approved'
            //                + ' (Dynamics NAV ERP)',false);

            // Notification.Send;

        end;
    end;

    local procedure FnCreateBOSAMemberAccounts()
    begin
        Saccosetup.Get();
        //NewMembNo := Saccosetup.BosaNumber;
        NewMembNo := Saccosetup."Last Memb No.";

        //Create BOSA account
        Cust."No." := Format(NewMembNo);
        Cust.Name := Name;
        Cust.Address := Address;
        Cust."Post Code" := "Postal Code";
        Cust.Pin := "KRA Pin";
        Cust.County := City;
        Cust."Phone No." := "Mobile Phone No";
        Cust."Global Dimension 1 Code" := "Global Dimension 1 Code";
        Cust."Global Dimension 2 Code" := "Global Dimension 2 Code";
        Cust."Customer Posting Group" := "Customer Posting Group";
        Cust."Registration Date" := Today;
        Cust."Mobile Phone No" := "Mobile Phone No";
        Cust.Status := Cust.Status::Active;
        Cust."Employer Code" := "Employer Code";
        Cust."Date of Birth" := "Date of Birth";
        Cust."Station/Department" := "Station/Department";
        Cust."E-Mail" := "E-Mail (Personal)";
        Cust.Location := Location;
        Cust.Title := Title;
        Cust."Home Address" := "Home Address";
        Cust."Home Postal Code" := "Home Postal Code";
        Cust."Home Town" := "Home Town";
        Cust."Recruited By" := "Recruited By";
        Cust."Contact Person" := "Contact Person";
        Cust."ContactPerson Relation" := "ContactPerson Relation";
        Cust."ContactPerson Occupation" := "ContactPerson Occupation";
        Cust."Account Category" := "Account Category";
        //---Junior Accounts
        Cust."Guardian No." := "Guardian No.";
        Cust."Guardian Name" := "Guardian Name";
        //**
        Cust."Office Branch" := "Office Branch";
        Cust.Department := Department;
        Cust.Occupation := Occupation;
        Cust.Designation := Designation;
        Cust."Bank Code" := "Bank Code";
        Cust."Bank Branch" := "Bank Name";
        Cust."Bank Account No." := "Bank Account No";
        //**
        Cust."Sub-Location" := "Sub-Location";
        Cust.District := District;
        Cust."Payroll/Staff No" := "Payroll/Staff No";
        Cust."ID No." := "ID No.";
        Cust."Mobile Phone No" := "Mobile Phone No";
        Cust."Marital Status" := "Marital Status";
        Cust."Customer Type" := Cust."customer type"::Member;
        Cust.Gender := Gender;
        Cust."Sms Notification" := "Sms Notification";

        Cust.Image := Picture;
        Cust.Signature := Signature;
        Cust.IPRS := IPRS;
        //========================================================================Member Risk Rating
        Cust."Individual Category" := "Individual Category";
        Cust.Entities := Entities;
        Cust."Member Risk Level" := ("Member Risk Level");
        Cust."Due Diligence Measure" := Format("Due Diligence Measure");
        Cust."Member Residency Status" := "Member Residency Status";
        Cust."Industry Type" := "Industry Type";
        Cust."Length Of Relationship" := "Length Of Relationship";
        Cust."International Trade" := "International Trade";
        Cust."Electronic Payment" := "Electronic Payment";
        Cust."Accounts Type Taken" := "Accounts Type Taken";
        Cust."Cards Type Taken" := "Cards Type Taken";
        //========================================================================
        Cust."Monthly Contribution" := "Monthly Contribution";
        Cust."Contact Person" := "Contact Person";
        Cust."Contact Person Phone" := "Contact Person Phone";
        Cust."ContactPerson Relation" := "ContactPerson Relation";
        Cust."Recruited By" := "Recruited By";
        Cust."ContactPerson Occupation" := "ContactPerson Occupation";
        Cust."Village/Residence" := "Village/Residence";
        Cust.Insert(true);

        Saccosetup."Last Memb No." := IncStr(NewMembNo);
        Saccosetup.Modify;
        BOSAACC := Cust."No.";

    end;

    local procedure FnCreateFOSAMemberAccounts()
    var

    begin
        IncrementNo := '';
        MemberAppliedProducts.Reset();
        MemberAppliedProducts.SetRange(MemberAppliedProducts."Membership Applicaton No", "No.");
        if MemberAppliedProducts.Find('-') then begin
            repeat
                if "Fosa Account No" = '' then begin
                    AcctNo := FnGetFosaAccountTypeNumber(MemberAppliedProducts."Product Code", MembApp."Global Dimension 2 Code", BOSAACC);
                    Accounts.Init;
                    Accounts."No." := AcctNo;
                    Accounts."Date of Birth" := "Date of Birth";
                    Accounts.Name := UpperCase(Name);
                    Accounts."Creditor Type" := Accounts."creditor type"::Account;
                    Accounts."Staff No" := "Payroll/Staff No";
                    Accounts."ID No." := "ID No.";
                    Accounts."Phone No." := "Mobile Phone No";
                    Accounts."MPESA Mobile No" := "Mobile Phone No";
                    Accounts."Registration Date" := "Registration Date";
                    Accounts."Post Code" := "Postal Code";
                    Accounts.County := City;
                    Accounts."BOSA Account No" := Cust."No.";
                    Accounts."Marital Status" := "Marital Status";
                    Accounts.Image := Picture;
                    Accounts.Signature := Signature;
                    Accounts."Passport No." := "Passport No.";
                    Accounts."Company Code" := "Employer Code";
                    Accounts.Status := Accounts.Status::New;
                    Accounts."Account Type" := MemberAppliedProducts."Product Code";
                    Accounts."Date of Birth" := "Date of Birth";
                    Accounts."Global Dimension 1 Code" := 'FOSA';
                    Accounts."Global Dimension 2 Code" := "Global Dimension 2 Code";
                    Accounts.Address := Address;
                    Accounts."Address 2" := "Address 2";
                    Accounts."Registration Date" := Today;
                    Accounts.Status := Accounts.Status::Active;
                    Accounts.Section := Section;
                    Accounts."Home Address" := "Home Address";
                    Accounts.District := District;
                    Accounts.Location := Location;
                    Accounts."Sub-Location" := "Sub-Location";
                    Accounts."Registration Date" := Today;
                    Accounts."Monthly Contribution" := "Monthly Contribution";
                    Accounts."E-Mail" := "E-Mail (Personal)";
                    Accounts."Vendor Posting Group" := FnGetPostingGroup(MemberAppliedProducts."Product Code");
                    Accounts.Insert;

                    //Update BOSA with FOSA Account
                    if Cust.Get(BOSAACC) then begin
                        Cust."FOSA Account" := AcctNo;
                        Cust.Modify;
                    end;
                end;
            until MemberAppliedProducts.Next = 0;
        end;


    end;

    local procedure FnGetFosaAccountTypeNumber(ProductCode: Code[40]; Dimension2: Code[10]; BOSAAC: code[40]): Code[20]
    var
        SavingsAccountTypes: Record "Account Types-Saving Products";
    begin
        SavingsAccountTypes.Reset();
        SavingsAccountTypes.SetRange(SavingsAccountTypes.Code, ProductCode);
        if SavingsAccountTypes.find('-') then begin
            exit(format(SavingsAccountTypes."Account No Prefix" + "Global Dimension 2 Code" + BOSAAC));
        end;
    end;

    local procedure FnGetPostingGroup(ProductCode: Code[40]): Code[20]
    var
        SavingsAccountTypes: Record "Account Types-Saving Products";
    begin
        SavingsAccountTypes.Reset();
        SavingsAccountTypes.SetRange(SavingsAccountTypes.Code, ProductCode);
        if SavingsAccountTypes.find('-') then begin
            exit(SavingsAccountTypes."Posting Group");
        end;
    end;

    local procedure FnCreateNextOfKinDetails()
    var
        NextofKinBOSA: Record "Members Next Kin Details";
    begin
        NextOfKinApp.Reset;
        NextOfKinApp.SetRange(NextOfKinApp."Account No", "No.");
        if NextOfKinApp.Find('-') then begin
            repeat
                //........................................FOSA
                // NextofKinFOSA.Init;
                // NextofKinFOSA."Account No" := AcctNo;
                // NextofKinFOSA.Name := NextOfKinApp.Name;
                // NextofKinFOSA.Relationship := NextOfKinApp.Relationship;
                // NextofKinFOSA.Beneficiary := NextOfKinApp.Beneficiary;
                // NextofKinFOSA."Date of Birth" := NextOfKinApp."Date of Birth";
                // NextofKinFOSA.Address := NextOfKinApp.Address;
                // NextofKinFOSA.Telephone := NextOfKinApp.Telephone;
                // NextofKinFOSA.Fax := NextOfKinApp.Fax;
                // NextofKinFOSA.Email := NextOfKinApp.Email;
                // NextofKinFOSA."ID No." := NextOfKinApp."ID No.";
                // NextofKinFOSA."%Allocation" := NextOfKinApp."%Allocation";
                // NextofKinFOSA.Type := NextOfKin.Type;
                // NextofKinFOSA.Insert;
                //......................................BOSA
                NextofKinBOSA.Init;
                NextofKinBOSA."Account No" := AcctNo;
                NextofKinBOSA.Name := NextOfKinApp.Name;
                NextofKinBOSA.Relationship := NextOfKinApp.Relationship;
                NextofKinBOSA.Beneficiary := NextOfKinApp.Beneficiary;
                NextofKinBOSA."Date of Birth" := NextOfKinApp."Date of Birth";
                NextofKinBOSA.Address := NextOfKinApp.Address;
                NextofKinBOSA.Telephone := NextOfKinApp.Telephone;
                NextofKinBOSA.Fax := NextOfKinApp.Fax;
                NextofKinBOSA.Email := NextOfKinApp.Email;
                NextofKinBOSA."ID No." := NextOfKinApp."ID No.";
                NextofKinBOSA."%Allocation" := NextOfKinApp."%Allocation";
                NextofKinBOSA.Type := NextOfKin.Type;
                NextofKinBOSA.Insert;

            until NextOfKinApp.Next = 0;
        end;
    end;

    local procedure FnCreateAccountSignatories()
    begin
        AccountSignApp.Reset;
        AccountSignApp.SetRange(AccountSignApp."Account No", "No.");
        if AccountSignApp.Find('-') then begin
            repeat
                AccountSign.Init;
                AccountSign."Account No" := AcctNo;
                AccountSign.Names := AccountSignApp.Names;
                AccountSign."Date Of Birth" := AccountSignApp."Date Of Birth";
                AccountSign."Staff/Payroll" := AccountSignApp."Staff/Payroll";
                AccountSign."ID No." := AccountSignApp."ID No.";
                AccountSign.Signatory := AccountSignApp.Signatory;
                AccountSign."Must Sign" := AccountSignApp."Must Sign";
                AccountSign."Must be Present" := AccountSignApp."Must be Present";
                AccountSign.Picture := AccountSignApp.Picture;
                AccountSign.Signature := AccountSignApp.Signature;
                AccountSign."Expiry Date" := AccountSignApp."Expiry Date";
                AccountSign."Mobile Number" := AccountSignApp."Mobile No";
            until AccountSignApp.Next = 0;
        end;
    end;

    local procedure FnAutoCreateATMApplication()
    begin
        if GenSetUp."Auto Fill Msacco Application" = true then begin
            MpesaAppH.Init;
            MpesaAppH.No := '';
            MpesaAppH."Date Entered" := Today;
            MpesaAppH."Time Entered" := Time;
            MpesaAppH."Entered By" := UserId;
            MpesaAppH."Document Serial No" := "ID No.";
            MpesaAppH."Document Date" := Today;
            MpesaAppH."Customer ID No" := "ID No.";
            MpesaAppH."Customer Name" := Name;
            MpesaAppH."MPESA Mobile No" := "Phone No.";
            MpesaAppH."App Status" := MpesaAppH."app status"::Pending;
            MpesaAppH.Insert(true);

            MpesaAppNo := MpesaAppH.No;
            MpesaAppD.Init;
            MpesaAppD."Application No" := MpesaAppNo;
            MpesaAppD."Account Type" := MpesaAppD."account type"::Vendor;
            MpesaAppD."Account No." := AcctNo;
            MpesaAppD.Description := Name;
            MpesaAppD.Insert;
        end;
    end;

    local procedure FnAutoCreateMobileApplication()
    var
        MobileApplications: Record "SurePESA Applications";
    begin
        MobileApplications.reset;
        MobileApplications.Init();
        MobileApplications."No." := FnGenerateNextNumberSeries();
        MobileApplications."Account No" := AcctNo;
        MobileApplications."Account Name" := rec.Name;
        MobileApplications.Telephone := rec."Phone No.";
        MobileApplications."ID No" := rec."ID No.";
        MobileApplications.Status := MobileApplications.Status::Application;
        MobileApplications."Date Applied" := Today;
        MobileApplications."Time Applied" := Time;
        MobileApplications."Created By" := UserId;
        MobileApplications.Sent := false;
        MobileApplications."No. Series" := 'SUREPESA';
        MobileApplications.Insert(true);

    end;

    local procedure FnGenerateNextNumberSeries(): Code[20]
    var
        SaccoNoSeries: Record "Sacco No. Series";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        SaccoNoSeries.Get();
        SaccoNoSeries.TestField(SaccoNoSeries."SurePESA Registration Nos");
        EXIT(NoSeriesManagement.GetNextNo(SaccoNoSeries."SurePESA Registration Nos", 0D, true));
        exit('Error generating No series of mobile applications');
    end;

    local procedure FnAutoCreateAgencyApplication()
    var
        AgencyTable: Record "Agency Members App";
    begin
        AgencyTable.Init();
        AgencyTable."Account No" := AcctNo;
        AgencyTable."Account Name" := Name;
        AgencyTable.Telephone := "Phone No.";
        AgencyTable."ID No" := "ID No.";
        AgencyTable.Status := AgencyTable.Status::Application;
        AgencyTable."Date Applied" := Today;
        AgencyTable."Time Applied" := Time;
        AgencyTable."Created By" := UserId;
        AgencyTable.Sent := false;
        AgencyTable."No. Series" := '';
        AgencyTable.SentToServer := false;
        AgencyTable.Insert(true);
    end;

    local procedure FnSendSMSOnAccountOpening()
    var
    begin
        SMSToSend := 'Dear Member your account has been created successfully, your Account No is '
        + BOSAACC + '  Account Name ' + Name + ' .' + 'You can now Deposit Via PayBill 587649. Thank You For Choosing to Bank With Us';
        IEntry := 0;
        SMSMessages.Reset();
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end else begin
            iEntryNo := 1;
        end;
        SMSMessages.Reset();
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Batch No" := '';
        SMSMessages."Document No" := 'MEMBERREGISTRATION';
        SMSMessages."Account No" := Cust."No.";
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'SYSTEM GENERATED';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::No;
        SMSMessages."SMS Message" := SMSToSend;
        SMSMessages."Telephone No" := "Phone No.";
        SMSMessages.Insert();
    end;

    trigger OnAfterGetRecord()
    begin
        //............................
        SetStyles();

        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(REC.RecordId);//Return No and allow sending of approval request.

        EnabledApprovalWorkflowsExist := true;
        //............................
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserMgt: Codeunit "User Management";
    begin
        //FnUpdateEditableControls();
    end;

    local procedure SetStyles()
    begin
        CoveragePercentStyle := 'Strong';
        if "Member Risk Level" <> "member risk level"::"Low Risk" then
            CoveragePercentStyle := 'Unfavorable';
        if "Member Risk Level" = "member risk level"::"Low Risk" then
            CoveragePercentStyle := 'Favorable';
    end;

    local procedure FnSendMemberWelcomeEmailWithAttachment()
    var
        MemberReg: Record Customer;
        LoansRegister: Record "Loans Register";
        SaccoGeneralSetup: Record "Sacco General Set-Up";
        //GeneralApplicationCodeUnit: Codeunit "General Application Codeunit";
        FileName: Text[200];
        FileName2: Text[200];
        FileType: Text[100];
        SendEmailTo: Text[100];
        EmailBody: Text[1000];
        EmailSubject: Text[100];
        membersreg: Record Customer;
        Outstr: OutStream;
        Instr: InStream;

        Outstr2: OutStream;
        Instr2: InStream;
        TempBlob: Codeunit "Temp Blob";

        MailToSend: Codeunit "Email Message";
        GenerateDoc: InStream;//Generate PDF/Document to be sent 
        EncodeStream: Codeunit "Base64 Convert";//To encode the stream of data form GenerateDoc
        FnEmail: Codeunit Email;
        DialogBox: Dialog;
    begin
        DialogBox.Open('Sending Member Welcome Email');
        //------------------->Get Key Details of Send Email
        SendEmailTo := '';
        SendEmailTo := "E-Mail (Personal)";//"E-Mail (Personal)"
        EmailSubject := '';
        EmailSubject := 'MEMBER ACCEPTANCE REPORT ';

        EmailBody := '';
        EmailBody := 'Dear ' + Format(Name) + '  We hope this email finds you well.Please find the attached';
        //------------------->Generate The Report Attachments To Send
        //---------Attachment 1
        FileName := Format("No.") + '-WelcomeLetter.pdf';
        TempBlob.CreateOutStream(Outstr);
        Report.SaveAs(Report::"Member Accceptance Letter", '', ReportFormat::Pdf, Outstr);
        TempBlob.CreateInStream(Instr);
        //REPORT.SAVEASPDF(REPORT::"Loan Appraisal Draft", SaccoGeneralSetup."Path To Email Attachments " + FileName);//Save A copy

        //------------------->Create Emails Start
        MailToSend.Create(SendEmailTo, EmailSubject, EmailBody);
        MailToSend.AddAttachment(FileName, FileType, Instr);
        FnEmail.Send(MailToSend, Enum::"Email Scenario"::Default);
        DialogBox.Close();
    end;


}

