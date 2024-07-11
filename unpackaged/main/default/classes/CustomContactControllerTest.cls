@isTest
public class CustomContactControllerTest {
    
    @isTest
    static void testSaveContact() {
        // Create a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Instantiate the controller
        CustomContactController controller = new CustomContactController();
        controller.accountId = testAccount.Id;
        
        // Verify the initial state (no contacts)
        System.assertEquals(0, controller.contactList.size(), 'Initial contact list should be empty');
        
        // Set up the new contact
        controller.newContact.FirstName = 'Jane';
        controller.newContact.LastName = 'Doe';
        controller.newContact.Email = 'jane.doe@example.com';
        
        // Call the saveContact method
        Test.startTest();
        controller.saveContact();
        Test.stopTest();
        
        // Verify the contact was created
        List<Contact> createdContacts = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(1, createdContacts.size(), 'There should be one contact associated with the test account');
        Contact createdContact = createdContacts[0];
        System.assertEquals('Jane', createdContact.FirstName, 'Contact first name should be Jane');
        System.assertEquals('Doe', createdContact.LastName, 'Contact last name should be Doe');
        System.assertEquals('jane.doe@example.com', createdContact.Email, 'Contact email should be jane.doe@example.com');
        
        // Verify the controller's contact list is updated
        System.assertEquals(1, controller.contactList.size(), 'Controller contact list should have one contact');
        System.assertEquals('Jane', controller.contactList[0].FirstName, 'Controller contact first name should be Jane');
        System.assertEquals('Doe', controller.contactList[0].LastName, 'Controller contact last name should be Doe');
        
        // Test the path where accountId is not set
        CustomContactController controllerWithoutAccount = new CustomContactController();
        controllerWithoutAccount.accountId = null;
        controllerWithoutAccount.newContact.FirstName = 'John';
        controllerWithoutAccount.newContact.LastName = 'Doe';
        controllerWithoutAccount.newContact.Email = 'john.doe@example.com';
        
        Test.startTest();
        controllerWithoutAccount.saveContact();
        Test.stopTest();
        
        // Verify that no contact was created and an error message was added
        List<Contact> noContacts = [SELECT Id FROM Contact WHERE FirstName = 'John' AND LastName = 'Doe'];
        System.assertEquals(0, noContacts.size(), 'No contact should be created without an account ID');
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR), 'An error message should be present');
    }
}