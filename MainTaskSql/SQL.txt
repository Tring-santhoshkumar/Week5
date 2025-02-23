--ROOMS TABLE
CREATE TABLE rooms(
	room_id SERIAL PRIMARY KEY,
	room_no VARCHAR(10) UNIQUE NOT NULL,
	room_type VARCHAR(50) NOT NULL,
	room_price NUMERIC(10,2) NOT NULL,
	room_available BOOLEAN DEFAULT TRUE
);


--BOOK TABLE
CREATE TABLE books(
	book_id SERIAL PRIMARY KEY,
	customer_name VARCHAR(50) NOT NULL,
	check_in DATE NOT NULL,
	check_out DATE NOT NULL,
	room_id INT REFERENCES rooms(room_id) ON DELETE CASCADE
);


--FUNCTION FOR ADDING ROOMS
CREATE OR REPLACE FUNCTION add_room(currRoom_no INT, currRoom_type VARCHAR, currRoom_price NUMERIC)
RETURNS VOID AS $$
BEGIN
	INSERT INTO rooms(room_no,room_type,room_price) VALUES (currRoom_no,currRoom_type,currRoom_price);
END;
$$ LANGUAGE plpgsql;


--ADDING ROOMS TO HOTEL
SELECT add_room('1','Ac',1000);
SELECT add_room('2','Ac',1000);
SELECT add_room('3','Non Ac',500);
SELECT add_room('4','Non Ac',500);
SELECT add_room('5','Non Ac',500);


--FUNCTION TO BOOK ROOM
CREATE OR REPLACE FUNCTION book_room(currRoom_name VARCHAR,currRoom_type VARCHAR,currRoom_price NUMERIC,currRoom_check_in DATE,currRoom_check_out DATE)
RETURNS TEXT AS $$
DECLARE
	currRoom_id INT;
BEGIN
	SELECT room_id INTO currRoom_id FROM rooms WHERE room_type = currRoom_type AND room_price = currRoom_price AND room_available = TRUE ORDER BY room_id;
	
	IF currRoom_id IS NULL
	THEN RETURN 'No rooms with the requirements are available.';
	END IF;
	
	INSERT INTO books(room_id,customer_name,check_in,check_out) VALUES (currRoom_id,currRoom_name,currRoom_check_in,currRoom_check_out);
	UPDATE rooms SET room_available = FALSE WHERE room_id = currRoom_id;
	RETURN 'Booked Successfull!!!';
END;
$$ LANGUAGE plpgsql;


--BOOKING ROOMS
SELECT book_room('Santhosh','Ac',1000,'2025-02-22','2025-02-23');
SELECT book_room('Gowreesh','Non Ac',500,'2025-02-22','2025-02-23');
SELECT book_room('Gokul','Ac',1000,'2025-02-22','2025-02-23');
SELECT book_room('Dipshy','Ac',1000,'2025-02-22','2025-02-23');          --Booking fails


--FUNCTION TO CANCEL ROOMS
CREATE OR REPLACE FUNCTION cancel_room(currBook_id INT,currBook_name VARCHAR)
RETURNS TEXT AS $$
DECLARE
	currRoom_id INT;
BEGIN
	SELECT room_id INTO currRoom_id FROM books WHERE customer_name = currBook_name AND book_id = currBook_id;
	
	IF currRoom_id IS NULL
	THEN RETURN 'Room is not Booked or not Booked by you';
	END IF;
	
	DELETE FROM books WHERE currBook_id = book_id AND customer_name = currBook_name;
	UPDATE rooms SET room_available = TRUE WHERE currRoom_id = room_id;
	RETURN 'Booked room is successfully cancelled!';
END;
$$ LANGUAGE plpgsql;


--CANCELLING ROOMS
SELECT cancel_room(2,'Gokul');            --Canceling fails
SELECT cancel_room(2,'Gowreesh');


--DISPLAYING ROOMS AND BOOKING DETAILS
SELECT * FROM rooms;

SELECT * FROM books;

SELECT room_no,books.customer_name,room_type,room_price,books.check_in,books.check_out FROM rooms JOIN books ON rooms.room_id = books.room_id;





