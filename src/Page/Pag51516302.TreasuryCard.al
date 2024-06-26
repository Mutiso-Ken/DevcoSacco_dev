#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516302 "Treasury Card"
{
    Caption = 'Treasury Card';
    Editable = True;
    PageType = Card;
    DeleteAllowed = False;
    SourceTable = "Bank Account";
    SourceTableView = where("Account Type" = filter(Treasury));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Address; Address)
                {
                    ApplicationArea = Basic;
                    Visible = false;

                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code/City';
                    visible = false;
                }
                field(City; City)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = Basic;
                }
                field(Control22; Balance)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Min. Balance"; "Min. Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Our Contact Code"; "Our Contact Code")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field(CashierID; CashierID)
                {
                    ApplicationArea = Basic;
                    Caption = 'User ID';
                }
                field("Maximum Teller Withholding"; "Maximum Teller Withholding")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Communication)
            {
                visible = false;
                Caption = 'Communication';
                field("Fax No."; "Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Home Page"; "Home Page")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Posting)

            {
                Caption = 'Posting';
                visible = false;
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Last Check No."; "Last Check No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transit No."; "Transit No.")
                {
                    ApplicationArea = Basic;
                }
                field("Last Statement No."; "Last Statement No.")
                {
                    ApplicationArea = Basic;
                }
                field("Balance Last Statement"; "Balance Last Statement")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Acc. Posting Group"; "Bank Acc. Posting Group")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                visible = false;
                field("SWIFT Code"; "SWIFT Code")
                {
                    ApplicationArea = Basic;
                }
                field(Iban; Iban)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Bank Acc.")
            {
                Caption = '&Bank Acc.';
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Bank Account Statistics";
                    RunPageLink = "No." = field("No."),
                                  "Date Filter" = field("Date Filter"),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const("Bank Account"),
                                  "No." = field("No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(270),
                                  "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Balance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance';
                    Image = Balance;
                    RunObject = Page "Bank Account Balance";
                    RunPageLink = "No." = field("No."),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                }
                action("St&atements")
                {
                    ApplicationArea = Basic;
                    Caption = 'St&atements';
                    RunObject = Page "Bank Account Statement";
                    RunPageLink = "Bank Account No." = field("No.");
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Bank Account Ledger Entries";
                    RunPageLink = "Bank Account No." = field("No.");
                    RunPageView = sorting("Bank Account No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Chec&k Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Chec&k Ledger Entries';
                    Image = CheckLedger;
                    RunObject = Page "Check Ledger Entries";
                    RunPageLink = "Bank Account No." = field("No.");
                    RunPageView = sorting("Bank Account No.");
                }
                action("C&ontact")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&ontact';

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Check Report Name");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Account Type" := "account type"::Treasury;
    end;

    var
        UsersID: Record User;
}

