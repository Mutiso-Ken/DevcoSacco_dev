Table 51516301 "Treasury Transactions"
{

    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Treasury Transactions No");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Transaction Date"; Date)
        {
        }
        field(3; "Transaction Type"; Option)
        {
            OptionMembers = "Issue To Teller","Return To Treasury","Issue From Bank","Return To Bank","Inter Teller Transfers","End of Day Return to Treasury","Branch Treasury Transactions";

            trigger OnValidate()
            begin
                if "Transaction Type" = "transaction type"::"Issue To Teller" then
                    Description := 'ISSUE TO TELLER';

                if "Transaction Type" = "transaction type"::"Return To Treasury" then
                    Description := 'RETURN TO TREASURY';

                if "Transaction Type" = "transaction type"::"Inter Teller Transfers" then
                    Description := 'INTER TELLER TRANSFERS';

                if "Transaction Type" = "transaction type"::"Issue From Bank" then
                    Description := 'ISSUE FROM BANK';

                if "Transaction Type" = "transaction type"::"Return To Bank" then
                    Description := 'RETURN TO BANK';

                if "Transaction Type" = "transaction type"::"End of Day Return to Treasury" then
                    Description := 'END OF DAY RETURN TO TREASURY';


                if "Transaction Type" = "transaction type"::"Branch Treasury Transactions" then
                    Description := 'BRANCH TREASURY TRANSACTIONS';


                "From Account" := '';
                "To Account" := '';
            end;
        }
        field(4; "From Account"; Code[20])
        {
            TableRelation = if ("Transaction Type" = filter("Issue To Teller" | "Return To Bank" | "Branch Treasury Transactions")) "Bank Account"."No." where("Account Type" = const(Treasury))
            else
            if ("Transaction Type" = filter("Return To Treasury" | "Return To Treasury" | "Inter Teller Transfers")) "Bank Account"."No." where("Account Type" = const(Cashier))
            else
            if ("Transaction Type" = filter("Issue From Bank")) "Bank Account"."No." where("Account Type" = const(" "));

            trigger OnValidate()
            begin
                Banks.Reset;
                Banks.SetRange(Banks."No.", "From Account");
                if Banks.Find('-') then begin
                    "From Account Name" := Banks.Name;
                    Modify;
                end;
            end;
        }
        field(5; "To Account"; Code[20])
        {
            TableRelation = if ("Transaction Type" = filter("Return To Treasury" | "Issue From Bank" | "Branch Treasury Transactions")) "Bank Account"."No." where("Account Type" = const(Treasury))
            else
            if ("Transaction Type" = filter("Issue To Teller" | "Inter Teller Transfers")) "Bank Account"."No." where("Account Type" = const(Cashier))
            else
            if ("Transaction Type" = filter("Return To Bank")) "Bank Account"."No." where("Account Type" = const(" "));

            trigger OnValidate()
            begin
                Banks.Reset;
                Banks.SetRange(Banks."No.", "To Account");
                if Banks.Find('-') then begin
                    "To Account Name" := Banks.Name;
                    Modify;
                end;
            end;
        }
        field(6; Description; Text[100])
        {
        }
        field(7; Amount; Decimal)
        {
        }
        field(8; Posted; Boolean)
        {
        }
        field(9; "Date Posted"; Date)
        {
        }
        field(10; "Time Posted"; Time)
        {
        }
        field(11; "Posted By"; Text[20])
        {
        }
        field(12; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(13; "Transaction Time"; Time)
        {
        }
        field(14; "Coinage Amount"; Decimal)
        {
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(16; Issued; Option)
        {
            OptionMembers = No,Yes,"N/A";
        }
        field(17; "Date Issued"; Date)
        {
        }
        field(18; "Time Issued"; Time)
        {
        }
        field(19; "Issue Received"; Option)
        {
            Editable = false;
            OptionMembers = No,Yes,"N/A";
        }
        field(20; "Date Received"; Date)
        {
            Editable = false;
        }
        field(21; "Time Received"; Time)
        {
            Editable = false;
        }
        field(22; "Issued By"; Text[20])
        {
            Editable = false;
        }
        field(23; "Received By"; Text[20])
        {
            Editable = false;
        }
        field(24; Received; Option)
        {
            Editable = false;
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(32; "Request No"; Code[20])
        {
        }
        field(33; "Bank No"; Code[20])
        {
            TableRelation = "Bank Account"."No." where("doc attached" = const(false));
        }
        field(34; "Denomination Total"; Decimal)
        {
        }
        field(35; "External Document No."; Code[20])
        {
        }
        field(36; "Cheque No."; Code[20])
        {
        }
        field(37; "Transacting Branch"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(38; Approved; Boolean)
        {
        }
        field(39; "End of Day Trans Time"; Time)
        {
        }
        field(40; "End of Day"; Date)
        {
        }
        field(41; "Last Transaction"; Code[20])
        {
            CalcFormula = min("Treasury Transactions".No where("Transaction Type" = filter("End of Day Return to Treasury"),
                                                                "To Account" = field("To Account")));
            FieldClass = FlowField;
        }
        field(42; "Total Cash on Treasury Coinage"; Decimal)
        {
            CalcFormula = sum("Treasury Coinage"."Total Amount" where(No = field(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Till/Treasury Balance"; Decimal)
        {
        }
        field(44; "Excess/Shortage Amount"; Decimal)
        {
        }
        field(45; "From Account Name"; Text[80])
        {
        }
        field(46; "To Account Name"; Text[80])
        {
        }
        field(47; "Actual Cash At Hand"; Decimal)
        {
            CalcFormula = sum("Treasury Coinage"."Total Amount" where(No = field(No)));
            FieldClass = FlowField;
        }
        field(48; "Captured By"; Text[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        Error('The transaction has been posted and therefore cannot be deleted.');
    end;

    trigger OnInsert()
    begin
        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Treasury Transactions No");
            NoSeriesMgt.InitSeries(NoSetup."Treasury Transactions No", xRec."No. Series", 0D, No, "No. Series");
        end;

        if "Transaction Type" = "transaction type"::"Issue To Teller" then
            Description := 'ISSUE TO TELLER'
        else
            if "Transaction Type" = "transaction type"::"Issue From Bank" then
                Description := 'ISSUE FROM BANK'
            else
                Description := 'RETURN TO TREASURY';




        "Transaction Date" := Today;
        "Transaction Time" := Time;

        Denominations.Reset;
        TransactionCoinage.Reset;
        Denominations.Init;
        TransactionCoinage.Init;

        if Denominations.Find('-') then begin

            repeat
                TransactionCoinage.No := No;
                TransactionCoinage.Code := Denominations.Code;
                TransactionCoinage.Description := Denominations.Description;
                TransactionCoinage.Type := Denominations.Type;
                TransactionCoinage.Value := Denominations.Value;
                TransactionCoinage.Quantity := 0;
                TransactionCoinage.Insert;
            until Denominations.Next = 0;

        end;
    end;

    trigger OnModify()
    begin
        if Posted = true then
            Error('The transaction has been posted and therefore cannot be modified.');
    end;

    trigger OnRename()
    begin
        if Posted then begin
            Error('The transaction has been posted and therefore cannot be modified.');
            exit;
        end;
    end;

    var
        NoSetup: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Denominations: Record Denominations;
        TransactionCoinage: Record "Treasury Coinage";
        UsersID: Record User;
        Banks: Record "Bank Account";
}

