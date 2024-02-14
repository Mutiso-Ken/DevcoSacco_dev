#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516050 "Budget Committment"
{

    fields
    {
        field(10;"Line No";Integer)
        {
        }
        field(11;Date;Date)
        {
        }
        field(12;"Posting Date";Date)
        {
        }
        field(13;"Document Type";Option)
        {
            OptionCaption = 'LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,Grant Surrender,Cash Purchase';
            OptionMembers = LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,"Grant Surrender","Cash Purchase";
        }
        field(14;"Document No.";Code[20])
        {
        }
        field(15;Amount;Decimal)
        {
        }
        field(16;"Month Budget";Decimal)
        {
        }
        field(17;"Month Actual";Decimal)
        {
        }
        field(18;Committed;Boolean)
        {
        }
        field(19;"Committed By";Code[50])
        {
        }
        field(20;"Committed Date";Date)
        {
        }
        field(21;"Committed Time";Time)
        {
        }
        field(22;"Committed Machine";Text[100])
        {
        }
        field(23;Cancelled;Boolean)
        {
        }
        field(24;"Cancelled By";Code[20])
        {
        }
        field(25;"Cancelled Date";Date)
        {
        }
        field(26;"Cancelled Time";Time)
        {
        }
        field(27;"Cancelled Machine";Text[100])
        {
        }
        field(28;"Shortcut Dimension 1 Code";Code[20])
        {
        }
        field(29;"Shortcut Dimension 2 Code";Code[20])
        {
        }
        field(30;"Shortcut Dimension 3 Code";Code[20])
        {
        }
        field(31;"Shortcut Dimension 4 Code";Code[20])
        {
        }
        field(32;"G/L Account No.";Code[20])
        {
        }
        field(33;Budget;Code[20])
        {
        }
        field(34;"Vendor/Cust No.";Code[20])
        {
        }
        field(35;Type;Option)
        {
            OptionMembers = " ",Vendor,Customer;
        }
    }

    keys
    {
        key(Key1;"Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

