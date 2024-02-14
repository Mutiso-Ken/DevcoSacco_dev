#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516581 "SurePESA Appplications List"
{
    ApplicationArea = Basic;
    CardPageID = "SurePESA Applications Card";
    Editable = false;
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

                field("Created By"; "Created By")
                {
                    ApplicationArea = Basic;

                }
                field(Sent; Sent)
                {
                    ApplicationArea = Basic;
                }

                field("Time Applied"; "Time Applied")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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

