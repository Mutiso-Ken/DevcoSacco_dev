#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516157 "SendSms2"
{

    trigger OnRun()
    begin
        Report.Run(51516201,false,false);
    end;

    var
        Sms: Record "SMS Messages";


    procedure SendSms(Source: Text[30];Telephone: Text[200];Textsms: Text[200];DocumentNo: Text[100])
    begin
        /*
        Sms.RESET;
        IF Sms.FIND('+') THEN BEGIN
        Sms.INIT;
        Sms."Entry No":= Sms."Entry No"+1;
        END
        ELSE
        BEGIN
        Sms.INIT;
        Sms."Entry No":=1;
        END;
        Sms.Source:=Source;
        Sms."Telephone No":=Replacestring(Telephone,'-','');
        Sms."Date Entered":=TODAY;
        Sms."Time Entered":=TIME;
        Sms."Entered By":=USERID;
        Sms."SMS Message":=Textsms;
        Sms."Document No":=DocumentNo;
        Sms."Sent To Server":=Sms."Sent To Server"::"0";
        Sms.INSERT;
          */

    end;


    procedure Replacestring(string: Text[200];findwhat: Text[30];replacewith: Text[200]) Newstring: Text[200]
    begin
        /*WHILE STRPOS(string,findwhat) > 0 DO
        string := DELSTR(string,STRPOS(string,findwhat)) + replacewith + COPYSTR(string,STRPOS(string,findwhat) + STRLEN(findwhat));
        Newstring := string;*/

    end;
}

