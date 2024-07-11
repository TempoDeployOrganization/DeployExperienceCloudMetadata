public class CustomContactController {
    public Id accountId { get; set; }
    public Contact newContact { get; set; }
    public List<Contact> contactList { get; set; }
    
    public CustomContactController() {
        newContact = new Contact();
        loadContacts();
    }
    
    private void loadContacts() {
        if (accountId != null) {
            contactList = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :accountId];
        } else {
            contactList = new List<Contact>();
        }
    }
    
    public void saveContact() {
        if (accountId != null) {
            newContact.AccountId = accountId;
            try {
                insert newContact;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Contact saved successfully.'));
                newContact = new Contact(); // Reset the form
                loadContacts(); // Reload the contact list
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error saving contact: ' + e.getMessage()));
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account ID is not set.'));
        }
    }
}