#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516042 "CloudPESA PIN Reset Card"
{
    Editable = false;
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;
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
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Style = StrongAccent;
                }
                field(Telephone; Telephone)
                {
                    ApplicationArea = Basic;
                    Editable = true;
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
                field("Last PIN Reset"; "Last PIN Reset")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reset By"; "Reset By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SentToServer; SentToServer)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Reset Pin")
            {
                ApplicationArea = Basic;
                Image = Answers;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F5';

                trigger OnAction()
                begin
                    if SentToServer = false then begin
                        Error('Pin reset has already been Requested');
                    end else begin

                        "Last PIN Reset" := CurrentDatetime;
                        "Reset By" := UserId;
                        SentToServer := false;

                        pinResetLogs.Reset;
                        pinResetLogs.Init;
                        pinResetLogs."Account Name" := "Account Name";
                        pinResetLogs.No := "No.";
                        pinResetLogs."ID No" := "ID No";
                        pinResetLogs."Account No" := "Account No";
                        pinResetLogs.Telephone := Telephone;
                        pinResetLogs.Date := CurrentDatetime;
                        pinResetLogs."Last PIN Reset" := CurrentDatetime;
                        pinResetLogs."Reset By" := UserId;

                        if pinResetLogs.Insert = true then
                            Message('Pin reset has been successfully been sent');

                    end;
                end;
            }
            action("PIN Reset Entries")
            {
                ApplicationArea = Basic;
                Image = CampaignEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "CloudPESA PIN Reset Logs";
                RunPageLink = No = field("No.");
                RunPageOnRec = false;
                RunPageView = sorting("Entry No")
                              order(descending);
            }

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

    trigger OnOpenPage()
    begin
        //ERROR('under maintenance');
    end;

    var
        cloudpesaapp: Record "SurePESA Applications";
        pinResetLogs: Record "CloudPESA Pin Reset Logs";
}

