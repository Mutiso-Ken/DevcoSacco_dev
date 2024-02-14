#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516913 "MC Group Holders-editable"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = Customer;
    SourceTableView = where("Customer Posting Group" = const('MICRO'),
                            "Group Account" = filter(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                }
                // field("Group Account No";"Group Account No")
                // {
                //     ApplicationArea = Basic;

                //     trigger OnValidate()
                //     begin
                //         FosaName:='';

                //         if "FOSA Account" <> '' then begin
                //         if Vend.Get("FOSA Account") then begin
                //         FosaName:=Vend.Name;
                //         end;
                //         end;
                //     end;
                // }
                field("Group Account"; "Group Account")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Micro Group Code"; "Micro Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Address; Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(City; City)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("ID No."; "ID No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Certificate No.';
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        StatusPermissions.Reset;
                        StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
                        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::Edit);
                        if StatusPermissions.Find('-') = false then
                            Error('You do not have permissions to change the account status.');
                    end;
                }
                field("Customer Type"; "Customer Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Debtors Type"; "Debtors Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Officer Name"; "Loan Officer Name")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                }
                field("Registration Date"; "Registration Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Personal Details")
            {
            }
            group(Communication)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup1000000004)
            {
                action("Group Members")
                {
                    ApplicationArea = Basic;
                    Image = Hierarchy;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "MC Individual Sub-List";
                    // RunPageLink = "Group Account No"=field("No.");
                }
                action("Account Signatories ")
                {
                    ApplicationArea = Basic;
                    Caption = 'Signatories';
                    Image = Group;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Member Account Signatory list";
                    RunPageLink = "Account No" = field("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FosaName := '';

        // if "FOSA Account" <> '' then begin
        // if Vend.Get("FOSA Account") then begin
        // FosaName:=Vend.Name;
        // end;
        // end;

        // lblIDVisible := true;
        // lblDOBVisible := true;
        // lblRegNoVisible := false;
        // lblRegDateVisible := false;
        // lblGenderVisible := true;
        // txtGenderVisible := true;
        // lblMaritalVisible := true;
        // txtMaritalVisible := true;

        // if "Account Category" <> "account category"::SINGLE then begin
        // lblIDVisible := false;
        // lblDOBVisible := false;
        // lblRegNoVisible := true;
        // lblRegDateVisible := true;
        // lblGenderVisible := false;
        // txtGenderVisible := false;
        // lblMaritalVisible := false;
        // txtMaritalVisible := false;

        // end;
        OnAfterGetCurrRec;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        RecordFound := Find(Which);
        CurrPage.Editable := RecordFound or (GetFilter("No.") = '');
        exit(RecordFound);
    end;

    trigger OnOpenPage()
    begin
        ActivateFields;

        StatusPermissions.Reset;
        StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::Edit);
        if StatusPermissions.Find('-') = false then
            Error('You do not have permissions to edit account information.');
    end;

    var
        StatusPermissions: Record "Status Change Permision";
        FosaName: Text;
        Vend: Record Vendor;
        [InDataSet]
        lblIDVisible: Boolean;
        [InDataSet]
        lblDOBVisible: Boolean;
        [InDataSet]
        lblRegNoVisible: Boolean;
        [InDataSet]
        lblRegDateVisible: Boolean;
        [InDataSet]
        lblGenderVisible: Boolean;
        [InDataSet]
        txtGenderVisible: Boolean;
        [InDataSet]
        lblMaritalVisible: Boolean;
        [InDataSet]
        txtMaritalVisible: Boolean;
        RecordFound: Boolean;

    local procedure ActivateFields()
    begin
    end;

    local procedure OnAfterGetCurrRec()
    begin
        xRec := Rec;
        ActivateFields;
    end;
}

