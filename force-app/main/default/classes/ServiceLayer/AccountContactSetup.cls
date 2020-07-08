@isTest
public with sharing class AccountContactSetup {

    public static void AccountContactSetupUoW(fflib_SObjectUnitOfWork uow) {

        // Do some work!
        for(Integer a=0; a<100; a++) {
            Account acc = new Account();
            acc.Name = 'UoW Account Test Name ' + a;
            uow.registerNew(acc);
            for(Integer c=0; c<5; c++) {
                Contact cont = new Contact();
                cont.LastName = 'UoW Contact LastName ' + c;
                uow.registerNew(cont, Contact.AccountId, acc);
    
                Note n = new Note();
                n.Title = 'UoW Note Title' + c;
                n.Body = 'UoW Note ' + c;
                uow.registerNew(n, Note.ParentId, acc);
            }
        }
    }
}