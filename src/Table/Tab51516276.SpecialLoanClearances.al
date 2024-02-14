#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516276 "Special Loan Clearances"
{
    // DrillDownPageID = UnknownPage39004250;
    // LookupPageID = UnknownPage39004250;

    fields
    {
        field(1;"Loan No.";Code[20])
        {
            TableRelation = "Loans Register"."Loan  No.";
        }
        field(2;"Loan Top Up";Code[20])
        {
            TableRelation = "Loans Register"."Loan  No." where ("Client Code"=field("Client Code"),
                                                                Posted=const(true),
                                                                "Outstanding Balance"=filter(>0),
                                                                "Loan Product Type"=const('BCL'));

            trigger OnValidate()
            begin
                "Loan Type":='';
                "Principle Top Up":=0;
                "Interest Top Up":=0;
                "Total Top Up":=0;
                Loantypes.Reset;
                Loantypes.SetRange(Loantypes.Code,"Loan Type");
                Loans.Reset;
                Loans.SetRange(Loans."Loan  No.","Loan Top Up");
                if Loans.Find('-') then begin
                Loans.CalcFields(Loans."Outstanding Balance",Loans."Interest Due");
                "Loan Type":=Loans."Loan Product Type";
                if Cust.Get(Loans."Account No") then begin
                "ID. NO":=Cust."ID No.";
                end;

                "Principle Top Up":=Loans."Outstanding Balance";
                "Interest Top Up":="Principle Top Up"*(Loans.Interest/100/12);
                "Total Top Up":="Principle Top Up" +"Interest Top Up";
                "Monthly Repayment":=Loans.Repayment;


                if Loantypes.Get("Loan Type") then begin
                Commision:=("Principle Top Up"+"Interest Top Up")*(Loantypes."Top Up Commision"/100);
                end;
                "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;
                end;
            end;
        }
        field(3;"Client Code";Code[20])
        {
        }
        field(4;"Loan Type";Code[20])
        {
        }
        field(5;"Principle Top Up";Decimal)
        {

            trigger OnValidate()
            begin
                //IF Loantypes.GET("Loan Type") THEN BEGIN
                //"Interest Top Up":="Principle Top Up"*(Loantypes."Interest rate"/100);
                //END;

                //"Interest Top Up":="Principle Top Up"*(1.75/100);


                Loans.Reset;
                Loans.SetRange(Loans."Loan  No.","Loan Top Up");
                if Loans.Find('-') then begin
                Loans.CalcFields(Loans."Outstanding Balance");
                //IF "Principle Top Up" > Loans."Outstanding Balance" THEN
                //ERROR('Amount cannot be greater than the loan oustanding balance.');
                 "Interest Top Up":="Principle Top Up"*(Loans.Interest/100);
                end;



                "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;
            end;
        }
        field(6;"Interest Top Up";Decimal)
        {

            trigger OnValidate()
            begin
                "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;

                Loans.Reset;
                Loans.SetRange(Loans."Loan  No.","Loan Top Up");
                if Loans.Find('-') then begin
                Loans.CalcFields(Loans."Interest Due");
                if "Principle Top Up" < Loans."Outstanding Balance" then
                Error('Amount cannot be greater than the interest due.');

                end;
            end;
        }
        field(7;"Total Top Up";Decimal)
        {
        }
        field(8;"Monthly Repayment";Decimal)
        {
        }
        field(9;"Interest Paid";Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry".Amount where ("Customer No."=field("Client Code"),
                                                                  "Loan No"=field("Loan Top Up"),
                                                                  "Transaction Type"=filter("Interest Paid")));
            FieldClass = FlowField;
        }
        field(10;"Outstanding Balance";Decimal)
        {
            FieldClass = Normal;
        }
        field(11;"Interest Rate";Decimal)
        {
            CalcFormula = sum("Loans Register".Interest where ("Loan  No."=field("Loan Top Up"),
                                                               "Client Code"=field("Client Code")));
            FieldClass = FlowField;
        }
        field(12;"ID. NO";Code[20])
        {
        }
        field(13;Commision;Decimal)
        {

            trigger OnValidate()
            begin
                  "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;
            end;
        }
    }

    keys
    {
        key(Key1;"Loan No.","Client Code")
        {
            Clustered = true;
            SumIndexFields = "Total Top Up","Principle Top Up";
        }
        key(Key2;"Principle Top Up")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Client Code","Loan Type","Principle Top Up","Interest Top Up","Total Top Up","Monthly Repayment","Interest Paid","Outstanding Balance","Interest Rate",Commision)
        {
        }
    }

    var
        Loans: Record "Loans Register";
        Loantypes: Record "Loan Products Setup";
        Interest: Decimal;
        Cust: Record Customer;
}

