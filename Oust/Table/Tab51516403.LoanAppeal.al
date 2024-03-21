table 51516403 "Loan Appeal"
{
    Caption = 'Loan Appeal';
    DataClassification = ToBeClassified;
    LookupPageId = "Loan Appeal List";
    DrillDownPageId = "Loan Appeal List";

    fields
    {
        field(1; "Loan Number"; Code[30])
        {
            Caption = 'Loan Number';
            TableRelation = "Loans Register"."Loan  No.";
            trigger OnValidate()
            var
                LoanRegister: Record "Loans Register";
            begin
                if LoanRegister.get("Loan Number") then begin
                    LoanRegister.CalcFields(LoanRegister."Outstanding Balance");
                    "Loan Product Type" := LoanRegister."Loan Product Type";
                    Installments := LoanRegister.Installments;
                    Interest := LoanRegister.Interest;
                    "Oustanding Balance" := LoanRegister."Outstanding Balance";




                end;
            end;
        }
        field(2; "Amount Applied"; Decimal)
        {
            Caption = 'Amount Applied';
            FieldClass = FlowField;
            CalcFormula = lookup("Loans Register"."Approved Amount" where("Loan  No." = field("Loan Number")));
        }
        field(3; Installments; Integer)
        {
            Caption = 'Installments';
        }
        field(4; Interest; Integer)
        {
            Caption = 'Interest';
        }
        field(5; "Oustanding Balance"; Decimal)
        {
            Caption = 'Oustanding Balance';
        }
        field(6; "New Amount"; Decimal)
        {

            NotBlank = true;
        }
        field(7; "Loan Product Type"; Code[30])
        {
            Caption = 'Loan Product Type';
        }
        field(8; "New Loan Product Type"; Code[30])
        {
            Caption = 'New Loan Product Type';
            TableRelation = "Loan Products Setup".Code where(Source = const(BOSA));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if LoanType.Get("New Loan Product Type") then begin
                    NewInterest := LoanType."Interest rate";
                    NewInstalmentPeriod := LoanType."Instalment Period";
                    NewInstallment := LoanType."Default Installements";

                end;
            end;
        }
        field(9; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Increase,Decrease;
            NotBlank = true;
        }
        field(10; "Reason For change?"; Text[150])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(11; ClientCode; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Loans Register"."Client Code" where("Loan  No." = field("Loan Number")));
        }
        field(12; "Captured By"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(13; "New Principle Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                rec.CalcFields("Amount Applied");
                "New Amount" := "New Principle Amount" - "Amount Applied";
                if "New Amount" > 0 then
                    type := type::Increase else
                    if "New Amount" < 0 then Type := type::Decrease;
            end;


        }
        field(14; "NewInterest"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "NewInstalmentPeriod"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(16; NewInstallment; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; Appealed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Loan Number")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Captured By" := UpperCase(UserId);
    end;

    var
        LoanType: Record "Loan Products Setup";
}
