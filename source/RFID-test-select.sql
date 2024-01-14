-- Přůměrný počet záznamů na jednu tabulku
USE `RFID`;
SELECT AVG(row_count) as average_rows_per_table FROM 
(
    SELECT COUNT(*) as row_count FROM chips
    UNION ALL
    SELECT COUNT(*) FROM emploies
    UNION ALL
    SELECT COUNT(*) FROM rightsGroups
    UNION ALL
    SELECT COUNT(*) FROM accessGroups
    UNION ALL
    SELECT COUNT(*) FROM doorsGroups
    UNION ALL
    SELECT COUNT(*) FROM doors
    UNION ALL
    SELECT COUNT(*) FROM timeGroups
    UNION ALL
    SELECT COUNT(*) FROM daysGroups
    UNION ALL
    SELECT COUNT(*) FROM days
    UNION ALL
    SELECT COUNT(*) FROM logs
) AS counts;


-- Nvořený select
USE `RFID`; SELECT `days`.`day` FROM `days` WHERE `days`.`dayID` IN (
    SELECT `daysGroups`.`dayID` FROM `daysGroups` WHERE `daysGroups`.`tGroupID` IN (
        SELECT `timeGroups`.`TGroupID` FROM `timeGroups` WHERE `timeGroups`.`tGroupID` = 1
    )
);

-- Rekurze
SELECT e.firstname, e.lastname, d.day, tg.timeFrom, tg.timeTo, dr.MAC, dr.description FROM emploies e
	INNER JOIN rightsGroups 
    AS rg 
    ON rg.employeID = e.employeID 
    	INNER JOIN timeGroups 
        as tg 
        ON rg.timeGroup = tg.tGroupID 
        	INNER JOIN daysGroups 
            as dg 
            ON tg.tGroupID = dg.tGroupID 
            	LEFT OUTER JOIN days 
                as d 
                ON d.dayID = dg.dayID
                	INNER JOIN
                    accessGroups 
                    as ag
                    on ag.aGroupID = rg.accessGroup
                    	INNER JOIN
                        doorsGroups
                        as drg
                        ON drg.aGroupID = ag.aGroupID
                        	LEFT OUTER JOIN
                            doors
                            as dr
                            ON dr.doorID = drg.doorID;


