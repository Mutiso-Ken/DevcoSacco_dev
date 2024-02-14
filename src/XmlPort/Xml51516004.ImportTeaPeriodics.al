xmlport 51516004 "Import Tea Periodics"
{
    Caption = 'Import';
    Format = VariableText;
    schema
    {
        textelement(Salaries_Processing)
        {
            tableelement("Periodics Processing Lines"; "Periodics Processing Lines")
            {
                XmlName = 'TeaImport';
                fieldelement(DocumentNo; "Periodics Processing Lines"."Document No")
                {
                }
                fieldelement(GrowerNo; "Periodics Processing Lines"."Grower No")
                {
                }
                fieldelement(Amount; "Periodics Processing Lines".Amount)
                {
                }
            }
        }
    }
}
