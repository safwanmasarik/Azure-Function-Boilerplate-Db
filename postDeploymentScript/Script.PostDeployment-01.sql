/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 The script will run for every deployment. Hence it's mandatory for the script to be idempotent,
 which means only create data if it does not exist, hence prevent data duplication.
--------------------------------------------------------------------------------------
*/

-- create user super admin if not exist
INSERT INTO [dbo].[users] ([display_name], [email])
SELECT
    'Super Admin' [display_name],
    'superadmin@dummy.com' [email]
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            [dbo].[users]
        WHERE
            display_name = 'Super Admin'
    );

-- set updated_by to user super admin
DECLARE @updated_by uniqueidentifier = (
    SELECT
        id
    FROM
        [dbo].[users]
    WHERE
        display_name = 'Super Admin'
);

-- seed ship data
DECLARE @shipsToSeed TABLE (name nvarchar(100), code nvarchar(100));

INSERT INTO
    @shipsToSeed
VALUES
	('Thousand Sunny', 'thousand-sunny'),
	('Going Merry', 'going-merry'),
	('Oro Jackson', 'oro-jackson'),
	('Red October', 'red-october'),
	('Millennium Falcon', 'millennium-falcon'),
	('Red Force', 'red-force'),
	('Moby Dick', 'moby-dick')
;

WHILE EXISTS (SELECT * FROM @shipsToSeed) 
BEGIN
	
	-- method: table variable
    DECLARE @shipCodeToSeed nvarchar(100) = (SELECT TOP 1 code FROM @shipsToSeed);
	DECLARE @shipNameToSeed nvarchar(100) = (SELECT TOP 1 name FROM @shipsToSeed Where code = @shipCodeToSeed);

    INSERT INTO [dbo].[ships] ([name],[code], [updated_by])
    SELECT
        @shipNameToSeed [name],
        @shipCodeToSeed [code],
        @updated_by [updated_by]
    WHERE
        NOT EXISTS (
            SELECT
                1
            FROM
                [dbo].[ships]
            WHERE
                code = @shipCodeToSeed
        );

    DELETE @shipsToSeed WHERE code = @shipCodeToSeed;

END

-- seed ship purpose data
DECLARE @shipPurposesToSeed TABLE (name nvarchar(100), description nvarchar(100), code nvarchar(100));

INSERT INTO
    @shipPurposesToSeed
VALUES
	('Fishing', 'catch fish food, sell', 'fishing'),
	('Pirating', 'rob gold and selfmade law', 'pirate' ),
	('Passenger', 'carry passenger from origin to destination', 'transport-passenger'),
	('Oil Work', 'oil related works', 'transport-oil'),
	('Maritime Logistic', 'carry sea mens logistics supply', 'maritime-logistic'),
	('Maritime Security', 'enforce sea security', 'maritime-security')
;

WHILE EXISTS (SELECT * FROM @shipPurposesToSeed) 
BEGIN

	-- method: temporary table
	SELECT TOP 1 * INTO #shipPurposeToSeed
	FROM @shipPurposesToSeed

    INSERT INTO
        [dbo].[ship_purposes]
           (
			[name]
           ,[description]
           ,[code]
           ,[updated_by])
    SELECT
        (select top 1 name from #shipPurposeToSeed) [name],
        (select top 1 description from #shipPurposeToSeed) [description],
		(select top 1 code from #shipPurposeToSeed) [code],
        @updated_by [updated_by]
    WHERE
        NOT EXISTS (
            SELECT
                1
            FROM
                [dbo].[ship_purposes]
            WHERE
                code = (select top 1 code from #shipPurposeToSeed)
        );

    DELETE @shipPurposesToSeed WHERE code = (select top 1 code from #shipPurposeToSeed);
	DROP TABLE #shipPurposeToSeed;

END

-- seed ship contracts data (script generated from Sql Studio)
INSERT [dbo].[ship_contracts] ([id], [ship_code], [ship_purpose_code], [contract_start], [contract_end], [updated_date], [updated_by]) VALUES (N'fdfb08fe-a4ad-4b44-b64e-12fe28dcba1d', N'moby-dick', N'pirate', CAST(N'2023-06-21' AS Date), CAST(N'2023-07-21' AS Date), CAST(N'2023-02-28T10:49:49.713' AS DateTime), @updated_by)
GO
INSERT [dbo].[ship_contracts] ([id], [ship_code], [ship_purpose_code], [contract_start], [contract_end], [updated_date], [updated_by]) VALUES (N'010c7715-bf3b-4dc8-9a87-963018f0dbee', N'oro-jackson', N'pirate', CAST(N'2023-07-01' AS Date), CAST(N'2023-12-31' AS Date), CAST(N'2023-02-28T10:54:16.980' AS DateTime), @updated_by)
GO
INSERT [dbo].[ship_contracts] ([id], [ship_code], [ship_purpose_code], [contract_start], [contract_end], [updated_date], [updated_by]) VALUES (N'0976f812-e310-436e-a196-adf66e15ed29', N'oro-jackson', N'fishing', CAST(N'2023-06-01' AS Date), CAST(N'2023-06-30' AS Date), CAST(N'2023-02-28T11:14:19.207' AS DateTime), @updated_by)
GO
INSERT [dbo].[ship_contracts] ([id], [ship_code], [ship_purpose_code], [contract_start], [contract_end], [updated_date], [updated_by]) VALUES (N'953ea378-f70a-4344-85da-c2e5ea03ef69', N'red-force', N'maritime-logistic', CAST(N'2023-07-01' AS Date), CAST(N'2023-12-31' AS Date), CAST(N'2023-02-28T10:53:17.120' AS DateTime), @updated_by)
GO
INSERT [dbo].[ship_contracts] ([id], [ship_code], [ship_purpose_code], [contract_start], [contract_end], [updated_date], [updated_by]) VALUES (N'991bc034-c105-4e8e-bcdc-ce8a1ccb7b68', N'thousand-sunny', N'fishing', CAST(N'2023-07-01' AS Date), CAST(N'2023-12-31' AS Date), CAST(N'2023-02-28T10:53:57.877' AS DateTime), @updated_by)
GO
INSERT [dbo].[ship_contracts] ([id], [ship_code], [ship_purpose_code], [contract_start], [contract_end], [updated_date], [updated_by]) VALUES (N'64947e4f-71c6-468e-8888-e080fdb537e5', N'oro-jackson', N'pirate', CAST(N'2023-05-01' AS Date), CAST(N'2023-05-31' AS Date), CAST(N'2023-02-28T11:01:40.553' AS DateTime), @updated_by)
GO
INSERT [dbo].[ship_contracts] ([id], [ship_code], [ship_purpose_code], [contract_start], [contract_end], [updated_date], [updated_by]) VALUES (N'63a750b6-4e1e-4551-97ac-fbee23fdc4f7', N'red-force', N'maritime-security', CAST(N'2023-01-01' AS Date), CAST(N'2023-06-30' AS Date), CAST(N'2023-02-28T10:52:57.593' AS DateTime), @updated_by)
GO
