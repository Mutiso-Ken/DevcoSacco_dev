xmlport 51516005 "Import Salary Periodics"
{
    Caption = 'Import';
    Format = VariableText;
    schema
    {
        textelement(Salaries_Processing)
        {
            tableelement("Periodics Processing Lines"; "Periodics Processing Lines")
            {
                XmlName = 'SalaryImport';
                fieldelement(DocumentNo; "Periodics Processing Lines"."Document No")
                {
                }
                fieldelement(AccountNo; "Periodics Processing Lines"."Account No")
                {
                }
                fieldelement(Amount; "Periodics Processing Lines".Amount)
                {
                }
                fieldelement(StaffNo; "Periodics Processing Lines"."Staff No")
                {
                }
            }
        }
    }
}
