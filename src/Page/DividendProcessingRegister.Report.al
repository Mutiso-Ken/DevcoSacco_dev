#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516393 "Dividend Processing Prorated"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Dividend Processing Register.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = Status;
            column(ReportForNavId_6836; 6836)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(OpenBal;OpenBal)
            {
            }
            column(JanAmount;JanAmount)
            {
            }
            column(FebDep;FebDep)
            {
            }
            column(MarcDep;MarcDep)
            {
            }
            column(AprDep;AprDep)
            {
            }
            column(MayDep;MayDep)
            {
            }
            column(JuneDep;JuneDep)
            {
            }
            column(JulyDep;JulyDep)
            {
            }
            column(AugDep;AugDep)
            {
            }
            column(SeptDep;SeptDep)
            {
            }
            column(NovDep;NovDep)
            {
            }
            column(DecDep;DecDep)
            {
            }
            column(OctDep;OctDep)
            {
            }
            column(WHTX;WHTX)
            {
            }
            column(Netpay;Netpay)
            {
            }
            column(Gdividendonsacap;Gdividendonsacap)
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(GInterestOnDeposits;GInterestOnDeposits)
            {
            }
            column(Customer__Current_Shares_;"Current Shares")
            {
            }
            column(CustomerCaption;CustomerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(Customer__Current_Shares_Caption;FieldCaption("Current Shares"))
            {
            }
            column(DividendAmount_Customer;Customer."Dividend Amount")
            {
            }
            column(SharesRetained_Customer;Customer."Shares Retained")
            {
            }

            trigger OnAfterGetRecord()
            begin
                
                Customer."Dividend Amount":=0;
                
                DivProg.Reset;
                DivProg.SetCurrentkey("Member No");
                DivProg.SetRange(DivProg."Member No",Customer."No.");
                if DivProg.Find('-') then
                DivProg.DeleteAll;
                
                if StartDate = 0D then
                Error('You must specify start Date.');
                
                if PostingDate = 0D then
                  Error('Posting Date cannot be Empty');
                
                balancebrought:=0;
                DivTotal:=0;
                "W/Tax":=0;
                CommDiv:=0;
                OpenBal:=0;
                JanAmount:=0;
                FebDep:=0;
                MarcDep:=0;
                AprDep:=0;
                MayDep:=0;
                JuneDep:=0;
                JulyDep:=0;
                AugDep:=0;
                SeptDep:=0;
                NovDep:=0;
                DecDep:=0;
                OctDep:=0;
                OpenB:=0;
                Jan:=0;
                Feb:=0;
                March:=0;
                Apr:=0;
                May:=0;
                June:=0;
                July:=0;
                Aug:=0;
                Sept:=0;
                Nov:=0;
                Dec:=0;
                Oct:=0;
                Netpay:=0;
                GInterestOnDeposits:=0;
                Gdividendonsacap:=0;
                GenSetUp.Get();
                
                //1st Month
                Evaluate(BDate,'01/01/01');
                FromDate:=BDate;
                ToDate:=CalcDate('-1D',StartDate);
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                 // IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")*1))*(12/12));
                    DividendOnSharecap:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")*1))*(12/12));
                    CDiv:=DividendOnSharecap;
                    //MESSAGE('scap %1',DividendOnSharecap);
                    DivTotal:=InterestOnDeposits+DividendOnSharecap;
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg."Gross Dividends":=DivTotal;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares")*1)*(12/12);
                    DivProg.Shares:=Cust."Shares Retained"*1;
                    OpenBal:=InterestOnDeposits;
                    OpenB:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                //january
                FromDate:=StartDate;
                ToDate:=CalcDate('-1D',CalcDate('1M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(12/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    JanAmount:=InterestOnDeposits;
                    Jan:=CDiv;
                    //DivProg.INSERT;
                  end;
                //END;
                
                //february
                FromDate:=CalcDate('1M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('2M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                 // IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(11/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    FebDep:=InterestOnDeposits;
                     Feb:=CDiv;
                    //DivProg.INSERT;
                //  END;
                end;
                
                //march
                FromDate:=CalcDate('2M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('3M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(10/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    MarcDep:=InterestOnDeposits;
                     March:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                //APRIL
                FromDate:=CalcDate('3M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('4M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(9/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    AprDep:=InterestOnDeposits;
                     Apr:=CDiv;
                    //DivProg.INSERT;
                 // END;
                end;
                //MAY
                
                FromDate:=CalcDate('4M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('5M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                 // IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(8/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    MayDep:=InterestOnDeposits;
                     May:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                //JUNE
                FromDate:=CalcDate('5M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('6M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(7/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    JuneDep:=InterestOnDeposits;
                     June:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                //JULY
                FromDate:=CalcDate('6M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('7M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(6/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    JulyDep:=InterestOnDeposits;
                    July:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                //AUGUST
                FromDate:=CalcDate('7M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('8M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(5/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                     AugDep:=InterestOnDeposits;
                      Aug:=CDiv;
                   // DivProg.INSERT;
                  //END;
                end;
                //SEPT
                FromDate:=CalcDate('8M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('9M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(4/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    SeptDep:=InterestOnDeposits;
                     Sept:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                //OCT
                FromDate:=CalcDate('9M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('10M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                 // IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(3/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    OctDep:=InterestOnDeposits;
                     Oct:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                //NOV
                FromDate:=CalcDate('10M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('11M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(2/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                     NovDep:=InterestOnDeposits;
                      Nov:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                //DEC
                FromDate:=CalcDate('11M',StartDate);
                ToDate:=CalcDate('-1D',CalcDate('12M',StartDate));
                Evaluate(FromDateS,Format(FromDate));
                Evaluate(ToDateS,Format(ToDate));
                
                DateFilter:=FromDateS+'..'+ToDateS;
                Cust.Reset;
                Cust.SetCurrentkey("No.");
                Cust.SetRange(Cust."No.",Customer."No.");
                Cust.SetFilter(Cust."Date Filter",DateFilter);
                if Cust.Find('-') then begin
                  Cust.CalcFields(Cust."Current Shares",Cust."Shares Retained");
                  //IF (Cust."Current Shares" <> 0)   THEN BEGIN
                    CDiv:=(((GenSetUp."Dividend (%)"/100)*((Cust."Shares Retained")))*(12/12));
                    InterestOnDeposits:=(((GenSetUp."Interest on Deposits (%)"/100)*((Cust."Current Shares")))*(1/12));
                    DivTotal:=InterestOnDeposits;
                    DivTotal:=(CDiv+InterestOnDeposits);
                    DivProg.Init;
                    DivProg."Member No":=Customer."No.";
                    DivProg.Date:=ToDate;
                    DivProg.Shares:=Cust."Shares Retained";
                    DivProg."Current Shares":=Customer."Current Shares";
                    DivProg."Gross Dividends":=CDiv+DivTotal;
                    DivProg.GrossINT:=InterestOnDeposits;
                    DivProg.GRossSCap:=CDiv;
                    DivProg."Witholding Tax":=(CDiv+DivTotal)*(GenSetUp."Withholding Tax (%)"/100);
                    DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
                    DivProg."Qualifying Shares":=((Cust."Current Shares"+Cust."Shares Retained"));
                    DecDep:=InterestOnDeposits;
                     Dec:=CDiv;
                    //DivProg.INSERT;
                  //END;
                end;
                GInterestOnDeposits:=OpenBal+JanAmount+FebDep+MarcDep+AprDep+MayDep+JuneDep+JulyDep+AugDep+SeptDep+NovDep+DecDep+OctDep;
                Gdividendonsacap:=OpenB+Jan+Feb+March+Apr+May+June+July+Aug+Sept+Oct+Nov+Dec;
                WHTX:=(GInterestOnDeposits+Gdividendonsacap)*0.05;
                Netpay:=(GInterestOnDeposits+Gdividendonsacap)-WHTX;
                //Customer."Dividend Amount":=(DivTotal);
                //MESSAGE('div tot%1',Customer."Dividend Amount");
                //WHTX:=GenSetUp."Withholding Tax (%)"*Cust."Current Savings";
                
                
                //Customer.MODIFY;
                //WHTX:=0;
                //CommDiv:=0;
                
                
                DivProg.Reset;
                DivProg.SetRange(DivProg."Member No",Customer."No.");
                if DivProg.Find('-') then begin
                  repeat
                    //CommDiv:=CommDiv+DivProg."Gross Dividends";
                    //WHTX:=WHTX+DivProg."Witholding Tax";
                    //GInterestOnDeposits:=GInterestOnDeposits+DivProg.GrossINT;
                     //Gdividendonsacap:=Gdividendonsacap+DivProg.GRossSCap;
                    //MESSAGE('Gross%1',GInterestOnDeposits);
                  until DivProg.Next=0;
                end;
                //GInterestOnDeposits:=OpenBal+JanAmount+FebDep+MarcDep+AprDep+MayDep+JuneDep+JulyDep+AugDep+SeptDep+NovDep+DecDep+OctDep
                
                //Customer."Dividend Amount":=(GInterestOnDeposits+Gdividendonsacap);
                //Customer.MODIFY;
                //DivTotal:=CommDiv;
                //Customer.CALCFIELDS(Customer."Shares Retained");
                //DivOnshares:=0;
                //DivOnshares:=(Customer."Shares Retained"*(GenSetUp."Dividend (%)"/100));
                
                
                //delete journal
                
                /*
                IF GInterestOnDeposits <>1 THEN BEGIN
                  GenSetUp.GET();
                  IF (Customer."No."<>'') AND (Loanr.Defaulter=TRUE) THEN BEGIN
                  LineNo:=LineNo+1000;
                  Gnjlline.INIT;
                
                  Gnjlline."Journal Template Name":='GENERAL';
                  Gnjlline."Journal Batch Name":='DIVIDEND';
                  Gnjlline."Document No.":='DIVIDEND'+FORMAT(PostingDate);
                  Gnjlline."Line No.":=LineNo;
                  Gnjlline."Account Type":=Gnjlline."Account Type"::Customer;
                  Gnjlline."Account No.":=Customer."No.";
                  Gnjlline.VALIDATE(Gnjlline."Account No.");
                  Gnjlline."Posting Date":=PostingDate;
                  Gnjlline.Description:='Gross Dividends on Share Capital';
                  Gnjlline.VALIDATE(Gnjlline."Currency Code");
                  Gnjlline.Amount:=(Gdividendonsacap)*-1;
                  Gnjlline.VALIDATE(Gnjlline.Amount);
                  Gnjlline."Bal. Account Type":=Gnjlline."Bal. Account Type"::"G/L Account";
                  Gnjlline."Bal. Account No.":=GenSetUp."Dividend Payable Account";
                  Gnjlline."Transaction Type":=Gnjlline."Transaction Type"::Dividend;
                  Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                  Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                  IF Gnjlline.Amount<>0 THEN
                  Gnjlline.INSERT;
                
                  //Int On Div Acc
                
                LineNo:=LineNo+1000;
                  Gnjlline.INIT;
                
                  Gnjlline."Journal Template Name":='GENERAL';
                  Gnjlline."Journal Batch Name":='DIVIDEND';
                  Gnjlline."Document No.":='DIVIDEND'+FORMAT(PostingDate);
                  Gnjlline."Line No.":=LineNo;
                  Gnjlline."Account Type":=Gnjlline."Account Type"::Customer;
                  Gnjlline."Account No.":=Customer."No.";
                  Gnjlline.VALIDATE(Gnjlline."Account No.");
                  Gnjlline."Posting Date":=PostingDate;
                  Gnjlline.Description:='Gross Interest on Deposits';
                  Gnjlline.VALIDATE(Gnjlline."Currency Code");
                  Gnjlline.Amount:=GInterestOnDeposits*-1;
                  Gnjlline.VALIDATE(Gnjlline.Amount);
                  Gnjlline."Bal. Account Type":=Gnjlline."Bal. Account Type"::"G/L Account";
                  Gnjlline."Bal. Account No.":=GenSetUp."Int On Deposit Payable Acc";
                  Gnjlline."Transaction Type":=Gnjlline."Transaction Type"::Dividend;
                  Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                  Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                  IF Gnjlline.Amount<>0 THEN
                  Gnjlline.INSERT;
                
                  //>W/Tax
                  LineNo:=LineNo+1000;
                  Gnjlline.INIT;
                
                  Gnjlline."Journal Template Name":='GENERAL';
                  Gnjlline."Journal Batch Name":='DIVIDEND';
                  Gnjlline."Document No.":='DIVIDEND'+FORMAT(PostingDate);
                  Gnjlline."Line No.":=LineNo;
                  Gnjlline."Account Type":=Gnjlline."Account Type"::Customer;
                  Gnjlline."Account No.":=Customer."No.";
                  Gnjlline.VALIDATE(Gnjlline."Account No.");
                  Gnjlline."Posting Date":=PostingDate;
                  Gnjlline.Description:='Dividends Withholding Tax';
                  Gnjlline.VALIDATE(Gnjlline."Currency Code");
                
                  Gnjlline.Amount:=WHTX;
                  //(Gdividendonsacap+*(GenSetUp."Withholding Tax"/100)+(CDiv)*(GenSetUp."With. Tax Int. On Deposit(%)"/100));
                
                  Gnjlline.VALIDATE(Gnjlline.Amount);
                  Gnjlline."Bal. Account Type":=Gnjlline."Bal. Account Type"::"G/L Account";
                  Gnjlline."Bal. Account No.":=GenSetUp."Witholding Tax Account";
                  Gnjlline."Transaction Type":=Gnjlline."Transaction Type"::Dividend;
                  Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                  Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                  IF Gnjlline.Amount<>0 THEN
                  Gnjlline.INSERT;
                
                  END ELSE IF Loanr.Defaulter=FALSE THEN BEGIN
                  LineNo:=LineNo+1000;
                  Gnjlline.INIT;
                
                  Gnjlline."Journal Template Name":='GENERAL';
                  Gnjlline."Journal Batch Name":='DIVIDEND';
                  Gnjlline."Document No.":='DIVIDEND'+FORMAT(PostingDate);
                  Gnjlline."Line No.":=LineNo;
                  Gnjlline."Account Type":=Gnjlline."Account Type"::Customer;
                  Gnjlline."Account No.":=Customer."No.";
                  Gnjlline.VALIDATE(Gnjlline."Account No.");
                  Gnjlline."Posting Date":=PostingDate;
                  Gnjlline.Description:='Gross Dividends on Share Capital';
                  Gnjlline.VALIDATE(Gnjlline."Currency Code");
                  Gnjlline.Amount:=(Gdividendonsacap)*-1;
                  Gnjlline.VALIDATE(Gnjlline.Amount);
                  Gnjlline."Bal. Account Type":=Gnjlline."Bal. Account Type"::"G/L Account";
                  Gnjlline."Bal. Account No.":=GenSetUp."Dividend Payable Account";
                  Gnjlline."Transaction Type":=Gnjlline."Transaction Type"::Dividend;
                  Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                  Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                  IF Gnjlline.Amount<>0 THEN
                  Gnjlline.INSERT;
                
                //Int On Div Acc
                
                LineNo:=LineNo+1000;
                  Gnjlline.INIT;
                
                  Gnjlline."Journal Template Name":='GENERAL';
                  Gnjlline."Journal Batch Name":='DIVIDEND';
                  Gnjlline."Document No.":='DIVIDEND'+FORMAT(PostingDate);
                  Gnjlline."Line No.":=LineNo;
                  Gnjlline."Account Type":=Gnjlline."Account Type"::Customer;
                  Gnjlline."Account No.":=Customer."No.";
                  Gnjlline.VALIDATE(Gnjlline."Account No.");
                  Gnjlline."Posting Date":=PostingDate;
                  Gnjlline.Description:='Gross Interest on Deposits';
                  Gnjlline.VALIDATE(Gnjlline."Currency Code");
                  Gnjlline.Amount:=GInterestOnDeposits*-1;
                  Gnjlline.VALIDATE(Gnjlline.Amount);
                  Gnjlline."Bal. Account Type":=Gnjlline."Bal. Account Type"::"G/L Account";
                  Gnjlline."Bal. Account No.":=GenSetUp."Int On Deposit Payable Acc";
                  Gnjlline."Transaction Type":=Gnjlline."Transaction Type"::Dividend;
                  Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                  Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                  IF Gnjlline.Amount<>0 THEN
                  Gnjlline.INSERT;
                
                  //W/Tax
                  LineNo:=LineNo+1000;
                  Gnjlline.INIT;
                
                  Gnjlline."Journal Template Name":='GENERAL';
                  Gnjlline."Journal Batch Name":='DIVIDEND';
                  Gnjlline."Document No.":='DIVIDEND'+FORMAT(PostingDate);
                  Gnjlline."Line No.":=LineNo;
                  Gnjlline."Account Type":=Gnjlline."Account Type"::Customer;
                  Gnjlline."Account No.":=Customer."No.";
                  Gnjlline.VALIDATE(Gnjlline."Account No.");
                  Gnjlline."Posting Date":=PostingDate;
                  Gnjlline.Description:='Dividends Withholding Tax';
                  Gnjlline.VALIDATE(Gnjlline."Currency Code");
                  Gnjlline.Amount:=WHTX;
                  //(DivTotal*(GenSetUp."Withholding Tax"/100)+(CDiv)*(GenSetUp."With. Tax Int. On Deposit(%)"/100));
                
                  Gnjlline.VALIDATE(Gnjlline.Amount);
                  Gnjlline."Bal. Account Type":=Gnjlline."Bal. Account Type"::"G/L Account";
                  Gnjlline."Bal. Account No.":=GenSetUp."Witholding Tax Account";
                  Gnjlline."Transaction Type":=Gnjlline."Transaction Type"::Dividend;
                  Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                  Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                  IF Gnjlline.Amount<>0 THEN
                  Gnjlline.INSERT;
                
                END;
                
                END ELSE*/
                //IF (GInterestOnDeposits > 0) OR  (CDiv>0) THEN BEGIN
                LineNo:=LineNo+1000;
                Gnjlline.Init;
                
                Gnjlline."Journal Template Name":='GENERAL';
                Gnjlline."Journal Batch Name":='DIVIDEND';
                Gnjlline."Document No.":='DIVIDEND'+Format(PostingDate);
                Gnjlline."Line No.":=LineNo;
                Gnjlline."Account Type":=Gnjlline."account type"::Customer;
                Gnjlline."Account No.":=Customer."No.";
                Gnjlline.Validate(Gnjlline."Account No.");
                Gnjlline."Posting Date":=PostingDate;
                Gnjlline.Description:='Dividends on Share Capital';
                Gnjlline.Validate(Gnjlline."Currency Code");
                Gnjlline.Amount:=Gdividendonsacap*-1;
                //(DividendOnSharecap)-"W/Tax";
                Gnjlline.Validate(Gnjlline.Amount);
                Gnjlline."Bal. Account Type":=Gnjlline."bal. account type"::"G/L Account";
                Gnjlline."Bal. Account No.":=GenSetUp."Dividend Payable Account";
                Gnjlline."Transaction Type":=Gnjlline."transaction type"::Dividend;
                Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                if Gnjlline.Amount<>0 then
                Gnjlline.Insert;
                
                //Int On Div Acc
                
                LineNo:=LineNo+1000;
                  Gnjlline.Init;
                  Gnjlline."Journal Template Name":='GENERAL';
                  Gnjlline."Journal Batch Name":='DIVIDEND';
                  Gnjlline."Document No.":='DIVIDEND'+Format(PostingDate);
                  Gnjlline."Line No.":=LineNo;
                  Gnjlline."Account Type":=Gnjlline."account type"::Customer;
                  Gnjlline."Account No.":=Customer."No.";
                  Gnjlline.Validate(Gnjlline."Account No.");
                  Gnjlline."Posting Date":=PostingDate;
                  Gnjlline.Description:='Interest on Deposits';
                  Gnjlline.Validate(Gnjlline."Currency Code");
                  Gnjlline.Amount:=GInterestOnDeposits*-1;
                  //0+InterestOnDeposits;
                  Gnjlline.Validate(Gnjlline.Amount);
                  Gnjlline."Bal. Account Type":=Gnjlline."bal. account type"::"G/L Account";
                  Gnjlline."Bal. Account No.":=GenSetUp."Dividend Payable Account";
                  Gnjlline."Transaction Type":=Gnjlline."transaction type"::Dividend;
                  Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                  Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                  if Gnjlline.Amount<>0 then
                  Gnjlline.Insert;
                
                //>W/Tax
                LineNo:=LineNo+1000;
                Gnjlline.Init;
                
                Gnjlline."Journal Template Name":='GENERAL';
                Gnjlline."Journal Batch Name":='DIVIDEND';
                Gnjlline."Document No.":='DIVIDEND'+Format(PostingDate);
                Gnjlline."Line No.":=LineNo;
                Gnjlline."Account Type":=Gnjlline."account type"::Customer;
                Gnjlline."Account No.":=Customer."No.";
                Gnjlline.Validate(Gnjlline."Account No.");
                Gnjlline."Posting Date":=PostingDate;
                Gnjlline.Description:='Dividends Withholding Tax';
                Gnjlline.Validate(Gnjlline."Currency Code");
                Gnjlline.Amount:=WHTX;
                Gnjlline.Validate(Gnjlline.Amount);
                Gnjlline."Bal. Account Type":=Gnjlline."bal. account type"::"G/L Account";
                Gnjlline."Bal. Account No.":=GenSetUp."Withholding Tax Account";
                Gnjlline."Transaction Type":=Gnjlline."transaction type"::Dividend;
                Gnjlline."Shortcut Dimension 1 Code":='BOSA';
                Gnjlline."Shortcut Dimension 2 Code":='NAIROBI';
                if Gnjlline.Amount<>0 then
                Gnjlline.Insert;
                //END;
                
                //Customer - OnPostDataItem()

            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
                
                // Cust.RESET;
                // Cust.MODIFYALL(Cust."Dividend Amount",0);
                /*
                Gnjlline.RESET;
                Gnjlline.SETRANGE(Gnjlline."Journal Template Name",'GENERAL');
                Gnjlline.SETRANGE(Gnjlline."Journal Batch Name",'DIVIDEND');
                IF Gnjlline.FIND('-') THEN BEGIN
                  Gnjlline.DELETE;
                 END ;
                //End delete journal
                
                
                IF NOT GenBatch.GET('GENERAL','DIVIDEND') THEN
                BEGIN
                GenBatch.INIT;
                GenBatch."Journal Template Name":='GENERAL';
                GenBatch.Name:='DIVIDEND';
                GenBatch.INSERT;
                END;
                */

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate;StartDate)
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate;PostingDate)
                {
                    ApplicationArea = Basic;
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        JanAmount: Decimal;
        OpenBal: Decimal;
        FebDep: Decimal;
        MarcDep: Decimal;
        AprDep: Decimal;
        MayDep: Decimal;
        JuneDep: Decimal;
        JulyDep: Decimal;
        AugDep: Decimal;
        SeptDep: Decimal;
        NovDep: Decimal;
        DecDep: Decimal;
        OctDep: Decimal;
        Cust: Record Customer;
        StartDate: Date;
        DateFilter: Text[100];
        FromDate: Date;
        ToDate: Date;
        FromDateS: Text[100];
        ToDateS: Text[100];
        DivTotal: Decimal;
        GenSetUp: Record "Sacco General Set-Up";
        CDeposits: Decimal;
       
        DivProg: Record "Dividends Progression";
        CDiv: Decimal;
        BDate: Date;
       
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        "W/Tax": Decimal;
        CommDiv: Decimal;
        Loanr: Record "Loans Register";
        LineNo: Integer;
        Gnjlline: Record "Gen. Journal Line";
        PostingDate: Date;
        InterestOnDeposits: Decimal;
        DividendOnSharecap: Decimal;
        WTB: Decimal;
        WHTX: Decimal;
        GenBatch: Record "Gen. Journal Batch";
        memb: Record Customer;
        balancebrought: Decimal;
      
        totbrought: Decimal;
  
        DivOnshares: Decimal;
        GInterestOnDeposits: Decimal;
        Gdividendonsacap: Decimal;
        Jan: Decimal;
        OpenB: Decimal;
        Feb: Decimal;
        March: Decimal;
        Apr: Decimal;
        May: Decimal;
        June: Decimal;
        July: Decimal;
        Aug: Decimal;
        Sept: Decimal;
        Nov: Decimal;
        Dec: Decimal;
        Oct: Decimal;
        Netpay: Decimal;
}

