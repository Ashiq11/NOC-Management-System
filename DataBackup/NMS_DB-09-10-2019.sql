USE [master]
GO
/****** Object:  Database [NMS_DB]    Script Date: 10/9/2019 2:26:06 AM ******/
CREATE DATABASE [NMS_DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NMS_DB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\NMS_DB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'NMS_DB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\NMS_DB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [NMS_DB] SET COMPATIBILITY_LEVEL = 130
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
ALTER DATABASE [NMS_DB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [NMS_DB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'NMS_DB', N'ON'
GO
ALTER DATABASE [NMS_DB] SET QUERY_STORE = OFF
GO
USE [NMS_DB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [NMS_DB]
GO
/****** Object:  Table [dbo].[AnnualRequirementDtls]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnnualRequirementDtls](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AnnReqMstId] [int] NULL,
	[ProdName] [varchar](50) NULL,
	[ProdType] [varchar](500) NULL,
	[HsCode] [varchar](50) NULL,
	[Manufacturer] [varchar](100) NULL,
	[CountryOfOrigin] [varchar](20) NULL,
	[PackSize] [varchar](100) NULL,
	[TotalAmount] [float] NULL,
	[TentativeUnits] [int] NULL,
	[UnitPrice] [float] NULL,
	[Currency] [varchar](20) NULL,
	[TotalPrice] [float] NULL,
	[TotalPriceInBdt] [float] NULL,
 CONSTRAINT [PK_AnnualRequirement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AnnualRequirementMsts]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnnualRequirementMsts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ImporterId] [int] NULL,
	[SubmissionDate] [datetime] NULL,
 CONSTRAINT [PK_AnnualRequirementMsts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CurrencyRates]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CurrencyRates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Currency] [varchar](50) NULL,
	[ExchangeRate] [float] NULL,
 CONSTRAINT [PK_CurrencyRate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeInfos]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeInfos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpCode] [varchar](20) NULL,
	[EmpName] [varchar](50) NULL,
	[Designation] [varchar](20) NULL,
	[Email] [varchar](50) NULL,
	[ContactNo] [varchar](20) NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImporterInfos]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImporterInfos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Table [dbo].[ProformaInvoiceDtls]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProformaInvoiceDtls](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MstId] [int] NULL,
	[ProdName] [varchar](50) NULL,
	[ProdType] [varchar](500) NULL,
	[HsCode] [varchar](50) NULL,
	[Manufacturer] [varchar](100) NULL,
	[PackSize] [varchar](20) NULL,
	[NoOfUnits] [int] NULL,
	[UnitPrice] [float] NULL,
	[TotalAmount] [float] NULL,
	[ExchangeRate] [float] NULL,
	[TotalPrice] [float] NULL,
	[TotalPriceInBdt] [float] NULL,
	[Remarks] [varchar](500) NULL,
	[ApprovalStatus] [bit] NULL,
	[ApprovedBy] [int] NULL,
 CONSTRAINT [PK_ProformaInvoiceDtl] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProformaInvoiceMsts]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProformaInvoiceMsts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationNo] [varchar](50) NULL,
	[ProformaInvoiceNo] [varchar](50) NULL,
	[ProformaDate] [datetime] NULL,
	[SubmissionDate] [datetime] NULL,
	[Currency] [varchar](50) NULL,
	[PortOfLoading] [varchar](50) NULL,
	[PortOfEntry] [varchar](50) NULL,
	[PIScan] [varchar](100) NULL,
	[LitScan] [varchar](100) NULL,
	[TestReport] [varchar](100) NULL,
	[OtherDoc] [varchar](100) NULL,
	[Confirmation] [bit] NULL,
	[CountryOfOrigin] [varchar](50) NULL,
 CONSTRAINT [PK_ProformaInvoiceMst] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleInfos]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleInfos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_RoleInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLogins]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLogins](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NULL,
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
/****** Object:  Table [dbo].[UserRoleConfs]    Script Date: 10/9/2019 2:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoleConfs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_UserRoleConf] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AnnualRequirementDtls] ON 

INSERT [dbo].[AnnualRequirementDtls] ([Id], [AnnReqMstId], [ProdName], [ProdType], [HsCode], [Manufacturer], [CountryOfOrigin], [PackSize], [TotalAmount], [TentativeUnits], [UnitPrice], [Currency], [TotalPrice], [TotalPriceInBdt]) VALUES (3, 3, N'Ace 500', N'Paracetamol', N'121.100', N'Square Pharmaceuticals Ltd.', N'Bangladesh', N'10 kg', 10, 100000, 50, N'Dollar', 5000000, 420000000)
INSERT [dbo].[AnnualRequirementDtls] ([Id], [AnnReqMstId], [ProdName], [ProdType], [HsCode], [Manufacturer], [CountryOfOrigin], [PackSize], [TotalAmount], [TentativeUnits], [UnitPrice], [Currency], [TotalPrice], [TotalPriceInBdt]) VALUES (4, 3, N'Seclo 50', N'Omiprazol', N'100.100', N'Incepta Pharma Ltd', N'UK', N'100kg', 500, 25000, 20, N'Euro', 500000, 50000000)
INSERT [dbo].[AnnualRequirementDtls] ([Id], [AnnReqMstId], [ProdName], [ProdType], [HsCode], [Manufacturer], [CountryOfOrigin], [PackSize], [TotalAmount], [TentativeUnits], [UnitPrice], [Currency], [TotalPrice], [TotalPriceInBdt]) VALUES (5, 3, N'OCoff', N'Cough Syrup', N'001.001', N'Pharmasia', N'USA', N'100kg Bulk', 1000, 500000, 1000, N'Pound', 500000000, 55000000000)
INSERT [dbo].[AnnualRequirementDtls] ([Id], [AnnReqMstId], [ProdName], [ProdType], [HsCode], [Manufacturer], [CountryOfOrigin], [PackSize], [TotalAmount], [TentativeUnits], [UnitPrice], [Currency], [TotalPrice], [TotalPriceInBdt]) VALUES (7, 5, N'Calcium Cloride', N'Chemical', N'100001', N'JFK Chemical', N'USA', N'50 kg pack', 500, 100000, 800, N'Pound', 80000000, 8800000000)
INSERT [dbo].[AnnualRequirementDtls] ([Id], [AnnReqMstId], [ProdName], [ProdType], [HsCode], [Manufacturer], [CountryOfOrigin], [PackSize], [TotalAmount], [TentativeUnits], [UnitPrice], [Currency], [TotalPrice], [TotalPriceInBdt]) VALUES (8, 5, N'Sodium Silicate', N'Chemical', N'500454', N'Chengdu Chemical', N'China', N'25Kg', 100, 50000, 60, N'Dollar', 3000000, 252000000)
INSERT [dbo].[AnnualRequirementDtls] ([Id], [AnnReqMstId], [ProdName], [ProdType], [HsCode], [Manufacturer], [CountryOfOrigin], [PackSize], [TotalAmount], [TentativeUnits], [UnitPrice], [Currency], [TotalPrice], [TotalPriceInBdt]) VALUES (9, 5, N'Hydrozen Per Oxide', N'Chemical', N'45685', N'Jiska Chemical', N'Uk', N'1kg pack', 200, 500000, 1000, N'Pound', 500000000, 55000000000)
SET IDENTITY_INSERT [dbo].[AnnualRequirementDtls] OFF
SET IDENTITY_INSERT [dbo].[AnnualRequirementMsts] ON 

INSERT [dbo].[AnnualRequirementMsts] ([Id], [ImporterId], [SubmissionDate]) VALUES (3, 1031, CAST(N'2019-10-01T22:28:06.733' AS DateTime))
INSERT [dbo].[AnnualRequirementMsts] ([Id], [ImporterId], [SubmissionDate]) VALUES (5, 1032, CAST(N'2019-10-07T20:09:28.400' AS DateTime))
SET IDENTITY_INSERT [dbo].[AnnualRequirementMsts] OFF
SET IDENTITY_INSERT [dbo].[CurrencyRates] ON 

INSERT [dbo].[CurrencyRates] ([Id], [Currency], [ExchangeRate]) VALUES (1, N'Dollar', 84)
INSERT [dbo].[CurrencyRates] ([Id], [Currency], [ExchangeRate]) VALUES (2, N'Euro', 100)
INSERT [dbo].[CurrencyRates] ([Id], [Currency], [ExchangeRate]) VALUES (3, N'Pound', 110)
SET IDENTITY_INSERT [dbo].[CurrencyRates] OFF
SET IDENTITY_INSERT [dbo].[ImporterInfos] ON 

INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1031, N'Microsoft Inc.', N'Bill Gates', N'Chairman', N'+966589659', N'Dhaka', N'Dhaka', N'Dhaka City', N'Banani, Dhaka', N'Category 2', N'4578987', N'Resources\ImporterInfoFiles\58273d07-63d8-4508-9988-d98a59ef1351.pdf', N'1992285598787878', N'Resources\ImporterInfoFiles\466818f2-7e95-4996-9e75-cbfe5413328c.pdf', N'Resources\ImporterInfoFiles\8dac19c9-1a67-46ee-8253-974198345ad7.pdf', 1031, N'gates@outlook.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1032, N'Apple Incorporation', N'Team Cook', N'Ceo', N'01711230955', N'Dhaka', N'Faridpur', N'Faridpur Sadar', N'Faridpur, Dhaka', N'Farm', N'454545', N'Resources\ImporterInfoFiles\b32c68a4-9c83-4a5f-8a33-a9b3c63bbc39.pdf', N'1992285598787878', N'Resources\ImporterInfoFiles\c6cd3b6d-e72a-44e1-9f05-3bff3c0e1ce6.pdf', N'Resources\ImporterInfoFiles\571c032c-5c02-4fca-867c-afb58b5f1478.pdf', 1032, N'team@apple.com', NULL)
SET IDENTITY_INSERT [dbo].[ImporterInfos] OFF
SET IDENTITY_INSERT [dbo].[ProformaInvoiceDtls] ON 

INSERT [dbo].[ProformaInvoiceDtls] ([Id], [MstId], [ProdName], [ProdType], [HsCode], [Manufacturer], [PackSize], [NoOfUnits], [UnitPrice], [TotalAmount], [ExchangeRate], [TotalPrice], [TotalPriceInBdt], [Remarks], [ApprovalStatus], [ApprovedBy]) VALUES (1, 15, N'Calcium Cloride', N'Chemical', N'100001', N'JFK Chemical', N'50 kg pack', 10, 10, 10, 84, 100, 8400, NULL, 0, NULL)
INSERT [dbo].[ProformaInvoiceDtls] ([Id], [MstId], [ProdName], [ProdType], [HsCode], [Manufacturer], [PackSize], [NoOfUnits], [UnitPrice], [TotalAmount], [ExchangeRate], [TotalPrice], [TotalPriceInBdt], [Remarks], [ApprovalStatus], [ApprovedBy]) VALUES (2, 15, N'Sodium Silicate', N'Chemical', N'500454', N'Chengdu Chemical', N'25Kg', 10, 10, 10, 84, 100, 8400, NULL, 0, NULL)
SET IDENTITY_INSERT [dbo].[ProformaInvoiceDtls] OFF
SET IDENTITY_INSERT [dbo].[ProformaInvoiceMsts] ON 

INSERT [dbo].[ProformaInvoiceMsts] ([Id], [ApplicationNo], [ProformaInvoiceNo], [ProformaDate], [SubmissionDate], [Currency], [PortOfLoading], [PortOfEntry], [PIScan], [LitScan], [TestReport], [OtherDoc], [Confirmation], [CountryOfOrigin]) VALUES (15, N'1', N'81020191', CAST(N'2019-10-08T23:33:21.983' AS DateTime), CAST(N'2019-10-08T23:33:21.983' AS DateTime), N'Dollar', N'Chelsea', N'Chattogram', NULL, NULL, NULL, NULL, 0, N'Uk')
SET IDENTITY_INSERT [dbo].[ProformaInvoiceMsts] OFF
SET IDENTITY_INSERT [dbo].[RoleInfos] ON 

INSERT [dbo].[RoleInfos] ([Id], [Name]) VALUES (1, N'Admin')
INSERT [dbo].[RoleInfos] ([Id], [Name]) VALUES (2, N'Importer')
SET IDENTITY_INSERT [dbo].[RoleInfos] OFF
SET IDENTITY_INSERT [dbo].[UserLogins] ON 

INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1031, N'gates', 0x7D10C14023FB386ABE6D8A35089F7454D77FA7963ED17B58A6A0E1B501F5E010F977A2F24E634A93C7A3D308FAD3A05B6CF4C81632483FC7154A0FBFAFCB02DF, 0xA2F7D277E6A248A1A4BFD6F943C6D718D4D67D9E6A7EE13C273B102AC233B7A39758AAD67B70877261EE574020DDEA1807FE4DDB71385C940DC7E4F576A9D23D86E39527C69A2B1F8AFE27508B7C498D0B1C0BB703442F547018175854EC69BFCDFAC48651ECCF7F9554D235E12DB98E1A4DFBB5C26B7061A6F1D6F9154E99A9, NULL, NULL, CAST(N'2019-10-01T21:05:48.607' AS DateTime), NULL, NULL, CAST(N'2019-10-01T21:05:48.607' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1032, N'team', 0xE1273FE34A368A2FABF896AA3ADF2EB174C8F5178ABDA2D7D5BB0AEA4DC907929D1A84AD28277A6C283FA3E95E174874DBA580232A77A8EB608EF46781D3033B, 0xEB81E67B0C3B41FFA2B2E627284A87E05132B89636D356A3196B97C3370E502C1C4DA267A014677845AD324B7822C5714F8CD694E056F73CDC6FD73FB613B32401209655345D741F64AC800A60EE21F0EC94761E40EEB27B20D2AA7E8AAEFC2F3CBEDB45D17FB0ADDFCE79C89A8A28782ABE4AC3F118CE94DA513F073929C075, NULL, NULL, CAST(N'2019-10-07T20:03:10.597' AS DateTime), NULL, NULL, CAST(N'2019-10-07T20:03:10.597' AS DateTime), N'I')
SET IDENTITY_INSERT [dbo].[UserLogins] OFF
SET IDENTITY_INSERT [dbo].[UserRoleConfs] ON 

INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (1, 31, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (2, 32, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (3, 33, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (4, 34, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (1001, 1031, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (1002, 1032, 2)
SET IDENTITY_INSERT [dbo].[UserRoleConfs] OFF
/****** Object:  Index [IX_UserLogin]    Script Date: 10/9/2019 2:26:07 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserLogin] ON [dbo].[UserLogins]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AnnualRequirementDtls]  WITH CHECK ADD  CONSTRAINT [FK_AnnualRequirementDtls_AnnualRequirementMsts] FOREIGN KEY([AnnReqMstId])
REFERENCES [dbo].[AnnualRequirementMsts] ([Id])
GO
ALTER TABLE [dbo].[AnnualRequirementDtls] CHECK CONSTRAINT [FK_AnnualRequirementDtls_AnnualRequirementMsts]
GO
USE [master]
GO
ALTER DATABASE [NMS_DB] SET  READ_WRITE 
GO
