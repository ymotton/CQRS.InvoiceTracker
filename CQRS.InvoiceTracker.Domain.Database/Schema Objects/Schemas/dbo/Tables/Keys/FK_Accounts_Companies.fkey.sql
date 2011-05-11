ALTER TABLE [dbo].[Accounts]
    ADD CONSTRAINT [FK_Accounts_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

