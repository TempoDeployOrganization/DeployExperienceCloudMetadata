@isTest
public class AccountComponentControllerTest {
    @testSetup
    static void setupTestData() {
        // Create some test data that will be used in the tests
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i, Phone = '1234567890', Industry = 'Technology'));
        }
        insert testAccounts;
    }

 
    @isTest
    static void testSaveAccountSuccess() {
        // Test the saveAccount method for successful insertion
        AccountComponentController controller = new AccountComponentController();
        controller.newAccount = new Account(Name = 'New Test Account', Phone = '9876543210', Industry = 'Finance');
        
        Test.startTest();
        PageReference result = controller.saveAccount();
        Test.stopTest();
        
        // Check that the account was inserted
        Account insertedAccount = [SELECT Id, Name, Phone, Industry FROM Account WHERE Name = 'New Test Account' LIMIT 1];
        System.assertNotEquals(null, insertedAccount, 'The new account should be inserted successfully');
        System.assertEquals('9876543210', insertedAccount.Phone, 'Phone number should match');
        System.assertEquals('Finance', insertedAccount.Industry, 'Industry should match');
        
        // Check that the newAccount was reset
        System.assertEquals('', controller.newAccount.Name, 'The newAccount Name should be reset');
        System.assertEquals('', controller.newAccount.Phone, 'The newAccount Phone should be reset');
        System.assertEquals('', controller.newAccount.Industry, 'The newAccount Industry should be reset');

        // Check that a success message was added
        System.assertEquals(1, ApexPages.getMessages().size(), 'There should be one message');
        System.assertEquals(ApexPages.Severity.CONFIRM, ApexPages.getMessages()[0].getSeverity(), 'The message should be a confirmation');
    }

    @isTest
    static void testSaveAccountFailure() {
        // Test the saveAccount method for failure (e.g., missing required fields)
        AccountComponentController controller = new AccountComponentController();
        controller.newAccount = new Account(); // Missing required fields
        
        Test.startTest();
        PageReference result = controller.saveAccount();
        Test.stopTest();
        
        // Check that no account was inserted
        Integer accountCount = [SELECT COUNT() FROM Account WHERE Name = null];
        System.assertEquals(0, accountCount, 'No account should be inserted due to missing required fields');

        // Check that an error message was added
        System.assertEquals(1, ApexPages.getMessages().size(), 'There should be one message');
        System.assertEquals(ApexPages.Severity.ERROR, ApexPages.getMessages()[0].getSeverity(), 'The message should be an error');
    }
}