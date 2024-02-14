#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516496 "Christmas Calculate Interest"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Christmas Calculate Interest.rdlc';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            CalcFields = Balance;
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ObjAccTypes.Get(Vendor."Account Type") then begin
                    //1.----------------------------------DEBIT XMAS (Full Amount)----------------------------------------------
                    LineNo := LineNo + 1;
                    SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0",
                    GenJournalLine."account type"::Vendor, Vendor."No.", PostingDate, Vendor.Balance, 'FOSA', '', 'Christmas transfer', '');

                    //2.----------------------------------CREDIT ORDINARY(Full Amount)----------------------------------------------
                    LineNo := LineNo + 1000;
                    SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0",
                    GenJournalLine."account type"::Vendor, SFactory.FnGetFosaAccount(Vendor."BOSA Account No"), PostingDate, Vendor.Balance * -1, 'FOSA', '', 'Christmas Saving', '');

                    //3.----------------------------------CREDIT ORDINARY(Interest Earned)----------------------------------------------
                    LineNo := LineNo + 100000;
                    SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0",
                    GenJournalLine."account type"::Vendor, SFactory.FnGetFosaAccount(Vendor."BOSA Account No"), PostingDate, (Vendor.Balance * -1 * ObjAccTypes."Interest Rate" / 100), 'FOSA', '', 'Xmas Interest earned', '',
                    GenJournalLine."account type"::"G/L Account", ObjAccTypes."Interest Payable Account");

                    //4.----------------------------------DEBIT ORDINARY(Withholding Tax)----------------------------------------------
                    LineNo := LineNo + 1000000;
                    SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0",
                    GenJournalLine."account type"::Vendor, SFactory.FnGetFosaAccount(Vendor."BOSA Account No"), PostingDate, ((Vendor.Balance * ObjAccTypes."Interest Rate" / 100) * ObjAccTypes."Tax On Interest" / 100), 'FOSA', '', 'Witholding tax', '',
                    GenJournalLine."account type"::"G/L Account", ObjAccTypes."Interest Tax Account");

                    //5.----------------------------------RECOVER LOAN(xmas advance Principal)----------------------------------------------
                    FnRecoverAdvanceLoanPrincipal(Vendor."BOSA Account No");
                end;
            end;

            trigger OnPostDataItem()
            begin
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
                GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
                if GenJournalLine.Find('-') then begin
                    //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco21",GenJournalLine);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
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

    trigger OnPreReport()
    begin
        BATCH_NAME := 'XMAS_BATCH';
        BATCH_TEMPLATE := 'GENERAL';
        //DOCUMENT_NO:=FORMAT(DATE2DMY(PostingDate,3));
        DOCUMENT_NO := 'XMAS 2021';

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
        GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
        GenJournalLine.DeleteAll;
    end;

    var
        SFactory: Codeunit "SURESTEP Factory";
        BATCH_TEMPLATE: Code[100];
        BATCH_NAME: Code[100];
        DOCUMENT_NO: Code[100];
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        ObjAccTypes: Record "Account Types-Saving Products";
        PostingDate: Date;
        ObjLoans: Record "Loans Register";

    local procedure FnRecoverAdvanceLoanPrincipal(BosaNumber: Code[100])
    begin
        /*
        ObjLoans.RESET;
        ObjLoans.SETRANGE(ObjLoans."Client Code",BosaNumber);
        ObjLoans.SETFILTER(ObjLoans."Loan Product Type",'CHRISTMAS ADV');
        IF ObjLoans.FIND('-') THEN
          BEGIN
            ObjLoans.CALCFIELDS(ObjLoans."Outstanding Balance");
            IF ObjLoans."Outstanding Balance">0 THEN
              LineNo:=LineNo+100000000;
              SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
              GenJournalLine."Account Type"::Member,BosaNumber,PostingDate,ObjLoans."Outstanding Balance"*-1,'FOSA','',ObjLoans."Loan Product Type"+'-Repayment','',
              GenJournalLine."Account Type"::Vendor,ObjLoans."Account No");
        END
        */

    end;
}

