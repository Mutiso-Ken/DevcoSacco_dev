#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516584 "Agent Transactions"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Agent transaction";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;



    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = Basic;



                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Location"; "Transaction Location")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction By"; "Transaction By")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Agent Code"; "Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Date Posted"; "Date Posted")
                {
                    ApplicationArea = Basic;

                }
                field("Time Posted"; "Time Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Account Status"; "Account Status")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Messages; Messages)
                {
                    ApplicationArea = Basic;
                }
                field("Needs Change"; "Needs Change")
                {
                    ApplicationArea = Basic;
                }
                field("Old Account No"; "Old Account No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Changed; Changed)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Date Changed"; "Date Changed")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Time Changed"; "Time Changed")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Changed By"; "Changed By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Original Account No"; "Original Account No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Activity Code"; "Activity Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Global Dimension 1 Filter"; "Global Dimension 1 Filter")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Global Dimension 2 Filter"; "Global Dimension 2 Filter")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account No 2"; "Account No 2")
                {
                    ApplicationArea = Basic;
                }
                field(CCODE; CCODE)
                {
                    ApplicationArea = Basic;
                }

                field("Loan No"; "Loan No")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Telephone; Telephone)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Id No"; "Id No")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Member No"; "Member No")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(DeviceID; DeviceID)
                {
                    ApplicationArea = Basic;
                }

            }

        }
    }

    actions
    {

    }
    trigger OnOpenPage()
    begin
        SetCurrentKey("Transaction Date");
        Ascending(false);
    end;

}

