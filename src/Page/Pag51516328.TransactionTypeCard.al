#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516328 "Transaction Type Card"
{
    PageType = Card;
    SourceTable = "Transaction Types";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Has Schedule";"Has Schedule")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Category";"Transaction Category")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Span";"Transaction Span")
                {
                    ApplicationArea = Basic;
                }
                field("Default Mode";"Default Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Lower Limit";"Lower Limit")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000000;"Front Office Charges")
            {
                SubPageLink = "Transaction Type"=field(Code);
            }
        }
    }

    actions
    {
    }
}

