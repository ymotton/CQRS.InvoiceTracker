ALTER TABLE [dbo].[Cities]
    ADD CONSTRAINT [FK_Cities_Countries] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Countries] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

