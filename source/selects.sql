/* Mega select */



/* Group days*/
CREATE VIEW `DaysCount` AS
SELECT e.firstname, e.lastname,count(d.dayID) from days d
	INNER JOIN daysGroups
    as dg
    on d.dayID = dg.dayID
    	INNER JOIN timeGroups
        AS tg
        on tg.tGroupID = dg.tGroupID
        	INNER JOIN rightsGroups
            as rg
            on rg.timeGroup = tg.tGroupID
            	INNER JOIN emploies
                as e
                on e.employeID = rg.employeID
        		GROUP BY e.employeID;


/* Count door by group */
CREATE VIEW `DoorsCount` AS
SELECT ag.description,count(d.`doorID`) from doors d
	INNER JOIN doorsGroups
    as dg
    on d.doorID = dg.doorID
    	INNER JOIN accessGroups
        AS ag
        on ag.aGroupID = dg.aGroupID
        GROUP BY ag.description DESC;


/* Count access per day */ 
SELECT emploies.firstname, emploies.lastname, chips.macCode, logs.date, COUNT(logs.date) FROM logs
    INNER JOIN chips
    ON logs.chipID = chips.chipID
        INNER JOIN emploies
        on chips.chipID = emploies.chipID
        GROUP BY chips.macCode
        ORDER BY COUNT(logs.date) DESC;


/* Count access per door */
SELECT emploies.firstname, emploies.lastname, chips.macCode, logs.date, doors.description, COUNT(logs.doorID) FROM logs
    INNER JOIN chips
    ON logs.chipID = chips.chipID
        INNER JOIN emploies
        on chips.chipID = emploies.chipID
            INNER JOIN doors
            on doors.doorID = logs.doorID
            GROUP BY doors.description
            ORDER BY COUNT(logs.date) DESC;