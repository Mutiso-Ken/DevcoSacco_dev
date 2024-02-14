Page 51516203 "CEEP Change Request Card"
{
    PageType = Card;
    SourceTable = "CEEP Change Request";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; No)
                {
                    ApplicationArea = Basic;
                }
                field(Type; Type)
                {
                    ApplicationArea = Basic;
                    Editable = TypeEditable;

                    trigger OnValidate()
                    begin

                    end;
                }
                field("Micro Finance Change Type"; "Micro Finance Change Type")
                {
                    ApplicationArea = Basic;
                    Editable = AccountNoEditable;
                    Caption = 'Change Type';
                    trigger OnValidate()
                    var
                    begin
                        if "Micro Finance Change Type" = "Micro Finance Change Type"::"CEEP Member" then begin
                            ChoosenCEEPMember := true;
                            ChoosenCEEPGroup := false;
                            ChoosenCEEPSignatories := false;
                            ChoosenSgnatory := false;
                        end else
                            if "Micro Finance Change Type" = "Micro Finance Change Type"::"CEEP Group" then begin
                                ChoosenCEEPMember := false;
                                ChoosenCEEPGroup := true;
                                ChoosenCEEPSignatories := false;
                                ChoosenSgnatory := false;
                            end else
                                if "Micro Finance Change Type" = "Micro Finance Change Type"::" " then begin
                                    ChoosenCEEPMember := false;
                                    ChoosenCEEPGroup := false;
                                    ChoosenCEEPSignatories := false;
                                    ChoosenSgnatory := false;
                                end else
                                    if "Micro Finance Change Type" = "Micro Finance Change Type"::Signatories then begin
                                        ChoosenCEEPMember := false;
                                        ChoosenCEEPGroup := false;
                                        ChoosenCEEPSignatories := false;
                                        ChoosenSgnatory := true;
                                    end;
                    end;
                }
                field("Captured by"; "Captured by")
                {
                    ApplicationArea = Basic;
                }
                field("Capture Date"; "Capture Date")
                {
                    ApplicationArea = Basic;
                }
                field("Approved by"; "Approved by")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reason for change"; "Reason for change")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = TypeEditable;
                }
            }
            group(Category)
            {
                Caption = '  ';
                group(CEEPGroup)
                {
                    Visible = ChoosenCEEPGroup;
                    Caption = 'CEEP Group Details';
                    field("CEEP Group No"; "CEEP Group No")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Group Name"; "CEEP Group Name")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Group Officer"; "CEEP Group Officer")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Group Officer(New)"; "CEEP Group Officer(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        trigger OnValidate()
                        var
                        begin

                        end;
                    }
                    field("CEEP Group Officer Name(New)"; "CEEP Group Officer Name(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin

                        end;
                    }
                    field("CEEP Certificate"; "CEEP Certificate")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin

                        end;
                    }
                    field("CEEP Certificate(New)"; "CEEP Certificate(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        trigger OnValidate()
                        var
                        begin

                        end;
                    }
                    field("CEEP Branch"; "CEEP Branch")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin

                        end;
                    }
                    field("CEEP Branch(New)"; "CEEP Branch(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        trigger OnValidate()
                        var
                        begin

                        end;
                    }
                }
                //................................Ceep Member Details
                group(CEEPMember)
                {
                    Visible = ChoosenCEEPMember;
                    Caption = 'CEEP Member Details';
                    field("CEEP Member No"; "CEEP Member No")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Member Name"; "CEEP Member Name")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Member Name(New)"; "CEEP Member Name(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        Caption = 'New Member Name';
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Member Group Account"; "CEEP Member Group Account")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }

                    field("CEEP Member Group Name"; "CEEP Member Group Name")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Member Group Account(New)"; "CEEP Member Group Account(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }

                    field("CEEP Member Group Name(New)"; "CEEP Member Group Name(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Member ID"; "CEEP Member ID")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Member ID(New)"; "CEEP Member ID(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        Caption = 'New ID No';
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Member Phone No"; "CEEP Member Phone No")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                    field("CEEP Member Phone No(New)"; "CEEP Member Phone No(New)")
                    {
                        ApplicationArea = Basic;
                        Editable = TypeEditable;
                        trigger OnValidate()
                        var
                        begin
                        end;
                    }
                }
                group(GroupAccount)
                {
                    Visible = ChoosenSgnatory;
                    Caption = 'Account Number Details';
                    field("Group Accounts No"; "Group Accounts No")
                    {
                        Editable = TypeEditable;

                    }
                    field("Group Accounts Name"; "Group Accounts Name")
                    {
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Changes")
            {
                ApplicationArea = Basic;
                Caption = 'Update Changes';
                Image = UserInterface;
                Promoted = true;
                Enabled = NotOpen;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    if (Status <> Status::Approved) then begin
                        Error('Change Request Must be Approved First');
                    end;
                    If Confirm('Are you sure you want to Update Member Details ?', false) = false then begin
                        exit;
                    end else begin
                        FnUpdateMemberDetails();
                    end;

                    Message('Changes have been updated Successfully');
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Enabled = TypeEditable;

                trigger OnAction()
                var
                    SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
                begin

                    if Status <> Status::Open then
                        Error('Status MUST be open');
                    TestField("Reason for change");
                    if Confirm('Send Approval Request?', false) = false then begin
                        exit;
                    end else begin
                        SrestepApprovalsCodeUnit.SendCEEPChangeRequestForApproval(rec.No, Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel A&pproval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                Enabled = CancelApproval;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    text001: label 'This batch is already pending approval';
                    ApprovalMgt: Codeunit "Approvals Mgmt.";
                begin
                    if Confirm('Cancel Approval Request?', false) = true then begin
                        SrestepApprovalsCodeUnit.CancelceepChangeRequestRequestForApproval(rec.No, Rec);
                    end;
                end;
            }
            action("Current Account Signatories")
            {
                ApplicationArea = Basic;
                Caption = 'Current Signatories';
                Image = Relationship;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Member Account Signatory list";
                RunPageLink = "Account No" = field("Group Accounts No");
                Enabled = ChoosenSgnatory;
            }
            action("New Account Signatories")
            {
                ApplicationArea = Basic;
                Caption = 'New Signatories';
                Image = Relationship;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Change Req Signatory list";
                RunPageLink = "Document No" = field(No);
                Enabled = ChoosenSgnatory;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControl();
    end;

    trigger OnOpenPage()
    begin
        UpdateControl();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := type::"Microfinance Change";
    end;

    var
        vend: Record Vendor;
        NotOpen: Boolean;
        Memb: Record Customer;
        MobileVisible: Boolean;
        AtmVisible: Boolean;
        AccountVisible: Boolean;
        ProductNxK: Record "FOSA Account NOK Details";
        cloudRequest: Record "Change Request";
        nxkinvisible: Boolean;
        GenSetUp: Record "Sacco General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        NameEditable: Boolean;
        PictureEditable: Boolean;
        SignatureEditable: Boolean;
        AddressEditable: Boolean;
        CityEditable: Boolean;
        EmailEditable: Boolean;
        PersonalNoEditable: Boolean;
        IDNoEditable: Boolean;
        ChoosenCEEPMember: Boolean;
        ChoosenCEEPGroup: Boolean;
        ChoosenCEEPSignatories: Boolean;
        PosInSaccoEditable: Boolean;
        MembPayTypeEditable: Boolean;
        MaritalStatusEditable: Boolean;
        PassPortNoEditbale: Boolean;
        AccountTypeEditible: Boolean;
        SectionEditable: Boolean;
        DialogBox: Dialog;
        CardNoEditable: Boolean;
        HomeAddressEditable: Boolean;
        LocationEditable: Boolean;
        SubLocationEditable: Boolean;
        DistrictEditable: Boolean;
        MemberStatusEditable: Boolean;
        ReasonForChangeEditable: Boolean;
        SigningInstructionEditable: Boolean;
        MonthlyContributionEditable: Boolean;
        MemberCellEditable: Boolean;
        ATMApproveEditable: Boolean;
        CardExpiryDateEditable: Boolean;
        CardValidFromEditable: Boolean;
        CardValidToEditable: Boolean;
        ATMNOEditable: Boolean;
        IsMicroFinanceChoosen: Boolean;
        ATMIssuedEditable: Boolean;
        ATMSelfPickedEditable: Boolean;
        ATMCollectorNameEditable: Boolean;
        ATMCollectorIDEditable: Boolean;
        MicroFinanceChangeType: Boolean;
        ATMCollectorMobileEditable: Boolean;
        ResponsibilityCentreEditable: Boolean;
        MobileNoEditable: Boolean;
        CancelApproval: Boolean;
        SMobileNoEditable: Boolean;
        TypeEditable: Boolean;
        AccountNoEditable: Boolean;
        AccountCategoryEditable: Boolean;
        ReactivationFeeEditable: Boolean;
        loans: Record "Loans Register";
        RetirementDateEditable: Boolean;
        BATCH_TEMPLATE: Code[30];
        BATCH_NAME: Code[30];
        DOCUMENT_NO: code[50];
        SFactory: Codeunit "SURESTEP Factory";
        ChoosenSgnatory: Boolean;
        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;


    local procedure UpdateControl()
    begin
        if Status = Status::Open then begin
            NameEditable := true;
            NotOpen := false;
            CancelApproval := false;
            PictureEditable := true;
            SignatureEditable := true;
            AddressEditable := true;
            CityEditable := true;
            EmailEditable := true;
            PersonalNoEditable := true;
            IDNoEditable := true;
            MembPayTypeEditable := true;
            PosInSaccoEditable := true;
            MaritalStatusEditable := true;
            PassPortNoEditbale := true;
            AccountTypeEditible := true;
            EmailEditable := true;
            SectionEditable := true;
            CardNoEditable := true;
            HomeAddressEditable := true;
            LocationEditable := true;
            SubLocationEditable := true;
            DistrictEditable := true;
            MemberStatusEditable := true;
            ReasonForChangeEditable := true;
            SigningInstructionEditable := true;
            MonthlyContributionEditable := true;
            MemberCellEditable := true;
            ATMApproveEditable := true;
            CardExpiryDateEditable := true;
            CardValidFromEditable := true;
            CardValidToEditable := true;
            ATMNOEditable := true;
            ATMIssuedEditable := true;
            ATMSelfPickedEditable := true;
            ATMCollectorNameEditable := true;
            ATMCollectorIDEditable := true;
            ATMCollectorMobileEditable := true;
            ResponsibilityCentreEditable := true;
            MobileNoEditable := true;
            SMobileNoEditable := true;
            AccountNoEditable := true;
            ReactivationFeeEditable := true;
            TypeEditable := true;
            AccountCategoryEditable := true
        end else
            if Status = Status::Pending then begin
                NameEditable := false;
                NotOpen := false;
                CancelApproval := true;
                PictureEditable := false;
                SignatureEditable := false;
                AddressEditable := false;
                CityEditable := false;
                EmailEditable := false;
                PersonalNoEditable := false;
                IDNoEditable := false;
                PosInSaccoEditable := false;
                MembPayTypeEditable := false;
                MaritalStatusEditable := false;
                PassPortNoEditbale := false;
                AccountTypeEditible := false;
                EmailEditable := false;
                SectionEditable := false;
                CardNoEditable := false;
                HomeAddressEditable := false;
                LocationEditable := false;
                SubLocationEditable := false;
                DistrictEditable := false;
                MemberStatusEditable := false;
                ReasonForChangeEditable := false;
                SigningInstructionEditable := false;
                MonthlyContributionEditable := false;
                MemberCellEditable := false;
                ATMApproveEditable := false;
                CardExpiryDateEditable := false;
                CardValidFromEditable := false;
                CardValidToEditable := false;
                ATMNOEditable := false;
                ATMIssuedEditable := false;
                ATMSelfPickedEditable := false;
                ATMCollectorNameEditable := false;
                ATMCollectorIDEditable := false;
                ATMCollectorMobileEditable := false;
                ResponsibilityCentreEditable := false;
                MobileNoEditable := false;
                SMobileNoEditable := false;
                AccountNoEditable := false;
                TypeEditable := false;
                ReactivationFeeEditable := false;
                AccountCategoryEditable := false
            end else
                if Status = Status::Approved then begin
                    NameEditable := false;
                    NotOpen := true;
                    CancelApproval := false;
                    PictureEditable := false;
                    SignatureEditable := false;
                    AddressEditable := false;
                    CityEditable := false;
                    EmailEditable := false;
                    PersonalNoEditable := false;
                    IDNoEditable := false;
                    PosInSaccoEditable := false;
                    MembPayTypeEditable := false;
                    MaritalStatusEditable := false;
                    PassPortNoEditbale := false;
                    AccountTypeEditible := false;
                    EmailEditable := false;
                    SectionEditable := false;
                    CardNoEditable := false;
                    HomeAddressEditable := false;
                    LocationEditable := false;
                    SubLocationEditable := false;
                    DistrictEditable := false;
                    MemberStatusEditable := false;
                    ReasonForChangeEditable := false;
                    SigningInstructionEditable := false;
                    MonthlyContributionEditable := false;
                    MemberCellEditable := false;
                    ATMApproveEditable := false;
                    CardExpiryDateEditable := false;
                    CardValidFromEditable := false;
                    CardValidToEditable := false;
                    ATMNOEditable := false;
                    ATMIssuedEditable := false;
                    ATMSelfPickedEditable := false;
                    ATMCollectorNameEditable := false;
                    ATMCollectorIDEditable := false;
                    ATMCollectorMobileEditable := false;
                    ResponsibilityCentreEditable := false;
                    MobileNoEditable := false;
                    SMobileNoEditable := false;
                    AccountNoEditable := false;
                    ReactivationFeeEditable := false;
                    TypeEditable := false;
                    AccountCategoryEditable := false
                end;
        if "Micro Finance Change Type" = "Micro Finance Change Type"::"CEEP Member" then begin
            ChoosenCEEPMember := true;
            ChoosenCEEPGroup := false;
            ChoosenCEEPSignatories := false;
            ChoosenSgnatory := false;
        end else
            if "Micro Finance Change Type" = "Micro Finance Change Type"::"CEEP Group" then begin
                ChoosenCEEPMember := false;
                ChoosenCEEPGroup := true;
                ChoosenCEEPSignatories := false;
                ChoosenSgnatory := false;
            end else
                if "Micro Finance Change Type" = "Micro Finance Change Type"::Signatories then begin
                    ChoosenCEEPMember := false;
                    ChoosenCEEPGroup := false;
                    ChoosenCEEPSignatories := true;
                    ChoosenSgnatory := true;
                end else
                    if "Micro Finance Change Type" = "Micro Finance Change Type"::" " then begin
                        ChoosenCEEPMember := false;
                        ChoosenCEEPGroup := false;
                        ChoosenCEEPSignatories := false;
                        ChoosenSgnatory := false;
                    end;
    end;

    local procedure FnUpdateMemberDetails()
    var
        CustomerTable: Record customer;
        LoansReg: Record "Loans Register";
        PreviousAccountSignatories: record "Member Account Signatories";
        NewAccountSignatories: Record "Change Request New Signatories";
    begin
        if Type = type::"Microfinance Change" then begin
            if "Micro Finance Change Type" = "Micro Finance Change Type"::"CEEP Member" then begin
                CustomerTable.reset;
                CustomerTable.SetRange(CustomerTable."No.", "CEEP Member No");
                if CustomerTable.find('-') then begin
                    if "CEEP Member Name(New)" <> '' then begin
                        CustomerTable.Name := "CEEP Member Name(New)";
                    end;
                    if "CEEP Member Phone No(New)" <> '' then begin
                        CustomerTable."Phone No." := "CEEP Member Phone No(New)";
                        CustomerTable."Mobile Phone No" := "CEEP Member Phone No(New)";
                        CustomerTable."MPESA Mobile No" := "CEEP Member Phone No(New)";
                        CustomerTable."Mobile Phone No." := "CEEP Member Phone No(New)";

                    end;
                    if "CEEP Member ID(New)" <> '' then begin
                        CustomerTable."ID No." := "CEEP Member ID(New)";
                        LoansReg.Reset();
                        LoansReg.SetRange(LoansReg."Client Code", "CEEP Member No");
                        LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
                        if LoansReg.Find('-') then begin
                            repeat
                                if (LoansReg."Outstanding Balance" <> 0) or (LoansReg."Oustanding Interest" <> 0) then begin
                                    LoansReg."ID NO" := "CEEP Member ID(New)";
                                end;
                                LoansReg.Modify();
                            until LoansReg.Next = 0;
                        end;
                    end;
                    if "CEEP Member Group Account(New)" <> '' then begin
                        // CustomerTable."Group Account No" := "CEEP Member Group Account(New)";
                        CustomerTable."Group Account Name" := "CEEP Member Group Name(New)";
                        LoansReg.Reset();
                        LoansReg.SetRange(LoansReg."Client Code", "CEEP Member No");
                        LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
                        if LoansReg.Find('-') then begin
                            repeat
                                if (LoansReg."Outstanding Balance" <> 0) or (LoansReg."Oustanding Interest" <> 0) then begin
                                    LoansReg."Group Account" := "CEEP Member Group Account(New)";
                                    LoansReg."Group Name" := "CEEP Member Group Name(New)";
                                    LoansReg."Group Code" := "CEEP Member Group Account(New)";
                                end;
                                LoansReg.Modify();
                            until LoansReg.Next = 0;
                        end;
                    end;
                    CustomerTable.Modify(true);
                    Status := Status::Closed;
                    Rec.Modify();
                    CurrPage.Close();
                    exit;
                end;

            end else
                if "Micro Finance Change Type" = "Micro Finance Change Type"::"CEEP Group" then begin
                    CustomerTable.reset;
                    CustomerTable.SetRange(CustomerTable."No.", "CEEP Group No");
                    IF CustomerTable.Find('-') THEN begin
                        IF "CEEP Group Officer(New)" <> '' THEN begin
                            CustomerTable."Loan Officer Name" := "CEEP Group Officer Name(New)";
                            LoansReg.Reset();
                            LoansReg.SetRange(LoansReg."Group Account", "CEEP Group No");
                            LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
                            if LoansReg.Find('-') then begin
                                repeat
                                    if (LoansReg."Outstanding Balance" <> 0) or (LoansReg."Oustanding Interest" <> 0) then begin
                                        DialogBox.open('Updating Group officer Details for the group in the loans register for ' + (LoansReg."Client Name"));
                                        LoansReg."Loan Officer" := "CEEP Group Officer Name(New)";
                                    end;
                                    LoansReg.Modify();
                                until LoansReg.Next = 0;
                                DialogBox.Close();
                            end;
                        end;
                        IF "CEEP Certificate(New)" <> '' then begin
                            CustomerTable."ID No." := "CEEP Certificate(New)";
                        end;
                        IF "CEEP Branch(New)" <> '' THEN begin
                            CustomerTable."Global Dimension 2 Code" := "CEEP Branch(New)";
                            LoansReg.Reset();
                            LoansReg.SetRange(LoansReg."Group Account", "CEEP Group No");
                            LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
                            if LoansReg.Find('-') then begin
                                repeat
                                    if (LoansReg."Outstanding Balance" <> 0) or (LoansReg."Oustanding Interest" <> 0) then begin
                                        DialogBox.open('Updating Branch Details for the in the loans register for ' + (LoansReg."Client Name"));
                                        LoansReg."Branch Code" := "CEEP Branch(New)";
                                    end;
                                    LoansReg.Modify();
                                until LoansReg.Next = 0;
                                DialogBox.close();
                            end;
                        end;
                        CustomerTable.Modify();
                        Status := Status::Closed;
                        Rec.Modify();
                        CurrPage.Close();
                        exit;
                    end;
                end else
                    if "Micro Finance Change Type" = "Micro Finance Change Type"::Signatories then begin
                        //.........................Ensure New Signatories List is Not empty

                        ///........................Delete previous signatories of the account
                        PreviousAccountSignatories.Reset();
                        PreviousAccountSignatories.SetRange(PreviousAccountSignatories."Account No", "Group Accounts No");
                        if PreviousAccountSignatories.Find('-') then begin
                            PreviousAccountSignatories.DeleteAll();
                        end;
                        //........................Insert New Signatories
                        NewAccountSignatories.Reset();
                        NewAccountSignatories.SetRange(NewAccountSignatories."Document No", No);
                        if NewAccountSignatories.Find('-') then begin
                            repeat
                                PreviousAccountSignatories.Init();
                                PreviousAccountSignatories."Account No" := "Group Accounts No";
                                PreviousAccountSignatories."ID No." := NewAccountSignatories."ID No.";
                                PreviousAccountSignatories.Names := NewAccountSignatories.Names;
                                PreviousAccountSignatories."Must be Present" := NewAccountSignatories."Must be Present";
                                PreviousAccountSignatories."Must Sign" := NewAccountSignatories."Must Sign";
                                PreviousAccountSignatories.Signatory := NewAccountSignatories.Signatory;
                                PreviousAccountSignatories."Email Address" := NewAccountSignatories."Email Address";
                                PreviousAccountSignatories."Mobile Number" := NewAccountSignatories."Mobile Number";
                                PreviousAccountSignatories.Insert(true);
                            until NewAccountSignatories.Next = 0;
                        end;
                    end;
            Status := Status::Closed;
            Rec.Modify();
            CurrPage.Close();
            exit;
        end;
    end;
}

