// page 51516842 DevcoGENERALROLECENTRE
// {
//     ApplicationArea = All;
//     Caption = 'Devco SACCO';
//     PageType = RoleCenter;

//     layout
//     {
//         area(rolecenter)
//         {

//             part(Control75; "Headline RC Accountant")
//             {
//                 ApplicationArea = All;
//                 Visible = false;

//             }

//             part(Control99; "Finance Performance")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = false;
//             }
//             // part(FOSACue; "FOSA Cue")
//             // {
//             //     ApplicationArea = Basic, Suite;
//             //     Visible = true;

//             // }
//             part(BOSACue; "BOSA Cue")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = true;

//             }
//             // part("LoansCue"; "Loans Cue")
//             // {
//             //     ApplicationArea = Suite;
//             //     Visible = true;
//             // }
//             part("General Cue"; "General Cue")
//             {
//                 ApplicationArea = Suite;
//                 Visible = true;

//             }
//             // part("SasraLoanClassificationCue"; "Sasra Loan Classification Cue")
//             // {
//             //     ApplicationArea = Suite;
//             //     Visible = true;
//             // }

//             part("Emails"; "Email Activities")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = true;
//             }
//             part(Control123; "Team Member Activities")
//             {
//                 ApplicationArea = Suite;
//                 Visible = false;
//             }
//             part(Control1907692008; "My Accounts")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = false;
//             }
//             part(Control103; "Trailing Sales Orders Chart")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = false;
//             }

//             part(Control106; "My Job Queue")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = false;
//             }
//             part(Control9; "Help And Chart Wrapper")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = false;
//             }
//             part(Control100; "Cash Flow Forecast Chart")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = false;
//             }
//             part(Control108; "Report Inbox Part")
//             {
//                 AccessByPermission = TableData "Report Inbox" = IMD;
//                 ApplicationArea = Basic, Suite;
//                 Visible = true;
//             }
//             part(Control122; "Power BI Report Spinner Part")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = true;
//             }
//             systempart(Control1901377608; MyNotes)
//             {
//                 ApplicationArea = Basic, Suite;
//                 Visible = true;
//             }
//         }
//     }

//     actions
//     {
//         area(reporting)
//         {

//         }
//         area(embedding)
//         {
//             action("Chart of Account")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'Chart of Accounts';
//                 RunObject = Page "Chart of Accounts";
//                 ToolTip = 'Open the chart of accounts.';
//                 visible = true;
//             }
//             action("Bank Accounts List")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'Bank Accounts';
//                 Image = BankAccount;
//                 visible = true;
//                 RunObject = Page "Bank Account List";
//                 ToolTip = 'View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.';
//             }
//             action(Members)
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'Members';
//                 Image = Customer;
//                 visible = true;
//                 RunObject = Page "Member List";
//                 ToolTip = 'View or edit detailed information for the Members.';
//             }
//             action(FOSAAccounts)
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'FOSA Accounts';
//                 Image = Vendor;
//                 Visible = false;
//                 RunObject = Page "Account Details Master";
//                 ToolTip = 'View or edit detailed information for the FOSA Savings Accounts.';

//             }
//             action(FOSAAccountsBalance)
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'FOSA Account Balances';
//                 Image = Balance;
//                 RunObject = Page "Vendor List";
//                 RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
//                 ToolTip = 'View a summary of the bank account balance in different periods.';
//                 Visible = false;
//             }
//             action("Bulk Sms")
//             {
//                 ApplicationArea = Basic, suite;
//                 Caption = 'Send SMS';
//                 Image = Message;
//                 RunObject = Page "Bulk SMS Header";
//                 ToolTip = 'Send Bulk Sms to Members';
//                 Visible = false;
//             }
//             action("Posted Receipts List")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'View Posted Receipts';
//                 Image = Documents;
//                 RunObject = Page "Posted BOSA Receipts List";
//                 ToolTip = 'View Posted BOSA Receipts';
//                 Visible = false;
//             }
//         }
//         area(sections)
//         {


//             //......................... START OF FINANCIAL MANAGEMENT MENU ...........................

//             group(FinancialManagement)
//             {
//                 Caption = 'Financial Management';
//                 Image = Journals;
//                 ToolTip = 'Collect and make payments, prepare statements, and reconcile bank accounts.';


//                 group("General Ledger")
//                 {
//                     Caption = 'General Ledger';
//                     ToolTip = 'Process incoming and outgoing payments. Set up bank accounts and service connections for electronic banking.  ';
//                     Visible = true;

//                     action("General Journals")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'General Journals';
//                         Image = Journal;
//                         RunObject = Page "General Journal";
//                         ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.';
//                     }


//                     action("G/L Register")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'G/L Register';
//                         Image = Journal;
//                         RunObject = Page "G/L Registers";


//                     }

//                     action("Chart of Accounts")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Chart of Accounts';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or organize the general ledger accounts that store your financial data. All values from business transactions or internal adjustments end up in designated G/L accounts. Business Central includes a standard chart of accounts that is ready to support businesses in your country, but you can change the default accounts and add new ones.';

//                     }

//                     action("G/L Navigator")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'G/L Navigator';
//                         Image = Journal;
//                         RunObject = Page Navigate;


//                     }
//                 }
//                 //......................................................................................................................................

//                 group("Cash Management")
//                 {
//                     Caption = 'Cash Management';
//                     ToolTip = 'Process incoming and outgoing payments. Set up bank accounts and service connections for electronic banking.  ';
//                     Visible = true;

//                     action("Bank Accounts Management")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Bank Accounts List';

//                         RunObject = page "Bank Account List";
//                     }

//                     action("Treasury Management")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Treasury Management';
//                         RunObject = page "Treasury List";

//                     }
//                     action("Voucher Cash Payments")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Voucher Cash Payment';
//                         RunObject = Page "Payment List";
//                         Visible = false;

//                     }

//                     action("Cash Payments")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Cash Payments';
//                         RunObject = Page "Cash Payment List";
//                         Visible = false;

//                     }

//                     action("Bank Account Reconciliation")

//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Bank Accounts Reconcilations';
//                         RunObject = page "Bank Acc. Reconciliation List";

//                     }

//                     action("Posted Payment Reconcilations")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Payment Reconcilations';
//                         RunObject = page "Posted Payment Reconciliations";
//                         Visible = false;

//                     }

//                     action("Payment Reconcilations jOURNALS")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Payment Reconcilations Journals';
//                         RunObject = page "Payment Reconciliation Journal";

//                     }

//                 }

//                 //...........................................................................................


//                 group("Cheques Management")
//                 {
//                     Caption = 'Cheques Management';
//                     ToolTip = 'Process incoming and outgoing cheque payments. ';
//                     Visible = false;

//                     action("Family Bank Cheque Clearing")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Process Inward Cheques';
//                         RunObject = Page "Cheque Receipt List-Family";
//                     }

//                     action("Cheque Clearing")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Process Cheque Clearing';
//                         RunObject = Page "Process Cheque clearing";

//                     }

//                     action("Special Cheques Clearing")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Process Special Cheque Clearing';
//                         // promoted = true;
//                         // PromotedCategory = Process;
//                         //RunObject = Page RejectedCheques;

//                     }



//                 }


//                 //........................................................................................................................................           

//                 group("SASRA Reports")
//                 {
//                     Caption = 'SASRA Reports';
//                     ToolTip = 'which highlights the operations and performance of the SACCO industry during the year ended';
//                     Visible = true;

//                     action("Deposits Return-SASRA")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Deposits Return';
//                         Image = Report;
//                         RunObject = report "Deposit Return SASRA";
//                     }
//                     action("Agency Returns-SASRA")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Agency Report';
//                         Visible = true;
//                         RunObject = report "Agency Report-SASRA";
//                     }
//                     // action("Loans Defaulter Aging-SASRA")
//                     // {
//                     //     ApplicationArea = Basic, Suite;
//                     //     Caption = 'Loans Defaulter Aging';
//                     //     RunObject = report "Loans Defaulter Aging - SASRA";
//                     // }


//                     action("Loans Provisioning Summary-SASRA")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Loans Provisioning Summary';
//                         RunObject = report "Loans Provisioning Summarys";
//                     }
//                     action("Loan Sectorial Lendng-SASRA")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Loan Sectorial Lending';
//                         RunObject = REPORT "Loan Sectoral Lending Report";
//                     }
//                     action("Loans Insider Lending-SASRA")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Loans Insider Lending';
//                         RunObject = report "Insider Lending";
//                     }
//                 }
//                 //..........................................................................................................................................

//                 group("Payments Processing")
//                 {
//                     Caption = 'Payment Processing';
//                     ToolTip = 'Process incoming and outgoing payments.';
//                     Visible = true;

//                     action("Payment Vouchers")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Payment Vouchers Posting';
//                         Image = Journal;
//                         RunObject = Page "Payment List";

//                     }

//                     action("Posted Payment Vouchers")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Posted Payment Vouchers';
//                         Image = Journal;
//                         RunObject = Page "Posted Payment List";

//                     }

//                     action("Petty Cash Payment")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Petty Cash Payment';
//                         RunObject = page "PettyCash Payment List";
//                     }

//                     action("Posted Petty Cash")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Posted Petty Cash';
//                         RunObject = page "Posted PettyCash Payment List";

//                     }

//                     action("Pettycash rembursement")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Petty Cash Rembursement';
//                         RunObject = Page "Funds Transfer List";
//                     }

//                     action("PostedPetty Cash Reimbursement")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Posted Rembursements';
//                         RunObject = Page "Posted Funds Transfer List";
//                     }


//                 }
//                 Group(FundsTranfer)
//                 {
//                     Caption = 'Funds Tranfer';
//                     Visible = false;

//                     action("FundTransList")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'New Funds Transfer';
//                         RunObject = Page "Funds Transfer List";
//                     }

//                     action("PostedFundTrans")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Posted Funds Transfer';
//                         RunObject = Page "Posted Funds Transfer List";
//                     }

//                     action("EFT")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Electronic Funds Tranfer';
//                         RunObject = Page "EFT list";
//                     }




//                 }
//                 //............................................................................................
//                 group("Assets Management")
//                 {
//                     Caption = 'Assets Management';
//                     ToolTip = 'Record and Manage Assets.';
//                     Visible = true;
//                     action("Asset Register")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Assets Register';
//                         RunObject = Page "Fixed Asset List";
//                         ToolTip = 'Assets Register.';
//                     }

//                     action("Fixed Asset G/L Journal")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Fixed Asset G/J Journal';
//                         RunObject = Page "Fixed Asset G/L Journal";
//                         ToolTip = 'Record Asset Movement.';
//                     }


//                     action("Fixed Asset Journal")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Fixed Asset Journal';
//                         RunObject = Page "Fixed Asset Journal";
//                         ToolTip = 'View all Sacco Assets.';
//                     }

//                     action("Fixed Asset Setup")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Fixed Asset Setup';
//                         RunObject = page "Fixed Asset Setup";

//                     }
//                     group("Fixed Asset Report")
//                     {


//                         action("Fixed Asset List")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Fixed Asset List';
//                             RunObject = report "Fixed Asset - List";

//                         }
//                         action("Fixed Asset Register")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Fixed Asset Register';
//                             RunObject = report "Fixed Asset Register";

//                         }

//                         action("FA Posting Group Net Change")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'FA Posting Group Net Change';
//                             RunObject = report "FA Posting Group - Net Change";

//                         }

//                     }



//                 }



//                 //.................................................................................................................................................

//                 group("Finance Statements")
//                 {
//                     Caption = 'Financial Statements';
//                     ToolTip = 'Display Financial Statements.';
//                     Visible = true;

//                     action("Jamii Trial Balance")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Trial Balance';
//                         RunObject = report "Devco Sacco Trial Balance";
//                         ToolTip = 'Generate Trial Balance for a given period.';
//                     }
//                     action("Account Schedules")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Account Schedules';
//                         RunObject = page "Account Schedule Names List";
//                     }

//                     action("LiquidityReport")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Liquidity Report';
//                         // Image = Journal;
//                         // RunObject = Page "General Journal Batches";
//                         //  RunPageView = WHERE("Template Type" = CONST(General),
//                         //                    Recurring = CONST(false));
//                         ToolTip = 'Generate Liquidity Report for a given period.';
//                     }
//                 }


//                 //.......................................................................................................................................


//                 group("Financials Reports")
//                 {
//                     Caption = 'Financial Reports';
//                     ToolTip = 'Display Financial Reports.';
//                     Visible = false;



//                     action("Liquidity Report")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Liquidity Report';
//                         // Image = Journal;
//                         // RunObject = Page "General Journal Batches";
//                         //  RunPageView = WHERE("Template Type" = CONST(General),
//                         //                    Recurring = CONST(false));
//                         ToolTip = 'Generate Liquidity Report for a given period.';
//                     }

