#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516447 "Acc. Schedule Overview List"
{
    Caption = 'Acc. Schedule Overview';
    DataCaptionExpression = CurrentSchedName + ' - ' + CurrentColumnName;
    LinksAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Acc. Schedule Line";
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CurrentSchedName; CurrentSchedName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Schedule Name';
                    Lookup = true;
                    LookupPageID = "Account Schedule Names";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(AccSchedManagement.LookupName(CurrentSchedName, Text));
                    end;

                    trigger OnValidate()
                    begin
                        AccSchedManagement.CheckName(CurrentSchedName);
                        CurrentSchedNameOnAfterValidate;
                    end;
                }
                field(CurrentColumnName; CurrentColumnName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Column Layout Name';
                    Lookup = true;
                    TableRelation = "Column Layout Name".Name;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(AccSchedManagement.LookupColumnName(CurrentColumnName, Text));
                    end;

                    trigger OnValidate()
                    begin
                        AccSchedManagement.CheckColumnName(CurrentColumnName);
                        CurrentColumnNameOnAfterValidate;
                    end;
                }
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';

                    trigger OnValidate()
                    begin
                        AccSchedManagement.FindPeriod(Rec, '', PeriodType);
                        DateFilter := GetFilter("Date Filter");
                        CurrPage.Update;
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    var
                        SystemGeneralSetUp: Codeunit "System General Setup";
                    begin
                        if SystemGeneralSetUp.MakeDateFilter(DateFilter) = 0 then;
                        SetFilter("Date Filter", DateFilter);
                        DateFilter := GetFilter("Date Filter");
                        CurrPage.Update;
                    end;
                }
            }
            repeater(Control48)
            {
                Editable = false;
                field("Row No."; "Row No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(ColumnValues1; ColumnValues[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(1);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[1];
                    StyleExpr = ColumnStyle1;

                    trigger OnDrillDown()
                    begin
                        DrillDown(1);
                    end;
                }
                field(ColumnValues2; ColumnValues[2])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(2);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[2];
                    StyleExpr = ColumnStyle2;

                    trigger OnDrillDown()
                    begin
                        DrillDown(2);
                    end;
                }
                field(ColumnValues3; ColumnValues[3])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(3);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[3];
                    StyleExpr = ColumnStyle3;

                    trigger OnDrillDown()
                    begin
                        DrillDown(3);
                    end;
                }
                field(ColumnValues4; ColumnValues[4])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(4);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[4];
                    StyleExpr = ColumnStyle4;

                    trigger OnDrillDown()
                    begin
                        DrillDown(4);
                    end;
                }
                field(ColumnValues5; ColumnValues[5])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(5);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[5];
                    StyleExpr = ColumnStyle5;

                    trigger OnDrillDown()
                    begin
                        DrillDown(5);
                    end;
                }
                field(ColumnValues6; ColumnValues[6])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(6);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[6];
                    StyleExpr = ColumnStyle6;

                    trigger OnDrillDown()
                    begin
                        DrillDown(6);
                    end;
                }
                field(ColumnValues7; ColumnValues[7])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(7);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[7];
                    StyleExpr = ColumnStyle7;

                    trigger OnDrillDown()
                    begin
                        DrillDown(7);
                    end;
                }
                field(ColumnValues8; ColumnValues[8])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(8);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[8];
                    StyleExpr = ColumnStyle8;

                    trigger OnDrillDown()
                    begin
                        DrillDown(8);
                    end;
                }
                field(ColumnValues9; ColumnValues[9])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(9);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[9];
                    StyleExpr = ColumnStyle9;

                    trigger OnDrillDown()
                    begin
                        DrillDown(9);
                    end;
                }
                field(ColumnValues10; ColumnValues[10])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(10);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[10];
                    StyleExpr = ColumnStyle10;

                    trigger OnDrillDown()
                    begin
                        DrillDown(10);
                    end;
                }
                field(ColumnValues11; ColumnValues[11])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(11);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[11];
                    StyleExpr = ColumnStyle11;

                    trigger OnDrillDown()
                    begin
                        DrillDown(11);
                    end;
                }
                field(ColumnValues12; ColumnValues[12])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = FormatStr(12);
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[12];
                    StyleExpr = ColumnStyle12;

                    trigger OnDrillDown()
                    begin
                        DrillDown(12);
                    end;
                }
            }
            group("Dimension Filters")
            {
                Caption = 'Dimension Filters';
                field(Dim1Filter; Dim1Filter)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FormGetCaptionClass(1);
                    Caption = 'Dimension 1 Filter';
                    Enabled = Dim1FilterEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimValue: Record "Dimension Value";
                    begin
                        exit(DimValue.LookUpDimFilter(AnalysisView."Dimension 1 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        SetDimFilters(1, Dim1Filter);
                    end;
                }
                field(Dim2Filter; Dim2Filter)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FormGetCaptionClass(2);
                    Caption = 'Dimension 2 Filter';
                    Enabled = Dim2FilterEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimValue: Record "Dimension Value";
                    begin
                        exit(DimValue.LookUpDimFilter(AnalysisView."Dimension 2 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        SetDimFilters(2, Dim2Filter);
                    end;
                }
                field(Dim3Filter; Dim3Filter)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FormGetCaptionClass(3);
                    Caption = 'Dimension 3 Filter';
                    Enabled = Dim3FilterEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimValue: Record "Dimension Value";
                    begin
                        exit(DimValue.LookUpDimFilter(AnalysisView."Dimension 3 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        SetDimFilters(3, Dim3Filter);
                    end;
                }
                field(Dim4Filter; Dim4Filter)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FormGetCaptionClass(4);
                    Caption = 'Dimension 4 Filter';
                    Enabled = Dim4FilterEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimValue: Record "Dimension Value";
                    begin
                        exit(DimValue.LookUpDimFilter(AnalysisView."Dimension 4 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        SetDimFilters(4, Dim4Filter);
                    end;
                }
                field(CostCenterFilter; CostCenterFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Center Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CostCenter: Record "Cost Center";
                    begin
                        exit(CostCenter.LookupCostCenterFilter(Text));
                    end;

                    trigger OnValidate()
                    begin
                        if CostCenterFilter = '' then
                            SetRange("Cost Center Filter")
                        else
                            SetFilter("Cost Center Filter", CostCenterFilter);
                        CurrPage.Update;
                    end;
                }
                field(CostObjectFilter; CostObjectFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Object Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CostObject: Record "Cost Object";
                    begin
                        exit(CostObject.LookupCostObjectFilter(Text));
                    end;

                    trigger OnValidate()
                    begin
                        if CostObjectFilter = '' then
                            SetRange("Cost Object Filter")
                        else
                            SetFilter("Cost Object Filter", CostObjectFilter);
                        CurrPage.Update;
                    end;
                }
                field(CashFlowFilter; CashFlowFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Flow Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CashFlowForecast: Record "Cash Flow Forecast";
                    begin
                        exit(CashFlowForecast.LookupCashFlowFilter(Text));
                    end;

                    trigger OnValidate()
                    begin
                        if CashFlowFilter = '' then
                            SetRange("Cash Flow Forecast Filter")
                        else
                            SetFilter("Cash Flow Forecast Filter", CashFlowFilter);
                        CurrPage.Update;
                    end;
                }
                field("G/LBudgetFilter"; GLBudgetFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Budget Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Result: Boolean;
                    begin
                        Result := LookupGLBudgetFilter(Text);
                        if Result then begin
                            SetFilter("G/L Budget Filter", Text);
                            Text := GetFilter("G/L Budget Filter");
                        end;
                        exit(Result);
                    end;

                    trigger OnValidate()
                    begin
                        if GLBudgetFilter = '' then
                            SetRange("G/L Budget Filter")
                        else
                            SetFilter("G/L Budget Filter", GLBudgetFilter);
                        CurrPage.Update;
                    end;
                }
                field(CostBudgetFilter; CostBudgetFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Budget Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Result: Boolean;
                    begin
                        Result := LookupCostBudgetFilter(Text);
                        if Result then begin
                            SetFilter("Cost Budget Filter", Text);
                            Text := GetFilter("Cost Budget Filter");
                        end;
                        exit(Result);
                    end;

                    trigger OnValidate()
                    begin
                        if CostBudgetFilter = '' then
                            SetRange("Cost Budget Filter")
                        else
                            SetFilter("Cost Budget Filter", CostBudgetFilter);
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditAccountSchedule)
            {
                ApplicationArea = Basic;
                Caption = 'Print Schedule';
                Promoted = true;
                Image = Print;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AccSched: Report "Devco Account Schedule";
                    DateFilter2: Text[30];
                    GLBudgetFilter2: Text[30];
                    BusUnitFilter: Text[30];
                    CostBudgetFilter2: Text[30];
                begin
                    AccSched.SetAccSchedName(CurrentSchedName);
                    AccSched.SetColumnLayoutName(CurrentColumnName);
                    DateFilter2 := GetFilter("Date Filter");
                    GLBudgetFilter2 := GetFilter("G/L Budget Filter");
                    CostBudgetFilter2 := GetFilter("Cost Budget Filter");
                    BusUnitFilter := GetFilter("Business Unit Filter");
                    AccSched.SetFilters(DateFilter2, GLBudgetFilter2, CostBudgetFilter2, BusUnitFilter, Dim1Filter, Dim2Filter, Dim3Filter, Dim4Filter);
                    AccSched.Run;
                end;
            }
            action(PreviousColumn)
            {
                ApplicationArea = Basic;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    AdjustColumnOffset(-1);
                end;
            }
            action(NextPeriod)
            {
                ApplicationArea = Basic;
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Next Period';

                trigger OnAction()
                begin
                    AccSchedManagement.FindPeriod(Rec, '>=', PeriodType);
                    DateFilter := GetFilter("Date Filter");
                end;
            }
            action(PreviousPeriod)
            {
                ApplicationArea = Basic;
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Previous Period';

                trigger OnAction()
                begin
                    AccSchedManagement.FindPeriod(Rec, '<=', PeriodType);
                    DateFilter := GetFilter("Date Filter");
                end;
            }
            action(NextColumn)
            {
                ApplicationArea = Basic;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    AdjustColumnOffset(1);
                end;
            }
            action(Recalculate)
            {
                ApplicationArea = Basic;
                Caption = 'Recalculate';

                trigger OnAction()
                begin
                    AccSchedManagement.ForceRecalculate(true);
                end;
            }
            group(Excel)
            {
                Caption = 'Excel';
                group("Export to Excel")
                {
                    Caption = 'Export to Excel';
                    Image = ExportToExcel;
                    action("Create New Document")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create New Document';
                        Image = ExportToExcel;

                        trigger OnAction()
                        var
                            ExportAccSchedToExcel: Report "Export Acc. Sched. to Excel";
                        begin
                            ExportAccSchedToExcel.SetOptions(Rec, CurrentColumnName, UseAmtsInAddCurr);
                            ExportAccSchedToExcel.Run;
                        end;
                    }
                    action("Update Existing Document")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Update Existing Document';
                        Image = ExportToExcel;

                        trigger OnAction()
                        var
                            ExportAccSchedToExcel: Report "Export Acc. Sched. to Excel";
                        begin
                            ExportAccSchedToExcel.SetOptions(Rec, CurrentColumnName, UseAmtsInAddCurr);
                            ExportAccSchedToExcel.SetUpdateExistingWorksheet(true);
                            ExportAccSchedToExcel.Run;
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ColumnNo: Integer;
    begin
        Clear(ColumnValues);

        if (Totaling = '') or (not TempColumnLayout.FindSet) then
            exit;

        repeat
            ColumnNo := ColumnNo + 1;
            if (ColumnNo > ColumnOffset) and (ColumnNo - ColumnOffset <= ArrayLen(ColumnValues)) then begin
                ColumnValues[ColumnNo - ColumnOffset] :=
                  RoundNone(
                    MatrixMgt.RoundAmount(
                      AccSchedManagement.CalcCell(Rec, TempColumnLayout, UseAmtsInAddCurr),
                      TempColumnLayout."Rounding Factor"),
                    TempColumnLayout."Rounding Factor");
                ColumnLayoutArr[ColumnNo - ColumnOffset] := TempColumnLayout;
                GetStyle(ColumnNo - ColumnOffset, "Line No.", TempColumnLayout."Line No.");
            end;
        until TempColumnLayout.Next = 0;
        AccSchedManagement.ForceRecalculate(false);
    end;

    trigger OnInit()
    begin
        Dim4FilterEnable := true;
        Dim3FilterEnable := true;
        Dim2FilterEnable := true;
        Dim1FilterEnable := true;
    end;

    trigger OnOpenPage()
    var

        SystemGeneralSetUp: Codeunit "System General Setup";
    begin
        GLSetup.Get;
        if NewCurrentSchedName <> '' then
            CurrentSchedName := NewCurrentSchedName;
        if CurrentSchedName = '' then
            CurrentSchedName := Text000;
        if NewCurrentColumnName <> '' then
            CurrentColumnName := NewCurrentColumnName;
        if CurrentColumnName = '' then
            CurrentColumnName := Text000;
        if NewPeriodTypeSet then
            PeriodType := ModifiedPeriodType;
        SystemGeneralSetUp.SetParameters(0, 0);
        AccSchedManagement.CopyColumnsToTemp(CurrentColumnName, TempColumnLayout);
        AccSchedManagement.OpenSchedule(CurrentSchedName, Rec);
        AccSchedManagement.OpenColumns(CurrentColumnName, TempColumnLayout);
        AccSchedManagement.CheckAnalysisView(CurrentSchedName, CurrentColumnName, true);
        UpdateColumnCaptions;
        if AccSchedName.Get(CurrentSchedName) then
            if AccSchedName."Analysis View Name" <> '' then
                AnalysisView.Get(AccSchedName."Analysis View Name")
            else begin
                Clear(AnalysisView);
                AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
            end;

        AccSchedManagement.FindPeriod(Rec, '', PeriodType);
        SetFilter(Show, '<>%1', Show::No);
        SetRange("Dimension 1 Filter");
        SetRange("Dimension 2 Filter");
        SetRange("Dimension 3 Filter");
        SetRange("Dimension 4 Filter");
        SetRange("Cost Center Filter");
        SetRange("Cost Object Filter");
        SetRange("Cash Flow Forecast Filter");
        SetRange("Cost Budget Filter");
        SetRange("G/L Budget Filter");
        UpdateDimFilterControls;
        DateFilter := GetFilter("Date Filter");
    end;

    var
        Text000: label 'DEFAULT';
        Text005: label '1,6,,Dimension %1 Filter';
        TempColumnLayout: Record "Column Layout" temporary;
        ColumnLayoutArr: array[12] of Record "Column Layout";
        AccSchedName: Record "Acc. Schedule Name";
        AnalysisView: Record "Analysis View";
        GLSetup: Record "General Ledger Setup";
        AccSchedManagement: Codeunit AccSchedManagement;
        MatrixMgt: Codeunit "Matrix Management";
        CurrentSchedName: Code[10];
        CurrentColumnName: Code[10];
        NewCurrentSchedName: Code[10];
        NewCurrentColumnName: Code[10];
        ColumnValues: array[12] of Decimal;
        ColumnCaptions: array[12] of Text[80];
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        UseAmtsInAddCurr: Boolean;
        Dim1Filter: Text[250];
        Dim2Filter: Text[250];
        Dim3Filter: Text[250];
        Dim4Filter: Text[250];
        CostCenterFilter: Text[250];
        CostObjectFilter: Text[250];
        CashFlowFilter: Text[250];
        ColumnOffset: Integer;
        [InDataSet]
        Dim1FilterEnable: Boolean;
        [InDataSet]
        Dim2FilterEnable: Boolean;
        [InDataSet]
        Dim3FilterEnable: Boolean;
        [InDataSet]
        Dim4FilterEnable: Boolean;
        GLBudgetFilter: Text[250];
        CostBudgetFilter: Text[250];
        DateFilter: Text[30];
        ModifiedPeriodType: Option;
        NewPeriodTypeSet: Boolean;
        [InDataSet]
        ColumnStyle1: Text;
        [InDataSet]
        ColumnStyle2: Text;
        [InDataSet]
        ColumnStyle3: Text;
        [InDataSet]
        ColumnStyle4: Text;
        [InDataSet]
        ColumnStyle5: Text;
        [InDataSet]
        ColumnStyle6: Text;
        [InDataSet]
        ColumnStyle7: Text;
        [InDataSet]
        ColumnStyle8: Text;
        [InDataSet]
        ColumnStyle9: Text;
        [InDataSet]
        ColumnStyle10: Text;
        [InDataSet]
        ColumnStyle11: Text;
        [InDataSet]
        ColumnStyle12: Text;


    procedure SetAccSchedName(NewAccSchedName: Code[10])
    var
        AccSchedName: Record "Acc. Schedule Name";
    begin
        NewCurrentSchedName := NewAccSchedName;
        if AccSchedName.Get(NewCurrentSchedName) then
            if AccSchedName."Default Column Layout" <> '' then
                NewCurrentColumnName := AccSchedName."Default Column Layout";
    end;


    procedure SetPeriodType(NewPeriodType: Option)
    begin
        ModifiedPeriodType := NewPeriodType;
        NewPeriodTypeSet := true;
    end;

    local procedure SetDimFilters(DimNo: Integer; DimValueFilter: Text[250])
    begin
        case DimNo of
            1:
                if DimValueFilter = '' then
                    SetRange("Dimension 1 Filter")
                else begin
                    GetDimValueTotaling(DimValueFilter, AnalysisView."Dimension 1 Code");
                    SetFilter("Dimension 1 Filter", DimValueFilter);
                end;
            2:
                if DimValueFilter = '' then
                    SetRange("Dimension 2 Filter")
                else begin
                    GetDimValueTotaling(DimValueFilter, AnalysisView."Dimension 2 Code");
                    SetFilter("Dimension 2 Filter", DimValueFilter);
                end;
            3:
                if DimValueFilter = '' then
                    SetRange("Dimension 3 Filter")
                else begin
                    GetDimValueTotaling(DimValueFilter, AnalysisView."Dimension 3 Code");
                    SetFilter("Dimension 3 Filter", DimValueFilter);
                end;
            4:
                if DimValueFilter = '' then
                    SetRange("Dimension 4 Filter")
                else begin
                    GetDimValueTotaling(DimValueFilter, AnalysisView."Dimension 4 Code");
                    SetFilter("Dimension 4 Filter", DimValueFilter);
                end;
        end;
        CurrPage.Update;
    end;

    local procedure GetDimValueTotaling(var DimValueFilter: Text[250]; DimensionCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        if DimensionCode <> '' then begin
            DimensionValue.SetRange("Dimension Code", DimensionCode);
            DimensionValue.SetFilter(Code, DimValueFilter);
            if DimensionValue.FindFirst then
                if DimensionValue.Totaling <> '' then
                    DimValueFilter := DimensionValue.Totaling;
        end;
    end;

    local procedure FormGetCaptionClass(DimNo: Integer): Text[250]
    begin
        case DimNo of
            1:
                begin
                    if AnalysisView."Dimension 1 Code" <> '' then
                        exit('1,6,' + AnalysisView."Dimension 1 Code");

                    exit(StrSubstNo(Text005, DimNo));
                end;
            2:
                begin
                    if AnalysisView."Dimension 2 Code" <> '' then
                        exit('1,6,' + AnalysisView."Dimension 2 Code");

                    exit(StrSubstNo(Text005, DimNo));
                end;
            3:
                begin
                    if AnalysisView."Dimension 3 Code" <> '' then
                        exit('1,6,' + AnalysisView."Dimension 3 Code");

                    exit(StrSubstNo(Text005, DimNo));
                end;
            4:
                begin
                    if AnalysisView."Dimension 4 Code" <> '' then
                        exit('1,6,' + AnalysisView."Dimension 4 Code");

                    exit(StrSubstNo(Text005, DimNo));
                end;
            5:
                exit(FieldCaption("Date Filter"));
            6:
                exit(FieldCaption("Cash Flow Forecast Filter"));
        end;
    end;

    local procedure DrillDown(ColumnNo: Integer)
    begin
        TempColumnLayout := ColumnLayoutArr[ColumnNo];
        AccSchedManagement.DrillDownFromOverviewPage(TempColumnLayout, Rec, PeriodType);
    end;

    local procedure UpdateColumnCaptions()
    var
        ColumnNo: Integer;
        i: Integer;
    begin
        Clear(ColumnCaptions);
        if TempColumnLayout.FindSet then
            repeat
                ColumnNo := ColumnNo + 1;
                if (ColumnNo > ColumnOffset) and (ColumnNo - ColumnOffset <= ArrayLen(ColumnCaptions)) then
                    ColumnCaptions[ColumnNo - ColumnOffset] := TempColumnLayout."Column Header";
            until (ColumnNo - ColumnOffset = ArrayLen(ColumnCaptions)) or (TempColumnLayout.Next = 0);
        // Set unused columns to blank to prevent RTC to display control ID as caption
        for i := ColumnNo - ColumnOffset + 1 to ArrayLen(ColumnCaptions) do
            ColumnCaptions[i] := ' ';
    end;

    local procedure AdjustColumnOffset(Delta: Integer)
    var
        OldColumnOffset: Integer;
    begin
        OldColumnOffset := ColumnOffset;
        ColumnOffset := ColumnOffset + Delta;
        if ColumnOffset + 12 > TempColumnLayout.Count then
            ColumnOffset := TempColumnLayout.Count - 12;
        if ColumnOffset < 0 then
            ColumnOffset := 0;
        if ColumnOffset <> OldColumnOffset then begin
            UpdateColumnCaptions;
            CurrPage.Update(false);
        end;
    end;

    local procedure UpdateDimFilterControls()
    begin
        Dim1Filter := GetFilter("Dimension 1 Filter");
        Dim2Filter := GetFilter("Dimension 2 Filter");
        Dim3Filter := GetFilter("Dimension 3 Filter");
        Dim4Filter := GetFilter("Dimension 4 Filter");
        CostCenterFilter := '';
        CostObjectFilter := '';
        CashFlowFilter := '';
        Dim1FilterEnable := AnalysisView."Dimension 1 Code" <> '';
        Dim2FilterEnable := AnalysisView."Dimension 2 Code" <> '';
        Dim3FilterEnable := AnalysisView."Dimension 3 Code" <> '';
        Dim4FilterEnable := AnalysisView."Dimension 4 Code" <> '';
        GLBudgetFilter := '';
        CostBudgetFilter := '';
    end;

    local procedure CurrentSchedNameOnAfterValidate()
    var
        AccSchedName: Record "Acc. Schedule Name";
        PrevAnalysisView: Record "Analysis View";
    begin
        CurrPage.SaveRecord;
        AccSchedManagement.SetName(CurrentSchedName, Rec);
        if AccSchedName.Get(CurrentSchedName) then
            if (AccSchedName."Default Column Layout" <> '') and
               (CurrentColumnName <> AccSchedName."Default Column Layout")
            then begin
                CurrentColumnName := AccSchedName."Default Column Layout";
                AccSchedManagement.CopyColumnsToTemp(CurrentColumnName, TempColumnLayout);
                AccSchedManagement.SetColumnName(CurrentColumnName, TempColumnLayout);
            end;
        AccSchedManagement.CheckAnalysisView(CurrentSchedName, CurrentColumnName, true);

        if AccSchedName."Analysis View Name" <> AnalysisView.Code then begin
            PrevAnalysisView := AnalysisView;
            if AccSchedName."Analysis View Name" <> '' then
                AnalysisView.Get(AccSchedName."Analysis View Name")
            else begin
                Clear(AnalysisView);
                AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
            end;
            if PrevAnalysisView."Dimension 1 Code" <> AnalysisView."Dimension 1 Code" then
                SetRange("Dimension 1 Filter");
            if PrevAnalysisView."Dimension 2 Code" <> AnalysisView."Dimension 2 Code" then
                SetRange("Dimension 2 Filter");
            if PrevAnalysisView."Dimension 3 Code" <> AnalysisView."Dimension 3 Code" then
                SetRange("Dimension 3 Filter");
            if PrevAnalysisView."Dimension 4 Code" <> AnalysisView."Dimension 4 Code" then
                SetRange("Dimension 4 Filter");
        end;
        UpdateDimFilterControls;

        CurrPage.Update(false);
    end;

    local procedure CurrentColumnNameOnAfterValidate()
    begin
        AccSchedManagement.CopyColumnsToTemp(CurrentColumnName, TempColumnLayout);
        AccSchedManagement.SetColumnName(CurrentColumnName, TempColumnLayout);
        AccSchedManagement.CheckAnalysisView(CurrentSchedName, CurrentColumnName, true);
        UpdateColumnCaptions;
        CurrPage.Update(false);
    end;


    procedure FormatStr(ColumnNo: Integer): Text
    begin
        //exit(MatrixMgt.FormatAmount(ColumnLayoutArr[ColumnNo]."Rounding Factor", UseAmtsInAddCurr));
    end;


    procedure RoundNone(Value: Decimal; RoundingFactor: Option "None","1","1000","1000000"): Decimal
    begin
        if RoundingFactor <> Roundingfactor::None then
            exit(Value);

        exit(ROUND(Value));
    end;

    local procedure GetStyle(ColumnNo: Integer; RowLineNo: Integer; ColumnLineNo: Integer)
    var
        ColumnStyle: Text;
        ErrorType: Option "None","Division by Zero","Period Error",Both;
    begin
        AccSchedManagement.CalcFieldError(ErrorType, RowLineNo, ColumnLineNo);
        if ErrorType > Errortype::None then
            ColumnStyle := 'Unfavorable'
        else
            ColumnStyle := 'Standard';

        case ColumnNo of
            1:
                ColumnStyle1 := ColumnStyle;
            2:
                ColumnStyle2 := ColumnStyle;
            3:
                ColumnStyle3 := ColumnStyle;
            4:
                ColumnStyle4 := ColumnStyle;
            5:
                ColumnStyle5 := ColumnStyle;
            6:
                ColumnStyle6 := ColumnStyle;
            7:
                ColumnStyle7 := ColumnStyle;
            8:
                ColumnStyle8 := ColumnStyle;
            9:
                ColumnStyle9 := ColumnStyle;
            10:
                ColumnStyle10 := ColumnStyle;
            11:
                ColumnStyle11 := ColumnStyle;
            12:
                ColumnStyle12 := ColumnStyle;
        end;
    end;
}

