CREATE TABLE [dbo].[Contacts] (
    [Id]        UNIQUEIDENTIFIER NOT NULL,
    [Address]   NVARCHAR (50)    NOT NULL,
    [CityId]    UNIQUEIDENTIFIER NULL,
    [Email]     NVARCHAR (50)    NULL,
    [Telephone] NVARCHAR (50)    NULL,
    [Fax]       NVARCHAR (50)    NULL
);

