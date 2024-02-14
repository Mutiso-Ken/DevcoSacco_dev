#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516348 "Mpesa Transactions List"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "MPESA Transactions";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(TelephoneNo;TelephoneNo)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Key Word";"Key Word")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Time";"Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted";"Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Time Posted";"Time Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Account Status";"Account Status")
                {
                    ApplicationArea = Basic;
                }
                field(Messages;Messages)
                {
                    ApplicationArea = Basic;
                }
                field("Needs Change";"Needs Change")
                {
                    ApplicationArea = Basic;
                }
                field("Change Transaction No";"Change Transaction No")
                {
                    ApplicationArea = Basic;
                }
                field("Old Account No";"Old Account No")
                {
                    ApplicationArea = Basic;
                }
                field(Changed;Changed)
                {
                    ApplicationArea = Basic;
                }
                field("Date Changed";"Date Changed")
                {
                    ApplicationArea = Basic;
                }
                field("Time Changed";"Time Changed")
                {
                    ApplicationArea = Basic;
                }
                field("Changed By";"Changed By")
                {
                    ApplicationArea = Basic;
                }
                field("Approved By";"Approved By")
                {
                    ApplicationArea = Basic;
                }
                field("Original Account No";"Original Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Account Balance";"Account Balance")
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

