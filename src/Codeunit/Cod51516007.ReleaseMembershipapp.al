#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516007 "Release Membership app"
{
   // TableNo = UnknownTable51516220;

    trigger OnRun()
    begin
        // MembApp.Status:=MembApp.Status::Approved;
        // MembApp.Modify;
    end;


    procedure PerformRelease(var MembApp: Record "Membership Applications")
    begin
        with MembApp do begin
          Codeunit.Run(Codeunit::"Release Membership app",MembApp);
          end;
    end;
}

