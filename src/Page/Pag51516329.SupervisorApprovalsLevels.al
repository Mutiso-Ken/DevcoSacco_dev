#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516329 "Supervisor Approvals Levels"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Supervisors Approval Levels";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control4)
            {
                field(SupervisorID;SupervisorID)
                {
                    ApplicationArea = Basic;
                    Caption = 'User ID';
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Approval Amount";"Maximum Approval Amount")
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

