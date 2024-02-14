Table 51516543 "Periodics Processing Lines"
{
    fields
    {
        field(1; "Document No"; Code[20])
        {
            TableRelation = "Periodics Processing Header"."Document No";
        }
        field(2; "Member No"; Code[20])
        {
            TableRelation = CUSTOMER."No.";

        }
        field(3; "Member Name"; Text[250])
        {

        }
        field(4; "Staff No"; Code[20])
        {
            TableRelation = Vendor."Staff No";
            trigger OnValidate()
            var
                VendorTable: Record Vendor;
            begin
                // VendorTable.Reset();
                // VendorTable.SetRange(VendorTable."Account Type", 'ORDINARY');
                // VendorTable.SetRange(VendorTable."Staff No", "Staff No");
                // if VendorTable.Find('-') then begin
                //     "Account No" := VendorTable."No.";
                // end;
            end;
        }
        field(5; "Grower No"; Code[20])
        {

        }
        field(6; "Account No"; Code[100])
        {
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                VendorTable: Record Vendor;
            begin
                if VendorTable.get("Account No") then begin
                    "Member Name" := VendorTable.Name;
                    "Member No" := VendorTable."BOSA Account No";
                    "Account Found" := true;
                    IF VendorTable.Blocked = VendorTable.Blocked::All THEN begin
                        "Account Is Blocked" := true;
                    end;
                end;
            end;
        }
        field(7; Amount; Decimal)
        {
        }
        field(8; "Account Found"; Boolean)
        {
        }
        field(13; Posted; Boolean)
        {
        }
        field(14; "Posting Date"; Date)
        {
        }
        field(15; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(16; "Account Is Blocked"; Boolean)
        {
        }
        field(17; "Account Not Found"; Boolean)
        {
        }
        field(18; "Grower is processed"; Boolean)
        {
        }
        field(19; "No. Of Counts"; Integer)
        {
            CalcFormula = count("Periodics Processing Lines" where("Document No" = field("Document No"),
                                                                 "Account No" = field("Account No")));
            FieldClass = FlowField;
        }
        field(20; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Periodics Processing Lines".Amount where("Document No" = field("Document No"),
                                                                 "Account No" = field("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No", "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Loans: Record "Loans Register";
        Loantypes: Record "Loan Products Setup";
        Interest: Decimal;
        Cust: Record Customer;
        GenSetUp: Record "Sacco General Set-Up";
}

