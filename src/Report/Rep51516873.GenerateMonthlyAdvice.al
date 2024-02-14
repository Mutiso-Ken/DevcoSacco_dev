#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516873 "Generate Monthly Advice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Generate Monthly Advice.rdlc';

    dataset
    {
        dataitem(Members; Customer)
        {
            DataItemTableView = sorting("Payroll/Staff No", "Customer Type") order(ascending) where("Customer Type" = filter(Member));
            RequestFilterFields = "No.", "Date Filter", "Employer Code", Gender, Status;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(pICT; CompInfo.Picture)
            {
            }
            column(Staff_No; Members."Payroll/Staff No")
            {
            }
            column(No; Members."No.")
            {
            }
            column(Name; Members.Name)
            {
            }
            column(Employer; Members."Employer Code")
            {
            }
            column(MonthlyContrib; Members."Monthly Contribution")
            {
            }
            column(ShareCapContrib; Members."Monthly ShareCap Cont.")
            {
            }
            column(JazaContrib; Members."Monthly ShareCap Cont.")
            {
            }
            column(BenContrib; Members."Monthly ShareCap Cont.")
            {
            }
            column(ShareDriveContrib; Members."Principal Repayment")
            {
            }
            column(RegistrationFee; RegFee)
            {
            }
            column(Dev; MainLoan)
            {
            }
            column(Sch; SchLoan)
            {
            }
            column(Emer; Emergency)
            {
            }
            column(IPO; IPO)
            {
            }
            column(Land; LAND)
            {
            }
            column(Coll; COLL)
            {
            }
            column(INST; INST)
            {
            }
            column(HSe; HSEHOLD)
            {
            }
            column(Premium; premium)
            {
            }
            column(Laptop; laptop)
            {
            }
            column(Cons; cons)
            {
            }
            column(Phone; PHONELOAN)
            {
            }
            column(Defaulter; Default)
            {
            }
            column(Med; MED)
            {
            }
            column(SuperINST; superinst)
            {
            }
            column(CARInst; CarInst)
            {
            }
            column(VIJANAInst; VijanaInst)
            {
            }
            column(Booster; BoosterInst)
            {
            }
            column(sUPER; SuperPremium)
            {
            }
            column(Total_Loan; Members."Outstanding Balance")
            {
            }
            column(Total_Savings; Members."Current Shares")
            {
            }
            column(Advance; Advance)
            {
            }
            column(Business; Business)
            {
            }
            column(Holiday; Holiday)
            {
            }
            column(Insurance; Insurance)
            {
            }
            column(linda; linda)
            {
            }
            column(mid; mid)
            {
            }
            column(personal; personal)
            {
            }
            column(silver; silver)
            {
            }
            column(xmass; xmass)
            {
            }
            column(IntExecutive; IntExecutive)
            {
            }
            column(CollInt; CollInt)
            {
            }
            column(DevInt; DevInt)
            {
            }
            column(SchFeesInt; SchFeesInt)
            {
            }
            column(DigitalInt; DigitalInt)
            {
            }
            column(MfadhiliInt; MfadhiliInt)
            {
            }
            column(MasomoInt; MasomoInt)
            {
            }
            column(Masomoplustint; Masomoplustint)
            {
            }
            column(xmassavings; xmassavings)
            {
            }
            column(InvestmentMonthlyCont_Members; Members."Investment Monthly Cont")
            {
            }
            column(Welfare; Welfare)
            {
            }
            column(Totalded; "Total Deduction2")
            {
            }
            column(TotalLoans; TotalLoans)
            {
            }
            column(StaffcarInt; StaffcarInt)
            {
            }
            column(StaffHousingInt; StaffHousingInt)
            {
            }
            column(xmassint; xmassint)
            {
            }

            trigger OnAfterGetRecord()
            begin
                GenSetup.Get;


                CurrPageNumber := CurrPageNumber + 1;
                Default := 0;
                MainLoan := 0;
                SchLoan := 0;
                PHONELOAN := 0;
                Emergency := 0;
                COLL := 0;
                HSEHOLD := 0;
                INST := 0;
                cons := 0;
                MED := 0;
                LAND := 0;
                IPO := 0;
                premium := 0;
                laptop := 0;
                TotalLoans := 0;
                Shares := 0;
                Deposits := 0;
                superinst := 0;
                CarInst := 0;
                TCarinst := 0;
                VijanaInst := 0;
                TvijanaInst := 0;
                BoosterInst := 0;
                TBoosterInst := 0;
                SuperPremium := 0;
                TOTSuperPremium := 0;
                RegFee := 0;
                Advance := 0;
                Business := 0;
                Holiday := 0;
                Insurance := 0;
                linda := 0;
                mid := 0;
                personal := 0;
                silver := 0;
                xmass := 0;
                Welfare := 300;
                DevInt := 0;
                CollInt := 0;
                MasomoInt := 0;
                Masomoplustint := 0;
                MfadhiliInt := 0;
                SchFeesInt := 0;
                DigitalInt := 0;
                IntExecutive := 0;
                StaffcarInt := 0;
                StaffHousingInt := 0;
                xmassint := 0;
                Cust.Reset;
                Cust.SetRange(Cust."No.", "No.");
                if Cust.Find('-') then begin
                    Cust.CalcFields(Cust."Shares Retained", Cust."Registration Fee Paid");
                    if Cust."Advice Type" = Cust."advice type"::"New Member" then begin
                        RegFee := GenSetup."Registration Fee";
                    end;

                    if Cust."Advice Type" = Cust."advice type"::"Reintroduction With Reg Fees" then begin
                        RegFee := GenSetup."Rejoining Fee";//GenSetup."Registration Fee";
                    end;

                    if Cust."Registration Fee Paid" = GenSetup."Registration Fee" then begin
                        RegFee := 0;
                        Cust."Advice Type" := Cust."advice type"::" ";
                        Cust.Modify;
                    end;
                end;

                Vendor.Reset;
                Vendor.SetRange(Vendor."BOSA Account No", Members."No.");
                Vendor.SetRange(Vendor."Account Type", 'CHRISTMAS');
                if Vendor.Find('-') then begin
                    xmassavings := Vendor."Monthly Contribution";

                end;
                //Fosa loans
                // Advance

                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'ADVANCE');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Salary then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        Advance := Advance + LoanApp.Repayment
                                    else
                                        Advance := Advance + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        Advance := Advance + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                    until LoanApp.Next = 0;
                end;


                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'DIGITAL');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    Business := Business + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        Business := Business + LoanApp."Outstanding Balance";  // + (LoanApp."Outstanding Balance"*0.01);
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            DigitalInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                            //MESSAGE();
                        end

                    until LoanApp.Next = 0;
                end;



                //digital


                // MFADHILI
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'MFADHILI');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    Holiday := Holiday + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        Holiday := Holiday + LoanApp."Outstanding Balance";   //+ (LoanApp."Outstanding Balance"*0.01);
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            MfadhiliInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                            //MfadhiliInt:=ROUND(LoanApp."Oustanding Interest");
                        end;
                    until LoanApp.Next = 0;
                end;
                //mfadhili

                // MASOMO
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'MASOMO');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    Insurance := Insurance + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        Insurance := Insurance + LoanApp."Outstanding Balance";  // + (LoanApp."Outstanding Balance"*0.01);
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            MasomoInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                        end;
                    until LoanApp.Next = 0;

                end;
                //MASOMO


                // PEPEA
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'PEPEA');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    linda := linda + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        linda := linda + LoanApp."Outstanding Balance";  //+ (LoanApp."Outstanding Balance"*0.01);
                    until LoanApp.Next = 0;
                end;
                //PEPEA


                // MIDYEAR is staff car
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'STAFF CAR');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    mid := mid + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        mid := mid + LoanApp."Outstanding Balance";// + (LoanApp."Outstanding Balance"*0.01);
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            StaffcarInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                        end;

                    until LoanApp.Next = 0;
                end;
                //STAFF CAR


                // NORM ADV
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'NORM ADV');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    personal := personal + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        personal := personal + LoanApp."Outstanding Balance"; // + (LoanApp."Outstanding Balance"*0.01);
                    until LoanApp.Next = 0;
                end;
                //NORM ADV


                // STAFF HOUSING
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'STAFF HOUSING');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    silver := silver + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        silver := silver + LoanApp."Outstanding Balance"; // + (LoanApp."Outstanding Balance"*0.01);
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            StaffHousingInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                            //StaffHousingInt:=ROUND(LoanApp."Oustanding Interest");
                        end;
                    until LoanApp.Next = 0;
                end;
                //STAFF HOUSING

                //----------------------SMART HOME------------------------------------------------
                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'SMART HOME');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    silver := silver + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        silver := silver + LoanApp."Outstanding Balance"; // + (LoanApp."Outstanding Balance"*0.01);
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            StaffHousingInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                        end;
                    until LoanApp.Next = 0;
                end;
                // XMASS
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'DEVTVIA_SAVINGS');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    xmass := xmass + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        xmass := xmass + LoanApp."Outstanding Balance";  //+ (LoanApp."Outstanding Balance"*0.01);
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            xmassint := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                        end;
                    until LoanApp.Next = 0;
                end;
                //XMASS

                //............................. CHANGAMKA ADVANCE............................................//
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'CHANGAMKA');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    Insurance := Insurance + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        Insurance := Insurance + LoanApp."Outstanding Balance";  // + (LoanApp."Outstanding Balance"*0.01);
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            MasomoInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                        end;
                    until LoanApp.Next = 0;

                end;

                //............................END OF CHANGAMKA..............................................//


                //......................Executive Loan.....................................................//

                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'EXECUTIVE');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Monthly Repayment" < LoanApp."Outstanding Balance") then
                                    MainLoan := MainLoan + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        MainLoan := MainLoan + LoanApp."Outstanding Balance";// + (LoanApp."Outstanding Balance"*0.01);

                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            IntExecutive := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                            //IntExecutive:=ROUND(LoanApp."Oustanding Interest");
                        end;
                    until LoanApp.Next = 0;

                end;


                //Developemt loan /Normal loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'DEVELOPMENT');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    cons := cons + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        cons := cons + LoanApp."Outstanding Balance"; //+ (LoanApp."Outstanding Balance"*0.01);

                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            DevInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                            //DevInt:=ROUND(LoanApp."Oustanding Interest");
                        end;
                    until LoanApp.Next = 0;
                end;


                //IPO Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'IPO');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        IPO := IPO + LoanApp.Repayment
                                    else
                                        IPO := IPO + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        IPO := IPO + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                IPO := IPO + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;



                //SCHOOL Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'SCHOOL FEES');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    SchLoan := SchLoan + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        SchLoan := SchLoan + LoanApp."Outstanding Balance"; // + (LoanApp."Outstanding Balance"*0.01);

                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            SchFeesInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                        end;
                    until LoanApp.Next = 0;
                end;




                //Emergency Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'EMER');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        Emergency := Emergency + LoanApp.Repayment
                                    else
                                        Emergency := Emergency + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        Emergency := Emergency + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                Emergency := Emergency + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;



                //LAND Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'LAND');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        LAND := LAND + LoanApp.Repayment
                                    else
                                        LAND := LAND + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        LAND := LAND + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                LAND := LAND + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;




                //masomo plus Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'MASOMOPLUS');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    INST := INST + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        INST := INST + LoanApp."Outstanding Balance"; //+ (LoanApp."Outstanding Balance"*0.01);
                                                                                      //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                                                                                      //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                                                                                      /*IF (  LoanApp."Outstanding Balance" > 10) THEN BEGIN
                                                                                      IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                                                                                      INST:=INST+LoanApp."Check Off Amount"
                                                                                      END;*/
                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin
                            Masomoplustint := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                        end;
                    until LoanApp.Next = 0;
                end;

                //masomo plus



                //HSEHOLD Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'HSEHOLD');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        HSEHOLD := HSEHOLD + LoanApp.Repayment
                                    else
                                        HSEHOLD := HSEHOLD + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        HSEHOLD := HSEHOLD + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                HSEHOLD := HSEHOLD + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;




                //LAPTOP Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'LAP');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        laptop := laptop + LoanApp.Repayment
                                    else
                                        laptop := laptop + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        laptop := laptop + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.015);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                laptop := laptop + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;


                //PREMIUM Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'PREMIUM');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        premium := premium + LoanApp.Repayment
                                    else
                                        premium := premium + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        premium := premium + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.0125);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                premium := premium + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;


                //PHONE Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'PHONE');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        PHONELOAN := PHONELOAN + LoanApp.Repayment
                                    else
                                        PHONELOAN := PHONELOAN + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        PHONELOAN := PHONELOAN + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                PHONELOAN := PHONELOAN + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;



                //COLLege loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'COLLEGE');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 0) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    COLL := COLL + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        COLL := COLL + LoanApp."Outstanding Balance"; // + (LoanApp."Outstanding Balance"*0.01);

                        if (LoanApp."Outstanding Balance" >= 0) and (LoanApp."Oustanding Interest" >= 0) then begin

                            CollInt := ROUND(LoanApp."Oustanding Interest" + (LoanApp."Outstanding Balance" * (LoanApp.Interest / 1200)), 0.01, '>');
                            //CollInt:=ROUND(LoanApp."Oustanding Interest");
                        end;
                    until LoanApp.Next = 0;
                end;




                //MED Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'MED');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        MED := MED + LoanApp.Repayment
                                    else
                                        MED := MED + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        MED := MED + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                MED := MED + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;




                //DEFAULTER Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'DEFAULTER');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        Default := Default + LoanApp.Repayment
                                    else
                                        Default := Default + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        Default := Default + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                Default := Default + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;



                //SUPA Instant Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'SUPA');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        superinst := superinst + LoanApp.Repayment
                                    else
                                        superinst := superinst + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        superinst := superinst + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                superinst := superinst + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;




                //CAR Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'CAR');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        CarInst := CarInst + LoanApp.Repayment
                                    else
                                        CarInst := CarInst + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        CarInst := CarInst + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                CarInst := CarInst + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                    //MESSAGE('THE CAR LOAN BAL IS %1',CarInst);
                end;



                //VIJANA Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'VIJANA');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        VijanaInst := VijanaInst + LoanApp.Repayment
                                    else
                                        VijanaInst := VijanaInst + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        VijanaInst := VijanaInst + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                VijanaInst := VijanaInst + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;



                //SUPER Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'SUPER');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                            if (LoanApp."Outstanding Balance" > 10) then
                                if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                    if LoanApp."Loan Principle Repayment" = 0 then
                                        SuperPremium := SuperPremium + LoanApp.Repayment
                                    else
                                        SuperPremium := TOTSuperPremium + LoanApp."Loan Principle Repayment"
                                else
                                    if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                        SuperPremium := SuperPremium + LoanApp."Outstanding Balance" + (LoanApp."Outstanding Balance" * 0.01);
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                SuperPremium := SuperPremium + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;


                //BOOSTER Loan
                LoanApp.Reset;
                //LoanApp.SETRANGE(LoanApp."Date filter",0D,MaxDate);
                LoanApp.SetRange(LoanApp."Issued Date", 0D, MaxDate);
                LoanApp.SetCurrentkey(LoanApp."Client Code", LoanApp."Loan Product Type", LoanApp.Posted, LoanApp."Issued Date");
                LoanApp.SetRange(LoanApp."Client Code", Members."No.");
                LoanApp.SetRange(LoanApp."Loan Product Type", 'BOOSTER');
                LoanApp.SetRange(LoanApp.Posted, true);
                if LoanApp.Find('-') then begin
                    repeat
                        LoanApp.CalcFields(LoanApp."Outstanding Balance");
                        //IF LoanApp."standing order" = FALSE THEN
                        if (LoanApp."Outstanding Balance" > 10) then
                            if (LoanApp."Loan Principle Repayment" < LoanApp."Outstanding Balance") then
                                //IF LoanApp."Loan Principle Repayment" = 0 THEN
                                //BoosterInst:=BoosterInst+LoanApp.Repayment
                                //ELSE
                                BoosterInst := BoosterInst + LoanApp."Loan Principle Repayment"
                            else
                                if (LoanApp."Loan Principle Repayment" > LoanApp."Outstanding Balance") then
                                    BoosterInst := BoosterInst + LoanApp."Outstanding Balance";
                        //IF LoanApp."Recovery Mode"=LoanApp."Recovery Mode"::Checkoff THEN
                        //MainLoan:=MainLoan+LoanApp."Check Off Amount"
                        if (LoanApp."Outstanding Balance" > 10) then begin
                            if LoanApp."Recovery Mode" = LoanApp."recovery mode"::Checkoff then
                                BoosterInst := BoosterInst + LoanApp."Check Off Amount"
                        end;

                    until LoanApp.Next = 0;
                end;





                TotalLoans := MainLoan + SchLoan + Emergency + IPO + LAND + INST + COLL + Default + MED + HSEHOLD + premium + laptop + PHONELOAN + TCarinst +
                +TvijanaInst + Members."Monthly Contribution" + cons + Members."Monthly ShareCap Cont." + Advance +
                Business + Holiday + Insurance + linda + mid + silver + personal + xmass + IntExecutive + CollInt + DevInt + SchFeesInt + DigitalInt + MfadhiliInt + MasomoInt + Masomoplustint + StaffcarInt + StaffHousingInt + xmassint; // Cust."Jaza Jaza Contribution"
                                                                                                                                                                                                                                            //message('total loans is %1',TotalLoans);

                //Check if amount is >0
                /*IF TotalLoans=0 THEN
                CurrReport.SKIP;*/

                TMainLoan := TMainLoan + MainLoan;
                TSchLoan := TSchLoan + SchLoan;
                TEmergency := TEmergency + Emergency;
                TShares := TShares + Members."Monthly Contribution";
                tjazajaza := tjazajaza;  //Cust."Jaza Jaza Contribution";
                TINVESTMENT := TINVESTMENT + Cust."Investment Monthly Cont";
                TIPO := TIPO + IPO;
                TLAND := TLAND + LAND;
                TCOLL := TCOLL + COLL;
                TPHONELOAN := TPHONELOAN + PHONELOAN;
                TMED := TMED + MED;
                TDefault := TDefault + Default;
                TINST := TINST + INST;
                THSEHOLD := THSEHOLD + HSEHOLD;
                Tcons := Tcons + cons;
                Tsuperinst := Tsuperinst + superinst;
                TCarinst := TCarinst + CarInst;
                TvijanaInst := TvijanaInst + VijanaInst;
                TBoosterInst := TBoosterInst + BoosterInst;
                xmassavings := Vendor."Monthly Contribution";
                Welfare := Welfare;
                //TotalLoans:=MainLoan+SchLoan+Emergency+IPO+LAND+INST+COLL+MED+HSEHOLD+premium+laptop+TShares+Tcons;

                "Total Deduction2" := TotalLoans + RegFee + Welfare + Vendor."Monthly Contribution";
                /*
                IF Members.Status = Members.Status::Withdrawal THEN
                CurrReport.SKIP;
                */
                //MESSAGE('total deds is %1',"Total Deduction2");

            end;

            trigger OnPreDataItem()
            begin
                CompInfo.Get;

                MaxDate := GetRangemax(Members."Date Filter");
                Members.SetRange(Members."Date Filter", 0D, MaxDate);
                DateFilter := Members.GetFilter(Members."Date Filter");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Filter';
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
        CompInfo: Record "Company Information";
        LoanApp: Record "Loans Register";
        MainLoan: Decimal;
        SchLoan: Decimal;
        Emergency: Decimal;
        TMainLoan: Decimal;
        TDefault: Decimal;
        TSchLoan: Decimal;
        TEmergency: Decimal;
        TShares: Decimal;
        LoanApplications: Record "Loans Register";
        DateFilter: Text[150];
        Defaulter: Decimal;
        Default: Decimal;
        GuarLoan: Decimal;
        TGuarLoan: Decimal;
        TotalLoans: Decimal;
        CurrPageNumber: Integer;
        CustLedger: Record "Cust. Ledger Entry";
        MaxDate: Date;
        DateFilt: Text[30];
        mindate: Date;
        TCOLL: Decimal;
        COLL: Decimal;
        HSEHOLD: Decimal;
        THSEHOLD: Decimal;
        INST: Decimal;
        TINST: Decimal;
        TMED: Decimal;
        MED: Decimal;
        LAND: Decimal;
        TLAND: Decimal;
        IPO: Decimal;
        TIPO: Decimal;
        premium: Decimal;
        Tpremium: Decimal;
        laptop: Decimal;
        Tlaptop: Decimal;
        "Total Deduction2": Decimal;
        cons: Decimal;
        Tcons: Decimal;
        TINVESTMENT: Decimal;
        PHONELOAN: Decimal;
        TPHONELOAN: Decimal;
        Shares: Decimal;
        Deposits: Decimal;
        RegFee: Decimal;
        Cust: Record Customer;
        tjazajaza: Decimal;
        superinst: Decimal;
        Tsuperinst: Decimal;
        CarInst: Decimal;
        CARLOAN: Decimal;
        TCarinst: Decimal;
        VijanaInst: Decimal;
        TvijanaInst: Decimal;
        BoosterInst: Decimal;
        TBoosterInst: Decimal;
        SuperPremium: Decimal;
        TOTSuperPremium: Decimal;
        GenSetup: Record "Sacco General Set-Up";
        Advance: Decimal;
        Business: Decimal;
        Holiday: Decimal;
        Insurance: Decimal;
        linda: Decimal;
        mid: Decimal;
        personal: Decimal;
        silver: Decimal;
        xmass: Decimal;
        IntExecutive: Decimal;
        CollInt: Decimal;
        DevInt: Decimal;
        SchFeesInt: Decimal;
        DigitalInt: Decimal;
        MfadhiliInt: Decimal;
        MasomoInt: Decimal;
        Masomoplustint: Decimal;
        Vendor: Record Vendor;
        xmassavings: Decimal;
        Welfare: Decimal;
        StaffcarInt: Decimal;
        StaffHousingInt: Decimal;
        xmassint: Decimal;
}

