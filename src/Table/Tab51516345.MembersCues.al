Table 51516345 "Members Cues"
{

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "All Members"; Integer)
        {
            CalcFormula = count(Customer where("Customer Posting Group" = filter('Member')));
            FieldClass = FlowField;
        }

        field(3; "Active Members"; Integer)
        {
            CalcFormula = count(Customer where(Status = const("Active"), "Customer Posting Group" = filter('Member'), "Current Shares" = filter(>= 500)));
            FieldClass = FlowField;
        }
        field(4; "NonActive Mbrs"; Integer)
        {
            CalcFormula = count(Customer where("Customer Posting Group" = filter('Member'), "Current Shares" = filter(< 500)));
            FieldClass = FlowField;
        }

        field(5; "ALL CEEP Mbrs"; Integer)
        {
            CalcFormula = count(Customer where("Customer Posting Group" = filter('MICRO'), "Account Category" = filter('Individual')));
            FieldClass = FlowField;
        }
        field(6; "Active CEEP Mbrs"; Integer)
        {
            CalcFormula = count(Customer where("Customer Posting Group" = filter('MICRO'), "Current Shares" = filter(>= 500), "Account Category" = filter('Individual')));
            FieldClass = FlowField;
        }
        field(7; "Inactive CEEP Mbrs"; Integer)
        {
            CalcFormula = count(Customer where("Customer Posting Group" = filter('MICRO'), "Current Shares" = filter(< 500), "Account Category" = filter('Individual')));
            FieldClass = FlowField;
        }

        field(8; "Requests to Approve"; Integer)
        {
            CalcFormula = count("Approval Entry" where("Approver ID" = field("User ID"),
                                                        Status = filter(Open)));
            Caption = 'Requests to Approve';
            FieldClass = FlowField;
        }
        field(9; "Requests Sent for Approval"; Integer)
        {
            CalcFormula = count("Approval Entry" where("Sender ID" = field("User ID"),
                                                        Status = filter(Open)));
            Caption = 'Requests Sent for Approval';
            FieldClass = FlowField;
        }
        field(10; "Working Mobile Bal"; Integer)
        {
            // CalcFormula = count("Approval Entry" where("Sender ID" = field("User ID"),
            //                                             Status = filter(Open)));
            // Caption = 'Requests Sent for Approval';
            // FieldClass = FlowField;
        }

        field(11; "Utility Mobile Bal"; Integer)
        {
            // CalcFormula = count("Approval Entry" where("Sender ID" = field("User ID"),
            //                                             Status = filter(Open)));
            // Caption = 'Requests Sent for Approval';
            // FieldClass = FlowField;
        }

        field(12; "SMS Bal"; Integer)
        {
            // CalcFormula = count("Approval Entry" where("Sender ID" = field("User ID"),
            //                                             Status = filter(Open)));
            // Caption = 'Requests Sent for Approval';
            // FieldClass = FlowField;
        }

        field(13; "CEEP Groups"; Integer)
        {
            CalcFormula = count(Customer where("Customer Posting Group" = filter('MICRO'), "Account Category" = filter('GROUP')));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

