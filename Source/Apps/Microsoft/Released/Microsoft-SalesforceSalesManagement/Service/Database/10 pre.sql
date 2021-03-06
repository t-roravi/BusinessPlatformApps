SET ANSI_NULLS              ON;
SET ANSI_PADDING            ON;
SET ANSI_WARNINGS           ON;
SET ANSI_NULL_DFLT_ON       ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER       ON;
go

-- Must be executed inside the target database

DECLARE @stmt AS VARCHAR(500), @p1 AS VARCHAR(100), @p2 AS VARCHAR(100);
DECLARE @cr CURSOR;

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='configuration' AND TABLE_TYPE='BASE TABLE')
BEGIN
	DECLARE @additionalTables NVARCHAR(MAX);
	SELECT @additionalTables = [value]
	FROM smgt.[configuration] WHERE configuration_group = 'SolutionTemplate' AND configuration_subgroup = 'SalesManagement' AND [name] = 'AdditionalTables';
SET @cr = CURSOR FAST_FORWARD FOR
              SELECT [value] FROM STRING_SPLIT(@additionalTables,',')
		
IF(@additionalTables <> '')
BEGIN
OPEN @cr;
FETCH NEXT FROM @cr INTO @p1;
WHILE @@FETCH_STATUS = 0  
BEGIN 
    SET @stmt = 'IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=''dbo'' AND TABLE_NAME='''+REPLACE(REPLACE(QuoteName(@p1),'[',''),']','')+''' AND TABLE_TYPE=''BASE TABLE'') DROP TABLE dbo.' + QuoteName(@p1);
	EXEC (@stmt);
	SET @stmt = 'IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA=''dbo'' AND ROUTINE_NAME=''spMerge'+REPLACE(REPLACE(QuoteName(@p1),'[',''),']','')+''' AND ROUTINE_TYPE=''PROCEDURE'')   DROP PROCEDURE dbo.spMerge'+ REPLACE(REPLACE(QuoteName(@p1),'[',''),']','');
	EXEC (@stmt);
	SET @stmt = 'IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA=''dbo'' AND DOMAIN_NAME='''+REPLACE(REPLACE(QuoteName(@p1),'[',''),']','')+'type'' ) DROP TYPE dbo.'+ REPLACE(REPLACE(QuoteName(@p1),'[',''),']','')+'type';
	EXEC (@stmt);
	FETCH NEXT FROM @cr INTO @p1;
END;
CLOSE @cr;
DEALLOCATE @cr;
END;
END;

-- Regular views
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='accountview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.accountview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='actualsalesview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.actualsalesview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='businessunitview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.businessunitview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='dateview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.dateview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='leadview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.leadview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='measuresview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.measuresview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='opportunityproductview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.opportunityproductview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='opportunityview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.opportunityview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='productview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.productview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='quotaview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.quotaview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='targetview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.targetview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='tempuserview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.tempuserview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='territoryview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.territoryview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='usermappingview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.usermappingview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='userview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.userview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='userascendantsview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.userascendantsview;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='configurationview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.configurationview;

-- Tables
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='actualsales' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.actualsales;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='configuration' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.configuration;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='date' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.[date];
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='quotas' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.quotas;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='targets' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.targets;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='usermapping' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.usermapping;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='entityinitialcount' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE smgt.entityinitialcount;

-- Tables
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='account' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE dbo.account;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='lead' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE dbo.lead;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='opportunity' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE dbo.opportunity;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='opportunitylineitem' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE dbo.opportunitylineitem;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='opportunitystage' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE dbo.opportunitystage;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='product2' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.product2;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='user' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE dbo.[user];
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='userrole' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE dbo.userrole;

-- Stored procedures
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='spMergeOpportunity' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.spMergeOpportunity;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='spMergeAccount' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.spMergeAccount;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='spMergeLead' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.spMergeLead;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='spMergeOpportunityLineItem' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.spMergeOpportunityLineItem;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='spMergeOpportunityStage' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.spMergeOpportunityStage;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='spMergeProduct2' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.spMergeProduct2;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='spMergeUserRole' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.spMergeUserRole;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='spMergeUser' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.spMergeUser;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='sp_get_replication_counts' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.sp_get_replication_counts;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='sp_get_prior_content' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.sp_get_prior_content;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='sp_get_pull_status' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.sp_get_pull_status;

-- Types
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA='dbo' AND DOMAIN_NAME='opportunitytype' )
	DROP TYPE dbo.opportunitytype
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA='dbo' AND DOMAIN_NAME='accounttype' )
	DROP TYPE dbo.accounttype
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA='dbo' AND DOMAIN_NAME='leadtype' )
	DROP TYPE dbo.leadtype
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA='dbo' AND DOMAIN_NAME='opportunitylineitemtype' )
	DROP TYPE dbo.opportunitylineitemtype
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA='dbo' AND DOMAIN_NAME='opportunitystagetype' )
	DROP TYPE dbo.opportunitystagetype
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA='dbo' AND DOMAIN_NAME='product2type' )
	DROP TYPE dbo.product2type
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA='dbo' AND DOMAIN_NAME='userroletype' )
	DROP TYPE dbo.userroletype
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA='dbo' AND DOMAIN_NAME='usertype' )
	DROP TYPE dbo.usertype

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='smgt')
BEGIN
    EXEC ('CREATE SCHEMA smgt AUTHORIZATION dbo'); -- Avoid batch error
END;