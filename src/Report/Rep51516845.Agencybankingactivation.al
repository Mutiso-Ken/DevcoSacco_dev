#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516845 "Agency banking activation"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("SurePESA Applications"; "SurePESA Applications")
        {
            column(ReportForNavId_1120054000; 1120054000)
            {
            }

            trigger OnAfterGetRecord()
            begin

                //MESSAGE('Processed successfuly');
                cloudAPP.Reset;
                cloudAPP.SetRange(cloudAPP.SentToServer, true);
                //cloudAPP.SETRANGE(cloudAPP."Account No",'L01001022335');
                if cloudAPP.Find('-') then begin
                    repeat
                        AgentAPP.Reset;
                        AgentAPP.SetRange(AgentAPP."Account No", cloudAPP."Account No");
                        if AgentAPP.Find('-') = false then begin
                            vend.Get(cloudAPP."Account No");
                            AgentAPP.Reset;
                            if AgentAPP.Find('+') then begin
                                iEntryNo := AgentAPP."No.";
                                iEntryNo := iEntryNo + 1;
                            end
                            else begin
                                iEntryNo := 1;
                            end;
                            AgentAPP.Init;
                            AgentAPP."No." := iEntryNo;
                            AgentAPP."Account No" := cloudAPP."Account No";
                            AgentAPP."Account Name" := cloudAPP."Account Name";
                            AgentAPP.Telephone := cloudAPP.Telephone;
                            AgentAPP."ID No" := cloudAPP."ID No";
                            AgentAPP."Time Applied" := Time;
                            AgentAPP."Date Applied" := Today;
                            AgentAPP."Created By" := UserId;
                            AgentAPP."Bosa Number" := vend."BOSA Account No";
                            //AgentAPP.SentToServer:=TRUE;
                            AgentAPP.Insert;

                        end;
                    until cloudAPP.Next = 0;

                end;
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
        AgentAPP: Record "Agency Members App";
        cloudAPP: Record "SurePESA Applications";
        vend: Record Vendor;
        Sacconoseries: Record "Sacco No. Series";
        iEntryNo: Integer;
}

