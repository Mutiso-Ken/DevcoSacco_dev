page 51516080 "Salary Processing Lines"
{
    ApplicationArea = All;
    Caption = 'Salary Processing Lines';
    PageType = List;
    SourceTable = "Periodics Processing Lines";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No")
                {
                    Editable = false;
                }
                field("Account No"; Rec."Account No")
                {
                }
                field("Member No"; Rec."Member No")
                {
                }
                field("Member Name"; Rec."Member Name")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Staff No"; "Staff No")
                {
                    trigger OnValidate()
                    var
                        VendorTable: Record Vendor;
                    begin
                        VendorTable.Reset();
                        VendorTable.SetRange(VendorTable."Account Type", 'ORDINARY');
                        VendorTable.SetRange(VendorTable."Staff No", "Staff No");
                        if VendorTable.Find('-') then begin
                            "Account No" := VendorTable."No.";
                            Modify();
                        end;
                    end;
                }
            }
        }
    }
}
