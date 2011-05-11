ALTER TABLE [dbo].[UserContacts]
    ADD CONSTRAINT [FK_UserContacts_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