//                     action("Deposit Return SASRA")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Deposit Return SASRA';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Deposit Return SASRA for a given period.';
//                     }


//                     action("Capital Adequacy Return")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Capital Adequacy Return';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Deposit Return SASRA for a given period.';
//                     }


//                     action("Liquidity Statement")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Liquidity Statement';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Deposit Return SASRA for a given period.';
//                     }

//                     action("Investiment Return")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Investiment Return';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Deposit Return SASRA for a given period.';
//                     }

//                     action("Statement of Financial Position")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Statement of Financial Position';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Deposit Return SASRA for a given period.';
//                     }

//                     action("Statement Of Comprehensive Income")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Statement Of Comprehensive Income';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Deposit Return SASRA for a given period.';
//                     }

//                     action("Agency Returns Report")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Agency Returns Report';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Agency Returns for a given period.';
//                     }

//                     action("Sectorial Lending Report")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Sectorial Lending Report';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Agency Returns for a given period.';
//                     }


//                     action("Insider Lending Report")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Insider Lending Report';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate Agency Returns for a given period.';
//                     }


//                     action("GL Accounts Net Change Report")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'GL Accounts Net Change Report';
//                         RunObject = Page "Chart of Accounts";
//                         ToolTip = 'View or Generate GL Accounts Net Change Report for a given period.';
//                     }




//                 }


//                 //.......................................................................................................................................

//                 //..................................................................................................................................
//                 group("Periodic Activities")
//                 {
//                     Caption = 'Periodic Activities';
//                     ToolTip = ' All Finance Module Setups ';
//                     Visible = true;

//                     action("Close Income Statement")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Close Income Statement';

//                         RunObject = report "Close Income Statement";
//                     }

//                     action("Create Accounting Period")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Create Accounting Period';

//                         RunObject = page "Accounting Periods";
//                     }

//                     action("Update Liquidity")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Update Liquidity Report';

//                     }
//                 }

//                 group("G/L Budgets")
//                 {
//                     Caption = 'G/L Budgets';
//                     ToolTip = 'G/L Budgets.';
//                     Visible = true;
//                     action("GL Budgets")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'G/L Budgets';

//                         RunObject = page "G/L Budget Names";
//                     }
//                 }

//             }

//             //...................... START OF FOSA MANAGEMENT MENU ................................................            

//             group(FOSAManagement)
//             {
//                 Caption = 'FOSA Management ';

//                 action("Savings Products")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     RunObject = page "Account Details Master";
//                     ToolTip = 'All Saving Products';
//                 }

//                 group(ProductManagement)
//                 {
//                     Caption = 'Product Management';
//                     action("ProductsApplication")
//                     {
//                         ApplicationArea = all;
//                         Caption = 'Products Application List';
//                         RunPageView = WHERE(status = CONST(open));
//                         RunObject = Page "Products Applications Master";
//                     }

//                     action(NewApprovedPoducts)
//                     {
//                         ApplicationArea = all;
//                         Caption = 'Products Pending Creation';
//                         RunPageView = WHERE(Status = CONST(Approved));
//                         RunObject = Page "Products Applied Master";
//                     }
//                     action(ProductsCreated)
//                     {
//                         ApplicationArea = all;
//                         Caption = 'Products Created';
//                         RunPageView = WHERE(Status = CONST(created));
//                         RunObject = Page "Products Applied Master";
//                     }
//                 }


//                 // group(StandingOrders)
//                 // {
//                 //     Caption = 'Standing Orders';
//                 //     action(StandingOrderApplication)
//                 //     {
//                 //         ApplicationArea = All;
//                 //         Caption = 'Standing Order Application List';

//                 //         RunObject = Page standingorderapplicationlist;
//                 //     }

//                 //     action(ActiveStandingOrder)
//                 //     {
//                 //         ApplicationArea = all;
//                 //         Caption = 'Active Standing Order';
//                 //         RunPageView = WHERE(Status = CONST(Approved));
//                 //         RunObject = Page "Standing Orders - List";
//                 //     }
//                 //     action("StopedStandingOrder")
//                 //     {
//                 //         ApplicationArea = all;
//                 //         Caption = 'Stopped Standing Order';
//                 //         RunPageView = WHERE(Status = CONST(Stopped));
//                 //         RunObject = Page "Standing Orders - List";
//                 //     }

//                 // }




//                 group("Cheque Management")
//                 {

//                     Caption = 'Cheque Management';
//                     group(chequetruncation)
//                     {
//                         Caption = 'Cheque Truncation';

//                         action("New Cheque Truncation")
//                         {
//                             ApplicationArea = All;
//                             RunObject = Page "Cheque Receipt List-Family";
//                             RunPageView = where(Posted = const(false));
//                         }

//                         action("Posted Cheque Truncation")
//                         {
//                             ApplicationArea = All;
//                             RunObject = Page "Postedcheque truncation";
//                             RunPageView = where(Posted = const(true));
//                         }
//                     }
//                     group(ChequeProcessing)

//                     {
//                         Caption = 'Cheque Processing';
//                         action("Uncleared Cheque List")
//                         {
//                             Caption = 'Unprocessed Cheque List';
//                             ApplicationArea = All;
//                             RunObject = Page "Process Cheque clearing";
//                         }
//                         action("Mature Cheque Uncleared")
//                         {
//                             Caption = 'Unprocessed Mature Cheque';
//                             ApplicationArea = All;
//                             RunObject = Page maturechequesnotposted;
//                         }

//                         action("Processed Cheques")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             caption = 'Procesed Cheques';
//                             RunObject = page processedchequelist;

//                         }

//                         action("Open Cheques")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Open Cheques';
//                             // promoted = true;
//                             // PromotedCategory = Process;
//                             //RunObject = Page OpenCheques;
//                             visible = false;
//                         }

//                         action("Rejected Cheques")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Rejected Cheques';
//                             // promoted = true;
//                             // PromotedCategory = Process;
//                             //RunObject = Page RejectedCheques;
//                             visible = false;
//                         }

//                         action("Approved Cheques")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Approved Cheques';
//                             // promoted = true;
//                             // PromotedCategory = Process;
//                             //RunObject = Page ApprovedCheques;
//                             visible = false;
//                         }

//                         action("Pending Cheques")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Pending Cheques';
//                             // promoted = true;
//                             // PromotedCategory = Process;
//                             // RunObject = Page PendingCheques;
//                             visible = false;
//                         }

//                     }

//                     group("Chequebook Management")
//                     {

//                         action("Cheque Book Application")
//                         {
//                             ApplicationArea = All;
//                             RunObject = Page "Cheque Book Application List";

//                         }

//                         action("Applied Cheque Books")
//                         {
//                             ApplicationArea = All;
//                             RunObject = Page "Cheque Book Application List F";
//                         }

//                         action("Cheque Register")
//                         {
//                             ApplicationArea = All;
//                             RunObject = Page "Cheques RegisterX";
//                         }
//                     }

//                     action("Collected Cheques")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Collected Cheques';
//                         visible = false;
//                         // promoted = true;
//                         // PromotedCategory = Process;
//                         //RunObject = page CollectedCheques;
//                     }
//                     group("Cheque Schedule")
//                     {
//                         action("Cheque Banking Schedule")
//                         {
//                             ApplicationArea = basic;
//                             RunObject = page "Banking Schedule Cheques";

//                         }
//                         action("Bankers Cheque Schedule")
//                         {
//                             ApplicationArea = basic;
//                             RunObject = page "Bankers Cheque Schedule";

//                         }

//                     }

//                 }


//                 group("FOSA Loans")
//                 {
//                     group("FOSA Loans Applications")
//                     {
//                         action("FOSA Applications")
//                         {
//                             Caption = 'FOSA Loans New Application List';
//                             Image = Receipt;
//                             RunObject = page fosaloansapplicationlist;
//                             RunPageView = where("loan Status" = const(application));
//                         }
//                         action("FOSA Applications-Pending")
//                         {
//                             Caption = 'FOSA Loans Pending Approval';
//                             Image = Receipt;
//                             RunPageView = where("Approval Status" = const(pending));
//                             RunObject = page fosaloansapplicationlist;
//                         }
//                         action("FOSA Applications-Approved")
//                         {
//                             Caption = 'FOSA Loans Pending Disbursement';
//                             Image = Receipt;
//                             RunPageView = where("Loan Status" = const(Approved));
//                             RunObject = page "Loans List - Advances";
//                         }
//                     }
//                     group("Overdraft Loan Management")
//                     {
//                         action(OverDraftNewApplication)
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Overdraft New Applications';
//                             RunPageView = where("Loan Status" = const(Application));
//                             RunObject = page "OverDrafts Application List";
//                         }
//                         action(OverDraftPendingApplication)
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Overdrafts Pending Approval';
//                             RunPageView = where("Loan Status" = const(Appraisal));
//                             RunObject = page "OverDrafts Application List";
//                         }
//                         action(OverDraftApprovedApplication)
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Overdrafts Pending Disbursements';
//                             RunPageView = where("Loan Status" = const(Approved));
//                             RunObject = page "OverDrafts Application List";
//                         }

//                         action(OverDraftPostedApplication)
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Overdrafts Disbursed';
//                             RunPageView = where("Loan Status" = const(Issued));
//                             RunObject = page "OverDrafts Posted List";

//                         }
//                     }
//                     group("Okoa Loan Management")
//                     {

//                         action(OkoaApplications)
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Okoa New Applications';
//                             RunPageView = where("Loan Status" = const(application));
//                             RunObject = page "Okoa Loan Applications List";
//                         }


//                         action(OkoaPendingApproval)
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Okoa Pending Approval';
//                             RunPageView = where("Loan Status" = const(appraisal));
//                             RunObject = page "Okoa Loan Applications List";
//                         }

//                         action(OkoaPendingDisbursement)
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Okoa Pending Disbursement';
//                             RunPageView = where("Loan Status" = const(approved));
//                             RunObject = page "Okoa Loan Applications List";

//                         }
//                         action(OkoaIssued)
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'Okoa Disbursed Loans';
//                             RunPageView = where("Loan Status" = const(issued));
//                             RunObject = page "Okoa Loan Applications List";
//                         }

//                     }
//                     action("FOSA Loans-Posted")
//                     {
//                         Caption = 'FOSA Loans Posted';
//                         Image = Receipt;
//                         RunObject = page "Posted Advances List";
//                     }
//                     group("FOSA Loans Reports")
//                     {

//                         action("Loans Register Report")
//                         {
//                             Caption = 'Overdraft Register Report';
//                             Image = Report;
//                             RunObject = report "Loans Register";

//                         }
//                         action("Overdraft Register")
//                         {
//                             Image = Receipt;
//                             RunObject = report "Overdraft Register";
//                         }
//                     }

//                 }
//                 group("Accounts Activation")
//                 {
//                     Caption = 'Account Activation';
//                     action("Account Activation List")
//                     {

//                         Image = Receipt;
//                         RunObject = page "allaccountactivationlist";
//                         Caption = 'New Account Activations';

//                     }

//                     action("Posted Account Activations")
//                     {
//                         Image = Receipt;
//                         RunObject = page postedaccountactivationlist;
//                         Caption = 'Activated Accounts';

//                     }

//                 }


//                 group("Periodics Activities")

//                 {
//                     Caption = 'Periodic Activities';



//                     group("Process Salary")
//                     {

//                         Caption = 'Member Salary Processing';
//                         action("Salary Processing List")
//                         {
//                             Image = ProfileCalendar;
//                             Caption = 'Member Salary Processing';
//                             RunObject = Page "Periodics Processing List";
//                         }
//                         action("Posted Salary Processings")
//                         {
//                             Image = Receipt;
//                             Caption = 'Posted Member Salary Processing';
//                             RunObject = Page "Posted Salary List";
//                         }
//                     }

//                     action("Process Monthly Tea")
//                     {
//                         Image = ProfileCalendar;
//                         Caption = 'Member Tea Processing';
//                         RunObject = Page "Periodics Processing-Tea";
//                     }

//                     action("Process Tea Bonus")
//                     {
//                         Image = Receipt;
//                         RunObject = Page TeaBonusPosting;
//                     }

//                     action("Process Milk")
//                     {
//                         Image = Receipt;
//                         RunObject = Page MilkPosting;
//                     }

//                     action("Generate FOSA Savings Interest")

//                     {
//                         Image = Report;
//                         RunObject = report "Generate FOSA Interest";
//                     }
//                     action("Generate Christmas  Interest")
//                     {
//                         Image = Receipt;
//                         RunObject = report "Christmas Calculate Interest";
//                     }

//                     action("Process Standing Orders")
//                     {
//                         Image = Receipt;
//                         RunObject = report "Process Standing Orders";
//                     }

