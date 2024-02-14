#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516450 "Investor Posting Group"
{

    fields
    {
        field(10;"Posting Code";Code[20])
        {
        }
        field(11;"Posting Group Description";Text[100])
        {
        }
        field(12;"Investor Deposit A/C";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(13;"Interest Payables A/C";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(14;"Interest Expense A/C";Code[20])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1;"Posting Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure CheckGLAcc(AccNo: Code[20];CheckProdPostingGroup: Boolean;CheckDirectPosting: Boolean)
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
          GLAcc.Get(AccNo);
          GLAcc.CheckGLAcc;
          if CheckProdPostingGroup then
            GLAcc.TestField("Gen. Prod. Posting Group");
          if CheckDirectPosting then
            GLAcc.TestField("Direct Posting",true);
        end;
    end;


    procedure GetReceivablesAccount(): Code[20]
    begin
        TestField("Investor Deposit A/C");
        exit("Investor Deposit A/C");
    end;


    procedure GetPmtDiscountAccount(Debit: Boolean): Code[20]
    begin
        /*
        //Surestep Comment
        IF Debit THEN BEGIN
          TESTFIELD("Payment Disc. Debit Acc.");
          EXIT("Payment Disc. Debit Acc.");
        END;
        TESTFIELD("Payment Disc. Credit Acc.");
        EXIT("Payment Disc. Credit Acc.");
        */

    end;


    procedure GetPmtToleranceAccount(Debit: Boolean): Code[20]
    begin
        /*
        //Surestep Comment
        IF Debit THEN BEGIN
          TESTFIELD("Payment Tolerance Debit Acc.");
          EXIT("Payment Tolerance Debit Acc.");
        END;
        TESTFIELD("Payment Tolerance Credit Acc.");
        EXIT("Payment Tolerance Credit Acc.");
        */

    end;


    procedure GetRoundingAccount(Debit: Boolean): Code[20]
    begin
        /*
        //Surestep Comment
        IF Debit THEN BEGIN
          TESTFIELD("Debit Rounding Account");
          EXIT("Debit Rounding Account");
        END;
        TESTFIELD("Credit Rounding Account");
        EXIT("Credit Rounding Account");
        */

    end;


    procedure GetApplRoundingAccount(Debit: Boolean): Code[20]
    begin
        /*
        //Surestep Comment
        IF Debit THEN BEGIN
          TESTFIELD("Debit Curr. Appln. Rndg. Acc.");
          EXIT("Debit Curr. Appln. Rndg. Acc.");
        END;
        TESTFIELD("Credit Curr. Appln. Rndg. Acc.");
        EXIT("Credit Curr. Appln. Rndg. Acc.");
        */

    end;


    procedure GetInterestPayableAccount(): Code[20]
    begin
        TestField("Interest Payables A/C");
        exit("Interest Payables A/C");
    end;


    procedure GetInterestExpenseAccount(): Code[20]
    begin
        TestField("Interest Expense A/C");
        exit("Interest Expense A/C");
    end;
}

