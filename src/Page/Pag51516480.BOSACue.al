#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516480 "BOSA Cue"
{
    PageType = CardPart;
    SourceTable = "Members Cues";
    UsageCategory = Lists;
    ApplicationArea = Basic;

    layout
    {
        area(content)
        {
            cuegroup(Group1)


            {
                Caption = 'BOSA Member Accounts ';
                // CuegroupLayout = Wide;
                field("All Members"; "All Members")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Member List";
                    //AutoFormatExpression = '#,##0;(#,##0);#';
                }

                field("Active Members"; "Active Members")
                {

                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Member List";
                }

                field("NonActive Mbrs"; "NonActive Mbrs")
                {

                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Member List";
                }

            }


            // cuegroup("CEEP Members")

            // {
            //     Caption = 'CEEP Member Accounts ';
            //     field("All CEEP Mbrs"; "All CEEP Mbrs")
            //     {

            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //         DrillDownPageId = "Member List";
            //     }
            // field("Active CEEP Mbrs"; "Active CEEP Mbrs")
            // {

            //     ApplicationArea = Basic;
            //     Image = none;
            //     Style = Favorable;
            //     StyleExpr = true;
            //     DrillDownPageId = "Member List";
            // }

            // field("InActive CEEP Mbrs"; "Inactive CEEP Mbrs")
            // {

            //     ApplicationArea = Basic;
            //     Image = none;
            //     Style = Favorable;
            //     StyleExpr = true;
            //     DrillDownPageId = "Member List";
            // }

            // field("CEEP Groups"; "CEEP Groups")
            // {

            //     ApplicationArea = Basic;
            //     Image = none;
            //     Style = Favorable;
            //     StyleExpr = true;
            //     DrillDownPageId = "Member List";
            // }

        }

    }


    actions
    {
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get(UserId) then begin
            Rec.Init;
            Rec."User ID" := UserId;
            Rec.Insert;
        end;
    end;
}