//                     action("Charge Account Maintance")
//                     {
//                         Image = Receipt;
//                         RunObject = report "Account Maintance";
//                     }
//                     action("Charge Quaterly Statement")
//                     {
//                         Image = Receipt;
//                         RunObject = report "Charge Statement";
//                     }
//                 }



//                 group("FDR Management")
//                 {

//                     action("FDR Application List")
//                     {
//                         Caption = 'FDR Application';
//                         Image = Receipt;
//                         RunObject = Page fdrapplicationlist;

//                     }

//                     action("FDR Processing")
//                     {
//                         Caption = 'FDR Processing';
//                         Image = Receipt;
//                         RunObject = report "Manage Fixed Deposit";

//                     }
//                     action("FDR Certificates")
//                     {
//                         Caption = 'FDR Certificates';
//                         Image = Receipt;
//                         RunObject = report "Fixed Deposit Receipt";


//                     }

//                     action("Active FDR ")
//                     {
//                         Caption = 'Active FDR';
//                         Image = Receipt;
//                         RunObject = page "Account Details Master";
//                         RunPageView = WHERE("Account Type" = CONST('FIXED'), "Balance" = filter(> 0));

//                     }
//                 }


//             }

//             //.......................... End of FOSA MANAGEMENT MENU ........................................



//             group("Cash Management New")
//             {
//                 Caption = 'Cash Management';
//                 ToolTip = 'Process incoming and outgoing payments. Set up bank accounts and service connections for electronic banking.  ';
//                 Visible = false;
//                 group("Cheque Manangement")
//                 {
//                     action(CollectedCheques)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Collected Cheques';
//                         // promoted = true;
//                         // PromotedCategory = Process;
//                         //RunObject = page CollectedCheques;
//                     }
//                     action(ProcessedCheques)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         caption = 'Procesed Cheques';
//                         // promoted = true;
//                         // PromotedCategory = Process;
//                         //RunObject = page ProccesedCheques;
//                     }
//                     action("OpenCheques")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Open Cheques';
//                         // promoted = true;
//                         // PromotedCategory = Process;
//                         //RunObject = Page OpenCheques;

//                     }
//                     action("RejectedCheques")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Rejected Cheques';
//                         // promoted = true;
//                         // PromotedCategory = Process;
//                         //RunObject = Page RejectedCheques;

//                     }
//                     action("ApprovedCheques")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Approved Cheques';
//                         // promoted = true;
//                         // PromotedCategory = Process;
//                         //RunObject = Page ApprovedCheques;

//                     }
//                     action("PendingCheques")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Pending Cheques';
//                         // promoted = true;
//                         // PromotedCategory = Process;
//                         // RunObject = Page PendingCheques;

//                     }

//                 }
//                 action(CashReceiptJournals)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Cash Receipt Journals';
//                     Image = Journals;
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "General Journal Batches";
//                     RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
//                                         Recurring = CONST(false));
//                     ToolTip = 'Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.';
//                 }
//                 action(PaymentJournals)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Payment Journals';
//                     Image = Journals;
//                     RunObject = Page "General Journal Batches";
//                     RunPageView = WHERE("Template Type" = CONST(Payments),
//                                         Recurring = CONST(false));
//                     ToolTip = 'Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.';
//                 }

//                 action(Action164)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Bank Accounts';
//                     Image = BankAccount;
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Bank Account List";
//                     ToolTip = 'View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.';
//                 }
//                 action("Payment Recon. Journals")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Payment Recon. Journals';
//                     Image = ApplyEntries;
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Pmt. Reconciliation Journals";
//                     ToolTip = 'Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.';
//                 }
//                 action("Bank Acc. Statements")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Bank Acc. Statements';
//                     Image = BankAccountStatement;
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Bank Account Statement List";
//                     ToolTip = 'View statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.';
//                 }
//                 action("Cash Flow Forecasts")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Cash Flow Forecasts';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Cash Flow Forecast List";
//                     ToolTip = 'Combine various financial data sources to find out when a cash surplus or deficit might happen or whether you should pay down debt, or borrow to meet upcoming expenses.';
//                 }
//                 action("Chart of Cash Flow Accounts")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Chart of Cash Flow Accounts';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Chart of Cash Flow Accounts";
//                     ToolTip = 'View a chart contain a graphical representation of one or more cash flow accounts and one or more cash flow setups for the included general ledger, purchase, sales, services, or fixed assets accounts.';
//                 }
//                 action("Cash Flow Manual Revenues")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Cash Flow Manual Revenues';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Cash Flow Manual Revenues";
//                     ToolTip = 'Record manual revenues, such as rental income, interest from financial assets, or new private capital to be used in cash flow forecasting.';
//                 }
//                 action("Cash Flow Manual Expenses")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Cash Flow Manual Expenses';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Cash Flow Manual Expenses";
//                     ToolTip = 'Record manual expenses, such as salaries, interest on credit, or planned investments to be used in cash flow forecasting.';
//                 }
//                 action(BankAccountReconciliations)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Bank Account Reconciliations';
//                     Image = BankAccountRec;
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Bank Acc. Reconciliation List";
//                     ToolTip = 'Reconcile bank accounts in your system with bank statements received from your bank.';
//                 }
//             }


//             group(BosaManagement)
//             {
//                 Caption = 'BOSA Management';

//                 //.................................START OF MEMBERSHIP MANAGEMENT..................................

//                 group(MembershipManagement)
//                 {
//                     Caption = 'Membership Management';


//                     action(MembersList)
//                     {
//                         ApplicationArea = all;
//                         Caption = 'Member Accounts';
//                         RunObject = Page "Member List";
//                         ToolTip = 'View Member Accounts';
//                         Visible = false;
//                     }
//                     group("Account Opening")
//                     {
//                         Caption = 'Membership Registration';
//                         action(NewAccountOpening)
//                         {
//                             ApplicationArea = All;
//                             Caption = 'New Account Opening';
//                             RunObject = page "Membership Application List";
//                             RunPageView = WHERE(status = CONST(open));
//                             RunPageMode = Edit;
//                         }
//                         action(NewAccountPending)
//                         {
//                             ApplicationArea = All;
//                             Caption = 'Applications Pending Approval';
//                             RunObject = page "Membership Application-Pending";
//                             RunPageView = WHERE(status = CONST(pending));
//                             RunPageMode = View;
//                         }

//                         action(NewApprovedAccounts)
//                         {
//                             ApplicationArea = all;
//                             Caption = 'Applications Pending Creation';
//                             RunObject = Page "Member Applications -Approved";
//                             RunPageMode = View;
//                             RunPageView = WHERE(status = CONST(approved));
//                         }
//                         action("CreatedAccounts")
//                         {
//                             ApplicationArea = all;
//                             Caption = 'Closed Membership Applications';
//                             RunObject = Page "Member Applications -Closed";
//                             RunPageMode = View;
//                             RunPageView = WHERE(status = CONST(closed));
//                         }

//                     }

//                     group("Membership Exit")
//                     {

//                         action("Member Withdrawal List")
//                         {
//                             ApplicationArea = all;
//                             RunObject = page "Membership Exit List";

//                         }

//                         action("Approved Membership Exit")
//                         {
//                             ApplicationArea = all;
//                             RunObject = page "Membership Exit List-Posted";
//                             RunPageView = where(status = const(Approved), posted = const(false));
//                         }

//                         action("Posted Membership Exit")
//                         {
//                             ApplicationArea = all;
//                             RunObject = page "Membership Exit List-Posted";
//                             RunPageView = where(Posted = const(true));
//                         }

//                     }

//                     group("Member Reports")
//                     {

//                         Caption = 'Membership Reports';
//                         action("Sacco Membership Reports")
//                         {
//                             ApplicationArea = all;
//                             RunObject = report "Member Accounts List";
//                             ToolTip = 'Members Register';

//                         }
//                         action("Member Account Balances Report")
//                         {
//                             ApplicationArea = all;

//                             RunObject = report "Member Account  balances";
//                             ToolTip = 'Member Account Balances Report';
//                         }

//                         action("Membership Closure Report")
//                         {
//                             ApplicationArea = all;
//                             Caption = 'Membership Exit Reports';
//                             RunObject = report "Membership Closure Report";

//                         }

//                     }


//                 }

//                 //'''''''''''''''''''''''''''''''''''''''''END OF MEMBERSHIP MANAGEMENT






//                 //................................................START OF CHANGE REQUEST MENU.........................
//                 group(ChangeRequest)
//                 {
//                     Caption = 'Change Request';
//                     action("Change Request")
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Change Request List';
//                         RunObject = Page "Change Request List";
//                         ToolTip = 'Change Member Details';
//                     }

//                     group(ReportsChangereq)
//                     {
//                         caption = 'Change Request Reports ';
//                         action(ChangeReqMobile)
//                         {
//                             ApplicationArea = All;
//                             Caption = 'Change Req(mobile)';
//                             Visible = false;
//                             // Promoted = true;
//                             // PromotedCategory = Process;
//                             //RunObject = report "Change Request Report(Mobile)";
//                         }
//                     }

//                     action(updatedchangereqslist)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Updated Change requests';
//                         RunObject = page "Updated Change Request List";
//                     }

//                 }

//                 action(AccountActivationList)
//                 {
//                     Caption = 'Account Activation';
//                     Image = Action;
//                     RunObject = page "Account Activation List";
//                     visible = false;
//                 }
//                 //...........................START OF TRANSFERS MENU .........................................
//                 group(Transfers)
//                 {
//                     Caption = 'BOSA Transfers';

//                     action(TransfersList)
//                     {
//                         ApplicationArea = basic, suite;
//                         Caption = 'Transfers List';
//                         Image = Customer;
//                         RunObject = page "BOSA Transfer List";
//                         ToolTip = 'Make member receiptings for payments done by member';

//                     }

//                     action(ApprovedTransfers)
//                     {
//                         ApplicationArea = basic, suite;
//                         Caption = 'Approved Transfer List';
//                         Image = Customer;
//                         RunObject = page "BOSA Transfer Posted";
//                         ToolTip = 'BOSA Transfer Posted';
//                         RunPageView = where(Posted = const(false), approved = const(true));

//                     }
//                     action(PostedTransfers)
//                     {
//                         ApplicationArea = basic, suite;
//                         Caption = 'Posted Transfer List';
//                         Image = Customer;
//                         RunObject = page "BOSA Transfer Posted";
//                         ToolTip = 'BOSA Transfer Posted';
//                         RunPageView = where(Posted = const(false), approved = const(true));

//                     }
//                 }
//                 //......................................................................................



//                 //.....................................START OF LOAN MANAGEMENT
//                 group(SaccoLoansManagement)
//                 {
//                     Caption = 'BOSA Loans';
//                     ToolTip = 'Manage BOSA Module';
//                     group("BOSA Loans Management")
//                     {
//                         Caption = 'New BOSA Loans Applications';
//                         ToolTip = 'BOSA Loans'' Management Module';
//                         action("BOSA Loan Application")
//                         {
//                             ApplicationArea = All;
//                             Caption = 'BOSA Loan Application List';
//                             Image = Loaners;
//                             RunObject = Page "Loan List-New Application BOSA";
//                             ToolTip = 'Open BOSA Loan Applications List';
//                             RunPageView = where(Posted = const(false), "Loan Status" = const(Application));
//                         }
//                         action("Pending BOSA Loan Application")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'BOSA Loans Pending Approval';
//                             Image = CreditCard;
//                             RunObject = Page "LoanList-Pending Approval BOSA";

//                             ToolTip = 'Open the list of BOSA Loans Pending Approval';

//                         }
//                         action("Approved Loans")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             Caption = 'BOSA Loans Pending Disbursement.';
//                             RunObject = Page "Loan Application BOSA-Approved";
//                             ToolTip = 'Open the list of Approved Loans Pending Disbursement.';
//                         }
//                     }


//                     group("Loan Batching")
//                     {
                        
//                         action("Loan Batch List")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             RunObject = page "Loans Disbursment Batch List";
                           
//                         }
//                           action("Posted Loan Batch List")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             RunObject = page "Posted Loan Batch - List";
                          
//                         }
//                     }
//                     group("Loans Top Up List")
//                     {
//                         action("LoansTop Up List")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             RunObject = page "Loan Top-Up List";
//                             Caption = 'Loans Top-Up List';
//                         }
//                         action("LoansTopUp Posted")
//                         {
//                             ApplicationArea = Basic, Suite;
//                             RunObject = page "Loan Top-Up List-Posted";
//                             Caption = 'Loans Top-Up Posted';
//                         }
//                     }



