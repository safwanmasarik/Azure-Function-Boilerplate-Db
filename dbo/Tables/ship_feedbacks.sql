CREATE TABLE [dbo].[ship_feedbacks] (
    [id]           INT              IDENTITY (1, 1) NOT NULL,
    [ship_code]    NVARCHAR (100)   NOT NULL,
    [comment]      NVARCHAR (MAX)   NOT NULL,
    [is_star]      BIT              CONSTRAINT [DF_ship_feedbacks_is_star] DEFAULT ((0)) NOT NULL,
    [is_active]    BIT              CONSTRAINT [DF_ship_feedbacks_is_active] DEFAULT ((1)) NOT NULL,
    [updated_date] DATETIME         CONSTRAINT [DF_ship_feedbacks_updated_date] DEFAULT (getdate()) NOT NULL,
    [updated_by]   UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ship_feedbacks] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ship_feedbacks_ships] FOREIGN KEY ([ship_code]) REFERENCES [dbo].[ships] ([code]),
    CONSTRAINT [FK_ship_feedbacks_users] FOREIGN KEY ([updated_by]) REFERENCES [dbo].[users] ([id])
);


GO


CREATE TRIGGER [dbo].[TR_ship_feedbacks_updated_date] on [dbo].[ship_feedbacks]
AFTER UPDATE
AS
BEGIN
   SET NOCOUNT ON;
   UPDATE [ship_feedbacks]
   SET updated_date = GETDATE()
   FROM  [ship_feedbacks] u
   INNER JOIN inserted i ON u.id = i.id
END
