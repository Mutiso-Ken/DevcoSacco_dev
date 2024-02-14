#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516289 "Process Checkoff Distributed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Process Checkoff Distributed.rdlc';

    dataset
    {
        dataitem("Checkoff Lines-Distributed";"Checkoff Lines-Distributed")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                
                 if FundsUser.Get(UserId) then begin
                    FundsUser.TestField(FundsUser."Checkoff Template");
                    FundsUser.TestField(FundsUser."Checkoff Batch");
                    JTemplate:=FundsUser."Checkoff Template";
                    JBatch:=FundsUser."Checkoff Batch";
                    end;
                
                if RcptHeader.Get("Receipt Header No") then begin
                
                GenBatches.Reset;
                GenBatches.SetRange(GenBatches."Journal Template Name",JTemplate);
                GenBatches.SetRange(GenBatches.Name,JBatch);
                if GenBatches.Find('-') = false then begin
                GenBatches.Init;
                GenBatches."Journal Template Name":=JTemplate;
                GenBatches.Name:=JBatch;
                GenBatches.Description:='CHECKOFF PROCESSING';
                GenBatches.Validate(GenBatches."Journal Template Name");
                GenBatches.Validate(GenBatches.Name);
                GenBatches.Insert;
                end;
                
                /*
                //Morris post Employer Amount
                IF RcptHeader.GET("Receipt Header No") THEN BEGIN
                LineN:=LineN+10000;
                Gnljnline.INIT;
                Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
                Gnljnline."Account No.":=RcptHeader."Account No";
                Gnljnline.VALIDATE(Gnljnline."Account No.");
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:='Employer payment';
                Gnljnline.Amount:=RcptHeader.Amount;
                Gnljnline.VALIDATE(Gnljnline.Amount);
                Gnljnline."Bal. Account Type":=Gnljnline."Bal. Account Type"::"G/L Account";
                //Gnljnline."Bal. Account No.":='20845';
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                //Gnljnline."Shortcut Dimension 2 Code":='';
                //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                IF Gnljnline.Amount<>0 THEN
                Gnljnline.INSERT;
                END;
                //End Morris post Employer Amount
                */
                Cust.Reset;
                Cust.SetRange(Cust."No.","Checkoff Lines-Distributed"."Member No.");
                //Cust.SETRANGE(Cust."Company Code","Checkoff Lines-Distributed".DEPT);
                if Cust.Find('-') then begin
                /*IF "Checkoff Lines-Distributed"."Loan No."<>'' THEN BEGIN
                IF ("Checkoff Lines-Distributed"."Account type"='SINTEREST') OR
                ("Checkoff Lines-Distributed".Reference='INTEREST PAID')THEN BEGIN
                
                    LineN:=LineN+10000;
                    Gnljnline.INIT;
                    Gnljnline."Journal Template Name":=JTemplate;
                    Gnljnline."Journal Batch Name":=JBatch;
                    Gnljnline."Line No.":=LineN;
                    Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                    Gnljnline."Account No.":=Cust."No.";
                    Gnljnline.VALIDATE(Gnljnline."Account No.");
                    Gnljnline."Document No.":=RcptHeader."Document No";
                    Gnljnline."Posting Date":=RcptHeader."Posting date";
                    Gnljnline.Description:="Checkoff Lines-Distributed".Reference;
                    Gnljnline.Amount:=-1*"Checkoff Lines-Distributed".Amount;
                    Gnljnline.VALIDATE(Gnljnline.Amount);
                    Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                    Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Interest Paid";
                    Gnljnline."Bal. Account Type":=Gnljnline."Bal. Account Type"::"G/L Account";
                    //Gnljnline."Bal. Account No.":='20820';
                    //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");                      LOANS.RESET;
                    LOANS.SETCURRENTKEY(LOANS."Loan Product Type");
                    LOANS.SETRANGE(LOANS."Client Code","Checkoff Lines-Distributed"."Member No.");
                    LOANS.SETRANGE(LOANS."Loan Product Type","Checkoff Lines-Distributed"."Loan Type");
                    IF LOANS.FIND('-') THEN BEGIN
                    REPEAT
                    LOANS.CALCFIELDS( LOANS."Outstanding Balance");
                    IF LOANS."Outstanding Balance">0 THEN BEGIN
                     "Checkoff Lines-Distributed"."Loan No." :=LOANS."Loan  No.";
                     Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                      "Checkoff Lines-Distributed".MODIFY;
                    END;
                    UNTIL LOANS.NEXT=0;
                     END;
                    Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                    //Gnljnline."Shortcut Dimension 2 Code":='HAZINA';
                    //Gnljnline."Loan No":=LoanAppInt."Loan  No.";
                    IF Gnljnline.Amount<>0 THEN
                    Gnljnline.INSERT;
                END;
                END;
                
                IF "Checkoff Lines-Distributed"."Loan No."<>'' THEN BEGIN
                IF ("Checkoff Lines-Distributed"."Account type"='SLOAN')OR ("Checkoff Lines-Distributed".Reference='REPAYMENT') THEN BEGIN
                
                 LineN:=LineN+10000;
                 Gnljnline.INIT;
                 Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                 Gnljnline."Line No.":=LineN;
                 Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                 Gnljnline."Account No.":=Cust."No.";
                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                 Gnljnline."Document No.":=RcptHeader."Document No";
                 Gnljnline."Posting Date":=RcptHeader."Posting date";
                 Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                 Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                 Gnljnline.VALIDATE(Gnljnline.Amount);
                 Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::Repayment;
                 Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                 Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                 Gnljnline."Bal. Account Type":=Gnljnline."Bal. Account Type"::"G/L Account";
                 //Gnljnline."Bal. Account No.":='20820';
                 //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                 LOANS.RESET;
                 LOANS.SETCURRENTKEY(LOANS."Loan Product Type");
                 LOANS.SETRANGE(LOANS."Client Code","Checkoff Lines-Distributed"."Member No.");
                 LOANS.SETRANGE(LOANS."Loan Product Type","Loan Type");
                 IF LOANS.FIND('-') THEN BEGIN
                 REPEAT
                 LOANS.CALCFIELDS( LOANS."Outstanding Balance");
                 IF LOANS."Outstanding Balance">0 THEN BEGIN
                 "Checkoff Lines-Distributed"."Loan No." :=LOANS."Loan  No.";
                 Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                 "Checkoff Lines-Distributed".MODIFY;
                 END;
                 UNTIL LOANS.NEXT=0;
                 END;
                 IF Gnljnline.Amount<>0 THEN
                 Gnljnline.INSERT;
                END;
                 END;
                
                IF "Checkoff Lines-Distributed"."Loan No."='' THEN BEGIN
                IF ("Checkoff Lines-Distributed"."Account type"='SLOAN')OR ("Checkoff Lines-Distributed".Reference='REPAYMENT') THEN BEGIN
                
                 LineN:=LineN+10000;
                 Gnljnline.INIT;
                 Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                 Gnljnline."Line No.":=LineN;
                 Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                 Gnljnline."Account No.":=Cust."No.";
                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                 Gnljnline."Document No.":=RcptHeader."Document No";
                 Gnljnline."Posting Date":=RcptHeader."Posting date";
                 Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                 Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                 Gnljnline.VALIDATE(Gnljnline.Amount);
                 Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Unallocated Funds";
                 Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                 Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                 Gnljnline."Bal. Account Type":=Gnljnline."Bal. Account Type"::"G/L Account";
                
                 IF Gnljnline.Amount<>0 THEN
                 Gnljnline.INSERT;
                END;
                 END;
                 */
                
                if ("Checkoff Lines-Distributed"."Loan No."<>'') and ("Checkoff Lines-Distributed"."Transaction Type"<>"Checkoff Lines-Distributed"."transaction type"::"Interest Paid")   then begin
                 LineN:=LineN+10000;
                 Gnljnline.Init;
                 Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                 Gnljnline."Line No.":=LineN;
                 Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                 Gnljnline."Account No.":=Cust."No.";
                 Gnljnline.Validate(Gnljnline."Account No.");
                 Gnljnline."Document No.":=RcptHeader."Document No";
                 Gnljnline."Posting Date":=RcptHeader."Posting date";
                 Gnljnline.Description:='Loan Repayment';
                 Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                 Gnljnline.Validate(Gnljnline.Amount);
                 Gnljnline."Transaction Type":=Gnljnline."transaction type"::Repayment;
                 Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                 Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                 Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                 //Gnljnline."Bal. Account No.":='20820';
                 //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                 LOANS.Reset;
                 LOANS.SetCurrentkey(LOANS."Loan Product Type");
                 LOANS.SetRange(LOANS."Client Code","Checkoff Lines-Distributed"."Member No.");
                 LOANS.SetRange(LOANS."Loan Product Type","Loan Type");
                 if LOANS.Find('-') then begin
                 repeat
                 LOANS.CalcFields( LOANS."Outstanding Balance");
                 if LOANS."Outstanding Balance">0 then begin
                 "Checkoff Lines-Distributed"."Loan No." :=LOANS."Loan  No.";
                 Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                 "Checkoff Lines-Distributed".Modify;
                 end;
                 until LOANS.Next=0;
                 end;
                 if Gnljnline.Amount<>0 then
                 Gnljnline.Insert;
                end;
                
                
                
                if ("Checkoff Lines-Distributed"."Loan No."<>'') and ("Checkoff Lines-Distributed"."Transaction Type"="Checkoff Lines-Distributed"."transaction type"::"Interest Paid")  then begin
                 LineN:=LineN+10000;
                 Gnljnline.Init;
                 Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                 Gnljnline."Line No.":=LineN;
                 Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                 Gnljnline."Account No.":=Cust."No.";
                 Gnljnline.Validate(Gnljnline."Account No.");
                 Gnljnline."Document No.":=RcptHeader."Document No";
                 Gnljnline."Posting Date":=RcptHeader."Posting date";
                 Gnljnline.Description:='Interest Paid';
                 Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                 Gnljnline.Validate(Gnljnline.Amount);
                 Gnljnline."Transaction Type":=Gnljnline."transaction type"::"Interest Paid";
                 Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                 Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                 Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                 //Gnljnline."Bal. Account No.":='20820';
                 //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                 LOANS.Reset;
                 LOANS.SetCurrentkey(LOANS."Loan Product Type");
                 LOANS.SetRange(LOANS."Client Code","Checkoff Lines-Distributed"."Member No.");
                 LOANS.SetRange(LOANS."Loan Product Type","Loan Type");
                 if LOANS.Find('-') then begin
                 repeat
                 LOANS.CalcFields( LOANS."Outstanding Balance");
                 if LOANS."Outstanding Balance">0 then begin
                 "Checkoff Lines-Distributed"."Loan No." :=LOANS."Loan  No.";
                 Gnljnline."Loan No":="Checkoff Lines-Distributed"."Loan No.";
                 "Checkoff Lines-Distributed".Modify;
                 end;
                 until LOANS.Next=0;
                 end;
                 if Gnljnline.Amount<>0 then
                 Gnljnline.Insert;
                end;
                
                if ("Checkoff Lines-Distributed"."Account type"='939') or ("Checkoff Lines-Distributed"."Transaction Type"="Checkoff Lines-Distributed"."transaction type"::" ") or
                   ("Checkoff Lines-Distributed".Reference='377')then begin
                LineN:=LineN+10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                Gnljnline."Account No.":=Cust."No.";
                Gnljnline.Validate(Gnljnline."Account No.");
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:='Deposit Contribution';
                Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                //Gnljnline."Bal. Account No.":='20845';
                Gnljnline."Transaction Type":=Gnljnline."transaction type"::"Deposit Contribution";
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                //Gnljnline."Shortcut Dimension 2 Code":='';
                //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                if Gnljnline.Amount<>0 then
                Gnljnline.Insert;
                end;
                
                if ("Checkoff Lines-Distributed"."Account type"='939') or ("Checkoff Lines-Distributed"."Transaction Type"="Checkoff Lines-Distributed"."transaction type"::"SchFees Shares") or
                   ("Checkoff Lines-Distributed".Reference='38J')then begin
                LineN:=LineN+10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                Gnljnline."Account No.":=Cust."No.";
                Gnljnline.Validate(Gnljnline."Account No.");
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:='School Shares Contribution';
                Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                //Gnljnline."Bal. Account No.":='20850';
                //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                Gnljnline."Transaction Type":=Gnljnline."transaction type"::"COOP Shares";
                Gnljnline."Shortcut Dimension 1 Code":='FOSA';
                Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
                if Gnljnline.Amount<>0 then
                Gnljnline.Insert;
                end;
                BAmount:=0;
                Bcount:=0;
                          RcptLine.Reset;
                          RcptLine.SetRange(RcptLine."Member No.","Member No.");
                          //Cust.SETRANGE(Cust."Company Code","Checkoff Lines-Distributed".DEPT);
                          if RcptLine.Find('-') then begin
                          repeat
                          if RcptLine."Account type"='BBF' then begin
                          Bcount:=Bcount+1;
                
                          end;
                          until RcptLine.Next=0;
                          end;
                          //MESSAGE('Bcount %1',Bcount);
                if ("Checkoff Lines-Distributed"."Account type"='WCONT')  then begin
                     BAmount:="Checkoff Lines-Distributed".Amount;
                
                
                
                          //MESSAGE('Bcount %1',Bcount);
                      if Bcount <= 0 then begin
                        LineN:=LineN+10000;
                        Gnljnline.Init;
                        Gnljnline."Journal Template Name":=JTemplate;
                        Gnljnline."Journal Batch Name":=JBatch;
                        Gnljnline."Line No.":=LineN;
                        Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                        Gnljnline."Account No.":=Cust."No.";
                        Gnljnline.Validate(Gnljnline."Account No.");
                        Gnljnline."Document No.":=RcptHeader."Document No";
                        Gnljnline."Posting Date":=RcptHeader."Posting date";
                        Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                        Gnljnline.Amount:=200*-1;
                        Gnljnline.Validate(Gnljnline.Amount);
                        Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                        //Gnljnline."Bal. Account No.":='20850';
                        //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                        Gnljnline."Transaction Type":=Gnljnline."transaction type"::"Benevolent Fund";
                        Gnljnline."Shortcut Dimension 1 Code":='FOSA';
                        Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
                        if Gnljnline.Amount<>0 then
                        Gnljnline.Insert;
                        BAmount:=BAmount-(Gnljnline.Amount*-1);
                
                
                        LineN:=LineN+10000;
                        Gnljnline.Init;
                        Gnljnline."Journal Template Name":=JTemplate;
                        Gnljnline."Journal Batch Name":=JBatch;
                        Gnljnline."Line No.":=LineN;
                        Gnljnline."Account Type":=Gnljnline."account type"::Vendor;
                        Gnljnline."Account No.":=Cust."FOSA Account";
                        Gnljnline.Validate(Gnljnline."Account No.");
                        Gnljnline."Document No.":=RcptHeader."Document No";
                        Gnljnline."Posting Date":=RcptHeader."Posting date";
                        Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                        Gnljnline.Amount:=BAmount*-1;
                        Gnljnline.Validate(Gnljnline.Amount);
                        Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                        //Gnljnline."Bal. Account No.":='20850';
                        //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                        //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Contribution";
                        Gnljnline."Shortcut Dimension 1 Code":='FOSA';
                        Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
                        if Gnljnline.Amount<>0 then
                        Gnljnline.Insert;
                        end else begin
                
                        LineN:=LineN+10000;
                        Gnljnline.Init;
                        Gnljnline."Journal Template Name":=JTemplate;
                        Gnljnline."Journal Batch Name":=JBatch;
                        Gnljnline."Line No.":=LineN;
                        Gnljnline."Account Type":=Gnljnline."account type"::Vendor;
                        Gnljnline."Account No.":=Cust."FOSA Account";
                        Gnljnline.Validate(Gnljnline."Account No.");
                        Gnljnline."Document No.":=RcptHeader."Document No";
                        Gnljnline."Posting Date":=RcptHeader."Posting date";
                        Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                        Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                        Gnljnline.Validate(Gnljnline.Amount);
                        Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                        //Gnljnline."Bal. Account No.":='20850';
                        //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                        //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Contribution";
                        Gnljnline."Shortcut Dimension 1 Code":='FOSA';
                        Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
                        if Gnljnline.Amount<>0 then
                        Gnljnline.Insert;
                
                end;
                end;
                
                if ("Checkoff Lines-Distributed"."Account type"='SJOINING') or ("Checkoff Lines-Distributed"."Account type"='0') then begin
                LineN:=LineN+10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name":=JTemplate;
                Gnljnline."Journal Batch Name":=JBatch;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                Gnljnline."Account No.":=Cust."No.";
                Gnljnline.Validate(Gnljnline."Account No.");
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                //Gnljnline."Bal. Account No.":='20880';
                //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                Gnljnline."Transaction Type":=Gnljnline."transaction type"::"Registration Fee";
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                //Gnljnline."Shortcut Dimension 2 Code":='';
                if Gnljnline.Amount<>0 then
                Gnljnline.Insert;
                //END;
                end;
                
                if ("Checkoff Lines-Distributed"."Account type"='hld') or ("Checkoff Lines-Distributed"."Account type"='3') or
                   ("Checkoff Lines-Distributed".Reference='INVESTMENT') or ("Checkoff Lines-Distributed".Reference='INVEST') then begin
                LineN:=LineN+10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name":=JTemplate;
                Gnljnline."Journal Batch Name":=JBatch;
                Gnljnline."Line No.":=LineN;
                //>Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
                //>Gnljnline."Account No.":=Cust."No.";
                Vend.Reset;
                Vend.SetRange(Vend."ID No.",Cust."ID No.");
                Vend.SetFilter(Vend."Account Type",'506');
                if Vend.Find('-') then begin
                repeat
                Gnljnline."Account Type":=Gnljnline."account type"::Vendor;
                Gnljnline.Validate(Gnljnline."Account No.",Vend."No.");
                Gnljnline."Shortcut Dimension 1 Code":='FOSA';
                until Vend.Next=0;
                end;
                
                if Gnljnline."Account No." = '' then begin
                Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                Gnljnline.Validate(Gnljnline."Account No.",Cust."No.");
                Gnljnline."Transaction Type":=Gnljnline."transaction type"::Executive;
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                end;
                
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:="Checkoff Lines-Distributed".Reference;
                Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                //Gnljnline."Bal. Account No.":='20915';
                //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                //Gnljnline."Shortcut Dimension 2 Code":='';
                if Gnljnline.Amount<>0 then
                Gnljnline.Insert;
                //END;
                end;
                
                
                if  ("Checkoff Lines-Distributed"."Account type"='2') then begin
                LineN:=LineN+10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                Gnljnline."Account No.":=Cust."No.";
                Gnljnline.Validate(Gnljnline."Account No.");
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                //Gnljnline."Bal. Account No.":='20915';
                ////Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                Gnljnline."Transaction Type":=Gnljnline."transaction type"::"Deposit Contribution";
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                //Gnljnline."Shortcut Dimension 2 Code":='';
                if Gnljnline.Amount<>0 then
                Gnljnline.Insert;
                end;
                
                
                if  ("Checkoff Lines-Distributed"."Account type"='20') then begin
                LineN:=LineN+10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                Gnljnline."Account No.":=Cust."No.";
                Gnljnline.Validate(Gnljnline."Account No.");
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                Gnljnline.Amount:="Checkoff Lines-Distributed".Amount;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Bal. Account Type":=Gnljnline."bal. account type"::"G/L Account";
                Gnljnline."Bal. Account No.":='20320';
                Gnljnline.Validate(Gnljnline."Bal. Account No.");
                Gnljnline."Transaction Type":=Gnljnline."transaction type"::Dividend;
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                if Gnljnline.Amount<>0 then
                Gnljnline.Insert;
                end;
                
                //EXCESS POSTING  LOANS it excludes othe trasactions other that loan and interest
                if "Checkoff Lines-Distributed"."Loan No."='' then begin
                if ("Checkoff Lines-Distributed".Reference='SLOAN')or ("Checkoff Lines-Distributed".Reference='REPAYMENT') or ("Checkoff Lines-Distributed".Reference='SINTEREST')
                or ("Checkoff Lines-Distributed".Reference='INTEREST PAID') then begin
                LineN:=LineN+10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."account type"::Customer;
                Gnljnline."Account No.":="Checkoff Lines-Distributed"."Member No.";
                Gnljnline.Validate(Gnljnline."Account No.");
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:="Checkoff Lines-Distributed".Reference;;
                Gnljnline.Amount:="Checkoff Lines-Distributed".Amount*-1;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Transaction Type":=Gnljnline."transaction type"::"Unallocated Funds";
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                if Gnljnline.Amount<>0 then
                Gnljnline.Insert;
                end;
                end;
                
                end else begin
                
                 "Checkoff Lines-Distributed"."Staff Not Found":=true;
                 "Checkoff Lines-Distributed".Modify;
                end;
                
                end;
                
                /*UNTIL RcptLine.NEXT=0;
                END;*/

            end;

            trigger OnPostDataItem()
            begin
                //Balance With Employer Debtor
                LineN:=LineN+10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name":=JTemplate;
                 Gnljnline."Journal Batch Name":=JBatch;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=RcptHeader."Account Type";
                Gnljnline."Account No.":=RcptHeader."Account No";
                Gnljnline.Validate(Gnljnline."Account No.");
                Gnljnline."Document No.":=RcptHeader."Document No";
                Gnljnline."Posting Date":=RcptHeader."Posting date";
                Gnljnline.Description:=RcptHeader.Remarks;
                Gnljnline.Amount:=RcptHeader.Amount;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                if Gnljnline.Amount<>0 then
                Gnljnline.Insert;
            end;

            trigger OnPreDataItem()
            begin
                  if FundsUser.Get(UserId) then begin
                    FundsUser.TestField(FundsUser."Checkoff Template");
                    FundsUser.TestField(FundsUser."Checkoff Batch");
                    JTemplate:=FundsUser."Checkoff Template";
                    JBatch:=FundsUser."Checkoff Batch";
                    end;
                //delete journal line
                Gnljnline.Reset;
                Gnljnline.SetRange("Journal Template Name",JTemplate);
                Gnljnline.SetRange("Journal Batch Name",JBatch);
                Gnljnline.DeleteAll;
                //end of deletion
                
                RunBal:=0;
                
                "Checkoff Lines-Distributed".ModifyAll("Checkoff Lines-Distributed"."Staff Not Found",false);
                /*
                IF RcptHeader."Document No" = '' THEN
                ERROR('Please specify the document No.');
                
                IF RcptHeader."Posting date" =0D THEN
                ERROR('Please specify the Posting date');
                */
                GenSetUp.Get(0);
                //Userid1:=USERID;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Gnljnline: Record "Gen. Journal Line";
        Cust: Record Customer;
        LoanApp: Record "Loans Register";
        LoanType: Record "Loan Products Setup";
        RunBal: Decimal;
        PDate: Date;
        DocNo: Code[20];
        InvCont: Decimal;
        InvMonthCont: Decimal;
        FDate: Date;
        LineN: Integer;
        Repayment: Decimal;
        Interest: Decimal;
        LoanRBal: Decimal;
        LCount: Integer;
        LRepayment: Decimal;
        LType: Text[30];
        RegFee: Decimal;
        SharesBal: Decimal;
        LoanAppInt: Record "Loans Register";
        datefilter1: Text[30];
        MaxDate: Date;
        LoanInt2: Record "Loans Register";
        PeriodInterest: Decimal;
        ShRec: Decimal;
        TotalRepay: Decimal;
        PType: Option " ","SARF & Super SARF","Less IPO";
        GenSetUp: Record "Sacco General Set-Up";
        MinShares: Decimal;
        LoanP: Record "Loan Products Setup";
        UnderpaidLoan: Decimal;
        Trans: Record Transactions;
        IntDateFilter: Text[150];
        LoanIntR: Record "Loans Register";
        IntRev: Decimal;
        AccNo: Code[20];
        PrepaidRemi: Record "Bosa Loan Clearances";
        "HFCKcontrib.": Decimal;
        LOANS: Record "Loans Register";
        Employees: Record "Checkoff Header-Distributed";
        Vend: Record Vendor;
        RcptBufID: Code[20];
        VendFound: Boolean;
        RcptHeader: Record "Checkoff Header-Distributed";
        RcptLine: Record "Checkoff Lines-Distributed";
        GenBatches: Record "Gen. Journal Batch";
        Bcount: Integer;
        BAmount: Decimal;
        FundsUser: Record "Funds User Setup";
        JTemplate: Text;
        JBatch: Text;
}

