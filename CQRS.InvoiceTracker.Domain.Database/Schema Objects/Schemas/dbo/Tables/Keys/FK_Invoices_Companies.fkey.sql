ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [FK_Invoices_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

