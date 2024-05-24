/**
 * Class containing tests for SiteRegisterController
 */
@IsTest
public with sharing class SiteRegisterControllerTest {

    // Test method for successful user registration with matching passwords
    @IsTest
    static void testSuccessfulRegistrationWithPassword() {
        // Create test account and contact
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@force.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        // Mock the profile
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Instantiate the controller
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd1234';
        controller.communityNickname = 'testnickname';

        Test.startTest();
        PageReference result = controller.registerUser();
        Test.stopTest();

        // Verify that the result is not null and redirects to the confirmation page
        System.assertNotEquals(result, null, 'Page reference should not be null');
        System.assertEquals('/apex/SiteRegisterConfirm', result.getUrl(), 'Page should redirect to SiteRegisterConfirm');
    }

    // Test method for mismatched passwords
    @IsTest
    static void testRegistrationWithMismatchedPasswords() {
        // Instantiate the controller
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        controller.communityNickname = 'testnickname';

        Test.startTest();
        PageReference result = controller.registerUser();
        Test.stopTest();

        // Verify that the result is null and an error message is displayed
        System.assertEquals(result, null, 'Page reference should be null');
        List<ApexPages.Message> messages = ApexPages.getMessages();
        System.assert(messages.size() > 0, 'There should be at least one error message');
        System.assertEquals(ApexPages.Severity.ERROR, messages[0].getSeverity(), 'The message severity should be ERROR');
        System.assert(messages[0].getSummary().contains(Label.site.passwords_dont_match), 'The error message should contain "Passwords do not match"');
    }

    // Test method for successful user registration without password
    @IsTest
    static void testSuccessfulRegistrationWithoutPassword() {
        // Create test account and contact
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test2@force.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        // Mock the profile
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Instantiate the controller
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test2@force.com';
        controller.email = 'test2@force.com';
        controller.password = null;
        controller.confirmPassword = null;
        controller.communityNickname = 'testnickname2';

        Test.startTest();
        PageReference result = controller.registerUser();
        Test.stopTest();

        // Verify that the result is not null and redirects to the confirmation page
        System.assertNotEquals(result, null, 'Page reference should not be null');
        System.assertEquals('/apex/SiteRegisterConfirm', result.getUrl(), 'Page should redirect to SiteRegisterConfirm');
    }
}