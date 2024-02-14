#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516593 "Agency Member app Card"
{
    PageType = Card;
    SourceTable = "Agency Members App";

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
                        AgencyMembers: record "Agency Members App";
                    begin
                        //.....................Check If User Is Existing
                        AgencyMembers.Reset();
                        AgencyMembers.SetRange(AgencyMembers."Account No", "Account No");
                        if AgencyMembers.Find('-') then begin
                            Error('The member is already registered !');
                        end;
                        //............................
                        "Created By" := UserId;
                        "Time Applied" := time;
                        "Date Applied" := Today;
                    end;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
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
                    visible = false;
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
                field(SentToServer; SentToServer)
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
            action(sendapp)
            {

                Caption = 'Send Application';
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

