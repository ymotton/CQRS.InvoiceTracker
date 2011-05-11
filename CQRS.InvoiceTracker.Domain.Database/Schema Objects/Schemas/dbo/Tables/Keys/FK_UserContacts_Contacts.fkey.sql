ALTER TABLE [dbo].[UserContacts]
    ADD CONSTRAINT [FK_UserContacts_Contacts] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[Contacts] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

