CREATE DATABASE CruiseShipDatabase;

DROP TABLE IF EXISTS Ship;
DROP TABLE IF EXISTS Crew;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS PassengersReservations;
DROP TABLE IF EXISTS Cruises;
DROP TABLE IF EXISTS RoomCategory;
DROP TABLE IF EXISTS ActivityReservations;
DROP TABLE IF EXISTS Activity;
DROP TABLE IF EXISTS Rooms;


--Ship information table
CREATE TABLE IF NOT EXISTS Ship(
	ShipID SERIAL NOT NULL UNIQUE,
	ShipName VARCHAR(30) NOT NULL,
	PRIMARY KEY (ShipID)
);

INSERT INTO Ship(ShipName) VALUES('The Star Ship');
INSERT INTO Ship(ShipName) VALUES('The Liberty Cruise');
INSERT INTO Ship(ShipName) VALUES('Allure of the Seas');

--SELECT * FROM ship;


--Crew information table
CREATE TABLE IF NOT EXISTS Crew (
	CrewID SERIAL NOT NULL UNIQUE,
	CrewDetails VARCHAR(200),
	PRIMARY KEY(CrewID)
);


INSERT INTO Crew(CrewDetails) VALUES ('Crew One');
INSERT INTO Crew(CrewDetails) VALUES ('Crew Jsap');

--SELECT * FROM Crew;


--Activity list/information table, contains one time activity charge
CREATE TABLE IF NOT EXISTS Activity (
	ActivityID SERIAL NOT NULL UNIQUE,
	ActivityCategory VARCHAR(100) NOT NULL,
	ActivityCharge NUMERIC(15,2) NOT NULL,
	ActivityDesc VARCHAR(200),
	PRIMARY KEY(ActivityID)
);

INSERT INTO Activity(ActivityCategory, ActivityCharge, activityDesc)
VALUES ('Sports', 100, 'Dive into the ocean!');

INSERT INTO Activity(ActivityCategory, ActivityCharge, activityDesc)
VALUES ('Sports', 499.99, 'MiniGolf on the cruise deck!');

INSERT INTO Activity(ActivityCategory, ActivityCharge, activityDesc)
VALUES ('Sports', 10000.99, 'Underwater Shark Cage!');

--SELECT * FROM Activity;


--Passenger information table
CREATE TABLE IF NOT EXISTS Passengers (
	PassengerID SERIAL NOT NULL UNIQUE,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	Gender CHAR(1) NOT NULL,
	Address VARCHAR(100),
	PRIMARY KEY (PassengerID)
);


INSERT INTO Passengers (FirstName, LastName, Gender)
VALUES ('First', 'Passenger', 'M');

INSERT INTO Passengers (FirstName, LastName, Gender)
VALUES ('Second', 'Passenger', 'F');

INSERT INTO Passengers (FirstName, LastName, Gender)
VALUES ('Last', 'Passenger', 'F');

--SELECT * FROM Passengers;


--Cruise information table, contains Cruise start and end dates, as well link to ship information through shipid
CREATE TABLE IF NOT EXISTS Cruises (
	CruiseID SERIAL NOT NULL UNIQUE,
	ShipID INTEGER NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	PRIMARY KEY (CruiseID),
	FOREIGN KEY (ShipID) REFERENCES Ship(ShipID)
);


INSERT INTO Cruises (ShipID, StartDate, EndDate)
VALUES (1, '10/10/2016', '10/11/2016');

INSERT INTO Cruises (ShipID, StartDate, EndDate)
VALUES (1, '12/12/2016', '1/1/2017');


--SELECT * FROM Cruises;


--Room category table. Cruise rooms are priced through the category.
CREATE TABLE IF NOT EXISTS RoomCategory (
	RoomCategoryCode CHAR(5) NOT NULL UNIQUE,
	CruiseCharge NUMERIC(15,2) NOT NULL,
	RoomCategoryDesc VARCHAR(200),
	PRIMARY KEY (RoomCategoryCode)
);


INSERT INTO RoomCategory(RoomCategoryCode, CruiseCharge)
VALUES ('CABIN', 2000.00);

INSERT INTO RoomCategory(RoomCategoryCode, CruiseCharge)
VALUES ('STARB', 2555.99);

--SELECT * FROM RoomCategory;


--Room information table, identifies room category as well as status of Occupied (O) or Vacant (V)
CREATE TABLE IF NOT EXISTS Rooms (
	RoomID SERIAL NOT NULL UNIQUE,
	CruiseID INTEGER NOT NULL,
	RoomCategoryCode CHAR(5) NOT NULL,
	RoomName VARCHAR(100) NOT NULL,
	RoomStatus CHAR(1) NOT NULL,
	PRIMARY KEY (RoomID),
	FOREIGN KEY (CruiseID) REFERENCES Cruises(CruiseID),
	FOREIGN KEY (RoomCategoryCode) REFERENCES RoomCategory(RoomCategoryCode)
);

