CREATE TABLE [dbo].[users] (
    [id]           UNIQUEIDENTIFIER CONSTRAINT [DF_users_id] DEFAULT (newid()) NOT NULL,
    [display_name] NVARCHAR (100)   NOT NULL,
    [email]        NVARCHAR (100)   NOT NULL,
    [is_active]    BIT              CONSTRAINT [DF_users_is_active] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_users_email] UNIQUE NONCLUSTERED ([email] ASC)
);

