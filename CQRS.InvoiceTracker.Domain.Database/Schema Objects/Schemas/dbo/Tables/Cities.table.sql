CREATE TABLE [dbo].[Cities] (
    [Id]         UNIQUEIDENTIFIER NOT NULL,
    [Postalcode] NVARCHAR (50)    NOT NULL,
    [Name]       NVARCHAR (50)    NOT NULL,
    [CountryId]  UNIQUEIDENTIFIER NULL
);

