Page 51516082 "TwoFactorAuth"
{
    Caption = 'Authentication Page';
    PageType = ListPart;
    
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = '  ';
                Editable = true;
                field("Input OTP"; InputOTP)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Importance = Promoted;
                }
            }
        }
    }

    actions
    {
    }

    var
        InputOTP: Integer;


    procedure GetEnteredOTP(): Integer
    begin
        exit(InputOTP);
    end;
}