//                     group("Loans' Reports")
//                     {
//                         action("Loans Balances Report")
//                         {
//                             ApplicationArea = all;
//                             RunObject = Report "Loan Balances Report";
//                             Caption = 'Member Loans Book Report';
//                             ToolTip = 'Member Loans Book Report';
//                             Visible = true;
//                         }
//                         action("Loan Defaulter Aging")
//                         {
//                             ApplicationArea = all;
//                             Caption = 'Loans Defaulter Aging-SASRA';
//                             RunObject = report "SASRA Loans Classification";
//                             ToolTip = 'Loan Defaulter Aging(Risk Classification)';
//                         }
//                         action("Loan Collection Targets Report")
//                         {
//                             ApplicationArea = all;
//                             RunObject = report "Loan Monthly Expectation";
//                             ToolTip = 'Loan Collection Targets';
//                             Caption = 'Loan Collection Targets';
//                         }

//                         action("Loans Guard Report")
//                         {
//                             ApplicationArea = all;
//                             RunObject = report "Loan Guard Report";
//                             ToolTip = 'Loans Guard Report';
//                         }
//                         action("Loans Register")
//                         {
//                             ApplicationArea = all;
//                             Caption = 'Member Loan Register';
//                             RunObject = Report "Loans Register";
//                             ToolTip = 'Loan Register Report';
//                             Visible = false;
//                         }

//                         action("Loans Arreas Report")
//                         {
//                             ApplicationArea = all;
//                             RunObject = Report "Loan Arrears Report";
//                             ToolTip = 'Loan Arreas Report';
//                             visible = false;
//                         }

//                         action("Loans Guarantor Details Report")
//                         {
//                             ApplicationArea = all;
//                             RunObject = Report "Loans Guarantor Details Report";
//                             ToolTip = 'Loans Securities Report';
//                         }
//                         action("General Recoveries Report")
//                         {
//                             ApplicationArea = all;
//                             RunObject = Report "Recovery From Salaries";
//                             Caption = 'General Recoveries Report';
//                         }
//                     }
//                     action("PostedLoans")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Posted BOSA Loans';
//                         RunObject = Page "Loans Posted List";
//                         ToolTip = 'Open the list of the Loans Posted.';
//                     }
//                     action("LoansRescheduleList")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         RunObject = page "Loans Reschedule  List";
//                         Caption = 'Loans Reschedule List';
//                     }
//                     action("Loan Calculator")
//                     {
//                         RunObject = page "Loans Calculator List";
//                     }
//                 }

//                 //.............................Collateral Management..........................................

//                 group("Collateral Management")
//                 {
//                     visible = false;

//                     action(Collateralreg)
//                     {
//                         Caption = 'Loan Collateral Register';
//                         Image = Register;
//                         RunObject = page "Loan Collateral Register List";
//                     }
//                     action(Collateralmvmt)
//                     {
//                         Caption = 'Loan Collateral Movement';
//                         //RunObject = page "Collateral Movement List";
//                     }

//                     group(CollateralReports)
//                     {
//                         Caption = 'Collateral Movement';
//                         action(ColateralsReport)
//                         {
//                             Caption = 'Collateral Report';
//                             //RunObject = report "Collaterals Report";
//                         }

//                     }
//                     group(ArchiveCollateral)
//                     {
//                         Caption = 'Archive';
//                         action(Effectedcollatmvmt)
//                         {
//                             Caption = 'Effective Collateral Movement';
//                             //RunObject = page "Effected Collateral Movement";
//                         }
//                     }


//                 }

//                 //.........................End of Collateral Management......................................


//                 //...................................Guarantor Management........................................
//                 group("Guarantor Management")
//                 {
//                     Caption = 'Guarantor Management';

//                     action("Guarantor Substitution List")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         RunObject = Page "Guarantorship Sub List";
//                     }
//                     action("Effected Guarantor Substitution")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         RunObject = Page "Loans Guarantee Details";
//                     }
//                     action("Member Loans Guaranteed")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         RunObject = Page "Loans Guarantee Details";
//                     }

//                     action("Members Loan  Guarantors")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         RunObject = Page "Loans Guarantee Details";
//                     }


//                 }

//                 //..................................End of Guarantor Management......................................

//                 //......................................Start of Defaulter Management............................
//                 group("Defaulter's Management")
//                 {
//                     Caption = 'Defaulter Management';

//                     //Visible = false;

//                     group(loanRecovery)
//                     {
//                         Caption = 'Loan Recovery';
//                         action(LoanRecovList)
//                         {
//                             Caption = 'Open Loan Recovery List';
//                             RunObject = page "Loan Recovery List";
//                             RunPageView = WHERE(Status = CONST(open));

//                         }
//                         action(PLoanRecovList)
//                         {
//                             Caption = 'Pending Approval Loan Recovery List';
//                             RunObject = page "Loan Recovery";
//                             RunPageView = WHERE(Status = CONST(pending));
//                             Visible = false;

//                         }
//                         action(ALoanRecovList)
//                         {
//                             Caption = 'Approved Loan Recovery List';
//                             RunObject = page "Loan Recovery";
//                             RunPageView = WHERE(Status = CONST(approved));
//                             Visible = false;

//                         }
//                         action(PostedLoanRecovList)
//                         {
//                             Caption = 'Posted Loan Recovery List';
//                             RunObject = page "Loan Recovery";
//                             RunPageView = WHERE(Status = CONST(closed));
//                             Visible = false;

//                         }
//                     }

//                     group(demandnotices)
//                     {
//                         caption = 'Demand Notices';
//                         action(LoanDemandnoticeslist)
//                         {
//                             caption = 'Loan Demand Notices List';
//                             //RunObject = page "Loan Demand Notices List";
//                         }
//                         group(DemnandTask)
//                         {
//                             Caption = 'Create Demand Notices';
//                             action(CreateDemand)
//                             {
//                                 Caption = 'Create Demand';
//                                 //RunObject = report "Create Demand Notices";
//                                 Image = Report2;
//                             }
//                         }
//                         group(DemandReports)
//                         {
//                             action(Ldemandnotice1)
//                             {
//                                 Caption = 'Loan Defaulter 1st Notice';
//                                 //RunObject = report "Loan Demand Notice";
//                                 Image = Report;

//                             }
//                             action(Ldemandnotice2)
//                             {
//                                 Caption = 'Loan Defaulter 2nd Notice';
//                                 //RunObject = report "Loan Demand Notice";
//                                 Image = Report;
//                             }
//                             action(Ldemandnotice3)
//                             {
//                                 Caption = 'Loan Defaulter 3rd Notice';
//                                 //RunObject = report "Loan Demand Notice";
//                                 Image = Report;
//                             }
//                         }
//                     }



//                 }


//                 //.......................................End of Defaulter Management .................................



//                 //...............................................Start of BOSA Reports.........................
//                 group("BOSA Reports")
//                 {
//                     action("New Members Report")
//                     {
//                         Caption = 'New Members Report';
//                         RunObject = report "New Member Accounts";
//                     }
//                     action("Sacco Loan Disbursements")
//                     {
//                         Caption = 'Loan Disbursements Report';
//                         RunObject = report "Sacco Loan Disbursements";
//                     }
//                     action("Loan Totals Per Category")
//                     {
//                         Caption = 'Loan Totals Per Category';
//                         RunObject = report "Loan Totals Per Employer";
//                     }
//                     action("Loans Portfolio Reports")
//                     {
//                         Caption = 'Loans Portfolio Reports';
//                         RunObject = report "Loans Potfolio Analysis";
//                     }
//                     action("Loans Portfolio Concentration Reports")
//                     {
//                         Caption = 'Loans Portfolio Concentration Reports';
//                         RunObject = report "Loan Portifolio Concentration";
//                     }
//                     action("Loans Underpaid/OverPaid")
//                     {
//                         Caption = 'Loans Underpaid/OverPaid';
//                         RunObject = report "Loans Underpaid";
//                     }
//                 }
//                 //.....................................End Of BOSA


//                 //..............................................................................................

//                 group(BOSAPeriodicActivities)
//                 {
//                     Caption = 'Periodic Activities';

//                     group(CheckOffDistributed)
//                     {
//                         Caption = 'Checkoff Processing-Distributed';
//                         action("Checkoff Processing List")
//                         {
//                             Caption = 'Checkoff Processing List';
//                             Image = Setup;
//                             RunObject = page "Checkoff Processing-D List";
//                         }
//                         action(CheckoffProcessingDistributed)
//                         {
//                             Caption = 'Checkoff Processing-Distributed';
//                             Image = Setup;
//                             RunObject = page "Transfer Schedule";
//                         }
//                     }
//                     group(CheckOffBlocked)
//                     {
//                         Caption = 'Checkoff Processing-Blocked';
//                         action("Checkoff Processing List Blocked")
//                         {
//                             Caption = 'Employer Checkoff Remittance';
//                             Image = Setup;
//                             RunObject = page "Bosa Receipts H List-Checkoff";
//                         }
//                         action("Posted Employer Checkoff Remittance")
//                         {
//                             Caption = 'Posted Employer Checkoff Remittance';
//                             Image = Setup;
//                             RunObject = page "Posted Bosa Rcpt List-Checkof";
//                         }
//                         action("Import Sacco Jnl")
//                         {
//                             Caption = 'Import Sacco Jnl';
//                             Image = Setup;
//                             RunObject = xmlport "Import Sacco Jnl";
//                         }
//                     }
//                     group(CheckOffAdvice)
//                     {
//                         Caption = 'Check-Off Advice';
//                         action("Data Sheet Main")
//                         {
//                             Caption = 'Data Sheet Main';
//                             Image = Setup;
//                             RunObject = page "Data Sheet Main";
//                         }
//                         action("Generate Monthly Advice")
//                         {
//                             Caption = 'Generate Monthly Advice';
//                             Image = Setup;
//                             RunObject = report "Generate Monthly Advice";
//                         }
//                         action("DataSheetMainReport")
//                         {
//                             Caption = 'Data Sheet Main Report';
//                             Image = Report;
//                             RunObject = report "Data Sheet Main";
//                         }
//                         action("DataSheetADJDeposits")
//                         {
//                             Caption = 'Data Sheet ADJ Deposits';
//                             Image = Report;
//                             RunObject = report "Data Sheet ADJ Deposits";
//                         }
//                         action("DataSheetADJLoans")
//                         {
//                             Caption = 'Data Sheet ADJ Loans';
//                             Image = Report;
//                             RunObject = report "Data Sheet ADJ Loan";
//                         }
//                     }
//                     group(MonthlyInterestProcessing)
//                     {
//                         Caption = 'Monthly Interest Processing';
//                         action("Post Monthly Interest")
//                         {
//                             Caption = 'Post Monthly Interest"';
//                             Image = Setup;
//                             RunObject = report "Post Monthly Interest.";
//                         }
//                     }
//                     group(Dividends)
//                     {
//                         Caption = 'Dividends';
//                         group("Flat Rate")
//                         {
//                             Caption = 'Flat Rate';
//                             action("Dividends Processing-Flat Rate")
//                             {
//                                 Caption = 'Dividends Processing-Flat Rate';
//                                 Image = Setup;
//                                 RunObject = report "Dividend Processing-Flat Rate";
//                             }
//                             action("Dividends Processing Flat Rate-List")
//                             {
//                                 Caption = 'Dividends Processing Flat Rate-List';
//                                 Image = Setup;
//                                 RunObject = page "Dividends Processing Flat Rate";
//                             }
//                         }
//                         group(Prorated)
//                         {
//                             Caption = 'Prorated';
//                             action("Dividends Processing-Prorated")
//                             {
//                                 Caption = 'Dividends Processing-Prorated';
//                                 Image = Setup;
//                                 RunObject = report "Dividend Processing-Prorated";
//                             }
//                             action("Dividends Register")
//                             {
//                                 Caption = 'Dividends Register';
//                                 Image = Setup;
//                                 RunObject = report "Dividend Register";
//                             }
//                         }


//                     }
//                 }

//             }

//             group("CEEP Management")
//             {



//                 group("CEEP Member Management")
//                 {
//                     action("CEEP Members List")
//                     {
//                         Image = Group;
//                         RunObject = page "MC Individual Sub-List";
//                     }

//                     group("CEEP membership application")
//                     {
//                         action("CEEP New Member Application")
//                         {
//                             Image = Group;
//                             RunPageView = WHERE(Status = CONST(Open));
//                             RunObject = page "MC Individual Application List";

//                         }
//                         action("CEEP Member Application-Pending Approval")
//                         {
//                             Image = Group;
//                             RunPageView = WHERE(Status = CONST(Pending));
//                             RunObject = page "MC Individual Application List";

//                         }
//                         action("CEEP Member Application-Pending Registration")
//                         {
//                             Image = Group;
//                             RunPageView = WHERE(Status = CONST(Approved));
//                             RunObject = page "MC Individual Application List";