INSERT INTO Rooms (CruiseID, RoomCategoryCode, RoomName, RoomStatus)
VALUES(1, 'CABIN', 'The Cabin Room', 'V');

INSERT INTO Rooms (CruiseID, RoomCategoryCode, RoomName, RoomStatus)
VALUES(1, 'STARB', 'The StarBoard Room', 'O');

INSERT INTO Rooms (CruiseID, RoomCategoryCode, RoomName, RoomStatus)
VALUES(2, 'CABIN', 'The Cabin Room', 'V');

INSERT INTO Rooms (CruiseID, RoomCategoryCode, RoomName, RoomStatus)
VALUES(2, 'STARB', 'The StarBoard Room', 'O');

--SELECT * FROM Rooms;


--PassengerReservation table, links passengers to reservations, cruises and rooms
CREATE TABLE IF NOT EXISTS PassengersReservations(
	ReservationID SERIAL NOT NULL UNIQUE,
	CruiseID INTEGER NOT NULL,
	PassengerID INTEGER NOT NULL,
	RoomID INTEGER NOT NULL,
	PRIMARY KEY(ReservationID),
	FOREIGN KEY(CruiseID) REFERENCES Cruises(CruiseID),
	FOREIGN KEY(PassengerID) REFERENCES Passengers(PassengerID),
	FOREIGN KEY(RoomID) REFERENCES Rooms(RoomID)
);


INSERT INTO PassengersReservations(CruiseID, PassengerID, RoomID)
VALUES (1, 1, 4);

INSERT INTO PassengersReservations(CruiseID, PassengerID, RoomID)
VALUES (1, 2, 2);

--SELECT * FROM PassengersReservations;


--Acitvity reservations table. Links activity passengers and crew members
CREATE TABLE IF NOT EXISTS ActivityReservations (
	ActivityReservationID SERIAL NOT NULL UNIQUE,
	ActivityID INTEGER NOT NULL,
	CrewID INTEGER NOT NULL,
	PassengerID INTEGER NOT NULL,
	ActivityDate DATE NOT NULL,
	StartTime TIME NOT NULL,
	EndTime TIME NOT NULL,
	OtherDetails VARCHAR(200),
	PRIMARY KEY (ActivityReservationID),
	FOREIGN KEY(ActivityID) REFERENCES Activity(ActivityID),
	FOREIGN KEY(PassengerID) REFERENCES Passengers(PassengerID),
	FOREIGN KEY(CrewID) REFERENCES Crew(CrewID)
);

INSERT INTO ActivityReservations(ActivityID, CrewID, PassengerID, ActivityDate, StartTime, EndTime)
VALUES (1, 1, 1, '10/10/2016', '11:00', '15:00');

INSERT INTO ActivityReservations(ActivityID, CrewID, PassengerID, ActivityDate, StartTime, EndTime)
VALUES (2, 2, 2, '10/10/2016', '11:00', '15:00');

--SELECT * FROM ActivityReservations;



--View: Cruise Passenger List
CREATE VIEW CruisePassengers AS
SELECT pr.ReservationID, sh.ShipName, p.FirstName, p.LastName, r.RoomID, r.RoomName
FROM Ship sh, Cruises c, Rooms r, PassengersReservations pr, Passengers p
WHERE sh.ShipID = c.ShipID
AND c.CruiseID = pr.CruiseID
AND r.RoomID = pr.RoomID
AND p.PassengerID = pr.PassengerID;


--View: Passenger ActivityList
CREATE VIEW PassengerActivities AS
SELECT ar.ActivityReservationID, p.PassengerID, p.FirstName, p.LastName, a.ActivityID, a.activityDesc, ar.ActivityDate, ar.StartTime, ar.EndTime, a.activityCharge
FROM ActivityReservations ar, Activity a, Passengers p
WHERE ar.ActivityID = a.ActivityID
AND ar.PassengerID = p.PassengerID
ORDER BY p.PassengerID;


--Report: PassengerTotal, calls calculateRoomCharge() and calculateActivityCharge() functions to return total values
CREATE VIEW PassengerTotal AS
SELECT p.PassengerID, p.FirstName, p.LastName, calculateRoomCharge(pr.reservationID) AS roomTotal, calculateActivityCharge(pr.passengerID) AS activityTotal, (calculateRoomCharge(pr.reservationID) + calculateActivityCharge(pr.passengerID)) AS total
FROM Passengers p, PassengersReservations pr
WHERE p.passengerID = pr.passengerID;



--Calculate Total Room Charge for a particular reservation, Reservation ID provided as a paremeter. Returns total room charge for that reservation as a numeric(15,2) type
CREATE OR REPLACE FUNCTION calculateRoomCharge(RID int) RETURNS NUMERIC(15,2)
AS $total$
DECLARE
	Day_total INTEGER; --Used to store total reservation days
	totalCharge NUMERIC(15,2); --Used to store the total room charge before returning
