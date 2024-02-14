
page 51516038 "Process Interest Picker"
{
    ApplicationArea = All;
    Caption = 'Please Input The Marked Fields';
    Extensible = false;
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(StartingDate; StartingDate)
            {
                ApplicationArea = All;
                Caption = 'Start Period';
                ShowMandatory = true;
                Editable = false;
                Enabled = false;
            }
            field(EndDate; EndDate)
            {
                ApplicationArea = All;
                Caption = 'Ending Period';
                ShowMandatory = true;
            }
            field(Authorisation; Authorisation)
            {
                ApplicationArea = All;
                Caption = 'Passcode';
                ShowMandatory = true;
                ExtendedDatatype = Masked;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin

    end;

    trigger OnOpenPage()
    begin
        PassedAuthentication := false;
        //..........Feed StartDate and End Date
        StartingDate := 0D;
        EndDate := CalcDate('CM', Today);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::OK then begin
            //.............Verify PIN Entered
            PassedAuthentication := FnVerifyPassword(Authorisation);
            exit(PassedAuthentication);
        end else begin
            exit;
        end;
    end;

    procedure GetDateFilterEntered(): Date
    begin
        //.............Exit With Period Date 
        Period :=EndDate;
        exit(Period);
    end;

    local procedure FnVerifyPassword(Authorisation: Text): Boolean
    begin
        //..............Check Password Against One Sent
        //Message('Just passing true boolean but later pass to evaluate against sent otp');
        if Authorisation = 'erp@2016!' then begin
            exit(true);
        end;
        Error('The Verification Code Is Incorrect. Try Again');
    end;

    var
        Period: DATE;
        PassedAuthentication: Boolean;
        EndDate: Date;
        StartingDate: date;
        Authorisation: Text;
}

