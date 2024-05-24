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
}