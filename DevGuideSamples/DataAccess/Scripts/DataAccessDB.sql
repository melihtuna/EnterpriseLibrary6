IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'BUILTIN\Users')
CREATE USER [BUILTIN\Users] FOR LOGIN [BUILTIN\Users]
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'BUILTIN\Administrators')
CREATE USER [BUILTIN\Administrators] FOR LOGIN [BUILTIN\Administrators]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[LastName] [nvarchar](50) NULL,
	[FirstName] [nvarchar](50) NULL,
	[PasswordHash] [nchar](64) NOT NULL,
	[PasswordSalt] [nchar](64) NOT NULL,
	[ApiKey] [nvarchar](50) NULL,
	[Description] [nvarchar](400) NULL,
	[UserTypeId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShippingOptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShippingOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[PriceAmount] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[States]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[States](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](400) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Offerings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Offerings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RetailerId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[PriceAmount] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	[IsFeatured] [bit] NOT NULL DEFAULT ((0)),
	[Comments] [nvarchar](400) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CartItems]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CartItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[OfferingId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Status] [nvarchar](10) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreditCardName] [nvarchar](30) NULL,
	[CreditCardNumber] [nchar](16) NULL,
	[CreditCardExpiryMonth] [nchar](2) NULL,
	[CreditCardExpiryYear] [nchar](2) NULL,
	[ShipStreet] [nvarchar](50) NULL,
	[ShipCity] [nvarchar](30) NULL,
	[ShipStateId] [int] NULL,
	[ShipZipCode] [nchar](5) NULL,
	[ShippingOptionId] [int] NULL,
	[BillStreet] [nvarchar](50) NULL,
	[BillCity] [nvarchar](30) NULL,
	[BillStateId] [int] NULL,
	[BillZipCode] [nchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderLines]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderLines](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[OfferingId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[TrackingNumber] [nvarchar](25) NULL,
	[HasShipped] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[OrderList]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[OrderList]
AS
SELECT        dbo.Orders.Id, dbo.Orders.Status, dbo.Orders.CreatedOn, dbo.Products.Name, dbo.Users.LastName, dbo.Users.FirstName, dbo.Orders.ShipStreet, 
                         dbo.Orders.ShipCity, dbo.Orders.ShipZipCode, dbo.ShippingOptions.Name AS ShippingOption, dbo.States.Name AS State
FROM            dbo.Orders INNER JOIN
                         dbo.Products ON dbo.Orders.Id = dbo.Products.Id INNER JOIN
                         dbo.Users ON dbo.Orders.CustomerId = dbo.Users.Id INNER JOIN
                         dbo.States ON dbo.Orders.ShipStateId = dbo.States.Id INNER JOIN
                         dbo.ShippingOptions ON dbo.Orders.ShippingOptionId = dbo.ShippingOptions.Id
' 
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'OrderList', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Orders"
            Begin Extent = 
               Top = 5
               Left = 273
               Bottom = 196
               Right = 486
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 29
               Left = 539
               Bottom = 164
               Right = 709
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 133
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "States"
            Begin Extent = 
               Top = 6
               Left = 732
               Bottom = 99
               Right = 902
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ShippingOptions"
            Begin Extent = 
               Top = 102
               Left = 732
               Bottom = 212
               Right = 902
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin Criteri' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'OrderList'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'dbo', N'VIEW',N'OrderList', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'aPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'OrderList'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'OrderList', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'OrderList'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStatesList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetStatesList]
AS
	SELECT [Name] FROM States
	RETURN
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProductsSlowly]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetProductsSlowly]
	@searchString varchar(30),
	@maxID int
AS
  WAITFOR DELAY ''00:00:05'' 
  SELECT * FROM Products WHERE [ID] <= @maxID AND [Name] LIKE @searchString 
	RETURN' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateProductsTable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateProductsTable]
	@productID int,
	@description varchar(400)
AS
	UPDATE Products SET [Description] = @description WHERE [Id] = @productID
	RETURN
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProductList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetProductList]
	@searchString varchar(30)
AS
  SELECT * FROM Products WHERE [Name] LIKE @searchString
	RETURN
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListOrdersByState]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ListOrdersByState]
	@state varchar(30)
AS
	SELECT * FROM OrderList WHERE State = @state
	RETURN
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListOrdersSlowly]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ListOrdersSlowly]
	@state varchar(30),
	@status varchar(10)
AS
  WAITFOR DELAY ''00:00:05'' 
	SELECT * FROM OrderList WHERE State = @state AND Status = @status
	RETURN
' 
END
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__Users__UserTypeI__03317E3D]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([UserTypeId]=(2) OR [UserTypeId]=(1) OR [UserTypeId]=(0)))
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Offering_Product]') AND parent_object_id = OBJECT_ID(N'[dbo].[Offerings]'))
ALTER TABLE [dbo].[Offerings]  WITH CHECK ADD  CONSTRAINT [Offering_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[Offerings] CHECK CONSTRAINT [Offering_Product]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Offering_Retailer]') AND parent_object_id = OBJECT_ID(N'[dbo].[Offerings]'))
ALTER TABLE [dbo].[Offerings]  WITH CHECK ADD  CONSTRAINT [Offering_Retailer] FOREIGN KEY([RetailerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Offerings] CHECK CONSTRAINT [Offering_Retailer]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[CartItem_Customer]') AND parent_object_id = OBJECT_ID(N'[dbo].[CartItems]'))
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD  CONSTRAINT [CartItem_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CartItems] CHECK CONSTRAINT [CartItem_Customer]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[CartItem_Offering]') AND parent_object_id = OBJECT_ID(N'[dbo].[CartItems]'))
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD  CONSTRAINT [CartItem_Offering] FOREIGN KEY([OfferingId])
REFERENCES [dbo].[Offerings] ([Id])
GO
ALTER TABLE [dbo].[CartItems] CHECK CONSTRAINT [CartItem_Offering]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Order_BillState]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders]'))
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [Order_BillState] FOREIGN KEY([BillStateId])
REFERENCES [dbo].[States] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [Order_BillState]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Order_Customer]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders]'))
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [Order_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [Order_Customer]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Order_ShippingOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders]'))
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [Order_ShippingOption] FOREIGN KEY([ShippingOptionId])
REFERENCES [dbo].[ShippingOptions] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [Order_ShippingOption]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Order_ShipState]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders]'))
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [Order_ShipState] FOREIGN KEY([ShipStateId])
REFERENCES [dbo].[States] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [Order_ShipState]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[OrderLine_Offering]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderLines]'))
ALTER TABLE [dbo].[OrderLines]  WITH CHECK ADD  CONSTRAINT [OrderLine_Offering] FOREIGN KEY([OfferingId])
REFERENCES [dbo].[Offerings] ([Id])
GO
ALTER TABLE [dbo].[OrderLines] CHECK CONSTRAINT [OrderLine_Offering]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[OrderLine_Order]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderLines]'))
ALTER TABLE [dbo].[OrderLines]  WITH CHECK ADD  CONSTRAINT [OrderLine_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[OrderLines] CHECK CONSTRAINT [OrderLine_Order]
