﻿ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [FK_Invoices_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

