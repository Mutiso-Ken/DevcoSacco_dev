report 51516013 "Dividend Register"
{
    ApplicationArea = All;
    Caption = 'Dividend Register';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/DividendRegister.rdlc';

    dataset
    {

        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", Status;
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(FOSA_Account; "FOSA Account")
            {
            }
            column(GrossNWD; GrossNWD)
            {
            }
            column(NWDWTax; NWDWTax)
            {
            }
            column(NetNWD; NetNWD)
            {
            }
            column(GrossFOSAShares; GrossFOSAShares)
            {
            }
            column(FOSASharesWTax; FOSASharesWTax)
            {
            }
            column(NetFOSAShares; NetFOSAShares)
            {
            }
            column(GrossComputerShares; GrossComputerShares)
            {
            }
            column(ComputerSharesWTax; ComputerSharesWTax)
            {
            }
            column(NetComputerShares; NetComputerShares)
            {
            }
            column(GrossVanShares; GrossVanShares)
            {
            }
            column(VanSharesWTax; VanSharesWTax)
            {
            }
            column(NetVanShares; NetVanShares)
            {
            }
            column(GrossPreferentialShares; GrossPreferentialShares)
            {
            }
            column(PreferentialSharesWTax; PreferentialSharesWTax)
            {
            }
            column(NetPreferentialShares; NetPreferentialShares)
            {
            }
            column(GrossLiftShares; GrossLiftShares)
            {
            }
            column(LiftSharesWTax; LiftSharesWTax)
            {
            }
            column(NetLiftShares; NetLiftShares)
            {
            }
            column(GrossPepeaShares; GrossPepeaShares)
            {
            }
            column(PepeaWTax; PepeaWTax)
            {
            }
            column(NetPepeaShares; NetPepeaShares)
            {
            }
            column(GrossTambaaShares; GrossTambaaShares)
            {
            }
            column(TambaaWTax; TambaaWTax)
            {
            }
            column(NetTambaaShares; NetTambaaShares)
            {
            }
            column(GrossHousingShares; GrossHousingShares)
            {
            }
            column(HousingWTax; HousingWTax)
            {
            }
            column(NetHousingShares; NetHousingShares)
            {
            }
            column(CapitalizedDividend; CapitalizedDividend)
            {
            }

            trigger OnPreDataItem()
            var
            begin
                GrossNWD := 0;
                NWDWTax := 0;
                NetNWD := 0;
                GrossFOSAShares := 0;
                FOSASharesWTax := 0;
                NetFOSAShares := 0;
                GrossComputerShares := 0;
                ComputerSharesWTax := 0;
                NetComputerShares := 0;
                GrossVanShares := 0;
                VanSharesWTax := 0;
                NetVanShares := 0;
                GrossPreferentialShares := 0;
                PreferentialSharesWTax := 0;
                NetPreferentialShares := 0;
                GrossLiftShares := 0;
                LiftSharesWTax := 0;
                NetLiftShares := 0;
                GrossPepeaShares := 0;
                PepeaWTax := 0;
                NetPepeaShares := 0;
                GrossTambaaShares := 0;
                TambaaWTax := 0;
                NetTambaaShares := 0;
                GrossHousingShares := 0;
                HousingWTax := 0;
                NetHousingShares := 0;
                CapitalizedDividend := 0;
            end;

            trigger OnAfterGetRecord()
            var
                Cust: Record customer;
                DividendsPorgressionTable: Record "Dividends Progression";
            begin
                Cust.reset;
                Cust.SetRange(Cust."No.", Customer."No.");
                if Cust.Find('-') then begin
                    repeat
                        DividendsPorgressionTable.Reset();
                        DividendsPorgressionTable.SetRange(DividendsPorgressionTable."Member No", Cust."No.");
                        DividendsPorgressionTable.SetRange(DividendsPorgressionTable."Dividend Year", '2022');
                        if DividendsPorgressionTable.Find('-') then begin
                            GrossNWD += DividendsPorgressionTable."Gross Current Shares";
                            NWDWTax += DividendsPorgressionTable."WTax-Current Shares";
                            NetNWD += DividendsPorgressionTable."Net Current Shares";
                            //.........
                            GrossFOSAShares += DividendsPorgressionTable."Gross FOSA Shares";
                            FOSASharesWTax += DividendsPorgressionTable."WTax-FOSA Shares";
                            NetFOSAShares += DividendsPorgressionTable."WTax-FOSA Shares";
                            //.........
                            GrossComputerShares += DividendsPorgressionTable."Gross Computer Shares";
                            ComputerSharesWTax += DividendsPorgressionTable."WTax-Computer Shares";
                            NetComputerShares += DividendsPorgressionTable."Net Computer Shares";
                            //.........
                            GrossVanShares += DividendsPorgressionTable."Gross Van Shares";
                            VanSharesWTax += DividendsPorgressionTable."WTax-Van Shares";
                            NetVanShares += DividendsPorgressionTable."Net Van Shares";
                            //.........
                            GrossPreferentialShares += DividendsPorgressionTable."Gross Preferential Shares";
                            PreferentialSharesWTax += DividendsPorgressionTable."WTax-Preferential Shares";
                            NetPreferentialShares += DividendsPorgressionTable."Net Preferential Shares";
                            //..........
                            GrossLiftShares += DividendsPorgressionTable."Gross Lift Shares";
                            LiftSharesWTax += DividendsPorgressionTable."WTax-Lift Shares";
                            NetLiftShares += DividendsPorgressionTable."Net Lift Shares";
                            //..........
                            GrossPepeaShares += DividendsPorgressionTable."Gross Pepea Shares";
                            PepeaWTax += DividendsPorgressionTable."WTax-Pepea Shares";
                            NetPepeaShares += DividendsPorgressionTable."Net Pepea Shares";
                            //...........
                            GrossTambaaShares += DividendsPorgressionTable."Gross Tambaa Shares";
                            TambaaWTax += DividendsPorgressionTable."WTax-Tambaa Shares";
                            NetTambaaShares += DividendsPorgressionTable."Net Tambaa Shares";
                            //............
                            GrossHousingShares += DividendsPorgressionTable."Gross Housing Shares";
                            HousingWTax += DividendsPorgressionTable."WTax-Housing Shares";
                            NetHousingShares += DividendsPorgressionTable."Net Housing Shares";
                            //.............
                        end;
                    until Cust.Next = 0;
                end
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        GrossNWD: Decimal;
        NWDWTax: Decimal;
        NetNWD: Decimal;

        GrossFOSAShares: Decimal;
        FOSASharesWTax: Decimal;
        NetFOSAShares: Decimal;


        GrossComputerShares: Decimal;
        ComputerSharesWTax: Decimal;
        NetComputerShares: Decimal;

        GrossVanShares: Decimal;
        VanSharesWTax: Decimal;
        NetVanShares: Decimal;

        GrossPreferentialShares: Decimal;
        PreferentialSharesWTax: Decimal;
        NetPreferentialShares: Decimal;

        GrossLiftShares: Decimal;
        LiftSharesWTax: Decimal;
        NetLiftShares: Decimal;

        GrossPepeaShares: Decimal;
        PepeaWTax: Decimal;
        NetPepeaShares: Decimal;

        GrossTambaaShares: Decimal;
        TambaaWTax: Decimal;
        NetTambaaShares: Decimal;

        GrossHousingShares: Decimal;
        HousingWTax: Decimal;
        NetHousingShares: Decimal;

        CapitalizedDividend: Decimal;
}
