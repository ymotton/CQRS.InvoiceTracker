ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [FK_Invoices_Accounts] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[Accounts] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

