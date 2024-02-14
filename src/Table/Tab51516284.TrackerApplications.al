#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516284 "Tracker Applications"
{
    // DrillDownPageID = "Tracker list";
    // LookupPageID = "Tracker list";

    fields
    {
        field(1;No;Code[30])
        {
        }
        field(2;"Date Entered";Date)
        {
        }
        field(3;"Time Entered";Time)
        {
        }
        field(4;"Entered By";Code[30])
        {
        }
        field(5;"Document Serial No";Text[50])
        {
        }
        field(6;"Document Date";Date)
        {
        }
        field(7;"Customer ID No";Code[50])
        {
        }
        field(8;"Customer Name";Text[200])
        {
        }
        field(9;"MPESA Mobile No";Text[50])
        {

            trigger OnValidate()
            begin
                /*StatusPermissions.RESET;
                StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
                StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"M-SACCO Approval");
                IF StatusPermissions.FIND('-') THEN
                ERROR('Approvers are not allowed to capture/modify application details.');
                 */

            end;
        }
        field(10;"MPESA Corporate No";Code[30])
        {
        }
        field(11;Status;Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(12;Comments;Text[200])
        {
        }
        field(13;"Rejection Reason";Text[30])
        {
        }
        field(14;"Date Approved";Date)
        {
        }
        field(15;"Time Approved";Time)
        {
        }
        field(16;"Approved By";Code[30])
        {
        }
        field(17;"Date Rejected";Date)
        {
        }
        field(18;"Time Rejected";Time)
        {
        }
        field(19;"Rejected By";Code[30])
        {
        }
        field(20;"Sent To Server";Option)
        {
            OptionMembers = No,Yes;
        }
        field(21;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(22;"1st Approval By";Code[30])
        {
        }
        field(23;"Date 1st Approval";Date)
        {
        }
        field(24;"Time First Approval";Time)
        {
        }
        field(25;"Withdrawal Limit Code";Code[20])
        {
            TableRelation = "MPESA Withdrawal Limits".Code;

            trigger OnValidate()
            begin
                WithdrawLimit.Reset;
                WithdrawLimit.SetRange(WithdrawLimit.Code,"Withdrawal Limit Code");
                if WithdrawLimit.Find('-') then begin
                WithdrawLimit.TestField(WithdrawLimit."Limit Amount");
                "Withdrawal Limit Amount":=WithdrawLimit."Limit Amount";
                end;
            end;
        }
        field(26;"Withdrawal Limit Amount";Decimal)
        {
        }
        field(27;"Application Type";Option)
        {
            OptionCaption = 'Initial,Change,Pin Request,Pay Bill Change,Change MobileNo,GJ Posting,Posting Reversal,Cancel Doc,Delegate Approval,Period Opening,Load Recovery,Death Claim,Customer Refund,Stop Order,Adjust Installments,Recoveries,Petty Cash,Reimbursement,Item Requisition,Human Resource,General Request,ICT Assets,Systems & Applications,Email Management,Connectivity,Hardware Support,Disbursment';
            OptionMembers = Initial,Change,"Pin Request","Pay Bill Change","Change MobileNo","GJ Posting","Posting Reversal","Cancel Doc","Delegate Approval","Period Opening","Load Recovery","Death Claim","Customer Refund","Stop Order","Adjust Installments",Recoveries,"Petty Cash",Reimbursement,"Item Requisition","Human Resource","General Request","ICT Assets","Systems & Applications","Email Management",Connectivity,"Hardware Support",Disbursment;

            trigger OnValidate()
            begin
                if "Application Type"="application type"::Initial then begin
                if "Application No"<>'' then begin
                Error('Please ensure the application number field is blank if the application is not a change application.');
                end;
                end;
            end;
        }
        field(28;"Application No";Code[10])
        {
            TableRelation = "MPESA Applications".No where (Status=const(Approved));

            trigger OnValidate()
            begin
                if "Application Type"<>"application type"::Change then begin
                Error('The application must be a change application before selecting this option.');
                end;

                MPESAApp.Reset;
                MPESAApp.SetRange(MPESAApp.No,"Application No");
                if MPESAApp.Find('-') then begin
                "Old Telephone No":=MPESAApp."MPESA Mobile No";
                "Document Serial No":=MPESAApp."Document Serial No";
                "Customer ID No":=MPESAApp."Customer ID No";
                "Customer Name":=MPESAApp."Customer Name";
                end
                else begin
                "Old Telephone No":='';
                end;

                MPESAAppDetails.Reset;
                MPESAAppDetails.SetRange(MPESAAppDetails."Application No",No);
                if MPESAAppDetails.Find('-') then begin
                repeat
                MPESAAppDetails.Delete;
                until MPESAAppDetails.Next=0
                end;


                MPESAAppDetails.Reset;
                MPESAAppDetails.SetRange(MPESAAppDetails."Application No","Application No");
                if MPESAAppDetails.Find('-') then begin
                repeat
                MPESAAppDet2.Reset;
                MPESAAppDet2.Init;
                MPESAAppDet2."Application No":=No;
                MPESAAppDet2."Account Type":=MPESAAppDetails."Account Type";
                MPESAAppDet2."Account No.":=MPESAAppDetails."Account No.";
                MPESAAppDet2.Description:=MPESAAppDetails.Description;
                MPESAAppDet2.Insert;
                until MPESAAppDetails.Next=0
                end;
            end;
        }
        field(29;Changed;Option)
        {
            OptionMembers = No,Yes;
        }
        field(30;"Date Changed";Date)
        {
        }
        field(31;"Time Changed";Time)
        {
        }
        field(32;"Changed By";Code[30])
        {
        }
        field(33;"Old Telephone No";Code[30])
        {
        }
        field(34;"I agree information is true";Boolean)
        {
        }
        field(35;"App Status";Option)
        {
            OptionMembers = Pending,"1st Approval",Approved,Rejected;
        }
        field(36;"Responsibility Center";Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(37;"Member No";Code[20])
        {
            TableRelation = Vendor."No." where ("Account Type"=const('SAVINGS'));
        }
        field(38;User;Code[20])
        {
        }
    }

    keys
    {
        key(Key1;No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Status<>Status::Open then begin
        Error('You cannot delete the MPESA transaction because it has already been sent for first approval.');
        end;
    end;

    trigger OnInsert()
    begin

          if No = '' then begin
          NoSetup.Get;
          NoSetup.TestField(NoSetup."Tracker no");
          NoSeriesMgt.InitSeries(NoSetup."Tracker no",xRec."No. Series",0D,No,"No. Series");
          end;


        "Entered By":=UserId;
        "Date Entered":=Today;
        "Time Entered":=Time;
    end;

    var
        NoSetup: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WithdrawLimit: Record "MPESA Withdrawal Limits";
        StatusPermissions: Record "Status Change Permision";
        MPESAApp: Record "MPESA Applications";
        MPESAAppDetails: Record "MPESA Application Details";
        MPESAAppDet2: Record "MPESA Application Details";
}

