CREATE TABLE [dbo].[ship_purposes] (
    [id]           UNIQUEIDENTIFIER CONSTRAINT [DF_ship_purposes_id] DEFAULT (newid()) NOT NULL,
    [name]         NVARCHAR (100)   NOT NULL,
    [description]  NVARCHAR (200)   NULL,
    [code]         NVARCHAR (100)   NOT NULL,
    [is_active]    BIT              CONSTRAINT [DF_ship_purposes_is_active] DEFAULT ((1)) NOT NULL,
    [updated_date] DATETIME         CONSTRAINT [DF_ship_purposes_updated_date] DEFAULT (getdate()) NOT NULL,
    [updated_by]   UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ship_purposes] PRIMARY KEY CLUSTERED ([code] ASC),
    CONSTRAINT [FK_ship_purposes_users] FOREIGN KEY ([updated_by]) REFERENCES [dbo].[users] ([id])
);




GO
CREATE TRIGGER [dbo].[TR_ship_purposes_updated_date] on dbo.ship_purposes
AFTER UPDATE
AS
BEGIN
   SET NOCOUNT ON;
   UPDATE [ship_purposes]
   SET updated_date = GETDATE()
   FROM  [ship_purposes] u
   INNER JOIN inserted i ON u.id = i.id
END
