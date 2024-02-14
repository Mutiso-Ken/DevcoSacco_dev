#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516236 "Member List-Editable"
{
    Caption = 'Member List';
    CardPageID = "Member Account Card - Editable";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Type" = filter(Member | MicroFinance));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                }
                field("Old Account No."; "Old Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                }
                field("ID No."; "ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll/Staff No"; "Payroll/Staff No")
                {
                    ApplicationArea = Basic;
                }
                field("FOSA Account"; "FOSA Account")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(ActionGroup19)
            {
                action("Member Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member Ledger Entries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                }
                action("Bank Account")
                {
                    ApplicationArea = Basic;
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Process;
                }
                action(Contacts)
                {
                    ApplicationArea = Basic;
                    Image = SendTo;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
            }
            group("Issued Documents")
            {
                Caption = 'Issued Documents';
                Visible = false;
                // action("Loans Guaranteed")
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Loans Guarantors';
                //     Image = "Report";
                //     Promoted = true;
                //     PromotedCategory = "Report";
                //     Visible = false;

                //     trigger OnAction()
                //     begin

                //         Cust.Reset;
                //         Cust.SetRange(Cust."No.","No.");
                //         if Cust.Find('-') then
                //         Report.Run(51516155,true,false,Cust);
                //     end;
                // }
                // action("Loans Guarantors")
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Loans Guaranteed';
                //     Image = "Report";
                //     Promoted = true;
                //     PromotedCategory = "Report";
                //     Visible = false;

                //     trigger OnAction()
                //     begin
                //         Cust.Reset;
                //         Cust.SetRange(Cust."No.","No.");
                //         if Cust.Find('-') then
                //         Report.Run(51516156,true,false,Cust);
                //     end;
                // }
            }
            group(ActionGroup11)
            {
                action("Next Of Kin")
                {
                    ApplicationArea = Basic;
                    Caption = 'Next Of Kin';
                    Image = Relationship;
                    Promoted = true;
                    PromotedCategory = Process;
                }
                action("Members Statistics")
                {
                    ApplicationArea = Basic;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                }
            }
            // action("Members Guaranteed")
            // {
            //     ApplicationArea = Basic;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     RunPageMode = View;

            //     trigger OnAction()
            //     begin
            //         LGurantors.Reset;
            //         LGurantors.SetRange(LGurantors."Loan No","No.");
            //         if LGurantors.Find('-') then

            //     end;

            separator(Action7)
            {
            }
            // }
            // group(ActionGroup6)
            // {
            //     action(Statement)
            //     {
            //         ApplicationArea = Basic;
            //         Caption = 'Detailed Statement';
            //         Image = Customer;
            //         Promoted = true;
            //         PromotedCategory = "Report";

            //         trigger OnAction()
            //         begin
            //             Cust.Reset;
            //             Cust.SetRange(Cust."No.","No.");
            //             if Cust.Find('-') then
            //             Report.Run(50031,true,false,Cust);
            //         end;
            //     }
            // action("Account Closure Slip")
            // {
            //     ApplicationArea = Basic;
            //     Caption = 'Account Closure Slip';
            //     Image = "Report";
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Visible = false;

            //     trigger OnAction()
            //     begin
            //         Cust.Reset;
            //         Cust.SetRange(Cust."No.","No.");
            //         if Cust.Find('-') then
            //         Report.Run(50033,true,false,Cust);
            //     end;
            // }
        }
    }




    trigger OnOpenPage()
    begin
        StatusPermissions.Reset;
        StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::Edit);
        if StatusPermissions.Find('-') = false then
            Error('You do not have permissions to edit member information.');
    end;

    var
        Cust: Record Customer;
        GeneralSetup: Record "Sacco General Set-Up";
        Gnljnline: Record "Gen. Journal Line";
        TotalRecovered: Decimal;
        TotalAvailable: Integer;
        Loans: Record "Loans Register";
        TotalFOSALoan: Decimal;
        TotalOustanding: Decimal;
        Vend: Record Vendor;
        TotalDefaulterR: Decimal;
        Value2: Decimal;
        AvailableShares: Decimal;
        Value1: Decimal;
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        RoundingDiff: Decimal;
        DActivity: Code[20];
        DBranch: Code[20];
        LoansR: Record "Loans Register";
        LoanAllocation: Decimal;
        LGurantors: Record "Loans Guarantee Details";
        StatusPermissions: Record "Status Change Permision";


    procedure GetSelectionFilter(): Code[80]
    var
        Cust: Record Customer;
        FirstCust: Code[30];
        LastCust: Code[30];
        SelectionFilter: Code[250];
        CustCount: Integer;
        More: Boolean;
    begin
        /*CurrPage.SETSELECTIONFILTER(Cust);
        CustCount := Cust.COUNT;
        IF CustCount > 0 THEN BEGIN
          Cust.FIND('-');
          WHILE CustCount > 0 DO BEGIN
            CustCount := CustCount - 1;
            Cust.MARKEDONLY(FALSE);
            FirstCust := Cust."No.";
            LastCust := FirstCust;
            More := (CustCount > 0);
            WHILE More DO
              IF Cust.NEXT = 0 THEN
                More := FALSE
              ELSE
                IF NOT Cust.MARK THEN
                  More := FALSE
                ELSE BEGIN
                  LastCust := Cust."No.";
                  CustCount := CustCount - 1;
                  IF CustCount = 0 THEN
                    More := FALSE;
                END;
            IF SelectionFilter <> '' THEN
              SelectionFilter := SelectionFilter + '|';
            IF FirstCust = LastCust THEN
              SelectionFilter := SelectionFilter + FirstCust
            ELSE
              SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
            IF CustCount > 0 THEN BEGIN
              Cust.MARKEDONLY(TRUE);
              Cust.NEXT;
            END;
          END;
        END;
        EXIT(SelectionFilter);
        */

    end;


    procedure SetSelection(var Cust: Record Customer)
    begin
        //CurrPage.SETSELECTIONFILTER(Cust);
    end;
}

