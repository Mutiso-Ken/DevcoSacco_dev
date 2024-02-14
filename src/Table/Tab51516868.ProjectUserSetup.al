#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516868 "Project User Setup"
{

    fields
    {
        field(10;"User ID";Code[20])
        {

            trigger OnLookup()
            begin
                 // UserManager.LookupUserID("User ID");
            end;

            trigger OnValidate()
            begin
                // UserManager.ValidateUserID(UserId);
            end;
        }
        field(11;"Reclassification Template";Code[20])
        {
            TableRelation = "FA Reclass. Journal Template".Name;
        }
        field(12;"Reclassification Batch";Code[20])
        {
            TableRelation = "FA Reclass. Journal Batch".Name where ("Journal Template Name"=field("Reclassification Template"));
        }
        field(13;"General Journal Template";Code[20])
        {
        }
        field(14;"General Journal Batch";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserManager: Codeunit "User Management";
}

