#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516344 "loans Cuess"
{

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; "Applied Loans"; Integer)
        {
            CalcFormula = COUNT("Loans Register" WHERE("Approval Status" = CONST(Open), "Approved Amount" = filter(> 0), "Loan Status" = const(Application), Source = const(BOSA)));
            FieldClass = FlowField;

        }
        field(3; "Active Loans"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Outstanding Balance" = filter(> 0), "Loan Status" = const(Issued), Source = const(BOSA)));
            FieldClass = FlowField;
        }
        field(4; "Pending Loans"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Pending), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), Source = const(BOSA)));
            FieldClass = FlowField;
        }


        field(8; "ASSET LOAN"; Integer)
        {
            CalcFormula = COUNT("Loans Register" WHERE("Approval Status" = CONST(Approved), "Approved Amount" = filter(> 0), "Loan Status" = const(Application), "Loan Product Type" = const('ASSET LOAN')));
            FieldClass = FlowField;

        }
        field(9; "COLLEGE LOAN"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Outstanding Balance" = filter(> 0), "Loan Status" = const(Issued), "Loan Product Type" = const('COLLEGE LOAN')));
            FieldClass = FlowField;
        }
        field(10; "DEBOOSTER"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('DEBOOSTER')));
            FieldClass = FlowField;

        }
        field(11; "EMERGENCY"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('EMERGENCY')));
            FieldClass = FlowField;
        }
        field(12; "FURNITURE"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('FURNITURE')));
            FieldClass = FlowField;
        }
        field(13; "HOUSEHOLD"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('HOUSEHOLD')));
            FieldClass = FlowField;
        }
        field(14; "IPF"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('IPF')));
            FieldClass = FlowField;
        }
        field(15; "KARIBU"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('KARIBU')));
            FieldClass = FlowField;
        }
        field(16; "LIKIZO"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('LIKIZO')));
            FieldClass = FlowField;
        }
        field(17; "MAKEOVER"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('MAKEOVER')));
            FieldClass = FlowField;
        }
        field(18; "NORMAL"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('NORMAL')));
            FieldClass = FlowField;
        }
        field(19; "PREMIUM"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('PREMIUM')));
            FieldClass = FlowField;
        }
        field(20; "QUICK CASH"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('QUICK CASH')));
            FieldClass = FlowField;
        }
        field(21; "SCH_FEES"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('SCH_FEES')));
            FieldClass = FlowField;
        }
    field(22; "Cleared Loans"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Outstanding Balance" = filter(<=0), "Loan Status" = const(Issued), Source = const(BOSA)));
            FieldClass = FlowField;
        }


    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

