/*
Deployment script for CQRS.InvoiceTracker.Domain.Database
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "CQRS.InvoiceTracker.Domain.Database"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
USE [master]
GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL
    AND DATABASEPROPERTYEX(N'$(DatabaseName)','Status') <> N'ONLINE')
BEGIN
    RAISERROR(N'The state of the target database, %s, is not set to ONLINE. To deploy to this database, its state must be set to ONLINE.', 16, 127,N'$(DatabaseName)') WITH NOWAIT
    RETURN
END

GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [InvoiceTrackerDomain], FILENAME = '$(DefaultDataPath)$(DatabaseName).mdf', FILEGROWTH = 1024 KB)
    LOG ON (NAME = [InvoiceTrackerDomain_log], FILENAME = '$(DefaultLogPath)$(DatabaseName)_log.LDF', MAXSIZE = 2097152 MB, FILEGROWTH = 10 %) COLLATE Latin1_General_CI_AS
GO
EXECUTE sp_dbcmptlevel [$(DatabaseName)], 100;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
USE [$(DatabaseName)]
GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GO
PRINT N'Creating [dbo].[Accounts]...';


GO
CREATE TABLE [dbo].[Accounts] (
    [Id]            UNIQUEIDENTIFIER NOT NULL,
    [Accountnumber] NVARCHAR (50)    NOT NULL,
    [CompanyId]     UNIQUEIDENTIFIER NOT NULL
);


GO
PRINT N'Creating PK_Accounts...';


GO
ALTER TABLE [dbo].[Accounts]
    ADD CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [dbo].[Cities]...';


GO
CREATE TABLE [dbo].[Cities] (
    [Id]         UNIQUEIDENTIFIER NOT NULL,
    [Postalcode] NVARCHAR (50)    NOT NULL,
    [Name]       NVARCHAR (50)    NOT NULL,
    [CountryId]  UNIQUEIDENTIFIER NULL
);


GO
PRINT N'Creating PK_Cities...';


GO
ALTER TABLE [dbo].[Cities]
    ADD CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [dbo].[Companies]...';


GO
CREATE TABLE [dbo].[Companies] (
    [Id]   UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR (255)   NOT NULL
);


GO
PRINT N'Creating PK_Companies...';


GO
ALTER TABLE [dbo].[Companies]
    ADD CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [dbo].[CompanyContacts]...';


GO
CREATE TABLE [dbo].[CompanyContacts] (
    [CompanyId] UNIQUEIDENTIFIER NOT NULL,
    [ContactId] UNIQUEIDENTIFIER NOT NULL
);


GO
PRINT N'Creating PK_CompanyContacts...';


GO
ALTER TABLE [dbo].[CompanyContacts]
    ADD CONSTRAINT [PK_CompanyContacts] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [ContactId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [dbo].[Contacts]...';


GO
CREATE TABLE [dbo].[Contacts] (
    [Id]        UNIQUEIDENTIFIER NOT NULL,
    [Address]   NVARCHAR (50)    NOT NULL,
    [CityId]    UNIQUEIDENTIFIER NULL,
    [Email]     NVARCHAR (50)    NULL,
    [Telephone] NVARCHAR (50)    NULL,
    [Fax]       NVARCHAR (50)    NULL
);


GO
PRINT N'Creating PK_Contacts...';


GO
ALTER TABLE [dbo].[Contacts]
    ADD CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [dbo].[Countries]...';


GO
CREATE TABLE [dbo].[Countries] (
    [Id]   UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR (255)   NULL,
    [Code] NVARCHAR (10)    NULL
);


GO
PRINT N'Creating PK_Country...';


GO
ALTER TABLE [dbo].[Countries]
    ADD CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [dbo].[Invoices]...';


GO
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


GO
PRINT N'Creating PK_Invoices...';


GO
ALTER TABLE [dbo].[Invoices]
    ADD CONSTRAINT [PK_Invoices] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [dbo].[UserContacts]...';


GO
CREATE TABLE [dbo].[UserContacts] (
    [UserId]    UNIQUEIDENTIFIER NOT NULL,
    [ContactId] UNIQUEIDENTIFIER NOT NULL
);


GO
PRINT N'Creating PK_UserContacts...';


GO
ALTER TABLE [dbo].[UserContacts]
    ADD CONSTRAINT [PK_UserContacts] PRIMARY KEY CLUSTERED ([UserId] ASC, [ContactId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [dbo].[Users]...';


GO
CREATE TABLE [dbo].[Users] (
    [Id]    UNIQUEIDENTIFIER NOT NULL,
    [Name]  NVARCHAR (50)    NOT NULL,
    [Email] NVARCHAR (50)    NOT NULL
);


GO
PRINT N'Creating PK_Users...';


GO
ALTER TABLE [dbo].[Users]
    ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating FK_Accounts_Companies...';


GO
ALTER TABLE [dbo].[Accounts] WITH NOCHECK
    ADD CONSTRAINT [FK_Accounts_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_Cities_Countries...';


GO
ALTER TABLE [dbo].[Cities] WITH NOCHECK
    ADD CONSTRAINT [FK_Cities_Countries] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Countries] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_CompanyContacts_Companies...';


GO
ALTER TABLE [dbo].[CompanyContacts] WITH NOCHECK
    ADD CONSTRAINT [FK_CompanyContacts_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_CompanyContacts_Contacts...';


GO
ALTER TABLE [dbo].[CompanyContacts] WITH NOCHECK
    ADD CONSTRAINT [FK_CompanyContacts_Contacts] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[Contacts] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_Contacts_Cities...';


GO
ALTER TABLE [dbo].[Contacts] WITH NOCHECK
    ADD CONSTRAINT [FK_Contacts_Cities] FOREIGN KEY ([CityId]) REFERENCES [dbo].[Cities] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_Invoices_Accounts...';


GO
ALTER TABLE [dbo].[Invoices] WITH NOCHECK
    ADD CONSTRAINT [FK_Invoices_Accounts] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[Accounts] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_Invoices_Companies...';


GO
ALTER TABLE [dbo].[Invoices] WITH NOCHECK
    ADD CONSTRAINT [FK_Invoices_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_Invoices_Users...';


GO
ALTER TABLE [dbo].[Invoices] WITH NOCHECK
    ADD CONSTRAINT [FK_Invoices_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_UserContacts_Contacts...';


GO
ALTER TABLE [dbo].[UserContacts] WITH NOCHECK
    ADD CONSTRAINT [FK_UserContacts_Contacts] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[Contacts] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_UserContacts_Users...';


GO
ALTER TABLE [dbo].[UserContacts] WITH NOCHECK
    ADD CONSTRAINT [FK_UserContacts_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
-- Refactoring step to update target server with deployed transaction logs
CREATE TABLE  [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
GO
sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Accounts] WITH CHECK CHECK CONSTRAINT [FK_Accounts_Companies];

ALTER TABLE [dbo].[Cities] WITH CHECK CHECK CONSTRAINT [FK_Cities_Countries];

ALTER TABLE [dbo].[CompanyContacts] WITH CHECK CHECK CONSTRAINT [FK_CompanyContacts_Companies];

ALTER TABLE [dbo].[CompanyContacts] WITH CHECK CHECK CONSTRAINT [FK_CompanyContacts_Contacts];

ALTER TABLE [dbo].[Contacts] WITH CHECK CHECK CONSTRAINT [FK_Contacts_Cities];

ALTER TABLE [dbo].[Invoices] WITH CHECK CHECK CONSTRAINT [FK_Invoices_Accounts];

ALTER TABLE [dbo].[Invoices] WITH CHECK CHECK CONSTRAINT [FK_Invoices_Companies];

ALTER TABLE [dbo].[Invoices] WITH CHECK CHECK CONSTRAINT [FK_Invoices_Users];

ALTER TABLE [dbo].[UserContacts] WITH CHECK CHECK CONSTRAINT [FK_UserContacts_Contacts];

ALTER TABLE [dbo].[UserContacts] WITH CHECK CHECK CONSTRAINT [FK_UserContacts_Users];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        DECLARE @VarDecimalSupported AS BIT;
        SELECT @VarDecimalSupported = 0;
        IF ((ServerProperty(N'EngineEdition') = 3)
            AND (((@@microsoftversion / power(2, 24) = 9)
                  AND (@@microsoftversion & 0xffff >= 3024))
                 OR ((@@microsoftversion / power(2, 24) = 10)
                     AND (@@microsoftversion & 0xffff >= 1600))))
            SELECT @VarDecimalSupported = 1;
        IF (@VarDecimalSupported > 0)
            BEGIN
                EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
            END
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET MULTI_USER 
    WITH ROLLBACK IMMEDIATE;


GO
