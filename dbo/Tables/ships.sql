CREATE TABLE [dbo].[ships] (
    [id]           INT              IDENTITY (1, 1) NOT NULL,
    [name]         NVARCHAR (100)   NOT NULL,
    [code]         NVARCHAR (100)   NOT NULL,
    [is_active]    BIT              CONSTRAINT [DF_ships_is_active] DEFAULT ((1)) NOT NULL,
    [updated_date] DATETIME         CONSTRAINT [DF_ships_updated_date] DEFAULT (getdate()) NOT NULL,
    [updated_by]   UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ships] PRIMARY KEY CLUSTERED ([code] ASC),
    CONSTRAINT [FK_ships_users] FOREIGN KEY ([updated_by]) REFERENCES [dbo].[users] ([id])
);


GO

CREATE TRIGGER [dbo].[TR_ships_updated_date] on [dbo].[ships]
AFTER UPDATE
AS
BEGIN
   SET NOCOUNT ON;
   UPDATE [ships]
   SET updated_date = GETDATE()
   FROM  [ships] u
   INNER JOIN inserted i ON u.id = i.id
END
