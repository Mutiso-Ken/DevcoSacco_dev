#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51516156 "Journal Post Successful"
{

    trigger OnRun()
    begin
    end;


    procedure PostedSuccessfully() Posted: Boolean
    begin
        
          Posted:=false;
         /*ValPost.SETRANGE(ValPost.UserID,USERID);
         ValPost.SETRANGE(ValPost."Value Posting",1);
         IF ValPost.FIND('-') THEN
            Posted:=TRUE;*/

    end;
}