//                         }
//                     }

//                 }



//                 // group("CEEP Group Management")
//                 // {
//                 //     action("CEEP Group List")
//                 //     {
//                 //         Image = Group;
//                 //         RunObject = page "MC Group List";
//                 //     }
//                 //     group("CEEP Group Applications")
//                 //     {

//                 //         action("CEEP Group List Application")
//                 //         {
//                 //             Image = Group;
//                 //             RunPageView = WHERE(Status = CONST(Open));
//                 //             RunObject = page "Member Application List";
//                 //         }
//                 //         action("Group Application-Pending Approval")
//                 //         {
//                 //             Image = Group;
//                 //             RunPageView = WHERE(Status = CONST(Pending));

//                 //             RunObject = page "Member Application List";
//                 //         }
//                 //         action("Group Application-Pending Registration")
//                 //         {
//                 //             Image = Group;
//                 //             RunPageView = WHERE(Status = CONST(Approved));
//                 //             //RunObject = page "MC Individual Application List";
//                 //             RunObject = page "Member Application List";
//                 //         }
//                 //     }

//                 // }


//                 group("CEEP Loans Management")
//                 {
//                     group("CEEP Loans Processing")
//                     {

//                         action("Loans Applications-New")
//                         {
//                             Image = Group;
//                             RunObject = page "Loans List-MICRO";
//                             RunPageView = WHERE("Loan Status" = CONST(Application), source = filter('MICRO'));
//                         }
//                         action("Loans Applications-Pending Approval")
//                         {
//                             Image = Group;
//                             RunObject = page "Loans List-MICRO";
//                             RunPageView = WHERE("Loan Status" = CONST(Appraisal), source = filter('MICRO'));
//                             RunPageMode = view;
//                         }
//                         action("Loans Applications-Pending Disbursement")
//                         {
//                             Image = Group;
//                             RunObject = page "Loans List-MICRO";
//                             RunPageView = WHERE("Loan Status" = CONST(approved), source = filter('MICRO'));

//                         }
//                         action("CEEP Batch Disbursement")
//                         {
//                             Image = Group;
//                             RunObject = page "Loans Disb Batch List(MICRO)";

//                         }

//                     }

//                     group("CEEP Posted Loans")
//                     {
//                         action("CEEP Loans Posted")
//                         {
//                             Image = Group;
//                             RunObject = page "Loans Posted-MICRO";
//                         }
//                         action("CEEP Batches Posted")
//                         {
//                             Image = Group;
//                             RunObject = page "Posted Loan Batch-List(MICRO)";
//                         }
//                     }
//                 }


//                 group("CEEP Transactions")
//                 {
//                     action("CEEP Receipt List")
//                     {
//                         Image = Group;
//                         RunObject = page "Micro_Finance_Transactions Lis";

//                     }
//                     action("CEEP Receipt Posted")
//                     {
//                         Image = Group;
//                         RunObject = page "Micro Finance Trans Posted";

//                     }
//                 }

//                 group("CEEP Reports")
//                 {
//                     action("CEEP Officer Targets")
//                     {
//                         ApplicationArea = all;
//                         RunObject = report "Loan Monthly Expectation";
//                         ToolTip = 'CEEP Officer Targets Report';
//                         Caption = 'CEEP Officer Targets';
//                     }
//                     action("CEEP Officer Collections")
//                     {
//                         ApplicationArea = all;
//                         RunObject = report "CEEP Officer Collections";
//                         ToolTip = 'CEEP Officer Collections Report';
//                     }
//                     action("CEEP Collections Report")
//                     {
//                         ApplicationArea = all;
//                         RunObject = report "CEEP Officer Collection Report";
//                         ToolTip = 'CEEP Collections & Variance Report';
//                         Caption = 'CEEP Collections & Variance Report';
//                     }
//                     action("CEEP Loans Register ")
//                     {
//                         Image = Report;
//                         Caption = 'Loans Register-CEEP';
//                         RunObject = report "Loans Register-CEEP";
//                     }


//                     action("CEEP Members Register ")
//                     {
//                         Image = Report;
//                         Caption = 'Members Register-CEEP';
//                         RunObject = report "Members Register-CEEP";
//                     }
//                     action("CEEP Loan Status Report")
//                     {
//                         Image = Report;
//                         RunObject = report "MICRO report";
//                     }
//                     action("CEEP Savings Report")
//                     {
//                         Image = Report;
//                         RunObject = report "MICRO Savings Report";
//                     }
//                     action("CEEP Interest Report")
//                     {
//                         Image = Report;
//                         RunObject = report "MICRO report Officer";
//                     }
//                 }



//                 group("CEEP Setups")
//                 {
//                     Caption = 'CEEP Change Request';
//                     action("CEEP Change Details")
//                     {
//                         Image = Group;
//                         Caption = 'New CEEP Change Request';
//                         RunObject = page "CEEP Change Request List";
//                         RunPageView = WHERE(status = CONST(open));
//                     }
//                     action("CEEP Change Details-p")
//                     {
//                         Image = Group;
//                         Caption = 'Pending Approval CEEP Change Request';
//                         RunObject = page "CEEP Change Request List";
//                         RunPageView = WHERE(status = CONST(PENDING));
//                     }
//                     action("CEEP Change Details-A")
//                     {
//                         Image = Group;
//                         Caption = 'Pending Change CEEP Request';
//                         RunObject = page "CEEP Change Request List";
//                         RunPageView = WHERE(status = CONST(approved));
//                     }
//                     action("CEEP Change Details-c")
//                     {
//                         Image = Group;
//                         Caption = 'Closed CEEP Change Requests';
//                         RunObject = page "CEEP Change Request List";
//                         RunPageView = WHERE(status = CONST(closed));
//                     }

//                 }


//                 group("CEEP Periodic Activities")
//                 {
//                     Visible = false;
//                     action("Group CEEP Officer Change")
//                     {
//                         Image = Group;
//                         RunObject = page "MC Group List-Editable";
//                     }

//                     action("Transfer CEEP Member to Group")
//                     {
//                         Image = Group;
//                         RunObject = page "MC Group List-Editable";
//                     }

//                     action("Bulk CEEP Officer Change")
//                     {
//                         Image = Group;
//                         RunObject = page "MC Group List-Editable";
//                     }

//                 }

//             }
//             //.......................... END OF CEEP MANAGEMENT MAIN MENU ........................................


//             //.......................... START OF TELLER ACTIVITIES MAIN MENU ......................................
//             group(TellerActivites)
//             {
//                 Caption = 'Teller Activities';

//                 group("BankingServicesTeller")
//                 {
//                     Caption = 'Banking Services';

//                     ToolTip = 'Banking Services.';
//                     action("Cahier Transactions")
//                     {
//                         Caption = 'New Teller Transactions';
//                         Image = PostedReceipt;
//                         RunObject = page "Cashier Transactions - List";
//                         ToolTip = 'Open New Cashier Transactions';

//                     }
//                     action("Cahier Posted Transactions")
//                     {
//                         Caption = 'Posted Teller Transactions';
//                         Image = PostedReceipt;
//                         RunObject = page "Cashier Transactions - Posted";
//                         ToolTip = 'Open New Casjier Transactions';

//                     }
//                 }


//                 group(TellerReceipts)
//                 {
//                     Caption = 'Member Receipting';

//                     ToolTip = 'Member Receipting Process.';

//                     action("TellersReceipts")
//                     {
//                         Caption = 'Member Receipts';
//                         Image = Receipt;
//                         RunObject = page "Receipts list-BOSA";
//                         ToolTip = 'New Member Receipts for payments done.';

//                     }
//                     action("Posted Teller BOSA Receipts")
//                     {
//                         Caption = 'Posted Member Receipts';
//                         Image = PostedReceipt;
//                         RunObject = page "Posted BOSA Receipts List";
//                         ToolTip = 'Member Receipts for payments done.';

//                     }
//                 }

//                 group("CEEP Transactions List")
//                 {

//                     Caption = 'CEEP Receipting';

//                     ToolTip = 'CEEP Transaction.';
//                     action("CEEP TransactionsList new")
//                     {
//                         Caption = 'CEEP Receipts';
//                         Image = PostedReceipt;
//                         RunObject = page "Micro_Finance_Transactions Lis";
//                         ToolTip = 'Open New ceep Transactions';

//                     }
//                     action("CEEP TransactionsList")
//                     {
//                         Caption = 'Posted CEEP Receiptss';
//                         Image = PostedReceipt;
//                         RunObject = page "Micro Finance Trans Posted";
//                         ToolTip = 'Open posted ceep Transactions';

//                     }
//                 }

//                 Group("Cash Issue/Return")
//                 {
//                     action("Issue Cash")
//                     {
//                         Caption = 'Treasury Cash Issue';
//                         Image = CashFlow;
//                         RunObject = page "Teller & Treasury Trans List";
//                     }
//                     action("Treasury receive")
//                     {
//                         Caption = 'Treasury Cash Receive';
//                         Image = CashFlow;
//                         RunObject = page treasuryreceivecash;
//                     }
//                     action("Teller Receive Cash")
//                     {
//                         Caption = 'Teller Cash Receive';
//                         Image = CashFlow;
//                         RunObject = page Receivetellercashlist;
//                     }

//                     action("Teller Return Cash")
//                     {
//                         Caption = 'Teller Cash Return';
//                         Image = CashFlow;
//                         RunObject = page ReturnTellerCashList;
//                     }

//                 }
//                 action("Cashier's Report")
//                 {
//                     Caption = 'Cashiers Report';
//                     Image = CashFlow;
//                     RunObject = report "Cashier Report";
//                 }





//             }
//             //.................... END OF TELLER ACTIVITIES MAIN MENU .........................................




//             //....................... START OF ALTERNATIVE CHANNELS MAIN MENU ...................................

//             group(CloudPesa)
//             {
//                 Caption = 'Alternative Channels';
//                 group(CloudPesaActivities)
//                 {
//                     Caption = 'Mobile Banking';

//                     ToolTip = 'Mobile Banking .';

//                     action("CloudPesaApplications")
//                     {
//                         Caption = 'M-Banking Applications';
//                         Image = Calls;
//                         RunObject = page "SurePESA Appplications List";
//                         ToolTip = 'Membership Applicaton for cloudpesa.';
//                     }
//                     action("RegisteredCloudPesaMembers")
//                     {
//                         Caption = 'M-Banking Registered Members';
//                         Image = PostedReceipt;
//                         RunObject = page "SurePESA Applications";
//                         ToolTip = 'Member Receipts for payments done.';

//                     }
//                     action("M-Banking PIN Reset")
//                     {
//                         Caption = 'M-Banking PIN Reset';
//                         Image = PostedReceipt;
//                         RunObject = page "CloudPESA PIN RESET";
//                         ToolTip = 'Member Receipts for payments done.';

//                     }

//                     action("SurePesaTransactions")
//                     {
//                         Caption = 'M-Banking Transactions';
//                         Image = PostedReceipt;
//                         RunObject = page "SUREPESA Transactions";
//                         ToolTip = 'Surepesa Transactions.';

//                     }
//                     action("Mobile Loans")
//                     {
//                         Caption = 'Mobile Loans';
//                         Image = PostedReceipt;
//                         RunObject = page "Mobile Loans";
//                         ToolTip = 'View Mobile Loans List.';
//                     }

//                 }

//                 group("Agency Banking")
//                 {
//                     Caption = 'Agency Banking';

//                     ToolTip = 'Agency Banking.';

//                     action("Agency Banking Application")
//                     {
//                         Caption = 'Agency Banking Application';
//                         Image = AgreementQuote;
//                         RunObject = page "Agency Members";

//                     }

//                     action("Agency Member")
//                     {
//                         Caption = 'Agency Banking Members';
//                         Image = AgreementQuote;
//                         RunObject = page "Agency Members";

//                     }

//                     action("Agency Transactions")
//                     {
//                         Caption = 'Agency Transactions';
//                         Image = AgreementQuote;
//                         RunObject = page "Agent Transactions";
//                         ToolTip = 'Agency Banking Transactions.';

//                     }

//                     group(AgentsManagements)
//                     {
//                         Caption = 'Agents Managements';

//                         action(AgentsApplication)
//                         {
//                             Caption = 'Agents Application';
//                             Image = AgreementQuote;
//                             RunObject = page "Agent applications List";

//                         }


//                         action(ApprovedAgents)
//                         {
//                             Caption = 'Approved Agents';
//                             Image = AgreementQuote;
//                             RunObject = page "Approved - Agent applications";

//                         }

//                     }

//                 }

//                 //.............................................................................................

//                 group("Paybill Management")
//                 {
//                     Caption = 'Paybill Deposits';

