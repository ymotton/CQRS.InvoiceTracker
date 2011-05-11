ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [InvoiceTrackerDomain], FILENAME = '$(DefaultDataPath)$(DatabaseName).mdf', FILEGROWTH = 1024 KB) TO FILEGROUP [PRIMARY];

