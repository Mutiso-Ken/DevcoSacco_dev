#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
table 51516016 "Loans Register Import"
{
    DrillDownPageID = "Loans Posted List";
    LookupPageID = "Loans Posted List";


    fields
    {
        field(1; "Loan  No."; Code[30])
        {

        }
        field(2; "Application Date"; Date)
        {

        }
        field(3; "Loan Product Type"; Code[20])
        {
     
        }
        field(4; "Client Code"; Code[50])
        {
     
        }
        field(5; "Group Code"; Code[20])
        {
        }
        field(6; Savings; Decimal)
        {
            Editable = false;
        }
        field(7; "Existing Loan"; Decimal)
        {
            Editable = false;
        }
        field(8; "Requested Amount"; Decimal)
        {

        }
        field(9; "Approved Amount"; Decimal)
        {
        
        }
        field(16; Interest; Decimal)
        {

        }
        field(17; Insurance; Decimal)
        {
          
        }
        field(21; "Source of Funds"; Code[20])
        {
         
        }
        field(22; "Client Cycle"; Integer)
        {
          
        }
        field(26; "Client Name"; Text[80])
        {
            Editable = true;
        }
        field(27; "Loan Status"; Option)
        {
            OptionMembers = Application,Appraisal,Rejected,Approved,Issued;

            trigger OnValidate()
            begin

            end;
        }
        field(29; "Issued Date"; Date)
        {

           
        }
        field(30; Installments; Integer)
        {

        }
        field(34; "Loan Disbursement Date"; Date)
        {

        }
        field(35; "Mode of Disbursement"; Option)
        {
            OptionCaption = ' ,Cheque,Transfer To FOSA,EFT,RTGS,Cheque NonMember,FOSA Loans,Individual Cheques';
            OptionMembers = " ",Cheque,"Bank Transfer",EFT,RTGS,"Cheque NonMember","FOSA Loans","Individual Cheques";

        }
        field(53; "Affidavit - Item 1 Details"; Text[100])
        {
        }
        field(54; "Affidavit - Estimated Value 1"; Decimal)
        {
        }
        field(55; "Affidavit - Item 2 Details"; Text[100])
        {
        }
        field(56; "Affidavit - Estimated Value 2"; Decimal)
        {
        }
        field(57; "Affidavit - Item 3 Details"; Text[100])
        {
        }
        field(58; "Affidavit - Estimated Value 3"; Decimal)
        {
        }
        field(59; "Affidavit - Item 4 Details"; Text[100])
        {
        }
        field(60; "Affidavit - Estimated Value 4"; Decimal)
        {
        }
        field(61; "Affidavit - Item 5 Details"; Text[100])
        {
        }
        field(62; "Affidavit - Estimated Value 5"; Decimal)
        {
        }
        field(63; "Magistrate Name"; Text[30])
        {
        }
        field(64; "Date for Affidavit"; Date)
        {
        }
        field(65; "Name of Chief/ Assistant"; Text[30])
        {
        }
        field(66; "Affidavit Signed?"; Boolean)
        {
        }
        field(67; "Date Approved"; Date)
        {
        }
        field(53048; "Grace Period"; DateFormula)
        {
        }
        field(53049; "Instalment Period"; DateFormula)
        {
        }
        field(53050; Repayment; Decimal)
        {

            
        }
        field(53051; "Pays Interest During GP"; Boolean)
        {
        }
        field(53053; "Percent Repayments"; Decimal)
        {
            Editable = false;
        }
        field(53054; "Paying Bank Account No"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(53055; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(53056; "Loan Product Type Name"; Text[100])
        {
        }
        field(53057; "Cheque Number"; Code[20])
        {

        }
        field(53058; "Bank No"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Bank Account"."No.";
        }
        field(53059; "Slip Number"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(53060; "Total Paid"; Decimal)
        {
            FieldClass = FlowFilter;
        }
        field(53061; "Schedule Repayments"; Decimal)
        {
           
        }
        field(53062; "Doc No Used"; Code[20])
        {
        }
        field(53063; "Posting Date"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(53065; "Batch No."; Code[20])
        {
       
        }
        field(53066; "Edit Interest Rate"; Boolean)
        {
        }
        field(53067; Posted; Boolean)
        {
            Editable = true;
        }
        field(53068; "Product Code"; Code[20])
        {
            
        }
        field(53077; "Document No 2 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(53078; "Field Office"; Code[20])
        {
        }
        field(53079; Dimension; Code[20])
        {
        }
        field(53080; "Amount Disbursed"; Decimal)
        {
        }
        field(53081; "Fully Disbursed"; Boolean)
        {
        }
        field(53082; "New Interest Rate"; Decimal)
        {
            Editable = false;
        }
        field(53083; "New No. of Instalment"; Integer)
        {
            Editable = false;
        }
        field(53084; "New Grace Period"; DateFormula)
        {
            Editable = false;
        }
        field(53085; "New Regular Instalment"; DateFormula)
        {
            Editable = false;
        }
        field(53086; "Loan Balance at Rescheduling"; Decimal)
        {
            Editable = false;
        }
        field(53087; "Loan Reschedule"; Boolean)
        {
        }
        field(53088; "Date Rescheduled"; Date)
        {
        }
        field(53089; "Reschedule by"; Code[20])
        {
        }
        field(53090; "Flat Rate Principal"; Decimal)
        {
        }
        field(53091; "Flat rate Interest"; Decimal)
        {
        }
        field(53092; "Total Repayment"; Decimal)
        {
         
        }
        field(53093; "Interest Calculation Method"; Option)
        {
            OptionMembers = ,"No Interest","Flat Rate","Reducing Balances";
        }
        field(53094; "Edit Interest Calculation Meth"; Boolean)
        {
        }
        field(53095; "Balance BF"; Decimal)
        {
        }
        field(53098; "Interest to be paid"; Decimal)
        {
            
        }
        field(53099; "Date filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(53101; "Cheque Date"; Date)
        {
        }
        field(53102; "Outstanding Balance"; Decimal)
        {
           
        }
        field(53103; "Loan to Share Ratio"; Decimal)
        {
        }
        field(53104; "Shares Balance"; Decimal)
        {
            Editable = false;
        }
        field(53105; "Max. Installments"; Integer)
        {
            Editable = false;
        }
        field(53106; "Max. Loan Amount"; Decimal)
        {
            Editable = false;
        }
        field(53107; "Loan Cycle"; Integer)
        {
            Editable = false;
        }
        field(53108; "Penalty Charged"; Decimal)
        {
           
        }
        field(53109; "Loan Amount"; Decimal)
        {
         
        }
        field(53110; "Current Shares"; Decimal)
        {
           
        }
        field(53111; "Loan Repayment"; Decimal)
        {
          
        }
        field(53112; "Repayment Method"; Option)
        {
            OptionMembers = Amortised,"Reducing Balance","Straight Line",Constants;

            
        }
        field(53113; "Grace Period - Principle (M)"; Integer)
        {

           
        }
        field(53114; "Grace Period - Interest (M)"; Integer)
        {
        }
        field(53115; Adjustment; Text[100])
        {
        }
        field(53116; "Payment Due Date"; Text[100])
        {
        }
        field(53117; "Tranche Number"; Integer)
        {
        }
        field(53118; "Amount Of Tranche"; Decimal)
        {
        }
        field(53119; "Total Disbursment to Date"; Decimal)
        {
        }
        field(53133; "Copy of ID"; Boolean)
        {
        }
        field(53134; Contract; Boolean)
        {
        }
        field(53135; Payslip; Boolean)
        {
        }
        field(53136; "Contractual Shares"; Decimal)
        {
        }
        field(53182; "Last Pay Date"; Date)
        {
            
        }
        field(53183; "Interest Due"; Decimal)
        {
           
        }
        field(53184; "Appraisal Status"; Option)
        {
            OptionCaption = 'Expresion of Interest,Desk Appraisal,Loan form purchased,Loan Officer Approved,Management Approved,Credit Subcommitee Approved,Trust Board Approved';
            OptionMembers = "Expresion of Interest","Desk Appraisal","Loan form purchased","Loan Officer Approved","Management Approved","Credit Subcommitee Approved","Trust Board Approved";

        }
        field(53185; "Interest Paid"; Decimal)
        {
            
        }
        field(53186; "Penalty Paid"; Decimal)
        {
           
        }
        field(53187; "Application Fee Paid"; Decimal)
        {
          
        }
        field(53188; "Appraisal Fee Paid"; Decimal)
        {
        
        }
        field(53189; "Global Dimension 1 Code"; Code[20])
        {
           
        }
        field(53190; "Repayment Start Date"; Date)
        {
        }
        field(53191; "Installment Including Grace"; Integer)
        {

            trigger OnValidate()
            begin
              
            end;
        }
        field(53192; "Schedule Repayment"; Decimal)
        {
           
        }
        field(53193; "Schedule Interest"; Decimal)
        {
          
        }
        field(53194; "Interest Debit"; Decimal)
        {
           
        }
        field(53195; "Schedule Interest to Date"; Decimal)
        {
           
        }
        field(53196; "Repayments BF"; Decimal)
        {
        }
        field(68000; "Account No"; Code[20])
        {
            
         
        }
        field(68001; "BOSA No"; Code[20])
        {
        }
        field(68002; "Staff No"; Code[20])
        {

        }
        field(68003; "BOSA Loan Amount"; Decimal)
        {
        }
        field(68004; "Top Up Amount"; Decimal)
        {
          
        }
        field(68005; "Loan Received"; Boolean)
        {
        }
        field(68006; "Period Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(68007; "Current Repayment"; Decimal)
        {
           
        }
        field(68008; "Oustanding Interest"; Decimal)
        {
          
        }
        field(68009; "Oustanding Interest to Date"; Decimal)
        {
          
        }
        field(68010; "Current Interest Paid"; Decimal)
        {
           
        }
        field(68011; "Document No. Filter"; Code[100])
        {
            FieldClass = FlowFilter;
        }
        field(68012; "Cheque No."; Code[20])
        {

        }
        field(68013; "Personal Loan Off-set"; Decimal)
        {
        }
        field(68014; "Old Account No."; Code[20])
        {
        }
        field(68015; "Loan Principle Repayment"; Decimal)
        {

            trigger OnValidate()
            begin
              
            end;
        }
        field(68016; "Loan Interest Repayment"; Decimal)
        {
        }
        field(68017; "Contra Account"; Code[20])
        {
        }
        field(68018; "Transacting Branch"; Code[20])
        {
        }
        field(68019; Source; Enum LoanSourcesEnum)
        {

        }
        field(68020; "Net Income"; Decimal)
        {
        }
        field(68021; "No. Of Guarantors"; Integer)
        {
          
        }
        field(68022; "Total Loan Guaranted"; Decimal)
        {
          
        }
        field(68023; "Shares Boosted"; Boolean)
        {
        }
        field(68024; "Basic Pay"; Decimal)
        {

            
        }
        field(68025; "House Allowance"; Decimal)
        {

           
        }
        field(68026; "Other Allowance"; Decimal)
        {

           
        }
        field(68027; "Total Deductions"; Decimal)
        {

            
        }
        field(68028; "Cleared Effects"; Decimal)
        {

        }
        field(68029; Remarks; Text[60])
        {
        }
        field(68030; Advice; Boolean)
        {
        }
        field(68031; "Special Loan Amount"; Decimal)
        {
            
        }
        field(68032; "Bridging Loan Posted"; Boolean)
        {
        }
        field(68033; "BOSA Loan No."; Code[20])
        {
        }
        field(68034; "Previous Repayment"; Decimal)
        {
        }
        field(68035; "No Loan in MB"; Boolean)
        {
        }
        field(68036; "Recovered Balance"; Decimal)
        {
        }
        field(68037; "Recon Issue"; Boolean)
        {
        }
        field(68038; "Loan Purpose"; Code[20])
        {
            TableRelation = "Loans Purpose".Code;
        }
        field(68039; Reconciled; Boolean)
        {
        }
        field(68040; "Appeal Amount"; Decimal)
        {

          
        }
        field(68041; "Appeal Posted"; Boolean)
        {
        }
        field(68042; "Project Amount"; Decimal)
        {

        }
        field(68043; "Project Account No"; Code[20])
        {
        
        }
        field(68044; "Location Filter"; Integer)
        {
           
        }
        field(68045; "Other Commitments Clearance"; Decimal)
        {
          
        }
        field(68046; "Discounted Amount"; Decimal)
        {
            Editable = false;
        }
        field(68047; "Transport Allowance"; Decimal)
        {

          
        }
        field(68048; "Mileage Allowance"; Decimal)
        {

        }
        field(68049; "System Created"; Boolean)
        {
        }
        field(68050; "Boosting Commision"; Decimal)
        {
        }
        field(68051; "Voluntary Deductions"; Decimal)
        {
        }
        field(68052; "4 % Bridging"; Boolean)
        {

        }
        field(68053; "No. Of Guarantors-FOSA"; Integer)
        {
        }
        field(68054; Defaulted; Boolean)
        {
        }
        field(68055; "Bridging Posting Date"; Date)
        {
        }
        field(68056; "Commitements Offset"; Decimal)
        {
        }
        field(68057; Gender; Option)
        {
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(68058; "Captured By"; Code[50])
        {
        }
        field(68059; "Branch Code"; Code[20])
        {
           
        }
        field(68060; "Recovered From Guarantor"; Boolean)
        {
        }
        field(68061; "Guarantor Amount"; Decimal)
        {
        }
        field(68062; "External EFT"; Boolean)
        {

            trigger OnValidate()
            begin


            end;
        }
        field(68063; "Defaulter Overide Reasons"; Text[150])
        {
        }
        field(68064; "Defaulter Overide"; Boolean)
        {

            trigger OnValidate()
            begin


            end;
        }
        field(68065; "Last Interest Pay Date"; Date)
        {
        
        }
        field(68066; "Other Benefits"; Decimal)
        {

        }
        field(68067; "Recovered Loan"; Code[20])
        {
        }
        field(68068; "1st Notice"; Date)
        {
        }
        field(68069; "2nd Notice"; Date)
        {
        }
        field(68070; "Final Notice"; Date)
        {
        }
        field(68071; "Outstanding Balance to Date"; Decimal)
        {
          
        }
        field(68072; "Last Advice Date"; Date)
        {
        }
        field(68073; "Advice Type"; Option)
        {
            OptionMembers = " ","Fresh Loan",Adjustment,Reintroduction,Stoppage,"Top Up";
        }
        field(68074; "Current Location"; Code[50])
        {
         
        }
        field(68090; "Compound Balance"; Decimal)
        {
        }
        field(68091; "Repayment Rate"; Decimal)
        {
        }
        field(68092; "Exp Repay"; Decimal)
        {
            FieldClass = Normal;
        }
        field(68093; "ID NO"; Code[40])
        {

            trigger OnValidate()
            begin


            end;
        }
        field(68094; RAmount; Decimal)
        {
        }
        field(68095; "Employer Code"; Code[50])
        {
        }
        field(68096; "Last Loan Issue Date"; Date)
        {
          
        }
        field(68097; "Lst LN1"; Boolean)
        {
        }
        field(68098; "Lst LN2"; Boolean)
        {
        }
        field(68099; "Last loan"; Code[20])
        {
            FieldClass = Normal;
        }
        field(69000; "Loans Category"; Option)
        {
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = Perfoming,Watch,Substandard,Doubtful,Loss;
        }
        field(69001; "Loans Category-SASRA"; Enum LoansCategorySASRA)
        {

        }
        field(69002; "Bela Branch"; Code[10])
        {
        }
        field(69003; "Net Amount"; Decimal)
        {
        }
        field(69004; "Bank code"; Code[10])
        {

        }
        field(69005; "Bank Name"; Text[150])
        {
        }
        field(69006; "Bank Branch"; Text[120])
        {
        }
        field(69007; "Outstanding Loan"; Decimal)
        {
        
        }
        field(69008; "Loan Count"; Integer)
        {
        
        }
        field(69009; "Repay Count"; Integer)
        {
         
        }
        field(69010; "Outstanding Loan2"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Client Code"),
                                                                  "Posting Date" = field("Date filter"),
                                                                  Amount = field("Approved Amount")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(69011; "Topup Loan No"; Code[20])
        {
            CalcFormula = lookup("Loan Offset Details"."Loan No." where("Loan Top Up" = field("Loan  No."),
                                                                         "Client Code" = field("Client Code")));
            FieldClass = FlowField;
        }
        field(69012; Defaulter; Boolean)
        {
        }
        field(69013; DefaulterInfo; Text[50])
        {
        }
        field(69014; "Total Earnings(Salary)"; Decimal)
        {
            FieldClass = Normal;
        }
        field(69015; "Total Deductions(Salary)"; Decimal)
        {
            FieldClass = Normal;
        }
        field(69016; "Share Purchase"; Decimal)
        {
        }
        field(69017; "Product Currency Code"; Code[30])
        {
            TableRelation = Currency;
        }
        field(69018; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(69019; "Amount Disburse"; Decimal)
        {
        }
        field(69020; Prepayments; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Client Code"),
                                                                  "Transaction Type" = filter("Administration Fee"),
                                                                  "Loan No" = field("Loan  No."),
                                                                  "Posting Date" = field("Date filter"),
                                                                  "Document No." = field("Document No. Filter")));
            FieldClass = FlowField;
        }
        field(69021; "Appln. between Currencies"; Option)
        {
            Caption = 'Appln. between Currencies';
            OptionCaption = 'None,EMU,All';
            OptionMembers = "None",EMU,All;
        }
        field(69022; "Expected Date of Completion"; Date)
        {
        }
        field(69023; "Total Schedule Repayment"; Decimal)
        {
            CalcFormula = sum("Loan Repayment Schedule"."Monthly Repayment" where("Loan No." = field("Loan  No.")));
            FieldClass = FlowField;
        }
        field(69024; "Recovery Mode"; Option)
        {
            OptionCaption = 'Checkoff,Standing Order,Salary,Pension,Direct Debits,Tea,Milk,Tea Bonus,Dividend';
            OptionMembers = Checkoff,"Standing Order",Salary,Pension,"Direct Debits",Tea,Milk,"Tea Bonus",Dividend;
        }
        field(69025; "Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Monthly,Quaterly';
            OptionMembers = Daily,Weekly,Monthly,Quaterly;

            trigger OnValidate()
            begin
                if "Repayment Frequency" = "repayment frequency"::Daily then
                    Evaluate("Instalment Period", '1D')
                else
                    if "Repayment Frequency" = "repayment frequency"::Weekly then
                        Evaluate("Instalment Period", '1W')
                    else
                        if "Repayment Frequency" = "repayment frequency"::Monthly then
                            Evaluate("Instalment Period", '1M')
                        else
                            if "Repayment Frequency" = "repayment frequency"::Quaterly then
                                Evaluate("Instalment Period", '1Q');
            end;
        }
        field(69026; "Approval Status"; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(69027; "Old Vendor No"; Code[20])
        {
        }
        field(69028; "Insurance 0.25"; Decimal)
        {
        }
        field(69029; "Total TopUp Commission"; Decimal)
        {
            FieldClass = Normal;
        }
        field(69030; "Total loan Outstanding"; Decimal)
        {
            FieldClass = Normal;
        }
        field(69031; "Monthly Shares Cont"; Decimal)
        {
        }
        field(69032; "Insurance On Shares"; Decimal)
        {
        }
        field(69033; "Total Loan Repayment"; Decimal)
        {
            CalcFormula = sum("Loans Register"."Loan Principle Repayment" where("Client Code" = field("Client Code"),
                                                                                 "Outstanding Balance" = filter(> 1)));
            FieldClass = FlowField;
        }
        field(69034; "Total Loan Interest"; Decimal)
        {
            CalcFormula = sum("Loans Register"."Loan Interest Repayment" where("Client Code" = field("Client Code"),
                                                                                "Outstanding Balance" = filter(> 1)));
            FieldClass = FlowField;
        }
        field(69035; "Net Payment to FOSA"; Decimal)
        {
        }
        field(69036; "Processed Payment"; Boolean)
        {
        }
        field(69037; "Date payment Processed"; Date)
        {
        }
        field(69038; "Attached Amount"; Decimal)
        {
        }
        field(69039; PenaltyAttached; Decimal)
        {
        }
        field(69040; InDueAttached; Decimal)
        {
        }
        field(69041; Attached; Boolean)
        {
        }
        field(69042; "Advice Date"; Date)
        {
        }
        field(69043; "Attachement Date"; Date)
        {
        }
        field(69044; "Total Loans Outstanding"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Client Code"),
                                                                  "Transaction Type" = filter(Loan | Repayment),
                                                                  "Loan Type" = filter(<> 'ADV' | 'ASSET' | 'B/L' | 'FL' | 'IPF')));
            FieldClass = FlowField;
        }
        field(69045; "Jaza Deposits"; Decimal)
        {

            trigger OnValidate()
            begin

                //LoanType.GET("Loan Product Type");
                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Client Code", "Client Code");
                if LoanApp.Find('-') then begin
                    Mdep := "Member Deposits" * 3;
                    Message('Member Deposits *3 is %1', Mdep);

                    if "Jaza Deposits" > Mdep then
                        Error('Jaza deposits can not be more than 3 times the deposits');

                    //"Jaza Deposits":=ROUND(Mdep,1,'<' );
                    if "Jaza Deposits" > Mdep then
                        "Jaza Deposits" := Mdep
                    else
                        "Jaza Deposits" := "Jaza Deposits"

                end;
                Modify;

                if LoanTyped.Get("Loan Product Type") then begin
                    if "Jaza Deposits" > LoanTyped."Jaza Max Boosting Amount" then begin
                        Error('Amount Entered is Greater than recommended Max. Jaza Deposits of %1', LoanTyped."Jaza Max Boosting Amount");
                    end;
                end;
                if LoanTyped.Get("Loan Product Type") then begin
                    if "Jaza Deposits" < LoanTyped."Jaza Min Boosting Amount" then begin
                        Error('Amount Entered is Less than recommended Min. Jaza Deposits of %1', LoanTyped."Jaza Min Boosting Amount");
                    end;
                end;
                PCharges.Reset;
                PCharges.SetRange(PCharges."Product Code", "Loan Product Type");
                if PCharges.Find('-') then begin
                    "Levy On Jaza Deposits" := "Jaza Deposits" * (PCharges.Percentage / 100);
                    Modify;
                end;
            end;
        }
        field(69046; "Member Deposits"; Decimal)
        {
            Editable = false;
        }
        field(69047; "Levy On Jaza Deposits"; Decimal)
        {
        }
        field(69048; "Min Deposit As Per Tier"; Decimal)
        {
        }
        field(69049; "Total Repayments"; Decimal)
        {
            CalcFormula = sum("Loans Register"."Loan Principle Repayment" where("Client Code" = field("Client Code"),
                                                                                 "Outstanding Balance" = filter(> 0)));
            FieldClass = FlowField;
        }
        field(69050; "Total Interest"; Decimal)
        {
            CalcFormula = sum("Loans Register"."Loan Interest Repayment" where("Client Code" = field("Client Code"),
                                                                                "Outstanding Balance" = filter(> 0)));
            FieldClass = FlowField;
        }
        field(69051; Bridged; Boolean)
        {
        }
        field(69052; "Deposit Reinstatement"; Decimal)
        {
        }
        field(69053; "Member Found"; Boolean)
        {
        }
        field(69054; "Recommended Amount"; Decimal)
        {
        }
        field(69055; "Previous Years Dividend"; Decimal)
        {
        }
        field(69056; "partially Bridged"; Boolean)
        {
        }
        field(69057; "loan  Interest"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                  "Transaction Type" = filter("Interest Paid" | "Interest Due"),
                                                                  "Posting Date" = field("Date filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(69058; "BOSA Deposits"; Decimal)
        {
        }
        field(69059; "Topup Commission"; Decimal)
        {
            CalcFormula = sum("Loan Offset Details".Commision where("Loan No." = field("Loan  No.")));
            FieldClass = FlowField;
        }
        field(69060; "Topup iNTEREST"; Decimal)
        {
            CalcFormula = sum("Loan Offset Details"."Interest Top Up" where("Loan No." = field("Loan  No.")));
            FieldClass = FlowField;
        }
        field(69061; "No of Gurantors FOSA"; Integer)
        {
            CalcFormula = count("Loan GuarantorsFOSA" where("Loan No" = field("Loan  No."),
                                                             Substituted = const(false)));
            FieldClass = FlowField;
        }
        field(69062; "Loan No Found"; Boolean)
        {
        }
        field(69063; "Checked By"; Code[30])
        {
        }
        field(69064; "Approved By"; Code[30])
        {
        }
        field(69065; "New Repayment Period"; Integer)
        {

            trigger OnValidate()
            begin

            end;
        }
        field(69066; "Rejected By"; Code[30])
        {
        }
        field(69067; "Loans Insurance"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Client Code"),
                                                                  "Transaction Type" = filter("Loan Insurance Paid"),
                                                                  "Loan No" = field("Loan  No.")));
            FieldClass = FlowField;
        }
        field(69068; "Last Int Date"; Date)
        {
            CalcFormula = max("Cust. Ledger Entry"."Posting Date" where("Customer No." = field("Client Code"),
                                                                          "Loan No" = field("Loan  No."),
                                                                          "Transaction Type" = filter("Interest Due")));
            FieldClass = FlowField;
        }
        field(69069; "Approval remarks"; Code[40])
        {
            FieldClass = Normal;
        }
        field(69070; "Loan Disbursed Amount"; Decimal)
        {
        }
        field(69071; "Bank Bridge Amount"; Decimal)
        {
        }
        field(69072; "Approved Repayment"; Decimal)
        {
        }
        field(69073; "Rejection  Remark"; Text[80])
        {
            CalcFormula = lookup("Approval Comment Line".Comment where("Document No." = field("Loan  No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(69074; "Original Approved Amount"; Decimal)
        {
        }
        field(69075; "Original Approved Updated"; Boolean)
        {
        }
        field(69076; Print; Boolean)
        {
        }
        field(69077; "Employer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Employer Code")));
            FieldClass = FlowField;
        }
        field(69078; "Totals Loan Outstanding"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Client Code"),
                                                                  "Transaction Type" = filter(Loan | Repayment),
                                                                  "Posting Date" = field("Date filter")));
            FieldClass = FlowField;
        }
        field(69079; "Interest Upfront Amount"; Decimal)
        {
        }
        field(69080; "Loan Processing Fee"; Decimal)
        {
        }
        field(69081; "Loan Appraisal Fee"; Decimal)
        {
        }
        field(69082; "Loan Insurance"; Decimal)
        {
        }
        field(69083; TotalInterestCharged; Boolean)
        {
        }
        field(69084; "Last IntcalcDate"; Date)
        {
        }
        field(69085; "Loan Collateral Fee"; Decimal)
        {
        }
        field(69086; "Net Loan Disbursed"; Decimal)
        {
        }
        field(69087; "Bosa Loan Clearances"; Decimal)
        {
            CalcFormula = sum("Bosa Loan Clearances"."Approved Amount" where("Main Loan Number" = field("Loan  No."),
                                                                              "Client Code" = field("Client Code"),
                                                                              Posted = const(true)));
            FieldClass = FlowField;
        }
        field(69088; "Has BLA"; Boolean)
        {
        }
        field(69089; "Partial Disbursement"; Boolean)
        {
        }
        field(69090; "Partial Amount Disbursed"; Decimal)
        {

            trigger OnValidate()
            begin

                if not "Partial Disbursement" then
                    Error('This Loan Application is not set for Partial Disbursment');
            end;
        }
        field(69091; "Boosting Shares"; Decimal)
        {
            CalcFormula = sum("Boosting Shares"."Boosting Amount" where("Loan No." = field("Loan  No."),
                                                                         "Client Code" = field("Client Code")));
            FieldClass = FlowField;
        }
        field(69092; "Entry Type"; Option)
        {
            OptionCaption = 'Insertion,Modification,Deletion';
            OptionMembers = Insertion,Modification,Deletion;
        }
        field(69093; "Master Loan No."; Code[10])
        {
            Description = '//Daudi - to hold Master Loan No for partially disbursed loans';
            TableRelation = "Partial Disbursment Table"."Loan No." where("Disbursment Balance" = filter(> 0),
                                                                          "Client Code" = field("Client Code"));

            trigger OnValidate()
            begin


                if not "Partial Disbursement" then
                    Error('This Loan Application is not set for Partial Disbursment');

                Partial.Reset;
                if Partial.Get("Master Loan No.") then begin
                    "Loan Product Type" := Partial."Loan Product Type";
                    Validate("Loan Product Type");
                    "Requested Amount" := Partial."Requested Amount";
                    "Approved Amount" := Partial."Approved Amount";
                    "Partial Amount Disbursed" := Partial."Disbursment Balance";
                    Installments := Partial.Installments;

                end;
            end;
        }
        field(69094; "Bridge Shares"; Decimal)
        {
        }
        field(69095; "Discount Amount"; Decimal)
        {
        }
        field(69096; "Vendor No"; Code[20])
        {
            TableRelation = Vendor."No." where("Creditor Type" = filter(<> Account));

            trigger OnValidate()
            begin
                if LoanType.Get("Loan Product Type") then begin
                    if LoanType."Requires LPO" = false then
                        Error('This is only applicable to LPO loans');
                end;


                VendLPO.Reset;
                VendLPO.SetRange(VendLPO."No.", "Vendor No");
                if VendLPO.Find('-') then begin
                    "Vendor Name" := VendLPO.Name;
                end;
            end;
        }
        field(69097; "Vendor Name"; Text[30])
        {
        }
        field(69098; "Monthly Repayment"; Decimal)
        {
        }
        field(69099; "Defaulted install"; Decimal)
        {
        }
        field(69100; LastPayDateImport; Date)
        {
        }
        field(69101; "Total Loans Default"; Decimal)
        {
        }
        field(69102; "Installment Defaulted"; Decimal)
        {
        }
        field(69103; "old no"; Code[20])
        {

            trigger OnValidate()
            begin
                CustomerRecord.Reset;
                CustomerRecord.SetRange(CustomerRecord."Old Account No.", "old no");
                if CustomerRecord.Find('-') then begin
                    "Client Code" := CustomerRecord."No.";
                end;
            end;
        }
        field(69104; "Eft Amount"; Decimal)
        {
        }
        field(69105; "Initial Approved Amount"; Decimal)
        {
        }
        field(69106; "Appeal Date"; Date)
        {
        }
        field(69107; "Appeal Loan"; Boolean)
        {
        }
        field(69108; "Appeal Batch No."; Code[20])
        {
            TableRelation = "Loan Disburesment-Batching"."Batch No." where("Batch Type" = const("Appeal Loans"));
        }
        field(69109; "Tax Excempt"; Boolean)
        {
        }
        field(69110; "Group Account"; Code[50])
        {
            TableRelation = Customer."No." where("Customer Posting Group" = const('MICRO'),
                                                            "Group Account" = const(true));
        }
        field(69111; "Loan Officer"; Code[30])
        {
            //TableRelation = "Loan Officers Details".Name;
        }
        field(69112; "Group Name"; Text[50])
        {
        }
        field(69113; "Check Previous Tiers"; Boolean)
        {

            trigger OnValidate()
            begin

                TestField("Reason Overriding Tiers");
            end;
        }
        field(69114; "Reason Overriding Tiers"; Text[50])
        {
        }
        field(69115; "Loan Tier"; Option)
        {
            OptionCaption = ' ,Tier One,Tier Two,Tier Three';
            OptionMembers = " ","Tier One","Tier Two","Tier Three";
        }
        field(69116; "Loan Tiers"; Option)
        {
            CalcFormula = lookup("Loan Products Setup"."Loan Tiers" where(Code = field("Loan Product Type")));
            FieldClass = FlowField;
            OptionCaption = ' ,Tier One,Tier Two,Tier Three';
            OptionMembers = " ","Tier One","Tier Two","Tier Three";
        }
        field(69117; "Check Int"; Boolean)
        {
        }
        field(69118; "Loan Next Pay Date"; Date)
        {
        }
        field(69161; "Loan to Appeal"; Code[15])
        {
            TableRelation = "Loans Register"."Loan  No." where("Client Code" = field("Client Code"));

            trigger OnValidate()
            begin
                LoanAppeal.Reset;
                LoanAppeal.SetRange(LoanAppeal."Loan  No.", "Loan to Appeal");
                if LoanAppeal.Find('-') then begin
                    "Loan to Appeal Approved Amount" := LoanAppeal."Approved Amount";
                    "Loan to Appeal issued Date" := LoanAppeal."Issued Date";
                end;
            end;
        }
        field(69162; "Loan to Appeal Approved Amount"; Decimal)
        {
        }
        field(69163; "Loan to Appeal issued Date"; Date)
        {
        }
        field(69168; "Loan to Reschedule"; Code[15])
        {
            TableRelation = "Loans Register"."Loan  No.";

            trigger OnValidate()
            begin
                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Loan  No.", "Loan to Reschedule");
                if LoanApp.Find('-') then begin
                    LoanApp.CalcFields(LoanApp."Outstanding Balance");
                    "Requested Amount" := LoanApp."Outstanding Balance";
                    "Recommended Amount" := LoanApp."Outstanding Balance";
                    "Approved Amount" := LoanApp."Outstanding Balance";
                    "Loan Product Type" := LoanApp."Loan Product Type";
                    Installments := LoanApp.Installments;
                    Validate("Loan Product Type");
                    Interest := LoanApp.Interest;
                    "Application Date" := Today;
                    Repayment := LoanApp.Repayment;

                end;
            end;
        }
        field(69169; Rescheduled; Boolean)
        {
            TableRelation = "Loans Register"."Loan  No." where("Client Code" = field("Client Code"),
                                                                "Outstanding Balance" = filter(> 0));
        }
        field(69170; "Loan Rescheduled Date"; Date)
        {
        }
        field(69171; "Loan Rescheduled By"; Code[15])
        {
        }
        field(69172; "Reason For Loan Reschedule"; Text[20])
        {
        }
        field(69173; "Batch Source"; Option)
        {
            OptionCaption = 'BOSA,FOSA,MICRO';
            OptionMembers = BOSA,FOSA,MICRO;
        }
        field(69174; "Principle Due"; Decimal)
        {
            Editable = true;
        }
        field(69175; "Expected Total Int."; Decimal)
        {
            Editable = false;
        }
        field(69176; "Check Off Amount"; Decimal)
        {
        }
        field(69177; "Int Paid Finsacco"; Decimal)
        {
        }
        field(69178; "Principal Paid"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Client Code"),
                                                                  "Loan No" = field("Loan  No."),
                                                                  "Transaction Type" = filter(Repayment),
                                                                  "Posting Date" = field("Date filter")));
            FieldClass = FlowField;
        }
        field(69179; "Total Direct Recovery"; Decimal)
        {
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                   "Transaction Type" = filter(Repayment),
                                                                   "Document No." = filter('RCV*'),
                                                                   "Posting Date" = field("Date filter")));
            FieldClass = FlowField;
        }
        field(69180; "Total Loan Paid"; Decimal)
        {
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                   "Transaction Type" = filter(Repayment),
                                                                   "Posting Date" = field("Date filter")));
            FieldClass = FlowField;
        }
        field(69181; "OPening Bal"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                  "Transaction Type" = filter(Loan),
                                                                  "Posting Date" = field("Date filter")));
            FieldClass = FlowField;
        }
        field(69182; "Total Direct Recovery Int"; Decimal)
        {
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                   "Transaction Type" = filter("Interest Paid"),
                                                                   "Document No." = filter('RECOVERY' | 'ARECOVERY'),
                                                                   "Posting Date" = field("Date filter"),
                                                                   Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(69183; "Total Direct Recovery IntP"; Decimal)
        {
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                   "Transaction Type" = filter(Repayment | "Interest Paid"),
                                                                   "Document No." = filter('RCV*'),
                                                                   "Posting Date" = field("Date filter"),
                                                                   Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(69184; Recoveries; Decimal)
        {
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                   "Transaction Type" = filter(Repayment | "Interest Paid"),
                                                                   "Document No." = field("Document No 2 Filter"),
                                                                   "Posting Date" = field("Date filter"),
                                                                   "Journal Batch Name" = field("Journal Batch Filter"),
                                                                   Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(69185; "Journal Batch Filter"; Code[100])
        {
            FieldClass = FlowFilter;
        }
        field(69186; "Interest Recovered"; Decimal)
        {
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                   "Transaction Type" = filter("Interest Paid"),
                                                                   "Document No." = field("Document No 2 Filter"),
                                                                   "Posting Date" = field("Date filter"),
                                                                   "Journal Batch Name" = field("Journal Batch Filter"),
                                                                   Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(69187; "Prinncipal Recovered"; Decimal)
        {
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Loan No" = field("Loan  No."),
                                                                   "Transaction Type" = filter(Repayment),
                                                                   "Document No." = field("Document No 2 Filter"),
                                                                   "Posting Date" = field("Date filter"),
                                                                   "Journal Batch Name" = field("Journal Batch Filter"),
                                                                   Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(69188; "Main Sector"; Code[10])
        {
            TableRelation = "Main Sector".Code;

            trigger OnValidate()
            begin
                TestField(Posted, false);
            end;
        }
        field(69189; "Sub-Sector"; Code[10])
        {
            TableRelation = "Sub-Sector".Code where(No = FIELD("Main Sector"));
            trigger OnValidate()
            begin
                TestField(Posted, false);
            end;
        }
        field(69190; "Specific Sector"; Code[10])
        {
            TableRelation = "Specific-Sector".Code where(No = FIELD("Sub-Sector"));
            trigger OnValidate()
            begin
                TestField(Posted, false);
            end;
        }
        field(69191; "Insider Board"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(customer.board WHERE("No." = FIELD("Client Code")));

            trigger OnValidate()
            begin

            end;
        }
        field(69192; "Insider Lending"; Boolean)//Staff lending
        {
            FieldClass = FlowField;
            CalcFormula = lookup(customer.staff WHERE("No." = FIELD("Client Code")));

            trigger OnValidate()
            begin

            end;
        }
        field(69193; "Amount in Arrears"; Decimal)
        {

        }
        field(69194; "No of Months in Arrears"; Integer)
        {

        }
        field(69195; "No of Days in Arrears"; Integer)
        {

        }
        field(69196; "Sacco Insider"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(customer."Sacco Insider" WHERE("No." = FIELD("Client Code")));

            trigger OnValidate()
            begin

            end;
        }
        field(69197; "Principal In Arrears"; Decimal)
        {

        }
        field(69198; "Interest In Arrears"; Decimal)
        {

        }
        field(69199; "disbursement time"; Time)
        {

        }
        field(69200; "Posted By"; Code[40])
        {

        }
        field(69201; "Outstanding Penalty"; Decimal)
        {

        }
        field(69202; "Outstanding Insurance"; Decimal)
        {

        }
        field(69203; "Loan Insurance Charged"; Decimal)
        {

        }
        field(69204; "Total Insurance Paid"; Decimal)
        {

        }
        field(69205; "Total Penalty Paid"; Decimal)
        {

        }
        field(69206; "Outstanding Interest"; Decimal)
        {

        }
        field(69207; "Total Interest Paid"; Decimal)
        {

        }
        field(69208; "Insurance Payoff"; Decimal)
        {

        }
        field(69209; "Overdraft Installements"; Option)
        {
            OptionCaption = ' ,1,2,3,Loan';
            OptionMembers = " ","1 Month","2 Months","3 Month","Loan";
        }


    }

    keys
    {
        key(Key1; "Loan  No.")
        {
            Clustered = true;
        }
        key(Key2; Posted)
        {
        }
        key(Key3; "Loan Product Type")
        {
            SumIndexFields = "Requested Amount";
        }
        key(Key4; Source, "Client Code", "Loan Product Type", "Issued Date")
        {
        }
        key(Key5; "Batch No.", Source, "Loan Status", "Loan Product Type")
        {
            SumIndexFields = "Approved Amount", "Appeal Amount";
        }
        key(Key6; "BOSA Loan No.", "Account No", "Batch No.")
        {
        }
        key(Key7; "Old Account No.")
        {
        }
        key(Key8; "Client Code")
        {
        }
        key(Key9; "Staff No")
        {
        }
        key(Key10; "BOSA No")
        {
        }
        key(Key11; "Loan Product Type", "Client Code", Posted)
        {
        }
        key(Key12; "Client Code", "Loan Product Type", Posted, "Issued Date")
        {
            SumIndexFields = "Approved Amount";
        }
        key(Key13; "Loan Product Type", "Application Date", Posted)
        {
            SumIndexFields = "Approved Amount";
        }
        key(Key14; Source, "Mode of Disbursement", "Issued Date", Posted)
        {
            SumIndexFields = "Approved Amount";
        }
        key(Key15; "Issued Date", "Loan Product Type")
        {
            SumIndexFields = "Approved Amount";
        }
        key(Key16; "Application Date")
        {
        }
        key(Key17; "Client Code", "Old Account No.")
        {
        }
        key(Key18; "Group Code")
        {
        }
        key(Key19; "Account No")
        {
        }
        key(Key20; Source, "Issued Date", "Loan Product Type", "Client Code")
        {
        }
        key(Key21; "Client Code", "Loan Product Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Loan  No.", "Loan Product Type Name", "Outstanding Balance", "Oustanding Interest")
        {
        }
    }

    trigger OnDelete()
    begin
        IF Posted = true THEN
            Error('A loan cannot be deleted ');
        IF "Approval Status" = "Approval Status"::Approved THEN
            Error('A loan cannot be deleted ');
        IF "Approval Status" = "Approval Status"::Pending THEN
            Error('A loan cannot be deleted ');

    end;

    trigger OnInsert()
    var
        UserSetUp: Record "User Setup";
    begin

        //SURESTEP
        if Source = Source::BOSA then begin
            if "Loan  No." = '' then begin
                SalesSetup.Get;
                SalesSetup.TestField(SalesSetup."BOSA Loans Nos");
                NoSeriesMgt.InitSeries(SalesSetup."BOSA Loans Nos", xRec."No. Series", 0D, "Loan  No.", "No. Series");
            end;

        end else
            if Source = Source::MICRO then begin
                if "Loan  No." = '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField(SalesSetup."Micro Loans");
                    NoSeriesMgt.InitSeries(SalesSetup."Micro Loans", xRec."No. Series", 0D, "Loan  No.", "No. Series");
                end;


            end else
                IF (Source = Source::FOSA) AND ("Loan Product Type" <> 'OVERDRAFT') AND ("Loan Product Type" <> 'OKOA') then begin

                    if "Loan  No." = '' then begin
                        SalesSetup.Get;
                        SalesSetup.TestField(SalesSetup."FOSA Loans Nos");
                        NoSeriesMgt.InitSeries(SalesSetup."FOSA Loans Nos", xRec."No. Series", 0D, "Loan  No.", "No. Series");
                    end;


                end
                else
                    if (Source = Source::FOSA) AND ("Loan Product Type" = 'OVERDRAFT') then begin
                        if "Loan  No." = '' then begin
                            SalesSetup.Get;
                            SalesSetup.TestField(SalesSetup."OVerdraft Nos");
                            NoSeriesMgt.InitSeries(SalesSetup."OVerdraft Nos", xRec."No. Series", 0D, "Loan  No.", "No. Series");
                        end;
                    end
                    else
                        if (Source = Source::FOSA) AND ("Loan Product Type" = 'OKOA') then begin
                            if "Loan  No." = '' then begin
                                SalesSetup.Get;
                                SalesSetup.TestField(SalesSetup."Okoa No.");
                                NoSeriesMgt.InitSeries(SalesSetup."Okoa No.", xRec."No. Series", 0D, "Loan  No.", "No. Series");
                            end;
                        end;
        //SURESTEP

        "Application Date" := Today;
        Advice := true;
        "Loan Status" := "Loan Status"::Application;
        "Captured By" := UpperCase(UserId);

        IF UserSetUp.GET(USERID) THEN
            "Transacting Branch" := UserSetUp.Branch;
    end;

    trigger OnModify()
    begin


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
        ScheduleCode: Code[30];
        GP: Text[30];
        Groups: Record "Loan Product Cycles";
        PeriodInterval: Code[10];
        GLSetup: Record "General Ledger Setup";
        Users: Record User;
        FlatPeriodInterest: Decimal;
        FlatRateTotalInterest: Decimal;
        FlatPeriodInterval: Code[10];
        ProdCycles: Record "Loan Product Cycles";
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
        LoansClearedSpecial: Record "Loan Special Clearance";
        BridgedLoans: Record "Loan Special Clearance";
        Loan: Record "Loans Register";
        banks: Record "Bank Account";
        DefaultInfo: Text[180];
        LoanGuarantorDetailsTable: Record "Loans Guarantee Details";
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
        AvailDep: Decimal;
        LoansOut: Decimal;
        Mdep: Decimal;
        BANDING: Record "Deposit Tier Setup";
        Band: Decimal;
        TotalOutstanding: Decimal;
        Insuarence: Decimal;
        LoanTyped: Record "Loan Products Setup";
        DAY: Integer;
        loannums: Integer;
        Enddates: Date;
        Partial: Record "Partial Disbursment Table";
        VendLPO: Record Vendor;
        DataSheet: Record "Data Sheet Main";
        LoanTypes: Record "Loan Products Setup";
        Text012: label '<Member does not have shares, therefore cannot qualify for any Loan>';
        LoanAppeal: Record "Loans Register";


    procedure CreateAnnuityLoan()
    var
        LoanTypeRec: Record "Loan Products Setup";
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin
    end;


    procedure DebtService(Principal: Decimal; Interest: Decimal; PayPeriods: Integer): Decimal
    var
        PeriodInterest: Decimal;
    begin
    end;


    procedure GetGracePeriod()
    begin
        IssuedDate := "Loan Disbursement Date";
        GracePeiodEndDate := CalcDate("Grace Period", IssuedDate);
        InstalmentEnddate := CalcDate("Instalment Period", IssuedDate);
        GracePerodDays := GracePeiodEndDate - IssuedDate;
        InstalmentDays := InstalmentEnddate - IssuedDate;
        if InstalmentDays <> 0 then
            NoOfGracePeriod := ROUND(GracePerodDays / InstalmentDays, 1);
    end;


    procedure FlatRateCalc(var FlatLoanAmount: Decimal; var FlatInterestRate: Decimal) FlatRateCalc: Decimal
    begin
    end;

    //For Micro Loans
    internal procedure FnAutoFillGuarantorMembers(LoanNo: Code[30]; ClientCode: Code[50])
    begin

    end;

    local procedure SetCurrencyCode(AccType2: Option "G/L Account",Customer,Vendor,"Bank Account"; AccNo2: Code[20]): Boolean
    begin


    end;

    local procedure GetCurrency()
    begin


    end;
}

