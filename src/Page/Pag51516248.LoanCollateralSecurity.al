#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516248 "Loan Collateral Security"
{
    PageType = ListPart;
    SourceTable = "Loan Collateral Details";

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Loan No"; "Loan No")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Code)
                {
                    ApplicationArea = Basic;
                }
                field(Type; Type)
                {
                    ApplicationArea = Basic;
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;

                }
                field(Value; Value)
                {
                    ApplicationArea = Basic;
                }

                field(Category; Category)
                {
                    ApplicationArea = Basic;
                }
                field("Collateral Multiplier"; "Collateral Multiplier")
                {
                    ApplicationArea = Basic;
                }
                field("Guarantee Value"; "Guarantee Value")
                {
                    ApplicationArea = Basic;
                }
                // field("View Document"; "View Document")
                // {
                //     ApplicationArea = Basic;
                //     Editable = false;
                // }
                field("Assesment Done By"; "Assesment Done By")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks; Remarks)
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

