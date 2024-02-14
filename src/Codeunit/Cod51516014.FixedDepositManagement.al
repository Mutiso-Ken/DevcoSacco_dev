#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516014 "FixedDepositManagement"
{
    TableNo = Vendor;

    trigger OnRun()
    begin
    end;

    var
        AccountTypes: Record "Account Types-Saving Products";
        FDType: Record "Fixed Deposit Type";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        InterestBuffer: Record "Interest Buffer";
        Vend: Record Vendor;
        GLEntries: Record "G/L Entry";
        FDInterestCalc: Record "FD Interest Calculation Criter";
        IntRate: Decimal;
        InterestAmount: Decimal;
        FixedDepType: Record "Fixed Deposit Type";
        FDDays: Integer;
        IntBufferNo: Integer;


    procedure RollOver(Account: Record Vendor;RunDate: Date)
    begin


        if Account.Blocked <> Account.Blocked::All then begin
        Account.CalcFields(Account."Balance (LCY)");
        if AccountTypes.Get(Account."Account Type") then begin
          if AccountTypes."Fixed Deposit" = true then begin
          if AccountTypes."Earns Interest" = true then
            Account.TestField(Account."FD Maturity Date");
            if Account."FD Maturity Date" <= RunDate then begin
              if FDType.Get(Account."Fixed Deposit Type") then begin
                CalculateFDInterest(Account,RunDate);

                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code,Account."Account Type");
                if AccountTypes.Find('-') then  begin

                  LineNo:=LineNo+10000;
                  Account.CalcFields("Untranfered Interest");

                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                  GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='FD Interest - '+Format(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=-Account."Untranfered Interest";
                  GenJournalLine.Validate(GenJournalLine.Amount);
                  GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                  GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
                 GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                  GenJournalLine.Insert;

                  //Withholding tax
                  LineNo:=LineNo+10000;

                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                  GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='Withholding Tax';
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100);
                  GenJournalLine.Validate(GenJournalLine.Amount);
                  GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                  GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
                 GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                  GenJournalLine.Insert;

                  //Withholding tax

                  //Transfer to savings
                  LineNo:=LineNo+10000;
                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                  GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='Transfer to Savings';
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=(Account."Balance (LCY)"+Account."Untranfered Interest")-(Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100));
                  GenJournalLine.Validate(GenJournalLine.Amount);
                  //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                  //GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
                 //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                  GenJournalLine.Insert;


                  LineNo:=LineNo+10000;
                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."Savings Account No.";//Account."No.";
                  GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='Transfer from fixed';
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=((Account."Balance (LCY)"+Account."Untranfered Interest")-(Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100)))*-1;
                  GenJournalLine.Validate(GenJournalLine.Amount);
                  //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                  //GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
                 //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                  GenJournalLine.Insert;

                  //Transfer to savings


                  //Post New
                  GenJournalLine.Reset;
                  GenJournalLine.SetRange("Journal Template Name",'PURCHASES');
                  GenJournalLine.SetRange("Journal Batch Name",'FXDEP');
                  if GenJournalLine.Find('-') then begin
                  Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJournalLine);
                  end;

                  //Post New


                  InterestBuffer.Reset;
                  InterestBuffer.SetRange(InterestBuffer."Account No",Account."No.");
                  if InterestBuffer.Find('-') then
                  InterestBuffer.ModifyAll(InterestBuffer.Transferred,true);

                  Account."FD Maturity Date":=CalcDate(FDType.Duration,Account."FD Maturity Date");
                  //Account."FD Maturity Instructions" := Account."FD Maturity Instructions"::"Transfer to Savings";
                  Account."Fixed Deposit Status":=Account."fixed deposit status"::Closed;
                 Account.Modify;
                end;
              end;
            end;
          end;
        end;
        end;
    end;


    procedure Renew(Account: Record Vendor;RunDate: Date)
    begin

        if Account.Blocked <> Account.Blocked::All then   begin
        if AccountTypes.Get(Account."Account Type") then begin
          if AccountTypes."Fixed Deposit" = true then begin
          if AccountTypes."Earns Interest" = true then
            Account.TestField("FD Maturity Date");
            if Account."FD Maturity Date" <= RunDate then begin
              if FDType.Get(Account."Fixed Deposit Type") then begin
                CalculateFDInterest(Account,RunDate);
                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code,Account."Account Type");
                if AccountTypes.Find('-') then  begin
                  Account.TestField("Savings Account No.");


                    LineNo:=LineNo+10000;
                  Account.CalcFields("Untranfered Interest");

                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                  //GenJournalLine."Account No.":=Account."Savings Account No.";
                 GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='FD Interest - '+Format(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=-Account."Untranfered Interest";
                 GenJournalLine.Validate(GenJournalLine.Amount);
                  GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                  GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
                 GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;


                  //Withholding tax
                  LineNo:=LineNo+10000;
                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                  GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='Withholding Tax';
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100);
                  GenJournalLine.Validate(GenJournalLine.Amount);
                  GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                  GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
                 GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                  GenJournalLine.Insert;

                  //Withholding tax

                  //Transfer to savings
                  LineNo:=LineNo+10000;
                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                  GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='Transfer to Savings';
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=Account."Untranfered Interest"-(Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100));
                  GenJournalLine.Validate(GenJournalLine.Amount);
                  //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                  //GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
                 //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                  GenJournalLine.Insert;


                  LineNo:=LineNo+10000;
                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."Savings Account No.";//Account."No.";
                  GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='Transfer from fixed';
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=(Account."Untranfered Interest"-(Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100)))*-1;
                  GenJournalLine.Validate(GenJournalLine.Amount);
                  //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                  //GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
                 //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                  GenJournalLine.Insert;

                  //Transfer to savings


                  //Post New
                  GenJournalLine.Reset;
                  GenJournalLine.SetRange("Journal Template Name",'PURCHASES');
                  GenJournalLine.SetRange("Journal Batch Name",'FXDEP');
                  if GenJournalLine.Find('-') then begin
                  Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJournalLine);
                  end;

                  //Post New
                  InterestBuffer.Reset;
                  InterestBuffer.SetRange(InterestBuffer."Account No",Account."No.");
                  if InterestBuffer.Find('-') then
                  InterestBuffer.ModifyAll(InterestBuffer.Transferred,true);

                  Account."FD Maturity Date":=CalcDate(FDType.Duration,Account."FD Maturity Date");
                  Account."Fixed Deposit Status" := Account."fixed deposit status"::Active;      //mutinda
                  Account.Modify;
                end;
              end;
            end;
          end;
        end;
        end;
    end;


    procedure CloseNonRenewable(Account: Record Vendor;RunDate: Date)
    begin
        
        if Account.Blocked <> Account.Blocked::All then   begin
        
        if AccountTypes.Get(Account."Account Type") then begin
          if AccountTypes."Fixed Deposit" = true then begin
          if AccountTypes."Earns Interest" = true then
            Account.TestField("FD Maturity Date");
            if Account."FD Maturity Date" <= RunDate then begin
              if FDType.Get(Account."Fixed Deposit Type") then begin
                CalculateFDInterest(Account,RunDate);
        
                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code,Account."Account Type");
                if AccountTypes.Find('-') then  begin
                  Account.TestField("Savings Account No.");
        
                    LineNo:=LineNo+10000;
                  Account.CalcFields("Untranfered Interest");
        
                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                 // GenJournalLine."Account No.":=Account."Savings Account No.";
                 GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='FD Interest - '+Format(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=-Account."Untranfered Interest";
                 GenJournalLine.Validate(GenJournalLine.Amount);
                  GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                  GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
                 GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
        
        
                  //Withholding tax
                  LineNo:=LineNo+10000;
                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                  GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='Withholding Tax';
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100);
                  GenJournalLine.Validate(GenJournalLine.Amount);
                  GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                  GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
                 GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                  GenJournalLine.Insert;
        
                  //Withholding tax
        
        
                    LineNo:=LineNo+10000;
                  Account.CalcFields("Untranfered Interest");
        
                  GenJournalLine.Init;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD INTEREST';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."account type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                  //GenJournalLine."Account No.":=Account."Savings Account No.";
                 GenJournalLine.Validate(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='Interest rebate on fixed';
                  GenJournalLine.Description:=UpperCase(GenJournalLine.Description);
                  GenJournalLine.Amount:=(Account."Untranfered Interest")*-0.01;
                 GenJournalLine.Validate(GenJournalLine.Amount);
                  GenJournalLine."Bal. Account Type":=GenJournalLine."bal. account type"::"G/L Account";
                  GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
                 GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                  if GenJournalLine.Amount<>0 then
                    GenJournalLine.Insert;
        
        
                   /*
                  LineNo:=LineNo+10000;
                  Account.CALCFIELDS("Untranfered Interest");
        
                  //Transfer Interest
                  GenJournalLine.INIT;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD MATURITY';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                  IF  Vend.GET (Account."Savings Account No.") THEN BEGIN
                  IF Vend.Blocked <> Vend.Blocked::All  THEN BEGIN
                  GenJournalLine."Account No.":=Account."Savings Account No.";
                  END;
                  END;
                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='FD Interest - '+ FORMAT(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');
                  GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                  GenJournalLine.Amount:=-Account."Untranfered Interest";
                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                  GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                  GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                  IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;
        
                  //Transfer Amount
                  LineNo:=LineNo+10000;
                  Account.CALCFIELDS(Account."Balance (LCY)");
                  GenJournalLine.INIT;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD MATURITY';
                  GenJournalLine."External Document No.":=Account."Savings Account No.";
                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                  GenJournalLine."Account No.":=Account."No.";
                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='FD MATURITY - Transfer To Savings';
                  GenJournalLine.Amount:=Account."Balance (LCY)";
                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                  IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;
        
                  LineNo:=LineNo+10000;
                  GenJournalLine.INIT;
                  GenJournalLine."Journal Template Name":='PURCHASES';
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Journal Batch Name":='FXDEP';
                  GenJournalLine."Document No.":='FD MATURITY';
                  GenJournalLine."External Document No.":=Account."No.";
                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
        
                  IF  Vend.GET (Account."Savings Account No.") THEN BEGIN
        
                  IF Vend.Blocked <> Vend.Blocked::All  THEN BEGIN
                  GenJournalLine."Account No.":=Account."Savings Account No.";
                  END;
                  END;
        
        
                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                  GenJournalLine."Posting Date":=RunDate;
                  GenJournalLine.Description:='FD MATURITY - Transfer To Savings';
                  GenJournalLine.Amount:=-Account."Balance (LCY)";
                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                  GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                  GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                  IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;
        
                 */
        
        
                  //Post New
                  GenJournalLine.Reset;
                  GenJournalLine.SetRange("Journal Template Name",'PURCHASES');
                  GenJournalLine.SetRange("Journal Batch Name",'FXDEP');
                  if GenJournalLine.Find('-') then begin
                  Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJournalLine);
                  end;
        
                  //Post New
        
        
        
                  InterestBuffer.Reset;
                  InterestBuffer.SetRange(InterestBuffer."Account No",Account."No.");
                  if InterestBuffer.Find('-') then
                  InterestBuffer.ModifyAll(InterestBuffer.Transferred,true);
        
                  //Account."FD Maturity Date":=Account."FD Maturity Date";
                  Account."FD Maturity Date":=CalcDate(FDType.Duration,Account."FD Maturity Date");
                  Account."Fixed Deposit Status" := Account."fixed deposit status"::Closed;
                  Account.Modify;
                end;
              end;
            end;
          end;
        end;
        end;

    end;


    procedure CalculateFDInterest(Account: Record Vendor;RunDate: Date)
    begin
        InterestAmount:=0;
        //IntRate:=0;
                      //MESSAGE(FORMAT(Account."Fixed Deposit Type"));
        
        IntRate:=Account."Neg. Interest Rate";
        InterestBuffer.Reset;
        if InterestBuffer.Find('+') then
        IntBufferNo:=InterestBuffer.No;
        
        
        if AccountTypes.Get(Account."Account Type") then begin
          if AccountTypes."Fixed Deposit" = true then begin
             if FixedDepType.Get(Account."Fixed Deposit Type") then begin
                /*FDInterestCalc.RESET;
                FDInterestCalc.SETRANGE(FDInterestCalc.Code,Account."Fixed Deposit Type");
                IF FDInterestCalc.FIND('-') THEN BEGIN
                  Account.CALCFIELDS("Balance (LCY)");
                  REPEAT
                    IF (FDInterestCalc."Minimum Amount" <= Account."Balance (LCY)") AND
                    (Account."Balance (LCY)" <= FDInterestCalc."Maximum Amount") THEN
                      IntRate:=FDInterestCalc."Interest Rate";
                     // MESSAGE(FORMAT(IntRate));
                  UNTIL FDInterestCalc.NEXT = 0;
                END;*/
                //MESSAGE(FORMAT(Account."Balance (LCY)"));
                FDDays := CalcDate(FixedDepType.Duration,RunDate)-RunDate;
                InterestAmount := Account."Balance (LCY)"*IntRate*0.01*(FDDays/365);
                InterestAmount := ROUND(InterestAmount,1.0,'<');
        
        
        
                IntBufferNo:=IntBufferNo+1;
        
                InterestBuffer.Init;
                InterestBuffer."Account No":=Account."No.";
                InterestBuffer.No:= IntBufferNo;
                InterestBuffer."Account Type":=Account."Account Type";
                InterestBuffer."Interest Date":=RunDate;
                InterestBuffer."Interest Amount":=InterestAmount;
                //InterestBuffer."Interest Earning Balance" := Account."Balance (LCY)"; mutinda
                InterestBuffer.Description:='FD INT - '+Format(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');      //mutinda
                InterestBuffer.Description:=UpperCase(InterestBuffer.Description);
                InterestBuffer."User ID":=UserId;
                if InterestBuffer."Interest Amount" <> 0 then
                InterestBuffer.Insert(true);
             end;
          end;
        end;

    end;
}

