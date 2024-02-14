#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516436 "Investor Group List"
{
    CardPageID = "Investor Group Card";
    PageType = List;
    SourceTable = "Investor Group Members";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID/Passport No";"ID/Passport No")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Mobile No.";"Mobile No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Card)
            {
                action("View Card")
                {
                    ApplicationArea = Basic;
                    Image = Card;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                           Page.Run(Page::"Investor Group Card",Rec);
                    end;
                }
            }
        }
    }
}

