# sObjectHierarchy
Any sobject with self lookup relationship.

[Installtion Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t900000002ZnP)

[Website](http://ratanpaul.github.io/sObjectHierarchy)

```
<apex:page standardController="Account" standardStylesheets="false" showHeader="false">
    <apex:form >
        <c:RN_sObjectHierarchy sObjectName="Account" relationshipFieldName="ParentId" sObjectId="{!account.Id}" sObjectFields="Name, Phone, Type, AccountNumber, Rating"/>
    </apex:form>
</apex:page>
```
![Account hierarchy](https://raw.githubusercontent.com/RatanPaul/imges/master/img/Account%20Hierarchy.png)

```
<apex:page standardController="contact" standardStylesheets="false" showHeader="false">
    <apex:form >
        <c:RN_sObjectHierarchy sObjectName="contact" relationshipFieldName="ratan__ParentContactId__c" sObjectId="{!contact.Id}" sObjectFields="Name, Phone, Email, Title"/>
    </apex:form>
</apex:page>
```
Note: Here ratan__ParentContactId__c is a custom field(self lookup) on Contact sObject.

![Account hierarchy](https://raw.githubusercontent.com/RatanPaul/imges/master/img/Contact%20Hierarchy.png)
