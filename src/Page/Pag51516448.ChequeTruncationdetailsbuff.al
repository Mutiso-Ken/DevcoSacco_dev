page 51516448 "Cheque Truncation details buff"
{
    ApplicationArea = All;
    Caption = 'Cheque Truncation details buff';
    PageType = ListPart;
    SourceTable = "Cheque Truncation Buffer";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ChequeDataId; ChequeDataId)
                {
                    ToolTip = 'Specifies the value of the AMOUNT field.';
                }
                field(SerialId; SerialId)
                {
                    ToolTip = 'Specifies the value of the BIMAGESIGN field.';
                }
                field(FilePathName; FilePathName)
                {
                    ToolTip = 'Specifies the value of the BIMAGESIZE field.';
                }
                field(RCODE; RCODE)
                {
                    ToolTip = 'Specifies the value of the CHQDGT field.';
                }
                field(VTYPE; VTYPE)
                {
                    ToolTip = 'Specifies the value of the COLLACC field.';
                }
                field(AMOUNT; AMOUNT)
                {
                    ToolTip = 'Specifies the value of the CURRENCYCODE field.';
                }
                field(ENTRYMODE; ENTRYMODE)
                {
                    ToolTip = 'Specifies the value of the ChequeDataId field.';
                }
                field(CURRENCYCODE; CURRENCYCODE)
                {
                    ToolTip = 'Specifies the value of the CreatedBy field.';
                }
                field(DESTBANK; DESTBANK)
                {
                    ToolTip = 'Specifies the value of the CreatedOn field.';
                }
                field(DESTBRANCH; DESTBRANCH)
                {
                    ToolTip = 'Specifies the value of the DESTACC field.';
                }
                field(DESTACC; DESTACC)
                {
                    ToolTip = 'Specifies the value of the DESTBANK field.';
                }
                field(CHQDGT; CHQDGT)
                {
                    ToolTip = 'Specifies the value of the DESTBRANCH field.';
                }
                field(PBANK; PBANK)
                {
                    ToolTip = 'Specifies the value of the ENTRYMODE field.';
                }
                field(PBRANCH; PBRANCH)
                {
                    ToolTip = 'Specifies the value of the FILLER field.';
                }
                field(FILLER; FILLER)
                {
                    ToolTip = 'Specifies the value of the FIMAGESIGN field.';
                }
                field(COLLACC; COLLACC)
                {
                    ToolTip = 'Specifies the value of the FIMAGESIGNBW field.';
                }
                field(MemberNo; MemberNo)
                {
                    ToolTip = 'Specifies the value of the FIMAGESIZE field.';
                }
                field(MembId; MembId)
                {
                    ToolTip = 'Specifies the value of the FIMAGESIZEBW field.';
                }
                field(MembShareId; MembShareId)
                {
                    ToolTip = 'Specifies the value of the FilePathName field.';
                }
                field(SNO; SNO)
                {
                    ToolTip = 'Specifies the value of the FrontBWImage field.';
                }
                field(PROCNO; PROCNO)
                {
                    ToolTip = 'Specifies the value of the FrontGrayScaleImage field.';
                }
                field(FIMAGESIZEBW; FIMAGESIZEBW)
                {
                    ToolTip = 'Specifies the value of the Imported to Receipt Lines field.';
                }
                field(FIMAGESIGNBW; FIMAGESIGNBW)
                {
                    ToolTip = 'Specifies the value of the IsFCY field.';
                }
                field(FIMAGESIZE; FIMAGESIZE)
                {
                    ToolTip = 'Specifies the value of the MembId field.';
                }
                field(FIMAGESIGN; FIMAGESIGN)
                {
                    ToolTip = 'Specifies the value of the MembShareId field.';
                }
                field(BIMAGESIZE; BIMAGESIZE)
                {
                    ToolTip = 'Specifies the value of the MemberNo field.';
                }
                field(BIMAGESIGN; BIMAGESIGN)
                {
                    ToolTip = 'Specifies the value of the ModifiedBy field.';
                }
                field(FrontBWImage; FrontBWImage)
                {
                    ToolTip = 'Specifies the value of the ModifiedOn field.';
                }
                field(FrontGrayScaleImage; FrontGrayScaleImage)
                {
                    ToolTip = 'Specifies the value of the PBANK field.';
                }
                field(RearImage; RearImage)
                {
                    ToolTip = 'Specifies the value of the PBRANCH field.';
                }
                field(IsFCY; IsFCY)
                {
                    ToolTip = 'Specifies the value of the PROCNO field.';
                }
                field(Supflag; Supflag)
                {
                    ToolTip = 'Specifies the value of the RCODE field.';
                }
                field(CreatedBy; CreatedBy)
                {
                    ToolTip = 'Specifies the value of the RearImage field.';
                }
                field(CreatedOn; CreatedOn)
                {
                    ToolTip = 'Specifies the value of the SNO field.';
                }
                field(UploadedFileId; UploadedFileId)
                {
                    ToolTip = 'Specifies the value of the SerialId field.';
                }
                field("Imported to Receipt Lines"; "Imported to Receipt Lines")
                {
                    ToolTip = 'Specifies the value of the SupervisedBy field.';
                }

            }
        }
    }
}
