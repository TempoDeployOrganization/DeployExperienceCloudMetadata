public class AccountManagementController {
    public Account newAccount { get; set; }
    public List<Account> accounts { get; set; }
    
    // Constructor
    public AccountManagementController() {
        // Initialize new account
        newAccount = new Account();
        // Load existing accounts
        loadAccounts();
    }
    
    // Method to load existing accounts
    private void loadAccounts() {
        accounts = [SELECT Id, Name, Phone, Industry FROM Account LIMIT 100];
    }
    
    // Method to create a new account
    public void createAccount() {
        try {
            insert newAccount;
            // Reload the list of accounts after insertion
            loadAccounts();
            // Clear the newAccount form
            newAccount = new Account();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating account: ' + e.getMessage()));
        }
    }
}