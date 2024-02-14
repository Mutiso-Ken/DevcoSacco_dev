#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516924 "Interest Progression"
{
    PageType = List;
    SourceTable = "Interest Progression";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Gross Interest";"Gross Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Witholding Tax";"Witholding Tax")
                {
                    ApplicationArea = Basic;
                }
                field("Net Interest";"Net Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Qualifying Savings";"Qualifying Savings")
                {
                    ApplicationArea = Basic;
                }
                field("Account Balance";"Account Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified";"Last Date Modified")
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

