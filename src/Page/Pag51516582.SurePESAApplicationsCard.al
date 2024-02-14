#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516582 "SurePESA Applications Card"
{
    PageType = Card;
    SourceTable = "SurePESA Applications";

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
                field("Account No"; "Account No")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    trigger OnValidate()
                    var
                        SurepesaMembers: record "SurePESA Applications";
                    begin
                        //...............................................
                        SurepesaMembers.Reset();
                        SurepesaMembers.SetRange(SurepesaMembers."Account No", "Account No");
                        if SurepesaMembers.Find('-') then begin
                            error('Member is already registered !')
                        end;
                        //...............................................
                        "Created By" := UserId;
                        "Time Applied" := Time;
                        "Date Applied" := Today;
                    end;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    Editable = false;
                }
                field(Telephone; Telephone)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID No"; "ID No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Date Applied"; "Date Applied")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Applied"; "Time Applied")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
            }
        }
        area(factboxes)
        {
            part(Control1000000004; "FOSA Statistics FactBox")
            {
                SubPageLink = "No." = field("Account No");
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
            action(reload)
            {
                caption = 'Send Application';
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }

        }


    }



}

