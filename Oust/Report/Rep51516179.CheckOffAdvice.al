#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516179 "Check Off Advice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check Off Advice.rdlc';

    dataset
    {
        dataitem("Members Register"; Customer)
        {
            DataItemTableView = where(Status = filter(Active));
            RequestFilterFields = "No.", "Employer Code", "Date Filter";
            column(ReportForNavId_1; 1)
            {
            }
            column(MonthlyContribution_MembersRegister; "Members Register"."Monthly Contribution")
            {
            }
            column(No_MembersRegister; "Members Register"."No.")
            {
            }
            column(Name_MembersRegister; "Members Register".Name)
            {
            }
            column(EmployerCode_MembersRegister; "Members Register"."Employer Code")
            {
            }
            column(Total_Loan_Repayment; TRepayment)
            {
            }
            column(MonthlyAdvice; MonthlyAdvice)
            {
            }
            column(mothlcommitment; "Members Register"."Monthly Contribution")
            {
            }
            column(Insurancecontributions; Insurance)
            {
            }
            column(LIKIZO_CONTRIBUTION; LIKIZO)
            {
            }
            column(Share_Capital; scapital)
            {
            }
            column(HOUSING_CONTRIBUTION; HOUSING)
            {
            }
            column(Deposit_Contribution; DEPOSIT)
            {
            }
            column(Interest_Repayment; interest)
            {
            }
            column(Principle_Repayment; principle)
            {
            }
            column(EmployerName; LoansRec."Employer Name")
            {
            }
            column(Employercode; LoansRec."Employer Code")
            {
            }
            column(DOCNAME; DOCNAME)
            {
            }
            column(CName; CompanyInfo.Name)
            {
            }
            column(Caddress; CompanyInfo.Address)
            {
            }
            column(CmobileNo; CompanyInfo."Phone No.")
            {
            }
            column(clogo; CompanyInfo.Picture)
            {
            }
            column(Cwebsite; CompanyInfo."Home Page")
            {
            }
            column(Employer_Name; employername)
            {
            }
            column(normloan; normloan)
            {
            }
            column(College; College)
            {
            }
            column(AssetL; AssetL)
            {
            }
            column(scfee; scfee)
            {
            }
            column(emmerg; emmerg)
            {
            }
            column(Quick; Quick)
            {
            }
            column(karibu; karibu)
            {
            }
            column(Premium; Premium)
            {
            }
            column(Makeover; Makeover) { }

            trigger OnAfterGetRecord()
            begin
                DOCNAME := 'EMPLOYER CHECKOFF ADVICE';
                Prepayment := 0;
                IntRepayment := 0;
                TRepayment := 0;
                PrincipalInterest := 0;
                MonthlyAdvice := 0;
                Lkizo := 0;
                normloan := 0;
                College := 0;
                AssetL := 0;
                scfee := 0;
                emmerg := 0;
                Quick := 0;
                karibu := 0;
                Makeover := 0;
                Premium := 0;
             
                Cust.Reset;
                Cust.SetRange(Cust."No.", "Members Register"."No.");
                Cust.SetRange(Cust."Employer Code", "Members Register"."Employer Code");
                if Cust.Find('-') then begin
                    Gsetup.Get();
                    Cust.CalcFields(Cust."Shares Retained");
                    if Cust."Shares Retained" < Gsetup."Retained Shares" then
                        if (Gsetup."Retained Shares" - Cust."Shares Retained") > 500 then
                            scapital := Gsetup."Shares Contribution"
                        else
                            scapital := Gsetup."Retained Shares" - Cust."Shares Retained"

                    else
                        scapital := 0;

                    LIKIZO := Cust."Likizo Contribution";
                    HOUSING := Cust."Housing Contribution";
                    DEPOSIT := Cust."Monthly Contribution";
                    //Alpha:=Cust."Alpha Savings";
                    /*
                    loans.RESET;
                    loans.SETRANGE(loans."Client Code","Members Register"."No.");
                    IF loans.FIND('-') THEN BEGIN

                      TRepayment:=0;
                      principle:=0;
                      interest:=0;


                      REPEAT
                        loans.CALCFIELDS(loans."Outstanding Balance");
                        IF loans."Outstanding Balance" >0 THEN BEGIN
                          principle:=principle + loans."Loan Principle Repayment";
                          interest:=interest + loans."Loan Interest Repayment";
                          PrincipalInterest:=loans.Repayment;
                          TRepayment:=TRepayment + PrincipalInterest;
                          END;  //loans."Outstanding Balance"
                        UNTIL loans.NEXT=0;
                      END; //loan.find
                    END;  //cust.find
                    */
                    //normloan
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'NORMAL');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            normloan := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            normloan := normloan;//
                        until loans.Next = 0;
                    end;
                    //END
                    //LCount:=LCount+1;
                    //college
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'COLLEGE');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            College := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            College := College;//
                        until loans.Next = 0;
                    end;
                    //Make over
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'MAKEOVER');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            Makeover := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            Makeover := Makeover;//
                        until loans.Next = 0;
                    end;
                    //Premium
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'PREMIUM');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            Premium := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            Premium := Premium;//
                        until loans.Next = 0;
                    end;

                    //school fee
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'SCH_FEES');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            College := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            College := College;//
                        until loans.Next = 0;
                    end;
                    //emmergency fee
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'EMERGENCY');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            emmerg := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            emmerg := emmerg;//
                        until loans.Next = 0;
                    end;

                    //Qickcash
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'QUICK CASH');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            Quick := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            Quick := Quick;//
                        until loans.Next = 0;
                    end;
                    //quic fee
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'KARIBU');

                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            karibu := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            karibu := karibu;//
                        until loans.Next = 0;
                    end;
                    //quic fee
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'ASSET LOAN');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            AssetL := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            AssetL := AssetL;//
                        until loans.Next = 0;
                    end;
                    //quic fee
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'LIKIZO');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            Lkizo := loans."Loan Principle Repayment" + loans."Loan Interest Repayment";
                            Lkizo := Lkizo;//
                        until loans.Next = 0;
                    end;


                    MonthlyAdvice := scapital + LIKIZO + HOUSING + DEPOSIT + normloan + College + scfee + emmerg + Quick + karibu + AssetL + Makeover + Premium;


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

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        LoansRec: Record "Loans Register";
        Prepayment: Decimal;
        IntRepayment: Decimal;
        TRepayment: Decimal;
        PrincipalInterest: Decimal;
        MonthlyAdvice: Decimal;
        DOCNAME: Text[30];
        CompanyInfo: Record "Company Information";
        Gsetup: Record "Sacco General Set-Up";
        Insurance: Decimal;
        insuranceContribution: Decimal;
        scapital: Decimal;
        minbal: Decimal;
        DEPOSIT: Decimal;
        LIKIZO: Decimal;
        HOUSING: Decimal;
        interest: Decimal;
        principle: Decimal;
        loans: Record "Loans Register";
        maxscap: Decimal;
        Cust: Record customer;
        employername: Text;
        member: Record "Sacco Employers";
        normloan: Decimal;
        College: Decimal;
        scfee: Decimal;
        emmerg: Decimal;
        Quick: Decimal;
        karibu: Decimal;
        AssetL: Decimal;
        Lkizo: Decimal;
        Makeover: Decimal;
        Premium: Decimal;
      
}

