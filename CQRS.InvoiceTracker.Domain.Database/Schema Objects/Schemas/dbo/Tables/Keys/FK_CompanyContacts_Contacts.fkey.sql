ALTER TABLE [dbo].[CompanyContacts]
    ADD CONSTRAINT [FK_CompanyContacts_Contacts] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[Contacts] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