//                     ToolTip = 'Manage Paybill Deposits.';
//                     action("All Paybill Deposits")
//                     {
//                         Caption = 'All Paybill Transactions';
//                         Image = PostedReceipt;
//                         RunObject = page "PAYBILL Transactions";
//                         ToolTip = 'View Paybill Deposits.';

//                     }

//                     action("Pending Paybill Deposits")
//                     {
//                         Caption = 'Pending Paybill Transactions';
//                         Image = PostedReceipt;
//                         RunObject = page pendingpaybill;
//                         ToolTip = 'View Paybill Deposits.';
//                         visible = false;
//                     }

//                     action("Failed Paybill Deposits")
//                     {
//                         Caption = 'Failed Paybill Transactions';
//                         Image = PostedReceipt;
//                         RunObject = page FailedPaybill;
//                         ToolTip = 'View Failed Paybill Deposits.';
//                         visible = false;

//                     }

//                     action("Paybill Import")
//                     {
//                         Caption = 'Import Paybill';
//                         Image = PostedReceipt;
//                         RunObject = page "CloudPESA Paybill Imports";
//                         ToolTip = 'Import Paybill Deposits from M-PESA Portal.';
//                         visible = false;

//                     }


//                 }


//                 //..............................................................................................
//                 group("ATM Banking")
//                 {
//                     Caption = 'ATM Banking';
//                     action(ATMApplication)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'ATM Card Application';
//                         //RunObject = page "ATM Cards Application - New";

//                     }
//                     action(ATMProcessed)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Processed ATM Cards';
//                         //RunObject = page "ATM Cards Appl. - Processed";

//                     }
//                     action(ATMTransactionDetails)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'ATM Transaction Details';
//                         //RunObject = page "Atm Transaction Details";

//                     }
//                     action(ATMRequestBatch)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'ATM Card Request Batch List';
//                         //RunObject = page "ATM Card Request Batch List";

//                     }
//                     action(ATMBatchReceiptsBatch)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'ATM Card Receipt Batch List';
//                         //RunObject = page "ATM Card Receipt Batch List";

//                     }
//                     action("ATM Logs Entries")
//                     {
//                         Caption = 'ATM Log Entries';
//                         Image = Receipt;
//                         RunObject = page "ATM Log Entries";

//                     }

//                     action("ATM Transactionss")
//                     {
//                         Caption = 'ATM Transactions';
//                         Image = Receipt;
//                         RunObject = page "ATM Transactions";

//                     }
//                     action("ABC ATM Transactionss")
//                     {
//                         Caption = 'ABC ATM Transactions';
//                         Image = Receipt;
//                         RunObject = page "ABC ATM Transactions";

//                     }


//                 }
//                 group("SMS Messages")
//                 {
//                     Caption = 'SMS Messages';

//                     ToolTip = 'SMS Messages.';
//                     action("SentSMS")
//                     {
//                         Caption = 'Sent SMS';
//                         Image = PostedReceipt;
//                         RunObject = page "SMS Messages";
//                         ToolTip = 'Sent SMS.';
//                     }

//                     action("Send BULK SMS")
//                     {
//                         Caption = 'Send BULK SMS';
//                         Image = PostedReceipt;
//                         RunObject = page "Bulk SMS Header List";
//                         ToolTip = 'Sent SMS.';

//                     }


//                 }
//                 group("Alternative Channels Setups")

//                 {
//                     Caption = 'Alternative Channels Setup';

//                     ToolTip = 'SMS Messages.';
//                     action("M-Banking Charges Setup")
//                     {
//                         Caption = 'M-Banking Charges Setup';
//                         Image = PostedReceipt;
//                         RunObject = page "SMS Messages";
//                         ToolTip = 'Sent SMS.';
//                     }

//                     action("Agency Banking Charges")
//                     {
//                         Caption = 'Agency Banking Charges Setup';
//                         Image = PostedReceipt;
//                         RunObject = page "Bulk SMS Header List";
//                         ToolTip = 'Sent SMS.';

//                     }
//                     action("ATM  Charges")
//                     {
//                         Caption = 'ATM Charges Setups';
//                         Image = PostedReceipt;
//                         RunObject = page "Bulk SMS Header List";
//                         ToolTip = 'Sent SMS.';

//                     }
//                 }

//             }

//             //.............................. END OF ALTERNATIVE CHANNELS MAIN MENU ..................................



//             group("Payment Management")
//             {
//                 Caption = 'Payment Process';
//                 Image = Payables;
//                 ToolTip = 'Payment Process.';
//                 Visible = false;
//                 action("Check Payment")
//                 {

//                     Caption = 'Check Payment ';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     //RunObject = page "Payment Voucher List";
//                     ToolTip = 'Payment Voucher List.';
//                 }

//                 action("Cash Payment")
//                 {

//                     Caption = 'New Petty Cash Payments List ';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     //RunObject = page "New Petty Cash Payments List";
//                     ToolTip = 'New Petty Cash Payments List.';
//                 }
//                 action("Posted Cash Payment")
//                 {

//                     Caption = 'Posted Cash Payment';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     //RunObject = page "Posted Petty Cash Payments";
//                     ToolTip = 'Posted Cash Payment';
//                 }
//                 action("Posted Cheque Payment")
//                 {

//                     Caption = 'Posted Cheque Payment';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     //RunObject = page "Posted Cheque Payment Vouchers";
//                     ToolTip = 'Posted Cheque Payment';
//                 }

//                 action("Funds Transfer List")
//                 {
//                     Caption = 'Funds Transfer List';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     // RunObject = page "Funds Transfer List";
//                     ToolTip = 'Funds Transfer List';
//                 }

//                 action("Posted Funds Transfer List")
//                 {
//                     Caption = 'Posted Funds Transfer List';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     //RunObject = page "Posred Funds Transfer List";
//                     ToolTip = 'Posted Funds Transfer List';
//                 }

//                 action("Receipt Header List")
//                 {
//                     Caption = 'Receipt Header List';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     //RunObject = page "Receipt Header List";
//                     ToolTip = 'Receipt Header List';
//                 }

//                 action("Posted Receipt Header List ")
//                 {
//                     Caption = 'Posted Receipt Header List ';
//                     ApplicationArea = Basic, Suite;
//                     Image = PostedOrder;
//                     //RunObject = page "Posted Receipt Header List";
//                     ToolTip = 'Posted Receipt Header List ';
//                 }

//             }
//             group("Payments Setup")
//             {
//                 Caption = 'Payment Setup';
//                 Image = Setup;
//                 ToolTip = 'Payment Setup.';
//                 Visible = false;
//                 action("Funds Genral Setup")
//                 {

//                     Caption = 'Funds General Setup. ';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     //RunObject = page "Funds General Setup";
//                     ToolTip = 'Funds General Setup.';
//                 }

//                 action("Budgetary Control Setup")
//                 {

//                     Caption = 'Budgetary Control Setup ';
//                     ApplicationArea = Basic, Suite;
//                     Image = Check;
//                     // RunObject = page "Budgetary Control Setup";
//                     ToolTip = 'Budgetary Control Setup';
//                 }
//                 // action("Funds User Setup")
//                 // {

//                 //     Caption = 'Funds User Setup ';
//                 //     ApplicationArea = Basic, Suite;
//                 //     Image = Check;
//                 //     //RunObject = page "Funds User Setup";
//                 //     ToolTip = 'Funds User Setup';
//                 // }
//                 action("Receipt and Payment Types List")
//                 {

//                     Caption = 'Receipt and Payment Types List';
//                     ApplicationArea = Basic, Suite;
//                     Image = Setup;
//                     //RunObject = page "Receipt and Payment Types List";
//                     ToolTip = 'Receipt and Payment Types List';
//                 }
//             }

//             group("Banking Services")
//             {
//                 Visible = false;
//                 action("Cashier Transactions")
//                 {
//                     Caption = 'cashier transactions';
//                     ApplicationArea = basic, suite;
//                     Image = Payment;
//                     //RunObject = page "Cashier Transactions - List";
//                     ToolTip = 'cashier transaction list';
//                 }
//                 action("banking Setup")
//                 {
//                     Caption = 'Transaction Type - List';
//                     ApplicationArea = basic, suite;
//                     Image = Setup;
//                     //RunObject = page "Transaction Type - List";
//                     ToolTip = 'Transaction Type - List';
//                 }
//             }


//             //......................... START OF CRM Main MENU ...............................................
//             group(SaccoCRM)
//             {
//                 Caption = 'CRM';
//                 Visible = true;

//                 action("CRM Member List")
//                 {
//                     Caption = 'CRM Member List';
//                     ApplicationArea = basic, suite;
//                     Image = ProdBOMMatrixPerVersion;
//                     RunObject = page "CRM Member List";

//                 }
//                 group("Case Management")
//                 {
//                     action("Case Registration")
//                     {
//                         Caption = 'Lead Management';
//                         ApplicationArea = basic, suite;
//                         Image = Capacity;
//                         RunObject = page "Lead list";
//                         RunPageView = WHERE(status = CONST(New));
//                         ToolTip = 'Create a New Case enquiry';

//                     }
//                     action("Assigned Cases")
//                     {
//                         Caption = 'Assigned Cases';
//                         ApplicationArea = basic, suite;
//                         Image = Open;
//                         RunObject = page "Lead list Escalated";
//                         RunPageView = WHERE(status = CONST(Escalted));
//                         ToolTip = 'Open List Of Cases open & Assigned To Me';
//                     }
//                     action("Resolved Case Enquiries")
//                     {
//                         Caption = 'Resolved Cases Enquiries';
//                         ApplicationArea = basic, suite;
//                         Image = Capacity;
//                         RunObject = page "Lead list Closed";
//                         RunPageView = WHERE(status = CONST(Resolved));
//                         ToolTip = 'Resolved Cases Enquiries';

//                     }
//                     // action("Unreolved Case Enquiries")
//                     // {
//                     //     Caption = 'Unresolved Case Enquiries';
//                     //     ApplicationArea = basic, suite;
//                     //     Image = Capacity;
//                     //     RunObject = page "Lead list Closed";
//                     //     RunPageView = WHERE("Lead Status" = CONST(open));
//                     //     ToolTip = 'Unresolved Cases Enquiries';
//                     // }
//                     group("CRM Reports")
//                     {
//                         action("Resolved Cases")
//                         {
//                             Caption = 'Resolved Cases';
//                             ApplicationArea = basic, suite;
//                             Image = Report;
//                             RunObject = report "CRM Resolved Cases Report";
//                             ToolTip = 'Resolved Cases';
//                         }
//                         action("UnResolved Cases")
//                         {
//                             Caption = 'UnResolved Cases';
//                             ApplicationArea = basic, suite;
//                             Image = Report;
//                             RunObject = report "CRM UnResolved Cases Report";
//                             ToolTip = 'UnResolved Cases';
//                         }
//                     }

//                 }
//                 group("CRM Gen Setup")
//                 {
//                     action("CRM General setup")
//                     {
//                         Caption = 'CRM General Setup';
//                         ApplicationArea = basic, suite;
//                         Image = Capacity;
//                         RunObject = page "CRM General SetUp";
//                         ToolTip = 'CRM Setup';

//                     }
//                     action("CRM CaseS types")
//                     {
//                         Caption = 'CRM Case types';
//                         ApplicationArea = basic, suite;
//                         Image = Capacity;
//                         RunObject = page "CRM Case Types";
//                         ToolTip = 'CRM Case Types';
//                         Visible = false;

//                     }
//                 }

//             }
//             //........................... End of CRM MAIN MENU ...............................................
//             group(Action16)
//             {
//                 Caption = 'Fixed Assets';
//                 Image = FixedAssets;
//                 Visible = false;
//                 ToolTip = 'Manage depreciation and insurance of your fixed assets.';
//                 action(Action17)
//                 {
//                     ApplicationArea = FixedAssets;
//                     Caption = 'Fixed Assets';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Fixed Asset List";
//                     ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.';
//                 }
//                 action("Fixed Assets G/L Journals")
//                 {
//                     ApplicationArea = FixedAssets;
//                     Caption = 'Fixed Assets G/L Journals';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "General Journal Batches";
//                     RunPageView = WHERE("Template Type" = CONST(Assets),
//                                         Recurring = CONST(false));
//                     ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation, in integration with the general ledger. The FA G/L Journal is a general journal, which is integrated into the general ledger.';
//                 }
//                 action("Fixed Assets Journals")
//                 {
//                     ApplicationArea = FixedAssets;
//                     Caption = 'Fixed Assets Journals';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "FA Journal Batches";
//                     RunPageView = WHERE(Recurring = CONST(false));
//                     ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.';
//                 }
//                 action("Fixed Assets Reclass. Journals")
//                 {
//                     ApplicationArea = FixedAssets;
//                     Caption = 'Fixed Assets Reclass. Journals';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "FA Reclass. Journal Batches";
//                     ToolTip = 'Transfer, split, or combine fixed assets by preparing reclassification entries to be posted in the fixed asset journal.';
//                 }
//                 action(Insurance)
//                 {
//                     ApplicationArea = FixedAssets;
//                     Caption = 'Insurance';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Insurance List";
//                     ToolTip = 'Manage insurance policies for fixed assets and monitor insurance coverage.';
//                 }
//                 action("Insurance Journals")
//                 {
//                     ApplicationArea = FixedAssets;
//                     Caption = 'Insurance Journals';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "Insurance Journal Batches";
//                     ToolTip = 'Post entries to the insurance coverage ledger.';
//                 }
//                 action("Recurring Fixed Asset Journals")
//                 {
//                     ApplicationArea = FixedAssets;
//                     Caption = 'Recurring Fixed Asset Journals';
//                     // Promoted = true;
//                     // PromotedCategory = Process;
//                     RunObject = Page "FA Journal Batches";
//                     RunPageView = WHERE(Recurring = CONST(true));
//                     ToolTip = 'Post recurring fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.';
//                 }
//             }
//             // group("Human Resources")

