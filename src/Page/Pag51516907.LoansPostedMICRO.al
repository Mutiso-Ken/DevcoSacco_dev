#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516907 "Loans Posted-MICRO"
{
    ApplicationArea = Basic;
    CardPageID = "Loan Posted Card - MICRO";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    PageType = List;
    //PageType = ListPart;
    SourceTable = "Loans Register";
    SourceTableView = where(Posted = const(true),
                            Source = const(MICRO));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan  No."; "Loan  No.")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Date of Completion"; "Expected Date of Completion")
                {
                    ApplicationArea = Basic;
                }
                field("Client Code"; "Client Code")
                {
                    ApplicationArea = Basic;
                }
                field("Group Code"; "Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("BOSA No"; "BOSA No")
                {
                    ApplicationArea = Basic;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Installments; Installments)
                {
                    ApplicationArea = Basic;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Oustanding Interest"; "Oustanding Interest")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Batch No."; "Batch No.")
                {
                    ApplicationArea = Basic;
                }
                field(Interest; Interest)
                {
                    ApplicationArea = Basic;
                }
                field("Loan Status"; "Loan Status")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Schedule Installments"; "Schedule Installments")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Schedule Loan Amount Issued"; "Schedule Loan Amount Issued")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Scheduled Principle Payments"; "Scheduled Principle Payments")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Scheduled Interest Payments"; "Scheduled Interest Payments")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Principal Paid"; "Principal Paid")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Interest Paid"; "Interest Paid")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Last Pay Date"; "Last Pay Date")
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

