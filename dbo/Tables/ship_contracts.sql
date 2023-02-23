CREATE TABLE [dbo].[ship_contracts] (
    [id]                UNIQUEIDENTIFIER CONSTRAINT [DF_ship_contracts_id] DEFAULT (newid()) NOT NULL,
    [ship_code]         NVARCHAR (100)   NOT NULL,
    [ship_purpose_code] NVARCHAR (100)   NOT NULL,
    [contract_start]    DATE             NOT NULL,
    [contract_end]      DATE             NOT NULL,
    [updated_date]      DATETIME         CONSTRAINT [DF_ship_contracts_updated_date] DEFAULT (getdate()) NOT NULL,
    [updated_by]        UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ship_contracts] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ship_contracts_ship_purposes] FOREIGN KEY ([ship_purpose_code]) REFERENCES [dbo].[ship_purposes] ([code]),
    CONSTRAINT [FK_ship_contracts_ships] FOREIGN KEY ([ship_code]) REFERENCES [dbo].[ships] ([code]),
    CONSTRAINT [FK_ship_contracts_users] FOREIGN KEY ([updated_by]) REFERENCES [dbo].[users] ([id])
);


GO


CREATE TRIGGER [dbo].[TR_ship_contracts_updated_date] on [dbo].[ship_contracts]
AFTER UPDATE
AS
BEGIN
   SET NOCOUNT ON;
   UPDATE [ship_contracts]
   SET updated_date = GETDATE()
   FROM  [ship_contracts] u
   INNER JOIN inserted i ON u.id = i.id
END
