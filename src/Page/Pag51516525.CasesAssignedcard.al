#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516525 "Cases Assigned card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Cases Management";
    SourceTableView = where(Status=filter(Assigned));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Case Number";"Case Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date of Complaint";"Date of Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Type of cases";"Type of cases")
                {
                    ApplicationArea = Basic;
                }
                field("Recommended Action";"Recommended Action")
                {
                    ApplicationArea = Basic;
                }
                field("Case Description";"Case Description")
                {
                    ApplicationArea = Basic;
                }
                field("Resource #2";"Resource #2")
                {
                    ApplicationArea = Basic;
                }
                field("Action Taken";"Action Taken")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Case Information")
            {
                field("Date To Settle Case";"Date To Settle Case")
                {
                    ApplicationArea = Basic;
                }
                field("Document Link";"Document Link")
                {
                    ApplicationArea = Basic;
                }
                field("solution Remarks";"solution Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Body Handling The Complaint";"Body Handling The Complaint")
                {
                    ApplicationArea = Basic;
                }
                field(Recomendations;Recomendations)
                {
                    ApplicationArea = Basic;
                }
                field("Support Documents";"Support Documents")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Resource Assigned";"Resource Assigned")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Member No";"Member No")
                {
                    ApplicationArea = Basic;
                }
                field("Fosa Account";"Fosa Account")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("loan no";"loan no")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000031;"Member Statistics FactBox")
            {
                SubPageLink = "No."=field("Member No");
            }
            part(Control1000000033;"Loans Sub-Page List")
            {
                Caption = 'Loans Details';
                SubPageLink = "Client Code"=field("Member No");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Assign To next  Reasorce")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                     TestField("Resource #2");
                     TestField("Action Taken");
                     TestField("Date To Settle Case");
                     TestField("solution Remarks");
                     "Date Sent":=WorkDate;
                     "Time Sent":=Time;
                     "Sent By":=UserId;
                      AssignedReas.Init;
                      AssignedReas."Case Number":="Case Number"+'c2';
                      AssignedReas."Receive date":=Today;
                      AssignedReas."Action Taken":="Action Taken";
                      AssignedReas."Receive User":="Resource#1";
                      AssignedReas."Body Handling The Complaint":="Body Handling The Complaint";
                      AssignedReas."Date To Settle Case":="Date To Settle Case";
                      AssignedReas."solution Remarks":="solution Remarks";
                      AssignedReas."Responsibility Center":="Responsibility Center";
                      AssignedReas."Resource Assigned":="Resource #2";
                      AssignedReas."Member No":="Member No";
                      AssignedReas."Account Name":="Account Name";
                      AssignedReas."Type of cases":="Type of cases";
                      AssignedReas."loan no":="loan no";
                      AssignedReas."Fosa Account":="Fosa Account";
                      AssignedReas."Date of Complaint":="Date of Complaint";
                      AssignedReas."Sent By":=UserId;
                      if AssignedReas."Resource Assigned"<>'' then
                        AssignedReas.Insert(true);
                      if Insert=true then;

                     Status:=Status::Assigned;
                     Modify;
                     sms();
                     Message('Case has been Assigned to %1',AssignedReas."Resource Assigned");

                     //to be continued tomorrow......
                end;
            }
            action(Receive)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                     "Receive User":=UserId;
                     "Receive date":=WorkDate;
                     "Receive Time":=Time;
                     Modify;
                end;
            }
            action(Resolved)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                begin

                    if Status= Status ::Resolved then begin
                    Error('Customer query has already been %1',Status);
                    end else



                    //TO ENABLE RESOLUTION OF CUSTOMER QUERIES LOGGED INTO THE SYSTEM
                    CustCare.SetRange(CustCare.No,"Case Number");
                    if CustCare.Find('-') then begin
                    CustCare.Status:=CustCare.Status::Resolved;
                    CustCare."Resolved User":=UserId;
                    CustCare."Resolved Date":= WorkDate;
                    CustCare."Resolved Time":= Time;
                    CustCare.Modify;
                    end;
                    caseCare.SetRange(caseCare."Case Number","Case Number");
                    if caseCare.Find('-')then begin
                      caseCare.Status:=caseCare.Status::Resolved;
                      caseCare."Resolved User":=UserId;
                      caseCare."Resolved Date":=WorkDate;
                      caseCare."Resolved Time":=Time;
                      caseCare.Modify;
                      smsResolved();
                      Message('The case has been successfully resolved');
                      end;
                    CurrPage.Editable:=false;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        SetRange("Resource Assigned",UserId);
    end;

    trigger OnOpenPage()
    begin
        SetRange("Resource Assigned",UserId);
    end;

    var
        CustCare: Record "General Equiries";
        AssignedReas: Record "Cases Management";
        caseCare: Record "Cases Management";

    local procedure sms()
    var
        iEntryNo: Integer;
        SMSMessages: Record "SMS Messages";
        Cust: Record Customer;
    begin

         //SMS MESSAGE
              SMSMessages.Reset;
              if SMSMessages.Find('+') then begin
              iEntryNo:=SMSMessages."Entry No";
              iEntryNo:=iEntryNo+1;
              end
              else begin
              iEntryNo:=1;
              end;

              SMSMessages.Reset;
              SMSMessages.Init;
              SMSMessages."Entry No":=iEntryNo;
              SMSMessages."Account No":="Member No";
              SMSMessages."Date Entered":=Today;
              SMSMessages."Time Entered":=Time;
              SMSMessages.Source:='Cases';
              SMSMessages."Entered By":=UserId;
              SMSMessages."Sent To Server":=SMSMessages."sent to server"::No;
              //SMSMessages."Sent To Server":=SMSMessages."Sent To Server::No;
              SMSMessages."SMS Message":='Your case/complain has been received and assigned to.'+"Resource #2"+
                                        ' kindly contact the resource for follow ups';
              Cust.Reset;
              if Cust.Get("Member No") then
              SMSMessages."Telephone No" := Cust."Phone No.";
              SMSMessages.Insert;
    end;

    local procedure smsResolved()
    var
        iEntryNo: Integer;
        SMSMessages: Record "SMS Messages";
        cust: Record Customer;
    begin

         //SMS MESSAGE
              SMSMessages.Reset;
              if SMSMessages.Find('+') then begin
              iEntryNo:=SMSMessages."Entry No";
              iEntryNo:=iEntryNo+1;
              end
              else begin
              iEntryNo:=1;
              end;

              SMSMessages.Reset;
              SMSMessages.Init;
              SMSMessages."Entry No":=iEntryNo;
              SMSMessages."Account No":="Member No";
              SMSMessages."Date Entered":=Today;
              SMSMessages."Time Entered":=Time;
              SMSMessages.Source:='Cases';
              SMSMessages."Entered By":=UserId;
              SMSMessages."Sent To Server":=SMSMessages."sent to server"::No;
              //SMSMessages."Sent To Server":=SMSMessages."Sent To Server::No;
              SMSMessages."SMS Message":='Your case/complain has been resolved by '+UserId+
                                        ' Thank you for your being our priority customer';
              cust.Reset;
              if cust.Get("Member No") then
              SMSMessages."Telephone No" := cust."Phone No.";
              SMSMessages.Insert;
    end;
}

