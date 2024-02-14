#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516288 "Validate Checkoff-Distributed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate Checkoff-Distributed.rdlc';

    dataset
    {
        dataitem("Checkoff Lines-Distributed";"Checkoff Lines-Distributed")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin



                    Cust.Reset;
                    Cust.SetRange(Cust."Payroll/Staff No","Staff/Payroll No");
                    Cust.SetRange(Cust."Employer Code","Employer Code");
                    //Cust.SETRANGE(Cust."Date Filter",ASATDATE);
                    if Cust.Find('-') then begin
                     repeat
                      Cust.CalcFields(Cust."Current Shares");
                      "Member No.":=Cust."No.";
                      Name:=Cust.Name;
                      "Expected Amount":=Cust."Monthly Contribution";
                      Variance:=Amount+"Expected Amount";
                      Modify;

                     until Cust.Next=0;
                  end;

                    Cust.Reset;
                    Cust.SetRange(Cust."Payroll/Staff No","Staff/Payroll No");
                    Cust.SetRange(Cust."Employer Code","Checkoff Lines-Distributed"."Employer Code");
                    //Cust.SETRANGE(Cust."Date Filter",ASATDATE);
                    if Cust.Find('-') then begin
                     repeat
                       if (Cust."Employer Code"='POSTAL CORP') then begin
                       if Reference='377' then begin
                         "Checkoff Lines-Distributed"."Transaction Type":="Checkoff Lines-Distributed"."transaction type"::"Deposits Contribution";
                         "Checkoff Lines-Distributed".Modify;
                          end else if  Reference='38J' then begin

                         "Checkoff Lines-Distributed"."Transaction Type":="Checkoff Lines-Distributed"."transaction type"::"SchFees Shares";
                            "Checkoff Lines-Distributed".Modify;
                         end;
                         end else if  (Cust."Employer Code"='TELKOM') then begin
                        if Reference='377' then begin
                         "Checkoff Lines-Distributed"."Transaction Type":="Checkoff Lines-Distributed"."transaction type"::"Deposits Contribution";
                         "Checkoff Lines-Distributed".Modify;
                          end else if  Reference='38J' then begin

                         "Checkoff Lines-Distributed"."Transaction Type":="Checkoff Lines-Distributed"."transaction type"::"SchFees Shares";
                            "Checkoff Lines-Distributed".Modify;
                         end;
                         end else if  (Cust."Employer Code"='TELKOM') then begin
                        if Reference='377' then begin
                         "Checkoff Lines-Distributed"."Transaction Type":="Checkoff Lines-Distributed"."transaction type"::"Deposits Contribution";
                         "Checkoff Lines-Distributed".Modify;
                          end else if  Reference='38J' then begin

                         "Checkoff Lines-Distributed"."Transaction Type":="Checkoff Lines-Distributed"."transaction type"::"SchFees Shares";
                            "Checkoff Lines-Distributed".Modify;
                         end;
                         end;


                       until Cust.Next=0;
                  end;



                //****Morris Advice Principle***//

                CheckoffMatrix.Reset;
                CheckoffMatrix.SetRange(CheckoffMatrix."check Interest",false);
                CheckoffMatrix.SetRange(CheckoffMatrix."Employer Code","Employer Code");
                CheckoffMatrix.SetRange(CheckoffMatrix."Check off Code","Checkoff Lines-Distributed".Reference);
                if CheckoffMatrix.Find('-') then begin
                  repeat

                    Loans.SetRange(Loans."Staff No","Staff/Payroll No");
                    Loans.SetRange(Loans."Employer Code","Employer Code");
                    Loans.SetRange(Loans."Loan Product Type",CheckoffMatrix."Loan Product Code");
                     if Loans.Find('-') then begin
                      repeat

                        Loans.CalcFields(Loans."Outstanding Balance");
                        if Loans."Outstanding Balance">0 then begin
                             "Checkoff Lines-Distributed"."Loan Balance":=Loans."Outstanding Balance";
                          "Loan No.":=Loans."Loan  No.";
                          "Loan Type":=Loans."Loan Product Type";
                          "Checkoff Lines-Distributed".adviced:=true;

                                Modify;
                                 end;

                                 until Loans.Next=0;
                               end;
                            until CheckoffMatrix.Next=0;
                            end;

                //**End  Advice Principal Morris***//


                //****Morris Advice Interest***//

                CheckoffMatrix.Reset;
                CheckoffMatrix.SetRange(CheckoffMatrix."check Interest",true);
                CheckoffMatrix.SetRange(CheckoffMatrix."Employer Code","Employer Code");
                CheckoffMatrix.SetRange(CheckoffMatrix."Check off Code","Checkoff Lines-Distributed".Reference);
                if CheckoffMatrix.Find('-') then begin
                  repeat

                    Loans.SetRange(Loans."Staff No","Staff/Payroll No");
                    Loans.SetRange(Loans."Employer Code","Employer Code");
                    Loans.SetRange(Loans."Loan Product Type",CheckoffMatrix."Loan Product Code");
                     if Loans.Find('-') then begin
                      repeat

                        Loans.CalcFields(Loans."Oustanding Interest");
                        if (Loans."Check Int"=false) then begin
                       // IF (Loans."Oustanding Interest">0) THEN BEGIN
                             "Checkoff Lines-Distributed"."Loan Balance":=Loans."Oustanding Interest";
                          "Loan No.":=Loans."Loan  No.";
                          "Loan Type":=Loans."Loan Product Type";
                          "Checkoff Lines-Distributed"."Transaction Type":="Checkoff Lines-Distributed"."transaction type"::"Interest Paid";
                          "Checkoff Lines-Distributed".adviced:=true;
                          Modify;
                                 end;
                                 //END;
                                 until Loans.Next=0;
                               end;
                            until CheckoffMatrix.Next=0;
                            end;


                //**End  Advice Interest Morris***//
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ASATDATE;ASATDATE)
                {
                    ApplicationArea = Basic;
                    Caption = 'As At';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Rcpt: Record "Checkoff Header-Distributed";
        PNo: Integer;
        Cust: Record Customer;
        Dept: Code[10];
        Loans: Record "Loans Register";
        LoanType: Record "Loan Products Setup";
        Pdate: Date;
        Variance: Decimal;
        ASATDATE: Date;
        BaldateTXT: Text[30];
        Baldate: Date;
        Employees: Record "Checkoff Header-Distributed";
        RcptHeader: Record "Checkoff Lines-Distributed";
        BBF: Decimal;
        Checkoff: Record "Checkoff Lines-Distributed";
        Num: Integer;
        INTEREST: Decimal;
        Num1: Integer;
        CheckoffMatrix: Record "Checkoff Distributed Matrix";
        LoansProduct: Record "Loan Products Setup";
}

