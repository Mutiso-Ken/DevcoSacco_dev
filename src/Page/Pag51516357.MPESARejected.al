#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516357 "MPESA Rejected"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    PageType = Card;
    SourceTable = "Change MPESA Transactions";
    SourceTableView = where(Status=const(Rejected));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Initiated By";"Initiated By")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Receipt No";"MPESA Receipt No")
                {
                    ApplicationArea = Basic;
                }
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                }
                field("New Account No";"New Account No")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Reasons for rejection";"Reasons for rejection")
                {
                    ApplicationArea = Basic;
                }
                field("Date Approved";"Date Approved")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Rejected';
                }
                field("Approved By";"Approved By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Rejected by';
                }
                field("Time Approved";"Time Approved")
                {
                    ApplicationArea = Basic;
                    Caption = 'Time Rejected';
                }
            }
        }
    }

    actions
    {
    }
}

