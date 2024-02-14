#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516602 "CloudPESA Paybill Imports"
{
    ApplicationArea = Basic;
    Editable = false;
    PageType = List;
    SourceTable = "CloudPESA Paybill Buffer";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Completion Time";"Completion Time")
                {
                    ApplicationArea = Basic;
                }
                field("Initiation Time";"Initiation Time")
                {
                    ApplicationArea = Basic;
                }
                field(Details;Details)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Status";"Transaction Status")
                {
                    ApplicationArea = Basic;
                }
                field("Paid In";"Paid In")
                {
                    ApplicationArea = Basic;
                }
                field(Withdrawn;Withdrawn)
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field("Balance Confirmed";"Balance Confirmed")
                {
                    ApplicationArea = Basic;
                }
                field("Reason Type";"Reason Type")
                {
                    ApplicationArea = Basic;
                }
                field("Other Party Info";"Other Party Info")
                {
                    ApplicationArea = Basic;
                }
                field("Linked Transaction ID";"Linked Transaction ID")
                {
                    ApplicationArea = Basic;
                }
                field("A/C No.";"A/C No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1120054018)
            {
            }
            action("Import cloud pesa")
            {
                ApplicationArea = Basic;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Paybill: Record "CloudPESA Paybill Buffer";
                begin

                    Xmlport.Run(51516016);
                end;
            }
            action(Clear)
            {
                ApplicationArea = Basic;
                Image = Default;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Paybill: Record "CloudPESA Paybill Buffer";
                begin
                    fnClearTble(Paybill);
                end;
            }
            action(Transfer)
            {
                ApplicationArea = Basic;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PaybillBuffer: Record "CloudPESA Paybill Buffer";
                    MPESAPAYBILL: Record "CloudPESA MPESA Trans";
                    AccountSplit: Text;
                    AccountFinal: Text;
                    TextTosplit: Text;
                    stringAcc: Decimal;
                    newString: Text;
                    newDate: Text;
                    finalDate: Text;
                    Vardecimal: Decimal;
                    myDate: Decimal;
                    myMonth: Decimal;
                    myYear: Decimal;
                    LastDate: Date;
                begin
                    PaybillBuffer.Reset;
                    PaybillBuffer.SetRange(PaybillBuffer."Linked Transaction ID",'');
                    if PaybillBuffer.Find('-')then begin
                      repeat
                        MPESAPAYBILL.Reset;
                        MPESAPAYBILL.SetRange(MPESAPAYBILL."Document No", PaybillBuffer."Receipt No.");
                        if MPESAPAYBILL.Find('-')=false then begin

                       TextTosplit:=PaybillBuffer.Details;
                        Part1 := SplitString(TextTosplit,'Acc.');
                        stringAcc:=StrLen(Part1+'Acc.  ');
                        Part2:=CopyStr(TextTosplit,stringAcc,100);

                        newString:=PaybillBuffer."Completion Time";
                        newDate:=SplitString(newString,' ');

                         finalDate:= DelChr(newDate,'=',DelChr(newDate,'=','1234567890'));

                    //31082018
                    //MESSAGE(finalDate);
                         Evaluate(myDate,CopyStr(finalDate,1,2));
                         Evaluate(myMonth,CopyStr(finalDate,3,2));
                         Evaluate(myYear,CopyStr(finalDate,5,8));


                       LastDate:=Dmy2date(myDate,myMonth,myYear);

                    //ERROR('%1',LastDate);

                        MPESAPAYBILL.Init;
                        MPESAPAYBILL."Document No":=PaybillBuffer."Receipt No.";
                        MPESAPAYBILL."Transaction Date":=LastDate;
                        MPESAPAYBILL."Transaction Time":=Time;
                        MPESAPAYBILL.Amount:=PaybillBuffer."Paid In";
                        MPESAPAYBILL."Paybill Acc Balance":=PaybillBuffer.Balance;
                        MPESAPAYBILL."Document Date":=Today;
                        MPESAPAYBILL."Key Word":='C';
                        MPESAPAYBILL."Account No":=Part2;
                        MPESAPAYBILL."Account Name":=CopyStr(PaybillBuffer."Other Party Info",16,250);
                        MPESAPAYBILL.Telephone:=CopyStr(PaybillBuffer."Other Party Info",1,12);
                        MPESAPAYBILL.Description:='Paybill Deposit';
                        MPESAPAYBILL.Insert;

                        end;
                        until PaybillBuffer.Next=0;

                    Message('Posted successfully');
                    fnClearTble(PaybillBuffer);
                      end;
                end;
            }
        }
    }

    var
        Part1: Text;
        Part2: Text;
        Part3: Text;

    local procedure fnClearTble(Paybill: Record "CloudPESA Paybill Buffer")
    begin
        Paybill.Reset;
        Paybill.SetRange(Paybill."Linked Transaction ID",'');
        if Paybill.Find('-')then begin
          repeat
          Paybill.Delete;

          until Paybill.Next=0;
          end;
    end;

    local procedure SplitString(sText: Text;separator: Text) Token: Text
    var
        Pos: Integer;
        Tokenq: Text;
    begin
        Pos := StrPos(sText,separator);
        if Pos > 0 then begin
          Token := CopyStr(sText,1,Pos-1);
          if Pos+1 <= StrLen(sText) then
            sText := CopyStr(sText,Pos+1)
          else
            sText := '';
        end else begin
          Token := sText;
          sText := '';
        end;
    end;
}

