#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516336 "Change MPESA PIN No"
{

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
        field(5;"MPESA Application No";Code[30])
        {
            TableRelation = "MPESA Applications".No where (Status=const(Approved),
                                                           "Sent To Server"=const(Yes));

            trigger OnValidate()
            begin
                MPESAApp.Reset;
                MPESAApp.SetRange(MPESAApp.No,"MPESA Application No");
                if MPESAApp.Find('-') then begin
                "Customer ID No":=MPESAApp."Customer ID No";
                "Customer Name":=MPESAApp."Customer Name";
                "MPESA Mobile No":=MPESAApp."MPESA Mobile No";
                "Document Date":=MPESAApp."Document Date";
                "MPESA Corporate No":=MPESAApp."MPESA Corporate No";
                end;
            end;
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
        field(14;"Date Sent";Date)
        {
        }
        field(15;"Time Sent";Time)
        {
        }
        field(16;"Sent By";Code[30])
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
        field(22;"MPESA Change Nos";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(23;"MPESA Application Nos";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(24;"Change MPESA PIN Nos";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(25;"App Status";Option)
        {
            OptionCaption = 'Pending,New PIN Sent,Rejected';
            OptionMembers = Pending,"New PIN Sent",Rejected;
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
          NoSetup.Get();
          NoSetup.TestField(NoSetup."Change MPESA PIN Nos");
          NoSeriesMgt.InitSeries(NoSetup."Change MPESA PIN Nos",xRec."No. Series",0D,No,"No. Series");
          end;


        "Entered By":=UserId;
        "Date Entered":=Today;
        "Time Entered":=Time;
    end;

    var
        NoSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MPESAApp: Record "MPESA Applications";
}

