#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516365 "Other Commitment Clearance"
{
    PageType = List;
    SourceTable = "Other Commitements Clearance";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field("Bankers Cheque No";"Bankers Cheque No")
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
            }
        }
    }

    actions
    {
    }
}

