/* Drop old DB*/
DROP DATABASE IF EXISTS `RFID`;

/* Create new DB and select it */
CREATE DATABASE `RFID`;
USE `RFID`;

/* Create tables*/
CREATE TABLE `chips` (
  `chipID` int PRIMARY KEY AUTO_INCREMENT,
  `macCode` text
  `enabled` int(1) NOT NULL
);

CREATE TABLE `emploies` (
  `employeID` int PRIMARY KEY AUTO_INCREMENT,
  `chipID` int,
  `firstname` VARCHAR(255),
  `lastname` VARCHAR(255)
  `employed` int(1) NOT NULL
);

CREATE TABLE `rightsGroups` (
  `employeID` int,
  `accessGroup` int,
  `timeGroup` int
);
CREATE TABLE `accessGroups` (
  `aGroupID` int PRIMARY KEY AUTO_INCREMENT,
  `description` text
);
CREATE TABLE `doorsGroups` (
  `aGroupID` int,
  `doorID` int
);
CREATE TABLE `doors` (
  `doorID` int PRIMARY KEY AUTO_INCREMENT,
  `MAC` text NOT NULL,
  `description` text
);
CREATE TABLE `timeGroups` (
  `tGroupID` int PRIMARY KEY AUTO_INCREMENT,
  `timeFrom` time,
  `timeTo` time
);
CREATE TABLE `daysGroups` (
  `tGroupID` int,
  `dayID` int
);
CREATE TABLE `days` (
  `dayID` int PRIMARY KEY AUTO_INCREMENT,
  `day` text
);
CREATE TABLE `logs` (
  `logID` int PRIMARY KEY AUTO_INCREMENT,
  `chipID` int NOT NULL,
  `doorID` int NOT NULL ,
  `date` date NOT NULL,
  `time` time NOT NULL
);

/* Create references*/
ALTER TABLE `rightsGroups` ADD FOREIGN KEY (`employeID`) REFERENCES `emploies` (`employeID`);
ALTER TABLE `emploies` ADD FOREIGN KEY (`chipID`) REFERENCES `chips` (`chipID`);
ALTER TABLE `rightsGroups` ADD FOREIGN KEY (`accessGroup`) REFERENCES `accessGroups` (`aGroupID`);
ALTER TABLE `rightsGroups` ADD FOREIGN KEY (`timeGroup`) REFERENCES `timeGroups` (`tGroupID`);
ALTER TABLE `logs` ADD FOREIGN KEY (`chipID`) REFERENCES `chips` (`chipID`);
ALTER TABLE `logs` ADD FOREIGN KEY (`doorID`) REFERENCES `doors` (`doorID`);
ALTER TABLE `daysGroups` ADD FOREIGN KEY (`tGroupID`) REFERENCES `timeGroups` (`tGroupID`);
ALTER TABLE `daysGroups` ADD FOREIGN KEY (`dayID`) REFERENCES `days` (`dayID`);
ALTER TABLE `doorsGroups` ADD FOREIGN KEY (`doorID`) REFERENCES `doors` (`doorID`);
ALTER TABLE `doorsGroups` ADD FOREIGN KEY (`aGroupID`) REFERENCES `accessGroups` (`aGroupID`);

CREATE INDEX idx_chipID ON logs(chipID);
CREATE INDEX idx_lastname_firstname ON emploies(lastname(255), firstname(255));

DELIMITER //
CREATE PROCEDURE CreateUserAndAssignChip(
    IN firstName VARCHAR(255),
    IN lastName VARCHAR(255),
    IN macCode TEXT,
    IN accessGroupID INT,
    IN timeGroupID INT
)
BEGIN
    DECLARE newChipID INT;
    DECLARE newEmployeeID INT;

    -- Insert a new chip
    INSERT INTO chips (macCode) VALUES (macCode);
    SET newChipID = LAST_INSERT_ID();

    -- Insert a new employee
    INSERT INTO emploies (chipID, firstname, lastname) VALUES (newChipID, firstName, lastName);
    SET newEmployeeID = LAST_INSERT_ID();

    -- Insert into rightsGroups
    INSERT INTO rightsGroups (employeID, accessGroup, timeGroup) VALUES (newEmployeeID, accessGroupID, timeGroupID);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER after_employe_update
AFTER UPDATE ON emploies
FOR EACH ROW
BEGIN
    IF OLD.employed <> NEW.employed AND NEW.employed = 0 THEN
        UPDATE chips
        SET enabled = 0
        WHERE chipID = NEW.chipID;
    END IF;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE FindDayWithMostAccesses()
BEGIN
    SELECT `date`, COUNT(*) as access_count
    FROM logs
    GROUP BY `date`
    ORDER BY access_count DESC
    LIMIT 1;
END //

DELIMITER ;
