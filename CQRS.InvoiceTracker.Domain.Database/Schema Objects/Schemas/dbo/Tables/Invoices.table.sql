CREATE TABLE [dbo].[Invoices] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [DateSent]    DATE             NULL,
    [DateEntered] DATETIME         NOT NULL,
    [DateDue]     DATE             NULL,
    [CompanyId]   UNIQUEIDENTIFIER NOT NULL,
    [UserId]      UNIQUEIDENTIFIER NOT NULL,
    [AccountId]   UNIQUEIDENTIFIER NOT NULL,
    [Amount]      DECIMAL (18, 2)  NULL,
    [Message]     NVARCHAR (50)    NULL,
    [Memo]        NVARCHAR (255)   NULL
);

