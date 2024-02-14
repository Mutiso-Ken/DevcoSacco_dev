#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516570 "Cheque Receipt Line-Family"
{
    CardPageID = "Cheque Truncation Card";
    PageType = List;
    SourceTable = "Cheque Issue Lines-Family";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Header No"; "Header No")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Cheque Serial No"; "Cheque Serial No")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Cheque No"; "Cheque No")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = Basic;
                    //editable = false;
                    trigger OnValidate()
                    var
                        cust: record Vendor;
                    begin
                        if cust.get("Account No.") then begin
                            cust.CalcFields(cust."FOSA Balance");
                            "Account Name" := cust.Name;
                            "Account Balance" := cust."FOSA Balance";
                        end;
                    end;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    editable = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    editable = false;
                }
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = Basic;
                    style = Unfavorable;
                    editable = false;
                }
                field("Un pay Code"; "Un pay Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Interpretation; Interpretation)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
                field("Verification Status"; "Verification Status")
                {
                    ApplicationArea = Basic;
                }

                field(FrontImage; FrontImage)
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field(FrontGrayImage; FrontGrayImage)
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field(BackImages; BackImages)
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Family Account No."; "Family Account No.")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Un Pay Charge Amount"; "Un Pay Charge Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Date _Refference No."; "Date _Refference No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Transaction Code"; "Transaction Code")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Date-1"; "Date-1")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Date-2"; "Date-2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Family Routing No."; "Family Routing No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Fillers; Fillers)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Transaction Refference"; "Transaction Refference")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unpay Date"; "Unpay Date")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }

                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Member Branch"; "Member Branch")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

