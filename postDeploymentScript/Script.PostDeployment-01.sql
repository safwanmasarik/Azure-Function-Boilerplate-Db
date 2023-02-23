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
