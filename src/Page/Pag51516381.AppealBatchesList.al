#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516381 "Appeal Batches - List"
{
    ApplicationArea = Basic;
    CardPageID = "Appeal batches Card";
    PageType = List;
    SourceTable = "Loan Disburesment-Batching";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000006)
            {
                field("Batch No.";"Batch No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Source;Source)
                {
                    ApplicationArea = Basic;
                }
                field("Description/Remarks";"Description/Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Mode Of Disbursement";"Mode Of Disbursement")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }
}

