#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516906 "MF Business Loans targets"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "MF Officer Loans Targets";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Target Type";"Target Type")
                {
                    ApplicationArea = Basic;
                }
                field(Year;Year)
                {
                    ApplicationArea = Basic;
                }
                field("Previous Year actual";"Previous Year actual")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(January;January)
                {
                    ApplicationArea = Basic;
                }
                field(February;February)
                {
                    ApplicationArea = Basic;
                }
                field(March;March)
                {
                    ApplicationArea = Basic;
                }
                field(April;April)
                {
                    ApplicationArea = Basic;
                }
                field(May;May)
                {
                    ApplicationArea = Basic;
                }
                field(June;June)
                {
                    ApplicationArea = Basic;
                }
                field(July;July)
                {
                    ApplicationArea = Basic;
                }
                field(August;August)
                {
                    ApplicationArea = Basic;
                }
                field(September;September)
                {
                    ApplicationArea = Basic;
                }
                field(October;October)
                {
                    ApplicationArea = Basic;
                }
                field(November;November)
                {
                    ApplicationArea = Basic;
                }
                field(December;December)
                {
                    ApplicationArea = Basic;
                }
                field(Totals;Totals)
                {
                    ApplicationArea = Basic;
                }
                field("Targets No. of Loans";"Targets No. of Loans")
                {
                    ApplicationArea = Basic;
                }
                field("Actuals No. of Loans";"Actuals No. of Loans")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(UserID;UserID)
                {
                    ApplicationArea = Basic;
                }
                field("Date Modified";"Date Modified")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup1000000024)
            {
                action("Import Business Loans targets")
                {
                    ApplicationArea = Basic;
                    Image = XMLFile;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = XMLport "Import BOSA Members";

                    trigger OnAction()
                    begin
                        ///fdfdfdfsfdfdd
                    end;
                }
            }
        }
    }
}

