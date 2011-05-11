ALTER TABLE [dbo].[CompanyContacts]
    ADD CONSTRAINT [FK_CompanyContacts_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