BEGIN
	--Calculate total days from start and end days and store in Day_total
	Day_total := (SELECT (c.endDate - c.startDate) AS days
		FROM cruises c, PassengersReservations pr
		WHERE c.CruiseID = pr.CruiseID
		AND pr.ReservationID = RID);

	--Calculate total and store in totalCharge
	SELECT INTO totalCharge (Day_Total * rc.CruiseCharge) AS totalCharge
	FROM PassengersReservations pr, Passengers p, Cruises c, Rooms r, RoomCategory rc
	WHERE pr.CruiseID = c.CruiseID
	AND pr.PassengerID = p.PassengerID
	AND pr.RoomID = r.RoomID
	AND r.RoomCategoryCode = rc.RoomCategoryCode
	AND pr.ReservationID = RID;

	RETURN totalCharge;
END;
$total$
LANGUAGE plpgsql;


--Calculate Total Actiity Charge for a particular passenger, Passenger ID provided as a paremeter. Returns total activity charge for that passenger as a numeric(15,2) type
CREATE OR REPLACE FUNCTION calculateActivityCharge(PID int) RETURNS NUMERIC(15,2)
AS $total$
DECLARE
	activityTotal NUMERIC(15,2); --Used to store the total room charge before returning
BEGIN
	--Calculate total and store in activityCharge
	SELECT INTO activityTotal (SUM(a.ActivityCharge)) AS totalActivityCharge
	FROM Activity a, ActivityReservations ar
	WHERE a.ActivityID = ar.ActivityID
	AND ar.PassengerID = PID
	GROUP BY ar.PassengerID;
	
	RETURN activityTotal;
END;
$total$
LANGUAGE plpgsql;


--Change Room status to Occupied(O) when a new reservation is inserted
CREATE OR REPLACE FUNCTION new_room_status()
RETURNS trigger AS $$
DECLARE
	Status CHAR(1);
BEGIN
	Status := (SELECT RoomStatus FROM Rooms WHERE Rooms.RoomID = New.RoomID);
	IF(status = 'V') THEN
	UPDATE Rooms SET RoomStatus = 'O'
	WHERE Rooms.RoomID = NEW.RoomID;
	RETURN NEW;
	ELSE RETURN NULL;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER new_room_status
AFTER INSERT ON PassengersReservations
FOR EACH ROW EXECUTE PROCEDURE new_room_status();


--Update room status to either Occupied(O) or Vacant(O) according to the cruise dates, triggered on reservation update
CREATE OR REPLACE FUNCTION update_room_status()
RETURNS trigger AS $$
DECLARE
	Status CHAR(1);
	End_date DATE := (
		SELECT c.endDate
		FROM PassengersReservations pr, Cruises c 
		WHERE c.CruiseID = pr.CruiseID
		AND pr.ReservationID = NEW.ReservationID);
BEGIN
	IF (End_date > now()) THEN
		UPDATE Rooms SET Roomstatus = 'V'
		WHERE Rooms.RoomID = OLD.RoomID;
		
		UPDATE Rooms SET Roomstatus = 'O'
		WHERE Rooms.RoomID = NEW.RoomID;
	ELSE
		UPDATE Rooms SET RoomStatus = 'V'
		WHERE Rooms.RoomID = NEW.RoomID
		OR Rooms.RoomID = OLD.RoomID;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_room_status
AFTER UPDATE ON PassengersReservations
FOR EACH ROW EXECUTE PROCEDURE update_room_status();


--Refresh Room Status Stored Procedure
CREATE OR REPLACE FUNCTION refresh_room_status()
RETURNS void AS $$
BEGIN
	UPDATE Rooms SET Rooms.RoomStatus = 'V';
	
	UDPATE Rooms SET RoomStatus = 'O'
	WHERE Rooms.RoomID IN (
		SELECT pr.RoomID
		FROM PassengersReservations pr, Cruises c 
		WHERE c.CruiseID = pr.CruiseID
		AND c.EndDate > now()
	);
END;
$$ LANGUAGE plpgsql;


--SECURITY

--Admin user
CREATE ROLE admin;
GRANT ALL ON ALL TABLES
IN SCHEMA PUBLIC
TO admin;


--Cruise desk should only be able to access/modify cruise related data
CREATE ROLE cruisedesk;
GRANT SELECT, INSERT, UPDATE ON PassengerReservations, Cruises, Rooms, Ship
TO cruisedesk;

--Room desk should only be able to access/modify room related data
CREATE ROLE roomdesk;
GRANT SELECT, INSERT, UPDATE ON PassengersReservations, Passengers, Rooms, RoomCategory
TO roomdesk;

--Activity desk should only be able to access/modify activity related data
CREATE ROLE activitydesk;
GRANT SELECT, INSERT, UPDATE ON Crew, Activity, ActivityReservations
TO activitydesk;