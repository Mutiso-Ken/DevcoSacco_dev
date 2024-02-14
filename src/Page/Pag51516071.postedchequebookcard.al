
#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 51516071 postedchequebookcard
{
    PageType = Card;
    SourceTable = "Cheque Book Application";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID No."; "ID No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cheque Book Type"; "Cheque Book Type")
                {
                    ApplicationArea = Basic;
                }
                field("Begining Cheque No."; "Begining Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("End Cheque No."; "End Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Centre"; "Responsibility Centre")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    visible = false;
                }
                field("Last check"; "Last check")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cheque Account No."; "Cheque Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Visible = false;
                }
                field("Cheque Register Generated"; "Cheque Register Generated")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cheque Book charges Posted"; "Cheque Book charges Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Requested By"; "Requested By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Issue/Generate Cheque Register")
            {
                ApplicationArea = Basic;
                Image = Interaction;
                Promoted = true;
                PromotedIsBig = true;
                visible = false;

                trigger OnAction()
                begin

                    if "Cheque Register Generated" then
                        Error('Cheque generation already done');
                    TestField("Begining Cheque No.");
                    TestField("End Cheque No.");
                    IncrNo := "Begining Cheque No.";

                    if "End Cheque No." < "Begining Cheque No." then
                        Error('Beginning number is more than ending number');


                    while IncrNo <= "End Cheque No." do begin
                        CheqReg.Init;
                        ///MESSAGE("Account No.");
                        CheqReg."Account No." := CopyStr("Account No.", 8, 5); //"Cheque Account No.";
                        CheqReg.Validate(CheqReg."Account No.");
                        CheqReg."Cheque No." := IncrNo;
                        CheqReg."Application No." := "No.";
                        CheqReg.Insert;

                        IncrNo := IncStr(IncrNo);
                    end;
                    "Cheque Register Generated" := true;
                    Modify;
                end;
            }
            action("Cheque Register")
            {
                ApplicationArea = Basic;
                Image = GetLines;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Cheque Register List";
                RunPageLink = "Application No." = field("No.");
            }
            action("Post Cheque Book Application")
            {
                Visible = false;
                ApplicationArea = Basic;
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;


                trigger OnAction()
                begin
                    /*
                  IF Status<>Status::Approved THEN BEGIN
                  ERROR('APPLICATION MUST BE APPROVED BEFORE POSTING CHARGES');
                  END;
                   */
                    if "Cheque Register Generated" then
                        // Error('Cheque generation already done');
                        TestField("Begining Cheque No.");
                    TestField("End Cheque No.");
                    IncrNo := "Begining Cheque No.";

                    if "End Cheque No." < "Begining Cheque No." then
                        Error('Beginning number is more than ending number');


                    while IncrNo <= "End Cheque No." do begin
                        CheqReg.Init;
                        ///MESSAGE("Account No.");
                        CheqReg."Account No." := CopyStr("Account No.", 8, 5); //"Cheque Account No.";
                        CheqReg.Validate(CheqReg."Account No.");
                        CheqReg."Cheque No." := IncrNo;
                        CheqReg."Application No." := "No.";
                        CheqReg.Insert;

                        IncrNo := IncStr(IncrNo);
                    end;
                    "Cheque Register Generated" := true;
                    Modify;



                    if "Cheque Book charges Posted" = true then begin
                        Error('Cheque book charges has already been posted');

                    end;

                    if Confirm('Are you sure you want post cheques', true) = true then begin
                        "TOTAL CHARGES" := 0;
                        Charges.Reset;
                        Charges.SetRange(Charges."Charge Type", Charges."charge type"::"Cheque Book");
                        if Charges.Find('-') then begin

                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange("Journal Batch Name", 'CHQTRANS');
                            GenJournalLine.DeleteAll;

                            //DEBIT THE VENDOR WITH CHEQUE CHARGES..................//
                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                            GenJournalLine."Document No." := "No.";
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := "Account No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := "Application Date";
                            GenJournalLine."External Document No." := "Cheque Account No.";
                            GenJournalLine.Description := 'Cheque Application fees';
                            GenJournalLine.Amount := Charges."Charge Amount";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            if Vend.Get("Account No.") then begin
                                GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                            end;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            //...........CREDIT G/L WITH CHEQUE APPLICATION FEE....///

                            LineNo := LineNo + 10000;

                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                            GenJournalLine."Document No." := "No.";
                            GenJournalLine."Line No." := LineNo;
                            //GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                            //GenJournalLine."Account No.":=Charges."GL Account";//'1-00-600-003';
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                            GenJournalLine."Account No." := 'BANK0032';
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := "Application Date";
                            GenJournalLine."External Document No." := "Cheque Account No.";
                            GenJournalLine.Description := 'Cheque Application fees';
                            GenJournalLine.Amount := -Charges."Charge Amount";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            if Vend.Get("Account No.") then begin
                                GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                            end;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            //...DEBIT CHEQUE PROCESSING DUTY......///


                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                            GenJournalLine."Document No." := "No.";
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := "Account No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := "Application Date";
                            GenJournalLine."External Document No." := "Cheque Account No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := "Application Date";
                            GenJournalLine.Description := 'Excise Duty';
                            GenJournalLine.Amount := Charges."Charge Amount" * 0.2;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            if Vend.Get("Account No.") then begin
                                GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                            end;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;


                            //CREDIT  EXERCISE DUTY G/L ACCOUNT ...................///

                            LineNo := LineNo + 10000;
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'CHQTRANS';
                            GenJournalLine."Document No." := "No.";
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                            GenJournalLine."Account No." := '3326';//GenSetup."Excise Duty G/L Acc.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := "Application Date";
                            GenJournalLine.Description := 'Excise Duty';
                            GenJournalLine.Amount := -(Charges."Charge Amount" * 0.2);
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            if Vend.Get("Account No.") then begin
                                GenJournalLine."Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                            end;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            // coop bank charges
                            /*IF ChequeSetUp.GET("Cheque Book Type") THEN BEGIN
                             LineNo:=LineNo+10000;
                              GenJournalLine.INIT;
                              GenJournalLine."Journal Template Name":='GENERAL';
                              GenJournalLine."Journal Batch Name":='CHQTRANS';
                              GenJournalLine."Document No.":="No.";
                              GenJournalLine."Line No.":=LineNo;
                             // GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                             // GenJournalLine."Account No.":='176';
                              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                              GenJournalLine."Account No.":=Charges."GL Account";//'1-00-600-003';
                              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                              GenJournalLine."Posting Date":=TODAY;
                              GenJournalLine."External Document No.":="Cheque Account No.";
                              GenJournalLine.Description:='Cheque Application fees';
                              GenJournalLine.Amount:=-(ChequeSetUp.Amount+(ChequeSetUp.Amount*0.1));
                              GenJournalLine.VALIDATE(GenJournalLine.Amount);
                              GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                              IF Vend.GET("Account No.") THEN BEGIN
                              GenJournalLine."Shortcut Dimension 2 Code":=Vend."Global Dimension 2 Code";
                              END;
                              GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                              GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                              IF GenJournalLine.Amount<>0 THEN
                              GenJournalLine.INSERT;
                               "TOTAL CHARGES":= "TOTAL CHARGES"+ChequeSetUp.Amount;
                             END;
                             */
                            // end of coopbank charges
                        end;


                        //Post New
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                        GenJournalLine.SetRange("Journal Batch Name", 'CHQTRANS');
                        if GenJournalLine.Find('-') then begin
                            //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);
                        end;
                        //Post New

                    end;

                    "Cheque Book charges Posted" := true;
                    Modify;

                    Message('Cheque book has been uccessfully Applied');

                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = Basic;
                Promoted = true;
                visible = false;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //TEST
                end;

            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                visible = false;

                trigger OnAction()
                begin
                    //TEST
                end;

            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }

    var
        CheqReg: Record "Cheques Register";
        IncrNo: Code[10];
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Vend: Record Vendor;
        AccountTypeS: Record "Account Types-Saving Products";
        AvailableBal: Decimal;
        Charges: Record Charges;
        GenSetup: Record "Sacco General Set-Up";
        ChequeSetUp: Record "Cheque Set Up";
        "TOTAL CHARGES": Decimal;
        TEST: Code[10];
}

