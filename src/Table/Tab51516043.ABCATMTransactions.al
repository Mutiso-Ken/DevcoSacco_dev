#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516043 "ABC ATM Transactions"
{

    fields
    {
        field(1;"Account No";Code[30])
        {
        }
        field(2;"Account Name";Text[50])
        {
        }
        field(3;"Trace ID";Code[50])
        {
        }
        field(4;"Document Date";Date)
        {
        }
        field(5;"Transaction Time";Time)
        {
        }
        field(6;"Transaction Type";Option)
        {
            OptionCaption = ' ,Withdrawal,Balance Enquiry,Mini Statement,Reversals,ATM Transaction,POS Transaction,POS Reversal,ATM Reversal';
            OptionMembers = " ",Withdrawal,"Balance Enquiry","Mini Statement",Reversals,"ATM Transaction","POS Transaction","POS Reversal","ATM Reversal";
        }
        field(7;"Telephone Number";Code[30])
        {
        }
        field(8;Posted;Boolean)
        {
        }
        field(9;"Date Posted";DateTime)
        {
        }
        field(10;"ATM Card No";Text[30])
        {
        }
        field(11;"Credit Account";Code[30])
        {
        }
        field(12;Status;Option)
        {
            OptionCaption = 'Pending,Completed,Failed';
            OptionMembers = Pending,Completed,Failed;
        }
        field(13;Comments;Text[50])
        {
        }
        field(14;Amount;Decimal)
        {
        }
        field(15;Charge;Decimal)
        {
        }
        field(16;Description;Text[100])
        {
        }
        field(18;Entry;Integer)
        {
            AutoIncrement = true;
        }
        field(20;Client;Code[50])
        {
        }
        field(21;"Posting Date";Date)
        {
        }
        field(22;"POS Trans";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Trace ID")
        {
        }
        key(Key2;"Account No",Entry)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('You are not allowed to delete anything from this table');
    end;

    trigger OnInsert()
    begin
        //ERROR('You are not allowed to manually insert anything into this table');
    end;

    trigger OnModify()
    begin
        //ERROR('You are not allowed to modify anything in this table');
    end;

    trigger OnRename()
    begin
        //ERROR('You are not allowed to edit anything from this table');
    end;
}

