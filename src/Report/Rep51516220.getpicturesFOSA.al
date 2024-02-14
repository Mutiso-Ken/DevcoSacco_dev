#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516220 "get pictures-FOSA"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/get pictures.rdlc';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Vendor.Get(Vendor."No.") then begin
                    repeat

                        if Vendor.Signature.HasValue() then
                            Clear(Vendor.Signature);

                        FileName := 'C:\Users\signatures\' + Vendor."BOSA Account No" + '.BMP';
                        //........................Check if file exists
                        if Exists(FileName) then begin
                            Vendor.Signature.ImportFile(FileName, ClientFileName);
                            if not Vendor.Modify(true) then
                                Vendor.Insert(true);
                        end;
                    until Vendor.Next = 0;
                end;
                //....................................................................................
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

    var
        Customer: Record Customer;
        FileManagement: Codeunit "File Management";
        FileName: Text;
        ClientFileName: Text;
        //...............................................................
        NameValueBuffer: Record "Name/Value Buffer";
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        ToFile: Text;
        ExportPath: Text;
}