//             // {
//             //     Visible = true;
//             //     group("Employee Management")
//             //     {
//             //         action("EmployeesList")
//             //         {
//             //             Caption = 'Employees List';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "Employees List";
//             //         }
//             //         group(HREmployeeReports)
//             //         {
//             //             Caption = 'Reports';
//             //             action("EmployeeListReport")
//             //             {
//             //                 Caption = 'Employees List Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 // RunObject = page ;
//             //             }

//             //             action("EmployeePIF")
//             //             {
//             //                 Caption = 'Employees PIF Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 // RunObject = page ;
//             //             }

//             //         }

//             //     }


//             //     group("Leave Management")
//             //     {
//             //         action("Leave Application")
//             //         {
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Leave Applications List";
//             //         }

//             //         action("Leave Reimbursement")
//             //         {
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Leave Reimbursment List";
//             //         }

//             //         action("Leave Planner")
//             //         {
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "Hr Leave Planner List";
//             //         }

//             //         action("Leave Journal")
//             //         {
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Leave Journal Lines";
//             //         }

//             //         action("Posted Leave Application")
//             //         {
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Leave Applications L-Posted";
//             //         }



//             //         group(LeaveReports)
//             //         {
//             //             caption = 'Leave Reports';

//             //             action("LeaveApplicationReports")
//             //             {
//             //                 Caption = 'Leave Application Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 // RunObject = page "HR Leave Applications List";

//             //             }

//             //             action("PostedLeaveApplication")
//             //             {
//             //                 Caption = 'Posted Leave Applications';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 // RunObject = page "HR Leave Applications List";

//             //             }

//             //         }

//             //     }

//             //     group("EmployeeRecruitment")

//             //     {
//             //         Caption = 'Employees Recruitment';
//             //         Visible = false;
//             //         action(EmployeeRequisitionsList)
//             //         {
//             //             Caption = 'Employee Requisition';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Employee Requisitions List";

//             //         }

//             //         action("JobApplicationList")
//             //         {
//             //             Caption = 'Job Application List';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Job Applications List";
//             //         }

//             //         action("JobShortlisting")
//             //         {
//             //             Caption = 'Job Shortlisting';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Shortlisting List";
//             //         }

//             //         action("QualifiedJobApplicants")
//             //         {
//             //             Caption = 'Qualified Job Applicants';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Job Applicants Qualified";
//             //         }

//             //         action("UnQualifiedJobApplicants")
//             //         {
//             //             Caption = 'UnQualified Job Applicants';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Applicants UnQualified List";
//             //         }

//             //         action("ApplicantToEmployee")
//             //         {
//             //             Caption = 'New Employees Registration';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;

//             //         }

//             //         group(EmployeeRecruitmentReports)
//             //         {
//             //             Caption = 'Recruitment Reports';
//             //             Visible = false;


//             //             action("EmployeeRequisitionReport")
//             //             {
//             //                 Caption = 'Employee Requisition Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 // RunObject = page "HR Applicants UnQualified List";
//             //             }

//             //             action("JobApplicationReport")
//             //             {
//             //                 Caption = 'Job Application Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //             }

//             //             action("ShortlistedApplicantsReport")
//             //             {
//             //                 Caption = 'Shortlisted Applicants Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;

//             //             }
//             //         }


//             //     }

//             //     // group("HRJobManagement")
//             //     // {

//             //     //     Caption = 'Job Management';
//             //     //     Visible = false;
//             //     //     action("JobList")
//             //     //     {
//             //     //         Caption = 'Job Lists';
//             //     //         ApplicationArea = basic, suite;
//             //     //         Image = Employee;
//             //     //         RunObject = page "Job List";
//             //     //     }
//             //     //     action("JobQualifications")
//             //     //     {
//             //     //         Caption = 'Job Qualifications';
//             //     //         ApplicationArea = basic, suite;
//             //     //         Image = Employee;
//             //     //         RunObject = page "HR Job Qualifications";
//             //     //     }

//             //     //     group(JobManagementReports)
//             //     //     {
//             //     //         Caption = 'Job Management Reports';
//             //     //         action("HR Jobs")
//             //     //         {
//             //     //             Caption = 'HR Jobs';
//             //     //             ApplicationArea = basic, suite;
//             //     //             Image = Employee;
//             //     //             // RunObject = page "HR Job Qualifications";
//             //     //         }
//             //     //         action("JobOccupantsReports")
//             //     //         {
//             //     //             Caption = 'Job Occupants Reports';
//             //     //             ApplicationArea = basic, suite;
//             //     //             Image = Employee;
//             //     //             // RunObject = page "HR Job Qualifications";
//             //     //         }
//             //     //         action("VacantJobsReport")
//             //     //         {
//             //     //             Caption = 'Vacant Jobs Report';
//             //     //             ApplicationArea = basic, suite;
//             //     //             Image = Employee;
//             //     //             // RunObject = page "HR Job Qualifications";
//             //     //         }
//             //     //         action("OccupiedJobsReport")
//             //     //         {
//             //     //             Caption = 'Occupied Jobs Report';
//             //     //             ApplicationArea = basic, suite;
//             //     //             Image = Employee;
//             //     //             RunObject = page "HR Job Qualifications";
//             //     //         }
//             //     //         action("JobReponsibilities")
//             //     //         {
//             //     //             Caption = 'Job Reponsibilities';
//             //     //             ApplicationArea = basic, suite;
//             //     //             Image = Employee;
//             //     //             // RunObject = page "HR Job Qualifications";
//             //     //         }

//             //     //         action("JobRequirements")
//             //     //         {
//             //     //             Caption = 'Job Requirements';
//             //     //             ApplicationArea = basic, suite;
//             //     //             Image = Employee;
//             //     //             // RunObject = page "HR Job Qualifications";
//             //     //         }

//             //     //         action("HRCost")
//             //     //         {
//             //     //             Caption = 'Human Resource Costs';
//             //     //             ApplicationArea = basic, suite;
//             //     //             Image = Employee;
//             //     //             // RunObject = page "HR Job Qualifications";
//             //     //         }

//             //     //     }

//             //     // }

//             //     group("PerformanceManagement")
//             //     {
//             //         Caption = 'Performance Management';
//             //         action("AppraisalsGoalsAppraisee")
//             //         {
//             //             Caption = 'Appraisals Goals - Appraisee';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             // RunObject = page "HR Job Qualifications";
//             //         }
//             //         action("AppraisalsGoalsSupervisor")
//             //         {
//             //             Caption = 'Appraisals Goals - Supervisor';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             // RunObject = page "HR Job Qualifications";
//             //         }

//             //         action("AppraisalsGoalsEvaluation")
//             //         {
//             //             Caption = 'Appraisals Goals Evaluations';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             // RunObject = page "HR Job Qualifications";
//             //         }

//             //         action("PerformanceDiscussions")
//             //         {
//             //             Caption = 'Performance Disscussion';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             // RunObject = page "HR Job Qualifications";
//             //         }

//             //         action("RatingScaleStructure")
//             //         {
//             //             Caption = 'Rating Scales Structure';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             // RunObject = page "HR Job Qualifications";
//             //         }

//             //         action("TrainingandCompetenciesList")
//             //         {
//             //             Caption = 'Training & Competencies List';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             // RunObject = page "HR Job Qualifications";
//             //         }

//             //         group(PerformanceManagementReport)

//             //         {
//             //             Caption = 'Performance Report';
//             //             action("TargetConfirmationReport")
//             //             {
//             //                 Caption = 'Target Confirmation Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 // RunObject = page "HR Job Qualifications";
//             //             }

//             //         }

//             //     }

//             //     group("DisciplinaryManagement")
//             //     {
//             //         Caption = 'Disciplinary Management';
//             //         Visible = false;
//             //         action(DisciplinaryCaseList)
//             //         {
//             //             Caption = 'Disciplinary Case List';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             // RunObject = page "HR Job Qualifications";
//             //         }
//             //         action("EmployeeGrievances")
//             //         {
//             //             Caption = 'Employee Grievances';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             // RunObject = page "HR Job Qualifications";
//             //         }
//             //         action("DisplinaryAction")
//             //         {
//             //             Caption = 'Displinary Action';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             //  RunObject = page "HR Job Qualifications";
//             //         }

//             //     }

//             //     group("TrainingManagement")
//             //     {

//             //         Caption = 'Training Management';
//             //         Visible = false;
//             //         action("TrainingNeeds")
//             //         {
//             //             Caption = 'Training Needs';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Training Needs";
//             //         }
//             //         action("TrainingGroups")
//             //         {
//             //             Caption = 'Training Groups';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Training Group";
//             //         }

//             //         action("TrainingApplicationList")
//             //         {
//             //             Caption = 'Training Application List';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "HR Training Application List";
//             //         }

//             //         action("TrainingProjectionList")
//             //         {
//             //             Caption = 'Training Projection List';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             RunObject = page "Hr Training Projection List";
//             //         }

//             //         action("TrainingCalenderList")
//             //         {
//             //             Caption = 'Training Calender List';
//             //             ApplicationArea = basic, suite;
//             //             Image = Employee;
//             //             //RunObject = page "Hr Training Projection List";
//             //         }

//             //         group(TrainingReport)
//             //         {
//             //             Caption = 'Training Reports';
//             //             action("TrainingNeedsReport")
//             //             {
//             //                 Caption = 'Training Needs Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 //RunObject = page "Hr Training Projection List";
//             //             }
//             //             action("TrainingProjectionReport")
//             //             {
//             //                 Caption = 'Training Projection Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 //RunObject = page "Hr Training Projection List";
//             //             }
//             //             action("TrainingCalenderReport")
//             //             {
//             //                 Caption = 'Training Calender Report';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 //RunObject = page "Hr Training Projection List";
//             //             }
//             //             action("SkillsInventoryForm")
//             //             {
//             //                 Caption = 'Skills Inventory Form';
//             //                 ApplicationArea = basic, suite;
//             //                 Image = Employee;
//             //                 //RunObject = page "Hr Training Projection List";
//             //             }

//             //         }

//             //     }


//             //     group("ExitInterviews")
//             //     {
//             //         Caption = 'Exit Interviews';
//             //         Visible = false;
//             //         action("DepartmentClearanceList")
//             //         {
//             //             Caption = 'Department Clearance List';
//             //             ApplicationArea = basic, suite;
//             //             //RunObject = page "HR General Setup";
//             //         }

//             //         action("ExitInterviewList")
//             //         {
//             //             Caption = 'Exit Interview List';
//             //             ApplicationArea = basic, suite;
//             //             //RunObject = page "HR General Setup";
//             //         }

//             //     }


//             // }

//             //             Group(SaccoPayroll)
//             //             {
//             //                 Caption = 'Payroll Management';
//             //                 group(payrollEmployees)
//             //                 {
//             //                     Caption = 'Payroll Employee';
//             //                     action(payrollemp)
//             //                     {
//             //                         Caption = 'Payroll Employee list';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Employee;
//             //                         RunObject = page "Payroll Employee List";
//             //                         tooltip = 'Open Payroll Employees list';
//             //                     }
//             //                     action(HREmployeeList)
//             //                     {
//             //                         Caption = 'HR Employee List';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Employee;
//             //                         RunObject = page "HR Employee List";
//             //                         tooltip = 'HR  Employees list';
//             //                     }
//             //                 }
//             //                 group(PayrollReports)
//             //                 {
//             //                     Caption = 'Payroll Reports';
//             //                     action(PayrollSummary)
//             //                     {
//             //                         Caption = 'Payroll Summary';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "Payroll Summary";

