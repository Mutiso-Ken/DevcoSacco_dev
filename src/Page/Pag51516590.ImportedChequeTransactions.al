#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51516590 "Imported Cheque Transactions"
{
    CardPageID = "Cheque Transactions Card";
    Editable = false;
    PageType = List;
    SourceTable = "Cheque Truncation Buffer";
    SourceTableView = where("Imported to Receipt Lines"=const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ChequeDataId;ChequeDataId)
                {
                    ApplicationArea = Basic;
                }
                field(SerialId;SerialId)
                {
                    ApplicationArea = Basic;
                }
                field(AMOUNT;AMOUNT)
                {
                    ApplicationArea = Basic;
                }
                field(CURRENCYCODE;CURRENCYCODE)
                {
                    ApplicationArea = Basic;
                }
                field(DESTBANK;DESTBANK)
                {
                    ApplicationArea = Basic;
                }
                field(DESTBRANCH;DESTBRANCH)
                {
                    ApplicationArea = Basic;
                }
                field(DESTACC;DESTACC)
                {
                    ApplicationArea = Basic;
                }
                field(PBANK;PBANK)
                {
                    ApplicationArea = Basic;
                }
                field(PBRANCH;PBRANCH)
                {
                    ApplicationArea = Basic;
                }
                field(MemberNo;MemberNo)
                {
                    ApplicationArea = Basic;
                }
                field(SNO;SNO)
                {
                    ApplicationArea = Basic;
                }
                field(FrontBWImage;FrontBWImage)
                {
                    ApplicationArea = Basic;
                }
                field(FrontGrayScaleImage;FrontGrayScaleImage)
                {
                    ApplicationArea = Basic;
                }
                field(RearImage;RearImage)
                {
                    ApplicationArea = Basic;
                }
                field(IsFCY;IsFCY)
                {
                    ApplicationArea = Basic;
                }
                field("Imported to Receipt Lines";"Imported to Receipt Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imported ?';
                }
            }
        }
    }

    actions
    {
    }
}

