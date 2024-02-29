report 51516300 "Update Member Dormancy"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.")
            {

            }
            trigger OnAfterGetRecord()
            var
                DateFormula: Text;
                Lastdate: Date;
            begin
                DateFormula := '<6M>';
                CalcFields(Customer."Last Payment Date");
                if (Customer.Status <> Customer.Status::Withdrawal) and (Customer."Last Payment Date" <> 0D) then begin
                    Lastdate := CalcDate(DateFormula, Customer."Last Payment Date");
                    if Lastdate < Today then begin
                        Customer.Status := Customer.Status::Dormant;
                        Customer.Modify();
                    end else
                        if Lastdate >= Today then begin
                            Customer.Status := Customer.Status::Active;
                            Customer.Modify();
                        end;
                end;

            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
}