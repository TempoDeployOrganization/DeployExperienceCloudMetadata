@isTest
public class AccountManagementControllerTest {
    
    @isTest
    static void testCreateAccount() {
        // Instantiate the controller
        AccountManagementController controller = new AccountManagementController();
        
        // Verify the initial state (no accounts)
        List<Account> initialAccounts = controller.accounts;
        System.assertEquals(0, initialAccounts.size(), 'Initial account list should be empty');
        
        // Set up the new account
        controller.newAccount.Name = 'Test Account';
        controller.newAccount.Phone = '123-456-7890';
        controller.newAccount.Industry = 'Technology';
        
        // Call the createAccount method
        Test.startTest();
        controller.createAccount();
        Test.stopTest();
        
        // Verify the account was created
        List<Account> createdAccounts = [SELECT Id, Name, Phone, Industry FROM Account WHERE Name = 'Test Account'];
        System.assertEquals(1, createdAccounts.size(), 'There should be one account with the name "Test Account"');
        Account createdAccount = createdAccounts[0];
        System.assertEquals('Test Account', createdAccount.Name, 'Account name should be "Test Account"');
        
        // Verify the controller's account list is updated
        List<Account> updatedAccounts = controller.accounts;
        System.assertEquals(1, updatedAccounts.size(), 'Controller account list should have one account');
    }
}