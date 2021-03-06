USE [master]
GO
/****** Object:  Database [NMS_DB]    Script Date: 9/22/2019 5:05:35 PM ******/
CREATE DATABASE [NMS_DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NMS_DB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\NMS_DB.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'NMS_DB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\NMS_DB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [NMS_DB] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NMS_DB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NMS_DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NMS_DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NMS_DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NMS_DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NMS_DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [NMS_DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [NMS_DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NMS_DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NMS_DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NMS_DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NMS_DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NMS_DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NMS_DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NMS_DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NMS_DB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [NMS_DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NMS_DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NMS_DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NMS_DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NMS_DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NMS_DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NMS_DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NMS_DB] SET RECOVERY FULL 
GO
ALTER DATABASE [NMS_DB] SET  MULTI_USER 
GO
ALTER DATABASE [NMS_DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NMS_DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NMS_DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NMS_DB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [NMS_DB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'NMS_DB', N'ON'
GO
USE [NMS_DB]
GO
/****** Object:  User [sql_nms]    Script Date: 9/22/2019 5:05:35 PM ******/
CREATE USER [sql_nms] FOR LOGIN [sql_nms] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [sql_nms]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [sql_nms]
GO
ALTER ROLE [db_datareader] ADD MEMBER [sql_nms]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [sql_nms]
GO
/****** Object:  Table [dbo].[AnnualRequirement]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AnnualRequirement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProdName] [varchar](50) NULL,
	[HSCode] [varchar](50) NULL,
	[Manufacturer] [varchar](100) NULL,
	[CountryOfOrgin] [varchar](20) NULL,
	[PackSize] [varchar](20) NULL,
	[TentativeUnits] [int] NULL,
	[UnitPrice] [float] NULL,
	[CurrencyId] [int] NULL,
	[TotalPrice] [float] NULL,
	[ProductCategory] [varchar](500) NULL,
	[ImpId] [int] NULL,
	[SubmissionDate] [datetime] NULL,
 CONSTRAINT [PK_AnnualRequirement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CurrencyRate]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CurrencyRate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyType] [varchar](50) NULL,
	[ExhchangeRate] [float] NULL,
 CONSTRAINT [PK_CurrencyRate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmployeeInfo]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmployeeInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpCode] [varchar](20) NULL,
	[EmpName] [varchar](50) NULL,
	[Designation] [varchar](20) NULL,
	[Email] [varchar](50) NULL,
	[ContactNo] [varchar](20) NULL,
 CONSTRAINT [PK_EmployeeInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ImporterInfos]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ImporterInfos](
	[Id] [int] NOT NULL,
	[OrgName] [varchar](200) NULL,
	[ContactName] [varchar](50) NULL,
	[Position] [varchar](20) NULL,
	[ContactNo] [varchar](20) NULL,
	[Division] [varchar](20) NULL,
	[District] [varchar](20) NULL,
	[Upazila] [varchar](20) NULL,
	[Address] [varchar](500) NULL,
	[DlsLicenseType] [varchar](20) NULL,
	[DlsLicenseNo] [varchar](20) NULL,
	[DlsLicenseScan] [varchar](100) NULL,
	[NidNo] [varchar](20) NULL,
	[NidScan] [varchar](100) NULL,
	[IrcScan] [varchar](100) NULL,
	[UserId] [int] NULL,
	[Email] [varchar](50) NULL,
	[ImpCode] [varchar](10) NULL,
 CONSTRAINT [PK_ImporterInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProformaInvoiceDtl]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProformaInvoiceDtl](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MstId] [int] NULL,
	[ProdName] [varchar](50) NULL,
	[HSCode] [varchar](50) NULL,
	[Manufacturer] [varchar](100) NULL,
	[CountryOfOrgin] [varchar](20) NULL,
	[PackSize] [varchar](20) NULL,
	[NoOfUnits] [int] NULL,
	[TotalAmount] [float] NULL,
	[TotalQuantity] [float] NULL,
	[TotalPrice] [float] NULL,
	[Type] [varchar](500) NULL,
	[Rmarks] [varchar](500) NULL,
	[ApprovalStatus] [bit] NULL,
	[ApprovedBy] [int] NULL,
 CONSTRAINT [PK_ProformaInvoiceDtl] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProformaInvoiceMst]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProformaInvoiceMst](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationNo] [varchar](50) NULL,
	[ProformaInvoiceNo] [varchar](50) NULL,
	[ProformaDate] [datetime] NULL,
	[SubmissionDate] [datetime] NULL,
	[CurrencyId] [int] NULL,
	[PortOfLoading] [varchar](50) NULL,
	[PortOfEntry] [varchar](50) NULL,
	[PIScan] [varchar](100) NULL,
	[LitScan] [varchar](100) NULL,
	[TestReport] [varchar](100) NULL,
	[OtherDoc] [varchar](100) NULL,
	[Confirmation] [bit] NULL,
 CONSTRAINT [PK_ProformaInvoiceMst] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleInfo]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RoleInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_RoleInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserLogin]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserLogin](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[PasswordHash] [varbinary](max) NULL,
	[PasswordSalt] [varbinary](max) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedTerminal] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedTerminal] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UserType] [varchar](10) NULL,
 CONSTRAINT [PK_UserLogin] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRoleConf]    Script Date: 9/22/2019 5:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoleConf](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_UserRoleConf] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX_UserLogin]    Script Date: 9/22/2019 5:05:36 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserLogin] ON [dbo].[UserLogin]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [NMS_DB] SET  READ_WRITE 
GO
