Page 51516463 "Credit Role Center"
{
    Caption = 'JAMII YETU SACCO LTD';
    PageType = RoleCenter;
    layout
    {
        area(rolecenter)
        {
            group(Part1)
            {
                part("General Cue"; "General Cue")
                {
                    ApplicationArea = Suite;
                    Visible = true;
                }
                part(Control96; "Report Inbox Part")
                {
                    AccessByPermission = TableData "Report Inbox" = IMD;
                    ApplicationArea = Suite;
                    Visible = false;
                    Caption = 'My Automated Reports';
                }
            }

        }
    }

    actions
    {
        area(reporting)
        {

        }
        area(embedding)
        {
            action("Chart of Account")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
                ToolTip = 'Open the chart of accounts.';
                visible = true;
            }
            action(Members)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Members';
                Image = Customer;
                visible = true;
                RunObject = Page "Member List";
                ToolTip = 'View or edit detailed information for the Members.';
            }
            action(FOSAAccounts)
            {
                // ApplicationArea = Basic, Suite;
                // Caption = 'FOSA Accounts';
                // Image = Vendor;
                // RunObject = Page "Account Details Master";
                // ToolTip = 'View detailed information for the FOSA Savings Accounts.';
                // Visible = true;
            }
            action("General Journals")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'General Journals';
                Image = Journal;
                RunObject = Page "General Journal";
                ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.';
            }
            action("G/L Register")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'G/L Register';
                Image = Journal;
                RunObject = Page "G/L Registers";
            }
            action("G/L Navigator")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'G/L Navigator';
                Image = Journal;
                RunObject = Page Navigate;
            }

        }
        area(sections)
        {


            //......................... START OF FINANCIAL MANAGEMENT MENU ...........................

            group(FinancialManagement)
            {
                Caption = 'Financial Management';
                Image = Journals;
                ToolTip = 'Collect and make payments, prepare statements, and reconcile bank accounts.';
                //..........................................................................................

                //.....................................................................
                group("SASRA Reports")
                {
                    Caption = 'SASRA Reports';
                    ToolTip = 'which highlights the operations and performance of the SACCO industry during the year ended';
                    Visible = true;

                    action("Deposits Return-SASRA")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Deposits Return';
                        Image = Report;
                        RunObject = report "Deposit Return SASRA";
                    }
                    action("Agency Returns-SASRA")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Agency Report';
                        Visible = true;
                        RunObject = report "Agency Report-SASRA";
                    }
                    action("Loans Provisioning Summary-SASRA")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Loans Provisioning Summary';
                        RunObject = report "Loans Provisioning Summarys";
                    }
                    action("Loan Sectorial Lendng-SASRA")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Loan Sectorial Lending';
                        RunObject = REPORT "Loan Sectoral Lending Report";
                    }
                    action("Loans Insider Lending-SASRA")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Loans Insider Lending';
                        RunObject = report "Insider Lending";
                    }
                    action("Loan Defaulter Aging")
                    {
                        ApplicationArea = all;
                        Caption = 'Loans Defaulter Aging-SASRA';
                        RunObject = report "Loans Defaulters Aging -(Auto)";
                        ToolTip = 'Loan Defaulter Aging(Risk Classification)';
                    }
                }
                //.......................................................................................................................................
            }

            //...................... START OF FOSA MANAGEMENT MENU .............
            group(FOSAManagement)
            {
                Caption = 'FOSA Management ';

                action("Savings Products")
                {
                    // ApplicationArea = Basic, Suite;
                    // RunObject = page "Account Details Master";
                    // ToolTip = 'All Saving Products';
                }
                // group(StandingOrders)
                // {
                //     Caption = 'Standing Orders';
                //     action(StandingOrderApplication)
                //     {
                //         ApplicationArea = All;
                //         Caption = 'Standing Order Application List';
                //         RunObject = Page standingorderapplicationlist;
                //     }
                //     action(ActiveStandingOrder)
                //     {
                //         ApplicationArea = all;
                //         Caption = 'Active Standing Order';
                //         RunPageView = WHERE(Status = CONST(Approved));
                //         RunObject = Page "Standing Orders - List";
                //     }
                //     action("StopedStandingOrder")
                //     {
                //         ApplicationArea = all;
                //         Caption = 'Stopped Standing Order';
                //         RunPageView = WHERE(Status = CONST(Stopped));
                //         RunObject = Page "Standing Orders - List";
                //     }

                // }
                group("FOSA Loans")
                {
                    group("FOSA Loans Management")
                    {
                        action("FOSA Applications")
                        {
                            Caption = 'FOSA Loans Application List';
                            Image = Receipt;
                            RunObject = page fosaloansapplicationlist;
                        }
                        action("FOSA Applications-Approved")
                        {
                            Caption = 'FOSA Loans Pending Disbursement';
                            Image = Receipt;
                            RunPageView = where("Loan Status" = const(Approved));
                            RunObject = page "Loans List - Advances";

                        }

                        action("FOSA Loans-Posted")
                        {
                            Caption = 'FOSA Loans Posted';
                            Image = Receipt;
                            RunObject = page "Posted Advances List";

                        }
                    }
                    group("FOSA Loans Reports")
                    {

                        action("Loans Register Report")
                        {
                            Caption = 'Overdraft Register Report';
                            Image = Report;
                            RunObject = report "Loans Register";

                        }

                    }
                    group("Overdraft Loan Management")
                    {

                        action(OverDraftNewApplication)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Overdraft New Applications';
                            RunPageView = where("Loan Status" = const(Application));
                            RunObject = page "OverDrafts Application List";


                        }
                        action(OverDraftPendingApplication)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Overdrafts Pending Approval';
                            RunPageView = where("Loan Status" = const(Appraisal));
                            RunObject = page "OverDrafts Application List";
                        }
                        action(OverDraftPostedApplication)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Overdrafts Disbursed';
                            RunPageView = where("Loan Status" = const(Issued));
                            RunObject = page "OverDrafts Posted List";

                        }
                    }
                    group("Okoa Loan Management")
                    {

                        action(OkoaApplications)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Okoa New Applications';
                            RunPageView = where("Loan Status" = const(application));
                            RunObject = page "Okoa Loan Applications List";
                        }


                        action(OkoaPendingApproval)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Okoa Pending Approval';
                            RunPageView = where("Loan Status" = const(appraisal));
                            RunObject = page "Okoa Loan Applications List";
                        }
                        action(OkoaIssued)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Okoa Disbursed Loans';
                            RunPageView = where("Loan Status" = const(issued));
                            RunObject = page "Okoa Loan Applications List";
                        }

                    }

                }
                group("Accounts Activation")
                {
                    Caption = 'Account Activation';
                    action("Account Activation List")
                    {

                        Image = Receipt;
                        RunObject = page "allaccountactivationlist";
                        Caption = 'New Account Activations';

                    }

                    action("Posted Account Activations")
                    {
                        Image = Receipt;
                        RunObject = page postedaccountactivationlist;
                        Caption = 'Activated Accounts';

                    }

                }
                group("FDR Management")
                {

                    // action("FDR Application List")
                    // {
                    //     Caption = 'FDR Application';
                    //     Image = Receipt;
                    //     RunObject = Page fdrapplicationlist;

                    // }
                    action("FDR Processing")
                    {
                        Caption = 'FDR Processing';
                        Image = Receipt;
                        RunObject = report "Manage Fixed Deposit";

                    }
                    action("FDR Certificates")
                    {
                        Caption = 'FDR Certificates';
                        Image = Receipt;
                        RunObject = report "Fixed Deposit Receipt";


                    }

                    action("Active FDR ")
                    {
                        // Caption = 'Active FDR';
                        // Image = Receipt;
                        // RunObject = page "Account Details Master";
                        // RunPageView = WHERE("Account Type" = CONST('FIXED'), "Balance" = filter(> 0));

                    }
                }


            }

            //.......................... End of FOSA MANAGEMENT MENU ........................................



            group(BosaManagement)
            {
                Caption = 'BOSA Management';

                //.................................START OF MEMBERSHIP MANAGEMENT..................................

                group(MembershipManagement)
                {
                    Caption = 'Membership Management';
                    action(MembersList)
                    {
                        ApplicationArea = all;
                        Caption = 'Member Accounts';
                        RunObject = Page "Member List";
                        ToolTip = 'View Member Accounts';
                    }
                    group(ChangeRequest)
                    {
                        Caption = 'Change Request';
                        action("Change Request")
                        {
                            ApplicationArea = All;
                            Caption = 'Change Request List';
                            RunObject = Page "Change Request List";
                            ToolTip = 'Change Member Details';
                        }
                        group(EffectedChangeReqs)
                        {
                            Caption = 'Effected Change Requests';
                            action(updatedchangereqslist)
                            {
                                ApplicationArea = All;
                                Caption = 'Updated Change requests';
                                RunObject = page "Updated Change Request List";
                            }
                        }
                    }

                    group("Membership Exit")
                    {
                        action("Member Withdrawal List")
                        {
                            ApplicationArea = all;
                            RunObject = page "Membership Exit List";

                        }
                        action("Posted Membership Withdrawal")
                        {
                            ApplicationArea = all;
                            RunObject = page "Membership Exit List-Posted";
                        }
                        action("Membership Closure Report")
                        {
                            ApplicationArea = all;
                            RunObject = report "Membership Closure Report";

                        }

                    }

                    group("Member Reports")
                    {

                        Caption = 'Membership Reports';
                        action("Sacco Membership Reports")
                        {
                            ApplicationArea = all;
                            RunObject = report "Member Accounts List";
                            ToolTip = 'Members Register';

                        }
                        action("Member Account Balances Report")
                        {
                            ApplicationArea = all;
                            RunObject = report "Member Account  balances";
                            ToolTip = 'Member Account Balances Report';
                        }
                    }
                }
                //................................................START OF CHANGE REQUEST MENU.........................

                //...........................START OF TRANSFERS MENU .........................................
                group(Transfers)
                {
                    Caption = 'BOSA Transfers';
                    action(TransfersList)
                    {
                        ApplicationArea = basic, suite;
                        Caption = 'Transfers List';
                        Image = Customer;
                        RunObject = page "BOSA Transfer List";
                        ToolTip = 'Make member receiptings for payments done by member';

                    }
                    action(PostedTransfers)
                    {
                        ApplicationArea = basic, suite;
                        Caption = 'Posted Transfer List';
                        Image = Customer;
                        RunObject = page "BOSA Transfer Posted";
                        ToolTip = 'BOSA Transfer Posted';

                    }
                }
                //.............................................................
                //.....................................START OF LOAN MANAGEMENT
                group(SaccoLoansManagement)
                {
                    Caption = 'Loan Management';
                    ToolTip = 'Manage BOSA Module';
                    group("BOSA Loans Management")
                    {
                        Caption = 'BOSA Loan Application';
                        ToolTip = 'BOSA Loans'' Management Module';
                        action("BOSA Loan Application")
                        {
                            ApplicationArea = All;
                            Caption = 'BOSA Loan New Applications';
                            Image = Loaners;
                            RunObject = Page "Loan List-New Application BOSA";
                            ToolTip = 'Open BOSA Loan Applications List';
                        }
                        action("Pending BOSA Loan Application")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'BOSA Loans-Pending Approval';
                            Image = CreditCard;
                            RunObject = Page "LoanList-Pending Approval BOSA";
                            ToolTip = 'Open the list of BOSA Loans Pending Approval';
                        }
                    }
                    group("Loans Reschedule List")
                    {
                        action("LoansRescheduleList")
                        {
                            ApplicationArea = Basic, Suite;
                            RunObject = page "Loans Reschedule  List";
                            Caption = 'Loans Reschedule List';
                        }
                    }
                    group("Loans Top Up List")
                    {
                        action("LoansTop Up List")
                        {
                            ApplicationArea = Basic, Suite;
                            RunObject = page "Loan Top-Up List";
                            Caption = 'Loans Top-Up List';
                        }
                        action("LoansTopUp Posted")
                        {
                            ApplicationArea = Basic, Suite;
                            RunObject = page "Loan Top-Up List-Posted";
                            Caption = 'Loans Top-Up Posted';
                        }
                    }

                    group("Processed Loans")
                    {
                        action("PostedLoans")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Loans';
                            RunObject = Page "Loans Posted List";
                            ToolTip = 'Open the list of the Loans Posted.';
                        }
                    }
                    group("Loans' Reports")
                    {
                        action("Loans Balances Report")
                        {
                            ApplicationArea = all;
                            RunObject = Report "Loan Balances Report";
                            Caption = 'Member Loans Book Report';
                            ToolTip = 'Member Loans Book Report';
                            Visible = true;
                        }

                        action("Loan Collection Targets Report")
                        {
                            ApplicationArea = all;
                            RunObject = report "Loan Monthly Expectation";
                            ToolTip = 'Loan Collection Targets';
                            Caption = 'Loan Collection Targets';
                        }

                        action("Loans Guard Report")
                        {
                            ApplicationArea = all;
                            RunObject = report "Loan Guard Report";
                            ToolTip = 'Loans Guard Report';
                        }
                        action("Loans Guarantor Details Report")
                        {
                            ApplicationArea = all;
                            RunObject = Report "Loans Guarantor Details Report";
                            ToolTip = 'Loans Securities Report';
                        }
                        action("General Recoveries Report")
                        {
                            ApplicationArea = all;
                            RunObject = Report "Recovery From Salaries";
                            Caption = 'General Recoveries Report';
                        }
                    }
                    //......................................................................
                    action("Loan Calculator")
                    {
                        RunObject = page "Loans Calculator List";
                    }
                }

                //.............................Collateral Management..........................................

                group("Collateral Management")
                {
                    visible = false;
                    action(Collateralreg)
                    {
                        Caption = 'Loan Collateral Register';
                        Image = Register;
                        RunObject = page "Loan Collateral Register List";
                    }
                    action(Collateralmvmt)
                    {
                        Caption = 'Loan Collateral Movement';
                        //RunObject = page "Collateral Movement List";
                    }

                    group(CollateralReports)
                    {
                        Caption = 'Collateral Movement';
                        action(ColateralsReport)
                        {
                            Caption = 'Collateral Report';
                            //RunObject = report "Collaterals Report";
                        }

                    }
                    group(ArchiveCollateral)
                    {
                        Caption = 'Archive';
                        action(Effectedcollatmvmt)
                        {
                            Caption = 'Effective Collateral Movement';
                            //RunObject = page "Effected Collateral Movement";
                        }
                    }
                }

                //.........................End of Collateral Management......................................
                //...................................Guarantor Management........................................
                group("Guarantor Management")
                {
                    Caption = 'Guarantor Management';
                    action("Guarantor Substitution List")
                    {
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Guarantorship Sub List";
                    }
                    action("Effected Guarantor Substitution")
                    {
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Loans Guarantee Details";
                    }
                }

                //..................................End of Guarantor Management......................................

                //......................................Start of Defaulter Management............................
                group("Defaulter's Management")
                {
                    Caption = 'Defaulter Management';

                    group(loanRecovery)
                    {
                        Caption = 'Loan Recovery';
                        action(LoanRecovList)
                        {
                            Caption = 'Open Loan Recovery List';
                            RunObject = page "Loan Recovery List";
                            RunPageView = WHERE(Status = CONST(open));

                        }
                        action(PLoanRecovList)
                        {
                            Caption = 'Pending Approval Loan Recovery List';
                            RunObject = page "Loan Recovery";
                            RunPageView = WHERE(Status = CONST(pending));

                        }
                        action(ALoanRecovList)
                        {
                            Caption = 'Approved Loan Recovery List';
                            RunObject = page "Loan Recovery";
                            RunPageView = WHERE(Status = CONST(approved));

                        }
                        action(PostedLoanRecovList)
                        {
                            Caption = 'Posted Loan Recovery List';
                            RunObject = page "Loan Recovery";
                            RunPageView = WHERE(Status = CONST(closed));

                        }
                    }

                    group(demandnotices)
                    {
                        caption = 'Demand Notices';
                        Visible = false;
                        action(LoanDemandnoticeslist)
                        {
                            caption = 'Loan Demand Notices List';
                            //RunObject = page "Loan Demand Notices List";
                        }
                        group(DemnandTask)
                        {
                            Caption = 'Create Demand Notices';
                            action(CreateDemand)
                            {
                                Caption = 'Create Demand';
                                //RunObject = report "Create Demand Notices";
                                Image = Report2;
                            }
                        }
                        group(DemandReports)
                        {
                            action(Ldemandnotice1)
                            {
                                Caption = 'Loan Defaulter 1st Notice';
                                //RunObject = report "Loan Demand Notice";
                                Image = Report;

                            }
                            action(Ldemandnotice2)
                            {
                                Caption = 'Loan Defaulter 2nd Notice';
                                //RunObject = report "Loan Demand Notice";
                                Image = Report;
                            }
                            action(Ldemandnotice3)
                            {
                                Caption = 'Loan Defaulter 3rd Notice';
                                //RunObject = report "Loan Demand Notice";
                                Image = Report;
                            }
                        }
                    }
                }


                //.......................................End of Defaulter Management .................................
                //...............................................Start of BOSA Reports.........................
                group("BOSA Reports")
                {
                    action("New Members Report")
                    {
                        Caption = 'New Members Report';
                        RunObject = report "New Member Accounts";
                    }
                    action("Loan Totals Per Category")
                    {
                        Caption = 'Loan Totals Per Category';
                        RunObject = report "Loan Totals Per Employer";
                    }
                    action("Loans Portfolio Reports")
                    {
                        Caption = 'Loans Portfolio Reports';
                        RunObject = report "Loans Potfolio Analysis";
                    }
                    action("Loans Portfolio Concentration Reports")
                    {
                        Caption = 'Loans Portfolio Concentration Reports';
                        RunObject = report "Loan Portifolio Concentration";
                    }
                    action("Loans Underpaid/OverPaid")
                    {
                        Caption = 'Loans Underpaid/OverPaid';
                        RunObject = report "Loans Underpaid";
                    }
                }
                //.....................................End Of BOSA
                //..............................................................................................
            }

            group("CEEP Management")
            {
                group("CEEP  Management")
                {

                    group("CEEP Member Management")
                    {
                        action("CEEP Members List")
                        {
                            Image = Group;
                            RunObject = page "MC Individual Sub-List";
                        }
                    }

                    group("CEEP Group Management")
                    {
                        action("CEEP Group List")
                        {
                            Image = Group;
                            RunObject = page "MC Group List";
                        }
                    }
                }

                group("CEEP Loans Management")
                {
                    group("CEEP Loans Processing")
                    {
                        action("Loans Applications-New")
                        {
                            Image = Group;
                            RunObject = page "Loans List-MICRO";
                            RunPageView = WHERE("Loan Status" = CONST(Application), source = filter('MICRO'));
                        }
                        action("Loans Applications-Pending Approval")
                        {
                            Image = Group;
                            RunObject = page "Loans List-MICRO";
                            RunPageView = WHERE("Loan Status" = CONST(Appraisal), source = filter('MICRO'));
                            RunPageMode = view;
                        }
                    }
                    group("CEEP Posted Loans")
                    {
                        action("CEEP Loans Posted")
                        {
                            Image = Group;
                            RunObject = page "Loans Posted-MICRO";
                        }
                    }
                }


                group("CEEP Transactions")
                {
                    action("CEEP Receipt List")
                    {
                        Image = Group;
                        RunObject = page "Micro_Finance_Transactions Lis";

                    }
                    action("CEEP Receipt Posted")
                    {
                        Image = Group;
                        RunObject = page "Micro Finance Trans Posted";
                    }
                }

                group("CEEP Reports")
                {
                    action("CEEP Officer Targets")
                    {
                        ApplicationArea = all;
                        RunObject = report "Loan Monthly Expectation";
                        ToolTip = 'CEEP Officer Targets Report';
                        Caption = 'CEEP Officer Targets';
                    }
                    action("CEEP Collections Report")
                    {
                        // ApplicationArea = all;
                        // RunObject = report "CEEP Officer Collection Report";
                        // ToolTip = 'CEEP Collections & Variance Report';
                        // Caption = 'CEEP Collections & Variance Report';
                    }
                    action("CEEP Loans Register ")
                    {
                        Image = Report;
                        Caption = 'Loans Register-CEEP';
                        RunObject = report "Loans Register-CEEP";
                    }


                    action("CEEP Members Register ")
                    {
                        Image = Report;
                        Caption = 'Members Register-CEEP';
                        RunObject = report "Members Register-CEEP";
                    }
                    action("CEEP Loan Status Report")
                    {
                        Image = Report;
                        RunObject = report "MICRO report";
                    }
                    action("CEEP Savings Report")
                    {
                        Image = Report;
                        RunObject = report "MICRO Savings Report";
                    }
                    action("CEEP Interest Report")
                    {
                        Image = Report;
                        RunObject = report "MICRO report Officer";
                    }
                }
            }
            //.......................... END OF CEEP MANAGEMENT MAIN MENU ........................................
            //.......................... START OF TELLER ACTIVITIES MAIN MENU ......................................
            //....................... START OF ALTERNATIVE CHANNELS MAIN MENU ................................
            //......................... START OF CRM Main MENU ...............................................
            group(SaccoCRM)
            {
                Caption = 'CRM';
                Visible = true;

                action("CRM Member List")
                {
                    Caption = 'CRM Member List';
                    ApplicationArea = basic, suite;
                    Image = ProdBOMMatrixPerVersion;
                    RunObject = page "CRM Member List";

                }
                group("Case Management")
                {
                    action("Case Registration")
                    {
                        Caption = 'Lead Management';
                        ApplicationArea = basic, suite;
                        Image = Capacity;
                        RunObject = page "Lead list";
                        RunPageView = WHERE(status = CONST(New));
                        ToolTip = 'Create a New Case enquiry';

                    }
                    action("Assigned Cases")
                    {
                        Caption = 'Assigned Cases';
                        ApplicationArea = basic, suite;
                        Image = Open;
                        RunObject = page "Lead list Escalated";
                        RunPageView = WHERE(status = CONST(Escalted));
                        ToolTip = 'Open List Of Cases open & Assigned To Me';
                    }
                }
            }
            // group("Self Services")
            // {
            //     Visible = true;
            //     action("Apply Leave")
            //     {
            //         ApplicationArea = basic, suite;
            //         Image = Employee;
            //         RunObject = page "HR Leave Applications List";
            //     }
            //     action("My Posted Leave Applications")
            //     {
            //         ApplicationArea = basic, suite;
            //         Image = Employee;
            //         RunObject = page "HR Leave Applications L-Posted";
            //     }
            //     action(SendPaySlip)
            //     {
            //         Caption = 'My Payslip';
            //         ApplicationArea = basic, suite;
            //         // RunObject = report "Send P9 Report Via Mail";
            //     }
            //     action(SendP9)
            //     {
            //         Caption = 'My P9 Slip';
            //         ApplicationArea = basic, suite;
            //         RunObject = report "Send P9 Report Via Mail";
            //     }
            // }

#if not CLEAN18
        }

#endif

    }

}



