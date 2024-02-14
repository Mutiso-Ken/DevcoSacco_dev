#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516578 "SurePESA Applications"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "SurePESA Applications";
       SourceTableView= sorting("No.")order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {

                }
                field("Date Applied"; "Date Applied")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Account No"; "Account No")
                {
                    ApplicationArea = Basic;
                }

                field(Telephone; Telephone)
                {
                    ApplicationArea = Basic;
                }
                field("ID No"; "ID No")
                {
                    ApplicationArea = Basic;
                }


                field(SentToServer; SentToServer)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pin Reset"; "Pin Reset")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Reset By"; "Reset By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Last PIN Reset"; "Last PIN Reset")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Sent; Sent)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Created By"; "Created By")
                {

                }
                field("Time Applied"; "Time Applied")
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