//             //                     }
//             //                     action(CompanyPayrollSummary)
//             //                     {
//             //                         Caption = 'Company Payroll Summary';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "Company Payroll Summary";

//             //                     }
//             //                     action(AllDeductionsReport)
//             //                     {
//             //                         Caption = 'All Deductions Summary';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "All Deductions Summary";

//             //                     }
//             //                     action(AllEarningsReport)
//             //                     {
//             //                         Caption = 'All Earnings Summary';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "All Earnings Summary";

//             //                     }
//             //                     action(DeductionsReport)
//             //                     {
//             //                         Caption = 'Deductions Summary';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "Deductions Summary";

//             //                     }
//             //                     action(EarningsReport)
//             //                     {
//             //                         Caption = 'Earnings Summary';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "Earnings Summary";

//             //                     }
//             //                     action(PAYESchedule)
//             //                     {
//             //                         Caption = 'PAYE Schedule';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "PAYE Schedule";

//             //                     }
//             //                     action(NHIFSchedule)
//             //                     {
//             //                         Caption = 'NHIF Schedule';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "NHIF Schedule";

//             //                     }
//             //                     action(NSSFSchedule)
//             //                     {
//             //                         Caption = 'NSSF Schedule';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "NSSF Schedule";

//             //                     }
//             //                     action(HousingLevySchedule)
//             //                     {
//             //                         Caption = 'Housing Levy Schedule';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "Housing Levy Schedule";

//             //                     }
//             //                     action(GratuitySchedule)
//             //                     {
//             //                         Caption = 'Gratuity Schedule';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "Gratuity Report";

//             //                     }
//             //                     action(ProvidentSchedule)
//             //                     {
//             //                         Caption = 'Provident Schedule';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "Provident Schedule";

//             //                     }
//             //                     action(BIFUContribution)
//             //                     {
//             //                         Caption = 'BIFU Contribution';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "BIFU Contribution";

//             //                     }
//             //                     action(P9Report)
//             //                     {
//             //                         Caption = 'P9 Report';
//             //                         ApplicationArea = basic, suite;
//             //                         Image = Report;
//             //                         RunObject = report "P9 Report";
//             //                     }
//             //                 }

//             //                 group(payrollperiodicactivities)
//             //                 {
//             //                     Caption = 'Payroll Periodic Activities';
//             //                     action(payrollperiods)
//             //                     {
//             //                         Caption = 'Payroll Periods';
//             //                         ApplicationArea = basic, suite;
//             //                         RunObject = page "Payroll Calender";
//             //                     }
//             //                     action(Transfertojournal)
//             //                     {
//             //                         Caption = 'Payroll journal transfer';
//             //                         ApplicationArea = basic, suite;
//             //                         RunObject = report "Payroll Journal Transfer";
//             //                     }
//             //                     action(Payrolnettransfer)
//             //                     {
//             //                         Caption = 'Payroll Net Transfer To FOSA';
//             //                         ApplicationArea = basic, suite;
//             //                         RunObject = report "NET Salary Transfer To FOSA";
//             //                     }

//             //                     action(SendPaySlip)
//             //                     {
//             //                         Caption = 'Send Payslip via Mail';
//             //                         ApplicationArea = basic, suite;
//             //                         // RunObject = report "Send P9 Report Via Mail";
//             //                     }
//             //                     action(SendP9)
//             //                     {
//             //                         Caption = 'Send P9 via Mail';
//             //                         ApplicationArea = basic, suite;
//             //                         RunObject = report "Send P9 Report Via Mail";
//             //                     }

//             //                 }


//             //             }

//             // #if not CLEAN18







//             group("Audit Trails")
//             {
//                 action("Session Tracker")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     RunObject = report "Session Tracker";
//                 }
//                 action("Transaction Log")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     RunObject = report "System Transaction Log";
//                 }
//                 action("Read Log")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     RunObject = report "System Change Entry Log";
//                     Caption = 'System Change Entry Log';
//                 }
//             }
//             group("Periodic Processes")
//             {
//                 action("Auto Loan Recovery")
//                 {
//                     RunObject = codeunit 51516058;
//                     image = CostAccountingDimensions;
//                     Enabled = true;
//                 }

//             }
//             group("Ledger Accounting")
//             {
//                 Caption = 'Ledger Accounting';
//                 visible = false;
//                 action("&G/L Trial Balance")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = '&G/L Trial Balance';
//                     Image = "Report";
//                     RunObject = Report "Trial Balance";
//                     ToolTip = 'View, print, or send a report that shows the balances for the general ledger accounts, including the debits and credits. You can use this report to ensure accurate accounting practices.';
//                 }
//                 action("&Bank Detail Trial Balance")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = '&Bank Detail Trial Balance';
//                     Image = "Report";
//                     RunObject = Report "Bank Acc. - Detail Trial Bal.";
//                     ToolTip = 'View, print, or send a report that shows a detailed trial balance for selected bank accounts. You can use the report at the close of an accounting period or fiscal year.';
//                 }
//                 action("&Account Schedule")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = '&Account Schedule';
//                     Image = "Report";
//                     RunObject = Report "Account Schedule";
//                     ToolTip = 'Open an account schedule to analyze figures in general ledger accounts or to compare general ledger entries with general ledger budget entries.';
//                 }
//                 action("Bu&dget")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Bu&dget';
//                     Image = "Report";
//                     RunObject = Report Budget;
//                     ToolTip = 'View or edit estimated amounts for a range of accounting periods.';
//                 }
//                 action("Trial Bala&nce/Budget")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Trial Bala&nce/Budget';
//                     Image = "Report";
//                     RunObject = Report "Trial Balance/Budget";
//                     ToolTip = 'View a trial balance in comparison to a budget. You can choose to see a trial balance for selected dimensions. You can use the report at the close of an accounting period or fiscal year.';
//                 }
//                 action("Trial Balance by &Period")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Trial Balance by &Period';
//                     Image = "Report";
//                     RunObject = Report "Trial Balance by Period";
//                     ToolTip = 'Show the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.';
//                 }
//                 action("&Fiscal Year Balance")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = '&Fiscal Year Balance';
//                     Image = "Report";
//                     RunObject = Report "Fiscal Year Balance";
//                     ToolTip = 'View, print, or send a report that shows balance sheet movements for selected periods. The report shows the closing balance by the end of the previous fiscal year for the selected ledger accounts. It also shows the fiscal year until this date, the fiscal year by the end of the selected period, and the balance by the end of the selected period, excluding the closing entries. The report can be used at the close of an accounting period or fiscal year.';
//                 }
//                 action("Balance Comp. - Prev. Y&ear")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Balance Comp. - Prev. Y&ear';
//                     Image = "Report";
//                     RunObject = Report "Balance Comp. - Prev. Year";
//                     ToolTip = 'View a report that shows your company''s assets, liabilities, and equity compared to the previous year.';
//                 }
//                 action("&Closing Trial Balance")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = '&Closing Trial Balance';
//                     Image = "Report";
//                     RunObject = Report "Closing Trial Balance";
//                     ToolTip = 'View, print, or send a report that shows this year''s and last year''s figures as an ordinary trial balance. The closing of the income statement accounts is posted at the end of a fiscal year. The report can be used in connection with closing a fiscal year.';
//                 }
//                 action("Dimensions - Total")
//                 {
//                     ApplicationArea = Dimensions;
//                     Caption = 'Dimensions - Total';
//                     Image = "Report";
//                     RunObject = Report "Dimensions - Total";
//                     ToolTip = 'View how dimensions or dimension sets are used on entries based on total amounts over a specified period and for a specified analysis view.';
//                 }

//                 action("Cash Flow Date List")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Cash Flow Date List';
//                     Image = "Report";
//                     RunObject = Report "Cash Flow Date List";
//                     ToolTip = 'View forecast entries for a period of time that you specify. The registered cash flow forecast entries are organized by source types, such as receivables, sales orders, payables, and purchase orders. You specify the number of periods and their length.';
//                 }



//                 group("Cost Accounting")
//                 {
//                     Caption = 'Cost Accounting';
//                     action("Cost Accounting P/L Statement")
//                     {
//                         ApplicationArea = all;
//                         Caption = 'Cost Accounting P/L Statement';
//                         Image = "Report";
//                         RunObject = Report "Cost Acctg. Statement";
//                         ToolTip = 'View the credit and debit balances per cost type, together with the chart of cost types.';
//                     }
//                     action("CA P/L Statement per Period")
//                     {
//                         ApplicationArea = all;
//                         Caption = 'CA P/L Statement per Period';
//                         Image = "Report";
//                         RunObject = Report "Cost Acctg. Stmt. per Period";
//                         ToolTip = 'View profit and loss for cost types over two periods with the comparison as a percentage.';
//                     }
//                     action("CA P/L Statement with Budget")
//                     {
//                         ApplicationArea = all;
//                         Caption = 'CA P/L Statement with Budget';
//                         Image = "Report";
//                         RunObject = Report "Cost Acctg. Statement/Budget";
//                         ToolTip = 'View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.';
//                     }
//                     action("Cost Accounting Analysis")
//                     {
//                         ApplicationArea = all;
//                         Caption = 'Cost Accounting Analysis';
//                         Image = "Report";
//                         RunObject = Report "Cost Acctg. Analysis";
//                         ToolTip = 'View balances per cost type with columns for seven fields for cost centers and cost objects. It is used as the cost distribution sheet in Cost accounting. The structure of the lines is based on the chart of cost types. You define up to seven cost centers and cost objects that appear as columns in the report.';
//                     }

//                 }


//                 group(Reconciliation)
//                 {
//                     Caption = 'Reconciliation';
//                     // action("Calculate Deprec&iation")
//                     // {
//                     //     ApplicationArea = FixedAssets;
//                     //     Caption = 'Calculate Deprec&iation';
//                     //     Ellipsis = true;
//                     //     Image = CalculateDepreciation;
//                     //     RunObject = Report "Calculate Depreciation";
//                     //     ToolTip = 'Calculate depreciation according to the conditions that you define. If the fixed assets that are included in the batch job are integrated with the general ledger (defined in the depreciation book that is used in the batch job), the resulting entries are transferred to the fixed assets general ledger journal. Otherwise, the batch job transfers the entries to the fixed asset journal. You can then post the journal or adjust the entries before posting, if necessary.';
//                     // }
//                     action("Import Co&nsolidation from Database")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Import Co&nsolidation from Database';
//                         Ellipsis = true;
//                         Image = ImportDatabase;
//                         RunObject = Report "Import Consolidation from DB";
//                         ToolTip = 'Import entries from the business units that will be included in a consolidation. You can use the batch job if the business unit comes from the same database in Business Central as the consolidated company.';
//                     }
//                     action("Bank Account R&econciliation")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Bank Account R&econciliation';
//                         Image = BankAccountRec;
//                         RunObject = Page "Bank Acc. Reconciliation";
//                         ToolTip = 'View the entries and the balance on your bank accounts against a statement from the bank.';
//                     }
//                     action("Payment Reconciliation Journals")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Payment Reconciliation Journals';
//                         Image = ApplyEntries;
//                         // Promoted = true;
//                         // PromotedCategory = Process;
//                         // PromotedIsBig = true;
//                         RunObject = Page "Pmt. Reconciliation Journals";
//                         RunPageMode = View;
//                         ToolTip = 'Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.';
//                     }
//                     action("Adjust E&xchange Rates")
//                     {
//                         ApplicationArea = Suite;
//                         Caption = 'Adjust E&xchange Rates';
//                         Ellipsis = true;
//                         Image = AdjustExchangeRates;
//                         RunObject = Codeunit "Exch. Rate Adjmt. Run Handler";
//                         ToolTip = 'Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.';
//                     }
//                     action("P&ost Inventory Cost to G/L")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'P&ost Inventory Cost to G/L';
//                         Image = PostInventoryToGL;
//                         RunObject = Report "Post Inventory Cost to G/L";
//                         ToolTip = 'Record the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.';
//                     }
//                     action("Intrastat &Journal")
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Intrastat &Journal';
//                         Image = Journal;
//                         RunObject = Page "Intrastat Jnl. Batches";
//                         ToolTip = 'Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.';
//                     }
//                     action("Calc. and Pos&t VAT Settlement")
//                     {
//                         ApplicationArea = VAT;
//                         Caption = 'Calc. and Pos&t VAT Settlement';
//                         Image = SettleOpenTransactions;
//                         RunObject = Report "Calc. and Post VAT Settlement";
//                         ToolTip = 'Close open VAT entries and transfers purchase and sales VAT amounts to the VAT settlement account. For every VAT posting group, the batch job finds all the VAT entries in the VAT Entry table that are included in the filters in the definition window.';
//                     }
//                 }
//             }



//         }


//     }

// }





