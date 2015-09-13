/*
    -->CreatedBy    :Ratan Paul
    -->CreatedOn    :13/sep/2013
*/
public with sharing class RN_sObjectHierarchy 
{
    public String strJSON {get;set;}
    public String strSobjectType {get;set;}
    public String strRelationshipName {get;set;}
    public String strFields {get;set;}
    public Id recordId {get;set;}
    private Id ultimateParentId ;
    private map<Id, Sobject> mapSobject;
    
    public RN_sObjectHierarchy()
    {
        mapSobject = new map<Id, Sobject>();
        strJSON ='';
    }
    
    public string getJSONData()
    {
        recursiveTopHierarchy(new set<Id>{recordId});
        recursiveDownHierarchy(new set<Id>{ultimateParentId});
        return JSON.serialize(mapSobject.values());
    }
    public string getFieldsJSON()
    {
        List<wrapperFields> lstWrapperFields = new List<wrapperFields>();
        set<String> setFields = new set<String>();
        for(String str:strFields.split(','))
        {
            setFields.add(str.trim());
        }
        for(Schema.SObjectField obj: Schema.getGlobalDescribe().get(strSobjectType).getDescribe().fields.getMap().values())
        {
            if(setFields.contains(obj.getDescribe().getName()) && obj.getDescribe().getName() != 'Name')
            {
                lstWrapperFields.add(new wrapperFields(obj.getDescribe().getLabel(), obj.getDescribe().getName(), string.valueOf(obj.getDescribe().getType()))); 				
            }
        }
        return JSON.serialize(lstWrapperFields);
    }
    public class wrapperFields
    {
        public String field         {get;set;}
        public String sortable      {get;set;}
        public String sortingType   {get;set;}
        public String filterable    {get;set;}
        public String displayName    {get;set;}
        
        public wrapperFields(String strFieldLabel, String strFieldName, String strFieldType)
        {
            this.displayName = strFieldLabel;
            this.field = strFieldName;
            this.sortingType = strFieldType;
            this.sortable = sortingType == 'string'? 'true':'false';
            this.filterable = 'true';
        }
    }
    
    //get ultimate parent id
    public void recursiveTopHierarchy(set<Id> setRecordIds)
    {
        set<Id> setAccountId = new set<Id>();
        String strQuery = 'SELECT '+strFields+', '+strRelationshipName+' FROM '+strSobjectType+ ' WHERE Id IN:setRecordIds';
        for(Sobject objSobject: Database.query(strQuery))
        {
            if(objSobject.get(strRelationshipName) != null)
                setAccountId.add((Id)objSobject.get(strRelationshipName));
            else
            {
                ultimateParentId = (Id)objSobject.get('Id');
                mapSobject.put((Id)objSobject.get('Id'), objSobject);
            }
        }
        if(!setAccountId.isEmpty())
            recursiveTopHierarchy(setAccountId);
    }
    
    public void recursiveDownHierarchy(set<Id> setRecordIds)
    {
        set<Id> setAccountId = new set<Id>();
        String strQuery = 'SELECT '+strFields+', '+strRelationshipName+' FROM '+strSobjectType+ ' WHERE '+strRelationshipName+' IN:setRecordIds';
        for(Sobject objSobject: Database.query(strQuery))
        {
            setAccountId.add((Id)objSobject.get('Id'));
            mapSobject.put((Id)objSobject.get('Id'), objSobject);
        }
        if(!setAccountId.isEmpty())
            recursiveDownHierarchy(setAccountId);
    }
}