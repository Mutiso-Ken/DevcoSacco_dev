codeunit 51516049 "Clean Member Account Signatory"
{
    trigger OnRun()
    var
        AccountSign: Record "Member Account Signatories";
        AccountSignNew: record "Member Acc Signatories import";
    begin
        // AccountSignNew.Reset();
        // if AccountSignNew.Find('-') then begin
        //     AccountSignNew.DeleteAll();
        // end;
        //.....................................
        // AccountSign.Reset();
        // if AccountSign.Find('-') then begin
        //     repeat
        //         AccountSignNew.Init();
        //         AccountSignNew."ID No." := AccountSign."ID No.";
        //         AccountSignNew."Account No" := FnGetBOSAAccountNo(AccountSign."Account No");
        //         AccountSignNew.Names := AccountSign.Names;
        //         AccountSignNew."Date Of Birth" := AccountSign."Date Of Birth";
        //         AccountSignNew.Signatory := AccountSign.Signatory;
        //         AccountSignNew."Must Sign" := AccountSign."Must Sign";
        //         AccountSignNew."Must be Present" := AccountSign."Must be Present";
        //         AccountSignNew."Mobile Number" := AccountSign."Mobile Number";
        //         AccountSignNew.Insert(true);
        //     until AccountSign.Next = 0;
        // end;
        //.......................................delete the old signatories and insert afresh
        AccountSign.Reset();
        AccountSign.SetCurrentKey(AccountSign."Account No");
        if AccountSign.Find('-') then begin
            AccountSign.DeleteAll();
        end;
        //....................................................
        AccountSignNew.Reset();
        if AccountSignNew.Find('-') then begin
            repeat
                AccountSign.Init();
                AccountSign."ID No." := AccountSignNew."ID No.";
                AccountSign."Account No" := AccountSignNew."Account No";
                AccountSign.Names := AccountSignNew.Names;
                AccountSign."Date Of Birth" := AccountSignNew."Date Of Birth";
                AccountSign.Signatory := AccountSignNew.Signatory;
                AccountSign."Must Sign" := AccountSignNew."Must Sign";
                AccountSign."Must be Present" := AccountSignNew."Must be Present";
                AccountSign."Mobile Number" := AccountSignNew."Mobile Number";
                AccountSign.Insert(true);
            until AccountSignNew.Next = 0;
        end;
        //..................Message Done
        Message('Done');
    end;

    local procedure FnGetBOSAAccountNo(AccountNo: Code[20]): Code[20]
    var
        MembersReg: Record Customer;
        VendorTable: Record Vendor;
    begin
        MembersReg.Reset();
        MembersReg.SetRange(MembersReg."No.", AccountNo);
        if MembersReg.Find('-') then begin
            exit(MembersReg."No.");
        end;
        //...........................
        VendorTable.Reset();
        VendorTable.SetRange(VendorTable."No.", AccountNo);
        if VendorTable.Find('-') then begin
            exit(VendorTable."BOSA Account No");
        end;

    end;
}
