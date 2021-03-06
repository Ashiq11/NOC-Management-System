USE [master]
GO
/****** Object:  Database [NMS_DB]    Script Date: 9/30/2019 12:32:43 AM ******/
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
/****** Object:  Table [dbo].[AnnualRequirements]    Script Date: 9/30/2019 12:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnnualRequirements](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProdName] [varchar](50) NULL,
	[HSCode] [varchar](50) NULL,
	[Manufacturer] [varchar](100) NULL,
	[CountryOfOrgin] [varchar](20) NULL,
	[PackSize] [varchar](20) NULL,
	[TentativeUnits] [int] NULL,
	[UnitPrice] [float] NULL,
	[Currency] [varbinary](20) NULL,
	[TotalPrice] [float] NULL,
	[ImpId] [int] NULL,
	[SubmissionDate] [datetime] NULL,
	[ProdType] [varchar](500) NULL,
	[TotalQuantity] [float] NULL,
 CONSTRAINT [PK_AnnualRequirement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CurrencyRates]    Script Date: 9/30/2019 12:32:44 AM ******/
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
/****** Object:  Table [dbo].[EmployeeInfos]    Script Date: 9/30/2019 12:32:44 AM ******/
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
	[UserId] [int] NULL,
 CONSTRAINT [PK_EmployeeInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImporterInfos]    Script Date: 9/30/2019 12:32:44 AM ******/
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
/****** Object:  Table [dbo].[ProformaInvoiceDtls]    Script Date: 9/30/2019 12:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProformaInvoiceDtls](
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
/****** Object:  Table [dbo].[ProformaInvoiceMsts]    Script Date: 9/30/2019 12:32:44 AM ******/
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
/****** Object:  Table [dbo].[RoleInfos]    Script Date: 9/30/2019 12:32:44 AM ******/
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
/****** Object:  Table [dbo].[Students]    Script Date: 9/30/2019 12:32:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLogins]    Script Date: 9/30/2019 12:32:44 AM ******/
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
/****** Object:  Table [dbo].[UserRoleConfs]    Script Date: 9/30/2019 12:32:44 AM ******/
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
SET IDENTITY_INSERT [dbo].[CurrencyRates] ON 

INSERT [dbo].[CurrencyRates] ([Id], [Currency], [ExchangeRate]) VALUES (1, N'Dollar', 80)
INSERT [dbo].[CurrencyRates] ([Id], [Currency], [ExchangeRate]) VALUES (2, N'Euro', 100)
INSERT [dbo].[CurrencyRates] ([Id], [Currency], [ExchangeRate]) VALUES (3, N'Pound', 115)
SET IDENTITY_INSERT [dbo].[CurrencyRates] OFF
SET IDENTITY_INSERT [dbo].[ImporterInfos] ON 

INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1010, N'Tesla Motors', N'Allen Mask', N'Ceo', N'+966589659', N'Dhaka', N'Dhaka', N'Dhamrai', N'Dhaka', N'Feed Meal', N'4578987', N'Resources\ImporterInfoFiles\dd751a84-bd56-4d9b-95ea-45c323eb9548.pdf', N'1992285598787878', N'Resources\ImporterInfoFiles\1d34d0b0-2e83-4b54-8f0c-bd57c726edd3.pdf', N'Resources\ImporterInfoFiles\f4004836-8ada-4ce5-bb68-7632e52ed90f.pdf', 1010, N'allen@tesla.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1011, N'Microsoft Inc.', N'Bill Gates', N'Chairman', N'+966589659', N'Dhaka', N'Dhaka', N'Dohar', N'Dhaka', N'Feed Meal', N'4578987', N'Resources\ImporterInfoFiles\19dd834c-3024-48f5-b6e7-e360d48bd663.pdf', N'1992285598787878', N'Resources\ImporterInfoFiles\f79de74f-a751-4ca5-adaa-a64dabb20943.pdf', N'Resources\ImporterInfoFiles\be1704ba-b12d-4f09-ab5d-15106f1c8558.pdf', 1011, N'gates@outlook.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1012, N'aa', N'aa', N'aa', N'12', N'Dhaka', N'Faridpur', N'Alfadanga', N'Dhaka', N'Farm', N'4578987', N'Resources\ImporterInfoFiles\c5da611b-0f58-408c-8b8e-76b1ee29f23b.pdf', N'1992285598787878', N'Resources\ImporterInfoFiles\23e1abf6-441e-4eec-a3e0-1263bd5a8b3b.pdf', N'Resources\ImporterInfoFiles\65bc863e-7bd5-4dd4-b917-1e1b30c29818.pdf', 1012, N'arif_sk@outlook.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1013, N'g', N'aa', N'aaaa', N'2131', N'Sylhet', N'Habiganj', N'Lakhai', N'123', N'Feed Meal', N'4578987', N'Resources\ImporterInfoFiles\a9b700a8-3f1d-49f1-9c3f-46e1b98b24fd.pdf', N'1992285598787878', N'Resources\ImporterInfoFiles\86138063-d28f-4b35-ab65-056e378e63bf.pdf', N'Resources\ImporterInfoFiles\f080493f-fe0a-41c1-a387-bd759292925e.pdf', 1013, N'sms43068@gmail.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1014, N'g', N'aaa', N'ads', N'5', N'Barishal', N'Barguna', N'Betagi', N'Dhaka', N'Category 2', N'4578987', N'Resources\ImporterInfoFiles\61910744-0d99-468a-9f23-c2d9b3c8abbe.pdf', N'1992285598787878', N'Resources\ImporterInfoFiles\2f20f6c1-dc2b-4f2e-a829-f43b65afbfef.pdf', N'Resources\ImporterInfoFiles\9e8351d9-62e2-43f5-b7f9-080bd99120d5.pdf', 1014, N'pickpocketfaisal@gmail.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1015, N'Microsoft Inc.', N'Bill Gates', N'Ceo', N'+966589659', N'Dhaka', N'Madaripur', N'Rajoir', N'a', N'Feed Meal', N'qerqwrqw', N'Resources\ImporterInfoFiles\7636f77c-b196-4698-bdb2-782fa1406f33.pdf', N'234', N'Resources\ImporterInfoFiles\39d20a6c-2943-437a-8509-5420d2bc4926.pdf', N'Resources\ImporterInfoFiles\f860e6f9-dbae-498d-a065-8b1dfc630ef8.pdf', 1015, N'sms43068@gmail.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (1016, N'Square Informatrix Ltd.', N'Arif Sheikh', N'Executive', N'01714285598', N'Dhaka', N'Dhaka', N'Dhaka City', N'48 Square Center, Mohakhali, Dhaka, 1213', N'Farm', N'457898564', N'Resources\ImporterInfoFiles\c9f0ddb0-5ee0-41b7-a93b-2517ce7da7c0.pdf', N'1992285598787878', N'Resources\ImporterInfoFiles\e15e5b69-ea45-4873-91ac-adb3a7277b6e.pdf', N'Resources\ImporterInfoFiles\ba2486c0-5b41-4c03-b13e-bbc6786a23b6.pdf', 1016, N'arif_sk@outlook.com', NULL)
SET IDENTITY_INSERT [dbo].[ImporterInfos] OFF
SET IDENTITY_INSERT [dbo].[RoleInfos] ON 

INSERT [dbo].[RoleInfos] ([Id], [Name]) VALUES (1, N'Admin')
INSERT [dbo].[RoleInfos] ([Id], [Name]) VALUES (2, N'Importer')
SET IDENTITY_INSERT [dbo].[RoleInfos] OFF
SET IDENTITY_INSERT [dbo].[Students] ON 

INSERT [dbo].[Students] ([Id], [Name]) VALUES (1, N'Arif')
INSERT [dbo].[Students] ([Id], [Name]) VALUES (4, N'Arif')
INSERT [dbo].[Students] ([Id], [Name]) VALUES (5, N'Arif')
SET IDENTITY_INSERT [dbo].[Students] OFF
SET IDENTITY_INSERT [dbo].[UserLogins] ON 

INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1010, N'allen', 0x2FDB1EAA1B0F02677E63E4B1933091E70974163C2CE278BB5A36CB37B42B0E5E6F93CAEFF76879F84FE1CAB94794340DF1F34356D0D805D25EE2D356BE119120, 0x96A1ED54A25817E6999EA90A6246FFB343CC7E29C32E1FC0BAC73E02F63E27C798D6E3B69B2A957B451770C172FFDB52CF4AABD92968C2DF82AE798518D48444E739318680774F7333A669107145E328B2169E676211EE962BAA5D93A53A49F4E55F2724B493F81EA151CA78922FE3FBB09355DF1E0DB5720BA4F71F11B619C1, NULL, NULL, CAST(N'2019-09-25T01:35:34.167' AS DateTime), NULL, NULL, CAST(N'2019-09-25T01:35:34.187' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1011, N'gates', 0xFF5DB505195EBE3231F351B6494E6C2FEF78688A6D2BA4ED20A25F78BE68C208C674509EFF99482F86D3699BEB1C470AC6F3B20115EA0BA01243C27DF903A618, 0xD9A28AD06BF6AABC22D85A6BA675E9204B57FC3A0F36B61AA4B00D149BA862BF089F3904D7964F93D346028DA784E234CDE9E4527EA72E9849C7B32A50D559E7BDB4A4716FF8D1247D38E89CAA0A7CFC1A62059ECC6DC26683810BC76E59C9523793F2C35073000C5F739CAB681EC15C05AC42259EEC9E74F634EFC9CF64E04E, NULL, NULL, CAST(N'2019-09-25T01:38:22.270' AS DateTime), NULL, NULL, CAST(N'2019-09-25T01:38:22.270' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1012, N'iuuouu', 0x3B71A9FB83412692C054055F36A16EAFF00A3A7464D235E5CDE4B537D3D92650D7F60B5A53F8239C72136B357AF4E420918C4E08EB905DBDBECC03A75EC95338, 0x59250C5C4BFAFF0DA9924DD7B870F5BB485A956190E1CC8C07C8E1852A3C385BEF82B0F2ACBF624DE50306A238299F84BF39650DF30C5FEC5704D3B32964C6BE63973004DB6EFC6EB917684A1D405FA9CADBCDC55F6F3858F00B2610CDDD09DBFAFDBE0297B0F71180823D3AE915A05C69785F0CBBCB2A1BB9FC3BA23958723A, NULL, NULL, CAST(N'2019-09-25T01:43:52.837' AS DateTime), NULL, NULL, CAST(N'2019-09-25T01:43:52.837' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1013, N'aa', 0x467FBB9A326B5EDCC537B53F4D51B04C3A6AC9141DB763018D385C30D5C5F0636694BA914E3F9E1F500185606CF811EB15F193D4E7BEAC8E793D7C991468011D, 0x2097D093CBA75D451C66EA2E076ADFA14E8EB1E27D7B5C5D3B55C1C4D9BB91FA9A0F525A7230CD8E0CD5F1D2089B68E87EAADE29B015BA542EBE29F2B2091931604F7AD75366054FC57C84D2391E99DEC8AEC58492074CFA899CB50761B0A0D8DF8C9CB6C134ABC16EAFCB73A98A7747AAE754F0958CABF5F7235F3788E3D370, NULL, NULL, CAST(N'2019-09-25T01:45:59.787' AS DateTime), NULL, NULL, CAST(N'2019-09-25T01:45:59.787' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1014, N'gg', 0x0F5C20CBCCF800DA4E44187507CFFB793F15E8ACFDBFCD9F09B11D616455487E033A30F6CB1B3371FE5188E6B1A5D222CAA86AD9B18C7BB9095270D5A2F69B4F, 0xF7515CD89F5C2E96B101E2CBFCE01A6811AC78E6DD6E221A5DA4E037E3EF076E13DD542B19ED95241C475DF1146CF948A4E05E47000D2EED3DB63F5285CE7ADF610AD35C310A65C2C32A51517EB01426E04E864F203A1D9EAE0AEBC9C7621491A87A54D61E8C54167B39DE5A409091BB912B5B1BA46E84940F83D53657095C49, NULL, NULL, CAST(N'2019-09-25T01:48:39.790' AS DateTime), NULL, NULL, CAST(N'2019-09-25T01:48:39.790' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1015, N'7', 0xC316500BA26B25F3AA217A7A13EB06C9C76064507249F8937046F778AF2F27A93DCDC0B7347A46D1F6FA406897F017E384ED4E29E39A39172127EE5F241004F8, 0x93580418933488F7F90EFE52A5688806317B68E4B4728EA3C328CBD7601639E1464AE2593833DC75F5DB53F777BE9018208D13470C99CEE14EE3F55B8BD81F1CBF945074853839F12F34AA149372915CE5AA0B4B16FFDE02AA9C6CC0360E7180033F76B6D9AB89DF7E5508763E4768EC03D3259C21B6527A7F03691D4DC8EB32, NULL, NULL, CAST(N'2019-09-25T01:52:08.657' AS DateTime), NULL, NULL, CAST(N'2019-09-25T01:52:08.657' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (1016, N'asesinoarif', 0xA7202FFB8910A19105395E24C3F05008F4294940C9692967C4974CA4BC6EFC29E5FDCD98F92DF29A7D0FFA1CB08E1C37084FBD29423E9A90C1FBFDBE364EE15D, 0x5EBC14EB30A09E7D7C139A4238AB563D0943DEC72D79612D2273B13AAD7EF49FE27AA8ED81B6D508FFD3E7B45E82054380B9F12C17C911F69889DAB9654C87B88B5CA1435E5D7D88F073080D3E2EFDF84BBEC388BE6B55344930621A6E236BD7707B034598892513B9462D0478297580F972710019D9EF57A8219A9CEF0480A6, NULL, NULL, CAST(N'2019-09-27T00:31:06.213' AS DateTime), NULL, NULL, CAST(N'2019-09-27T00:31:06.213' AS DateTime), N'I')
SET IDENTITY_INSERT [dbo].[UserLogins] OFF
SET IDENTITY_INSERT [dbo].[UserRoleConfs] ON 

INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (1, 1010, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (2, 1011, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (3, 1012, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (4, 1013, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (5, 1014, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (6, 1015, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (7, 1016, 2)
SET IDENTITY_INSERT [dbo].[UserRoleConfs] OFF
/****** Object:  Index [IX_UserLogin]    Script Date: 9/30/2019 12:32:44 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserLogin] ON [dbo].[UserLogins]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [NMS_DB] SET  READ_WRITE 
GO
