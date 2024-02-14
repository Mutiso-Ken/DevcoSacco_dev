#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516449 "FOSA Statistics"
{
    Caption = 'Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Book Balance';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }

                field("Uncleared Cheques"; "Uncleared Cheques")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Outstanding Overdraft"; "Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Outstanding Okoa Biz"; "Outstanding okoa biashara")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Outstanding FOSA Loan"; "Outstanding FOSA Loan")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                    Caption = 'Outstanding FOSA Loans';
                }
                field("Outstanding FOSA Interest"; "Outstanding FOSA Interest")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    Caption = 'Book Balance';
                    ApplicationArea = Basic;
                    StyleExpr = true;

                    trigger OnDrillDown()
                    var
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                    begin
                        DtldVendLedgEntry.SetRange("Vendor No.", "No.");
                        Copyfilter("Global Dimension 1 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 1");
                        Copyfilter("Global Dimension 2 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 2");
                        Copyfilter("Currency Filter", DtldVendLedgEntry."Currency Code");
                        VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
                    end;
                }
            }
            part("Loans Sub-Page List"; "Loans Sub-Page List")
            {

                SubPageLink = "Client Code" = field("BOSA Account No");

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if CurrentDate <> WorkDate then begin
            CurrentDate := WorkDate;
            DateFilterCalc.CreateAccountingPeriodFilter(VendDateFilter[1], VendDateName[1], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(VendDateFilter[2], VendDateName[2], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(VendDateFilter[3], VendDateName[3], CurrentDate, -1);
        end;

        SetRange("Date Filter", 0D, CurrentDate);

        for i := 1 to 4 do begin
            SetFilter("Date Filter", VendDateFilter[i]);
            CalcFields(
              "Purchases (LCY)", "Inv. Discounts (LCY)", "Inv. Amounts (LCY)", "Pmt. Discounts (LCY)",
              "Pmt. Disc. Tolerance (LCY)", "Pmt. Tolerance (LCY)",
              "Fin. Charge Memo Amounts (LCY)", "Cr. Memo Amounts (LCY)", "Payments (LCY)",
              "Reminder Amounts (LCY)", "Refunds (LCY)", "Other Amounts (LCY)");
            VendPurchLCY[i] := "Purchases (LCY)";
            VendInvDiscAmountLCY[i] := "Inv. Discounts (LCY)";
            InvAmountsLCY[i] := "Inv. Amounts (LCY)";
            VendPaymentDiscLCY[i] := "Pmt. Discounts (LCY)";
            VendPaymentDiscTolLCY[i] := "Pmt. Disc. Tolerance (LCY)";
            VendPaymentTolLCY[i] := "Pmt. Tolerance (LCY)";
            VendReminderChargeAmtLCY[i] := "Reminder Amounts (LCY)";
            VendFinChargeAmtLCY[i] := "Fin. Charge Memo Amounts (LCY)";
            VendCrMemoAmountsLCY[i] := "Cr. Memo Amounts (LCY)";
            VendPaymentsLCY[i] := "Payments (LCY)";
            VendRefundsLCY[i] := "Refunds (LCY)";
            VendOtherAmountsLCY[i] := "Other Amounts (LCY)";
        end;
        SetRange("Date Filter", 0D, CurrentDate);
    end;

    var
        Text000: label 'Overdue Amounts ($) as of %1';
        DateFilterCalc: Codeunit "DateFilter-Calc";
        VendDateFilter: array[4] of Text[30];
        VendDateName: array[4] of Text[30];
        CurrentDate: Date;
        VendPurchLCY: array[4] of Decimal;
        VendInvDiscAmountLCY: array[4] of Decimal;
        VendPaymentDiscLCY: array[4] of Decimal;
        VendPaymentDiscTolLCY: array[4] of Decimal;
        VendPaymentTolLCY: array[4] of Decimal;
        VendReminderChargeAmtLCY: array[4] of Decimal;
        VendFinChargeAmtLCY: array[4] of Decimal;
        VendCrMemoAmountsLCY: array[4] of Decimal;
        VendPaymentsLCY: array[4] of Decimal;
        VendRefundsLCY: array[4] of Decimal;
        VendOtherAmountsLCY: array[4] of Decimal;
        i: Integer;
        InvAmountsLCY: array[4] of Decimal;
        Text001: label 'Placeholder';
}

