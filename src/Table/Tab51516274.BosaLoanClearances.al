#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516274 "Bosa Loan Clearances"
{

    fields
    {
        field(1;"BLA Number";Code[10])
        {
        }
        field(2;"Client Code";Code[10])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if "Client Code" = '' then
                "Client Name":='';

                if CustomerRecord.Get("Client Code") then begin
                if CustomerRecord.Blocked=CustomerRecord.Blocked::All then
                Error('Member is blocked from transacting ' + "Client Code");



                CustomerRecord.TestField(CustomerRecord."ID No.");
                if CustomerRecord."Registration Date" <> 0D then begin
                if CalcDate(GenSetUp."Min. Loan Application Period",CustomerRecord."Registration Date") > Today then
                Error('Member is less than six months old therefor not eligible for loan application.');
                end;
                end;

                "Client Name":=CustomerRecord.Name;
                "Account No":=CustomerRecord."FOSA Account";
                "Staff No":=CustomerRecord."Payroll/Staff No";
                "ID No":=CustomerRecord."ID No.";
            end;
        }
        field(3;"Client Name";Code[60])
        {
        }
        field(4;"Loan Product Type";Code[60])
        {
            TableRelation = "Loan Products Setup".Code;

            trigger OnValidate()
            begin
                if LoanType.Get("Loan Product Type") then begin
                "Loan Product Type Name":=LoanType."Product Description";
                end;
            end;
        }
        field(5;"Loan Product Type Name";Code[60])
        {
        }
        field(6;Interest;Decimal)
        {
        }
        field(7;"Request Amount";Decimal)
        {
        }
        field(8;"Approved Amount";Decimal)
        {

            trigger OnValidate()
            begin
                if "Approved Amount"> "Request Amount" then begin
                Error('APPROVED AMOUNT CANT BE GREATER THAN REQUESTED AMOUNT');
                end;
            end;
        }
        field(9;"Main Loan Number";Code[60])
        {
            TableRelation = "Loans Register"."Loan  No." where ("Client Code"=field("Client Code"),
                                                                Posted=const(false));

            trigger OnValidate()
            begin
                
            end;
        }
        field(10;"Approval Status";Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(11;"No. Series";Code[10])
        {
        }
        field(12;"Staff No";Code[60])
        {
        }
        field(13;"Account No";Code[60])
        {
        }
        field(14;"ID No";Code[60])
        {
        }
        field(15;"Responsibility Center";Code[60])
        {
            TableRelation = "Responsibility Center";
        }
        field(16;Posted;Boolean)
        {
        }
        field(17;Balances;Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount (LCY)" where ("Loan No"=field("BLA Number")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"BLA Number")
        {
            Clustered = true;
        }
        key(Key2;"Client Code","Main Loan Number",Posted)
        {
            SumIndexFields = "Approved Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        SalesSetup.Get;
        SalesSetup.TestField(SalesSetup."BOSA Loans Nos");
        NoSeriesMgt.InitSeries(SalesSetup."BOSA Loans Nos",xRec."No. Series",0D,"BLA Number","No. Series");
    end;

    var
        SalesSetup: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LoanType: Record "Loan Products Setup";
        CustomerRecord: Record Customer;
        i: Integer;
        PeriodDueDate: Date;
        Gnljnline: Record "Gen. Journal Line";
       // Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
        CumInterest: Decimal;
        NewPrincipal: Decimal;
        PeriodPrRepayment: Decimal;
        GenBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        GnljnlineCopy: Record "Gen. Journal Line";
        NewLNApplicNo: Code[10];
        IssuedDate: Date;
        GracePerodDays: Integer;
        InstalmentDays: Integer;
        GracePeiodEndDate: Date;
        InstalmentEnddate: Date;
        NoOfGracePeriod: Integer;
        G: Integer;
        RunningDate: Date;
        NewSchedule: Record "Loan Repayment Schedule";
        ScheduleCode: Code[20];
        GP: Text[30];
        Groups: Record "Product Cycles";
        PeriodInterval: Code[10];
        GLSetup: Record "General Ledger Setup";
        Users: Record User;
        FlatPeriodInterest: Decimal;
        FlatRateTotalInterest: Decimal;
        FlatPeriodInterval: Code[10];
        ProdCycles: Record "Product Cycles";
        LoanApp: Record "Loans Register";
        MemberCycle: Integer;
        PCharges: Record "Loan Product Charges";
        TCharges: Decimal;
        LAppCharges: Record "Loan Applicaton Charges";
        Vendor: Record Vendor;
        Cust: Record Customer;
        Vend: Record Vendor;
        Cust2: Record Customer;
        TotalMRepay: Decimal;
        LPrincipal: Decimal;
        LInterest: Decimal;
        InterestRate: Decimal;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        UsersID: Record User;
        LoansBatches: Record "Loan Disburesment-Batching";
        Employer: Record "Sacco Employers";
        GenSetUp: Record "Sacco General Set-Up";
        Batches: Record "Loan Disburesment-Batching";
        MovementTracker: Record "Movement Tracker";
        SpecialComm: Decimal;
        CustR: Record Customer;
        RAllocation: Record "Receipt Allocation";
        "Standing Orders": Record "Standing Orders";
        StatusPermissions: Record "Status Change Permision";
        CustLedg: Record "Cust. Ledger Entry";
        LoansClearedSpecial: Record "Special Loan Clearances";
        BridgedLoans: Record "Special Loan Clearances";
        Loan: Record "Loans Register";
        banks: Record "Bank Account";
        DefaultInfo: Text[180];
        sHARES: Decimal;
        MonthlyRepayT: Decimal;
        MonthlyRepay: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        RepaySched: Record "Loan Repayment Schedule";
        currYear: Integer;
        StartDate: Date;
        EndDate: Date;
        Month: Integer;
        Mwezikwisha: Date;
}

