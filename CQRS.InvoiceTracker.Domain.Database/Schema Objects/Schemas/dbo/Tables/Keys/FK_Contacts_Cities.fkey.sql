﻿ALTER TABLE [dbo].[Contacts]
    ADD CONSTRAINT [FK_Contacts_Cities] FOREIGN KEY ([CityId]) REFERENCES [dbo].[Cities] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

