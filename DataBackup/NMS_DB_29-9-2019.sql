USE [master]
GO
/****** Object:  Database [NMS_DB]    Script Date: 9/29/2019 9:08:56 AM ******/
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
/****** Object:  User [sql_nms]    Script Date: 9/29/2019 9:08:57 AM ******/
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
/****** Object:  Table [dbo].[AnnualRequirements]    Script Date: 9/29/2019 9:08:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
/****** Object:  Table [dbo].[CurrencyRates]    Script Date: 9/29/2019 9:08:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CurrencyRates](
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
/****** Object:  Table [dbo].[EmployeeInfos]    Script Date: 9/29/2019 9:08:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ImporterInfos]    Script Date: 9/29/2019 9:08:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProformaInvoiceDtls]    Script Date: 9/29/2019 9:08:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProformaInvoiceMsts]    Script Date: 9/29/2019 9:08:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleInfos]    Script Date: 9/29/2019 9:08:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserLogins]    Script Date: 9/29/2019 9:08:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRoleConfs]    Script Date: 9/29/2019 9:08:57 AM ******/
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
SET IDENTITY_INSERT [dbo].[ImporterInfos] ON 

INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (31, N'Apple Inc.', N'Team Cook', N'Ceo', N'+5545487877778', N'Dhaka', N'Dhaka', N'Dhaka City', N'California', N'Farm', N'7878464646', N'Resources\ImporterInfoFiles\c5586286-b067-4dd1-9b78-5715a0992fcd.pdf', N'78799797986536448', N'Resources\ImporterInfoFiles\4f4dd143-e902-4a3e-a653-7121636564c4.pdf', N'Resources\ImporterInfoFiles\c0f0c076-2431-44f5-81ae-6c198fe60376.pdf', 31, N'team@apple.inc', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (32, N'Microsoft Corporation', N'Bill Gates', N'Chairman', N'+5545487877778', N'Barishal', N'Patuakhali', N'Galachipa', N'Jakson heights', N'Category 2', N'7878464646', N'Resources\ImporterInfoFiles\9c4a2d05-99b5-49ab-b99f-e8b09b70d7b9.pdf', N'78799797986536448', N'Resources\ImporterInfoFiles\af3ae43b-f220-4933-a935-20661c36853a.pdf', N'Resources\ImporterInfoFiles\02d5af77-3cc4-49f1-a66f-00d35f07a5c9.pdf', 32, N'gates@milinda.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (33, N'Sysnet IT', N'Kader Gang', N'Sales Executive', N'01521570000', N'Sylhet', N'Moulvibazar', N'Juri', N'Sylhet', N'Feed Meal', N'7878464646', N'Resources\ImporterInfoFiles\838780f5-5444-4e6f-abfd-3a97cc783638.pdf', N'78799797986536448', N'Resources\ImporterInfoFiles\7ae93bf1-00a1-4bee-b5ce-a1d0888ad86b.pdf', N'Resources\ImporterInfoFiles\2d8dd5aa-186c-4bf6-b49d-71992145f67e.pdf', 33, N'kader@gang.com', NULL)
INSERT [dbo].[ImporterInfos] ([Id], [OrgName], [ContactName], [Position], [ContactNo], [Division], [District], [Upazila], [Address], [DlsLicenseType], [DlsLicenseNo], [DlsLicenseScan], [NidNo], [NidScan], [IrcScan], [UserId], [Email], [ImpCode]) VALUES (34, N'Kashem Agro', N'Kashem Khan', N'Ceo', N'01711454545', N'Dhaka', N'Dhaka', N'Dhamrai', N'Dhaka, Bangladesh', N'Feed Meal', N'7878464646', N'Resources\ImporterInfoFiles\dda1b0da-a471-4342-820b-c109418ef4fa.pdf', N'78799797986536448', N'Resources\ImporterInfoFiles\5d2976d0-ca61-4bf0-9d6e-85c32381f81f.pdf', N'Resources\ImporterInfoFiles\387b4534-6bd5-4020-9291-79bd643e54ea.pdf', 34, N'kashem@gmail.com', NULL)
SET IDENTITY_INSERT [dbo].[ImporterInfos] OFF
SET IDENTITY_INSERT [dbo].[RoleInfos] ON 

INSERT [dbo].[RoleInfos] ([Id], [Name]) VALUES (1, N'Admin')
INSERT [dbo].[RoleInfos] ([Id], [Name]) VALUES (2, N'Importer')
SET IDENTITY_INSERT [dbo].[RoleInfos] OFF
SET IDENTITY_INSERT [dbo].[UserLogins] ON 

INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (31, N'team', 0x47832316A15B03298B9193765A7BFB75A7066F57F29F17FADA8907873F353201AA06F11918A6F84800FEB3A1F54037FA8E27FA32BC6DB68E57B68A5C2DEA0000, 0xFBE6646E4B1459421E3FD078AF4ADCF21289D2D2CD6A5C5D63711004FB20FB188B4723D7F2D1297C7C28D4DF7645DA5908D330BEDFB97EA7ADFB963D479C78F7F7990C358A3EB7ACD22C5CCE2F59D5DCAE2EB231A2A80FCEB94CA362C0CB6EF374694239106804DE090EEB1117DBFDD7827E3DB39059A87172FA297597573DF3, NULL, NULL, CAST(N'2019-09-24 10:57:31.617' AS DateTime), NULL, NULL, CAST(N'2019-09-24 10:57:31.617' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (32, N'gates', 0xAC2F88796060A99372139B9F5AAA7462D57B6B29AB3E8018324C82FFEE0BE22685212200EA8E1B66D913327395F6951433DD08F2CC4B61C5E0551AEED5FE8A6A, 0x055585E437657A15E74E8DBD6BABF4AE6061C7B889FE93DCCEFD112FBD085129ABE8E840D8CA4D27092F0A46EFCB288B3356ACF8749245406B8DA072908D38541FFA9F81E8027199C2D1C814E286A72196439B23E00955BBFD11F7985ACC6AE78E419C2461C688C3C9748C2D415C613618E36D02D4CD8CAEE4734B78820929DA, NULL, NULL, CAST(N'2019-09-24 15:38:48.160' AS DateTime), NULL, NULL, CAST(N'2019-09-24 15:38:48.160' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (33, N'kader', 0x8711EBA1A553EBD2EB12F9836F4D7F1AF855CA0E97E5ECC681115CDFB35B51AA3665EBCCE159F1060940C17E336A7A0084EF57F920854BEFAF00646D8F11A11D, 0xED8E19F72E4526BB958EE9D30812ED4EE9DF42C2DB63A8BFBA9DD5384A14832648290EEF40D35E9525D7EEAF333B1F39F19EFD6E87AA744AAA098E30D7CF96A2A1117B0204EF9582A5D4A28B406BFEB54A68147BCF3B26EC96585B66DC4F8A01C65CA0A7E2B0919E3AE2A3A3C84852032CBB5EDA22E44497ABECA8865EEC881D, NULL, NULL, CAST(N'2019-09-25 09:07:20.293' AS DateTime), NULL, NULL, CAST(N'2019-09-25 09:07:20.293' AS DateTime), N'I')
INSERT [dbo].[UserLogins] ([Id], [Username], [PasswordHash], [PasswordSalt], [CreatedBy], [CreatedTerminal], [CreatedDate], [UpdatedBy], [UpdatedTerminal], [UpdatedDate], [UserType]) VALUES (34, N'kashem', 0xD8EB605717AD9C0E4A03D0AE4BD9C538F5DF8A438223BCF7F905DA199E9E287212B39712F3AEDF17296F2F540D2ED0BF97A7B7756C122F5350F34FFB5F6E8CCB, 0x517FD387AE616699AC7883E5B3AA7D78BDE2FB2BCABF857F88DA1B427F50807F4E7B0B1A99B9AB042AACE11B6B30192E268A1BD9DF76584D7261024778CD7B7CBC5928B1C558408ACB2DCB5920E8FDA94F606E43C7FFD56E769D15B787E48415B258B3DEE22932381833B0A5FDBA1CF2FA979114CB679529F10725AA0D755BE6, NULL, NULL, CAST(N'2019-09-25 16:44:57.757' AS DateTime), NULL, NULL, CAST(N'2019-09-25 16:44:57.757' AS DateTime), N'I')
SET IDENTITY_INSERT [dbo].[UserLogins] OFF
SET IDENTITY_INSERT [dbo].[UserRoleConfs] ON 

INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (1, 31, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (2, 32, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (3, 33, 2)
INSERT [dbo].[UserRoleConfs] ([Id], [UserId], [RoleId]) VALUES (4, 34, 2)
SET IDENTITY_INSERT [dbo].[UserRoleConfs] OFF
/****** Object:  Index [IX_UserLogin]    Script Date: 9/29/2019 9:08:58 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserLogin] ON [dbo].[UserLogins]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [NMS_DB] SET  READ_WRITE 
GO
