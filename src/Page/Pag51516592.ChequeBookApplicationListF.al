#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516592 "Cheque Book Application List F"
{
    ApplicationArea = Basic;
    CardPageID = postedchequebookcard;
    Editable = false;
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Cheque Book Application";
    SourceTableView = where("Cheque Book charges Posted" = const(true),
                            "Cheque Register Generated" = const(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                    style = StrongAccent;
                }
                field("ID No."; "ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Cheque Account No."; "Cheque Account No.")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Staff No."; "Staff No.")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Cheque Register Generated"; "Cheque Register Generated")
                {

                }
                field("Cheque Book charges Posted"; "Cheque Book charges Posted")
                {

                }
                field("Requested By"; "Requested By")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

