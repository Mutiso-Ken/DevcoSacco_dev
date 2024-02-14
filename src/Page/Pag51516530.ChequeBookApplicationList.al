#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516530 "Cheque Book Application List"
{
    ApplicationArea = Basic;
    CardPageID = "Cheque Application";
    Editable = false;
    PageType = List;
    SourceTable = "Cheque Book Application";
    SourceTableView = where("Cheque Book charges Posted" = filter(false));
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
                    Style = StrongAccent;
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
                }
                field("Cheque Register Generated"; "Cheque Register Generated")
                {

                }
                field("Cheque Book Type"; "Cheque Book Type")
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

