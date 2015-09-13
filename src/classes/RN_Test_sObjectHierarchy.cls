@isTest
private class RN_Test_sObjectHierarchy
{
	private static testMethod void test() 
	{
        Account objAccount = new Account(Name = 'Test Account', Phone = '123456' );
        insert objAccount;
        RN_sObjectHierarchy obj = new RN_sObjectHierarchy();
        obj.recordId = objAccount.Id;
        obj.strSobjectType ='Account';
        obj.strRelationshipName = 'ParentId';
        obj.strFields = 'Name, Phone';
        obj.getJSONData();
        obj.getFieldsJSON();
	}
}