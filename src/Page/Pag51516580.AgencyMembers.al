#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516580 "Agency Members"
{
    ApplicationArea = Basic;
    CardPageID = "Agency Member app Card";
    PageType = List;
    SourceTable = "Agency Members App";
    SourceTableView = sorting("No.") order(descending);
    Editable = false;
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
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
                field(SentToServer; SentToServer)
                {
                    ApplicationArea = Basic;
                }
                field("Time Applied"; "Time Applied")
                {
                    ApplicationArea = Basic;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = Basic;
                }
                field(Sent; Sent)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }

                field("Bosa Number"; "Bosa Number")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Refresh)
            {

                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Refresh;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }


}

