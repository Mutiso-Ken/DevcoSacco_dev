#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516479 "Loans Cue"
{

    PageType = CardPart;
    SourceTable = "loans Cuess";
    UsageCategory = Lists;
    ApplicationArea = Basic;

    layout
    {
        area(content)
        {
            cuegroup(Group1)
            {
                Caption = 'BOSA LOANS ';
                field("New Applied Loans"; "Applied Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }

                field("Active Loans"; "Active Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }
                field("Cleared Loans"; "Cleared Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }

                field("Pending Loans"; "Pending Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field("ASSET LOAN"; "ASSET LOAN")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field("COLLEGE LOAN"; "COLLEGE LOAN")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field(DEBOOSTER; DEBOOSTER)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field(EMERGENCY; EMERGENCY)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field(FURNITURE; FURNITURE)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field(HOUSEHOLD; HOUSEHOLD)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";

                }
                field(IPF; IPF)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field(KARIBU; KARIBU)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field(LIKIZO; LIKIZO)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field(MAKEOVER; MAKEOVER)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";

                }
                field(NORMAL; NORMAL)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field(PREMIUM; PREMIUM)
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }



            }

            // cuegroup(Group2)
            // {
            //     Caption = 'FOSA LOANS ';
            //     field("Applied Bosa Loans"; "Applied Fosa Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }
            //     field("Pending FOSA Loans"; "Pending Fosa Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }
            //     field("Approved FOSA Loans"; "Active FOSA Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }

            // }


            // cuegroup(Group3)
            // {
            //     Caption = 'MICRO LOANS ';
            //     field("Applied Micro Loans"; "Applied Micro Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }
            //     field("Pending Micro Loans"; "Pending Micro Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }
            //     field("Approved Micro Loans"; "Active Micro Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }

            // }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get("Primary Key") then begin
            Rec.Init;
            Rec."Primary Key" := "Primary Key";
            Rec.Insert;
        end;
    end;
}

