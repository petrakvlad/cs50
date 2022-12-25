-- Keep a log of any SQL queries you execute as you solve the mystery.

airports              crime_scene_reports   passengers
atm_transactions      flights               people
bakery_security_logs  interviews            phone_calls
bank_accounts         namese

CREATE TABLE airports (
    id INTEGER,
    abbreviation TEXT,
    full_name TEXT,
    city TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE atm_transactions (
    id INTEGER,
    account_number INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    atm_location TEXT,
    transaction_type TEXT,
    amount INTEGER,
    PRIMARY KEY(id)
);

CREATE TABLE bakery_security_logs (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    activity TEXT,
    license_plate TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE bank_accounts (
    account_number INTEGER,
    person_id INTEGER,
    creation_year INTEGER,
    FOREIGN KEY(person_id) REFERENCES people(id)
);


CREATE TABLE crime_scene_reports (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    street TEXT,
    description TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE interviews (
    id INTEGER,
    name TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    transcript TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE passengers (
    flight_id INTEGER,
    passport_number INTEGER,
    seat TEXT,
    FOREIGN KEY(flight_id) REFERENCES flights(id)
);

CREATE TABLE people (
    id INTEGER,
    name TEXT,
    phone_number TEXT,
    passport_number INTEGER,
    license_plate TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE phone_calls (
    id INTEGER,
    caller TEXT,
    receiver TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    duration INTEGER,
    PRIMARY KEY(id)
);

CREATE TABLE flights (
    id INTEGER,
    origin_airport_id INTEGER,
    destination_airport_id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    PRIMARY KEY(id),
    FOREIGN KEY(origin_airport_id) REFERENCES airports(id),
    FOREIGN KEY(destination_airport_id) REFERENCES airports(id)
);



--///////////////////////

SELECT description
    FROM crime_scene_reports
    WHERE year = 2021 AND month = 7
    AND day = 28 AND street = "Humphrey Street";

SELECT name, transcript
    FROM interviews
    WHERE year = 2021 AND month = 7
    AND day = 28;

-- car leaving within  min after theft
SELECT activity, license_plate, hour, minute
    FROM bakery_security_logs
    WHERE year = 2021 AND month = 7
    AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25;

--withdrawal of cash in the morning
SELECT account_number, atm_location, transaction_type, amount
    FROM atm_transactions
    WHERE year = 2021 AND month = 7
    AND day = 28 AND atm_location = "Leggett Street"
    AND transaction_type = "withdraw";

--passport numbers of people who withdraw money at that time
SELECT passport_number FROM people WHERE id IN
(SELECT person_id FROM bank_accounts WHERE account_number IN
    (SELECT account_number
    FROM atm_transactions
    WHERE year = 2021 AND month = 7
    AND day = 28 AND atm_location = "Leggett Street"
    AND transaction_type = "withdraw"));

--call less than a minute long right after the robbery
    FROM phone_calls
    WHERE year = 2021 AND month = 7
    AND day = 28 AND duration < 60;


-- potential lsuspects
SELECT * FROM people WHERE license_plate IN
(SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2021 AND month = 7
    AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25)
    AND phone_number IN
        (SELECT caller
        FROM phone_calls
        WHERE year = 2021 AND month = 7
        AND day = 28 AND duration < 60)
        AND passport_number IN
        (SELECT passport_number FROM people WHERE id IN
        (SELECT person_id FROM bank_accounts WHERE account_number IN
        (SELECT account_number
        FROM atm_transactions
        WHERE year = 2021 AND month = 7
        AND day = 28 AND atm_location = "Leggett Street"
        AND transaction_type = "withdraw")));


-- whom the suspects called

SELECT *
    FROM phone_calls
    WHERE year = 2021 AND month = 7
    AND day = 28 AND duration < 60 AND caller IN
    (SELECT phone_number FROM people WHERE license_plate IN
    (SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2021 AND month = 7
    AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25)
    AND phone_number IN
        (SELECT caller
        FROM phone_calls
        WHERE year = 2021 AND month = 7
        AND day = 28 AND duration < 60)
        AND passport_number IN
        (SELECT passport_number FROM people WHERE id IN
        (SELECT person_id FROM bank_accounts WHERE account_number IN
        (SELECT account_number
        FROM atm_transactions
        WHERE year = 2021 AND month = 7
        AND day = 28 AND atm_location = "Leggett Street"
        AND transaction_type = "withdraw"))));

-- whom the suspects called as a separate table

DROP TABLE IF EXISTS namese;
CREATE TABLE namese (
    phone VARCHAR(255)
);

INSERT INTO namese
    (phone)

SELECT receiver
    FROM phone_calls
    WHERE year = 2021 AND month = 7
    AND day = 28 AND duration < 60 AND caller IN
    (SELECT phone_number FROM people WHERE license_plate IN
    (SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2021 AND month = 7
    AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25)
    AND phone_number IN
        (SELECT caller
        FROM phone_calls
        WHERE year = 2021 AND month = 7
        AND day = 28 AND duration < 60)
        AND passport_number IN
        (SELECT passport_number FROM people WHERE id IN
        (SELECT person_id FROM bank_accounts WHERE account_number IN
        (SELECT account_number
        FROM atm_transactions
        WHERE year = 2021 AND month = 7
        AND day = 28 AND atm_location = "Leggett Street"
        AND transaction_type = "withdraw"))));


-- what are the people whom they called

SELECT * FROM people WHERE phone_number IN
(SELECT * FROM namese);


-- what are the flights of suspects
SELECT * FROM passengers WHERE passport_number IN
(SELECT passport_number FROM people WHERE license_plate IN
(SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2021 AND month = 7
    AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25)
    AND phone_number IN
        (SELECT caller
        FROM phone_calls
        WHERE year = 2021 AND month = 7
        AND day = 28 AND duration < 60)
        AND passport_number IN
        (SELECT passport_number FROM people WHERE id IN
        (SELECT person_id FROM bank_accounts WHERE account_number IN
        (SELECT account_number
        FROM atm_transactions
        WHERE year = 2021 AND month = 7
        AND day = 28 AND atm_location = "Leggett Street"
        AND transaction_type = "withdraw"))));


-- flights of the suspects
SELECT * FROM passengers WHERE passport_number IN
(SELECT passport_number FROM people WHERE phone_number IN
(SELECT * FROM namese));


-- all the people from flights with suspect
SELECT * FROM people WHERE passport_number IN
(SELECT passport_number FROM passengers WHERE flight_id IN
(SELECT id FROM flights WHERE id IN(
SELECT flight_id FROM passengers WHERE passport_number = 5773159633)));

SELECT * FROM flights WHERE id IN(
SELECT flight_id FROM passengers WHERE passport_number = 5773159633);

