-- Database Initialization Script





-- Drop tables if they exist to ensure clean state
DROP TABLE IF EXISTS "GuestIntolerances" CASCADE;
DROP TABLE IF EXISTS "Intolerances" CASCADE;
DROP TABLE IF EXISTS "Guests" CASCADE;
DROP TABLE IF EXISTS "Families" CASCADE;

CREATE TABLE "Families" (
    "Id" SERIAL PRIMARY KEY,
    "Token" VARCHAR(8) NOT NULL UNIQUE, 
    "Name" VARCHAR(255) NOT NULL,
    "Email" VARCHAR(255) NULL,
    "ConfirmationDate" TIMESTAMP NULL
);

CREATE TABLE "Guests" (
    "Id" SERIAL PRIMARY KEY,
    "FamilyId" INT NOT NULL,
    "Name" VARCHAR(255) NOT NULL,
    "IsAttending" BOOLEAN NOT NULL DEFAULT FALSE,
    "IsChildMenu" BOOLEAN NOT NULL DEFAULT FALSE,
    "IsHalfPortion" BOOLEAN NOT NULL DEFAULT FALSE,
    "Intolerances" TEXT NULL,
    "Observations" TEXT NULL,
    "FunnyComment" TEXT NULL,
    FOREIGN KEY ("FamilyId") REFERENCES "Families"("Id") ON DELETE CASCADE
);

-- Create Intolerances Table
CREATE TABLE "Intolerances" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE "GuestIntolerances" (
    "GuestId" INT NOT NULL,
    "IntoleranceId" INT NOT NULL,
    PRIMARY KEY ("GuestId", "IntoleranceId"),
    FOREIGN KEY ("GuestId") REFERENCES "Guests"("Id") ON DELETE CASCADE,
    FOREIGN KEY ("IntoleranceId") REFERENCES "Intolerances"("Id") ON DELETE CASCADE
);

-- Insert Intolerances
INSERT INTO "Intolerances" ("Id", "Name") VALUES 
(2, 'Lactosa'),
(3, 'Frutos Secos'),
(4, 'Marisco'),
(5, 'Vegano'),
(6, 'Vegetariano');

-- Insert Families
-- IDs assigned manually: 1 to 33
INSERT INTO "Families" ("Id", "Token", "Name", "Email") VALUES 
(1, 'NsTr0s25', 'Nosotros', 'ivanfigueredo.et@gmail.com'),
(2, 'LpRz7a9X', 'Familia', 'ivanfigueredo.et@gmail.com'),
(3, 'SoLer82Q', 'Familia', 'ivanfigueredo.et@gmail.com'),
(4, 'GzSr5m2K', 'Familia', 'ivanfigueredo.et@gmail.com'),
(5, 'Fx7Y2n19', 'Familia', 'ivanfigueredo.et@gmail.com'),
(6, 'XlzS4j8H', 'Familia', 'ivanfigueredo.et@gmail.com'),
(7, 'XRs9c3VB', 'Familia', 'ivanfigueredo.et@gmail.com'),
(8, 'ElMR7d6P', 'Familia', 'ivanfigueredo.et@gmail.com'),
(9, 'RsNuNz42', 'Familia', 'ivanfigueredo.et@gmail.com'),
(10, 'Fx2A5b1C', 'Familia', 'ivanfigueredo.et@gmail.com'),
(11, 'FgMg8s3L', 'Familia', 'ivanfigueredo.et@gmail.com'),
(12, 'DmSc9x4N', 'Familia', 'ivanfigueredo.et@gmail.com'),
(13, 'FamX7z2W', 'Familia', 'ivanfigueredo.et@gmail.com'),
(14, 'FgRg5q1J', 'Familia', 'ivanfigueredo.et@gmail.com'),
(15, 'Fx3E6t8G', 'Familia', 'ivanfigueredo.et@gmail.com'),
(16, 'Fx4J9p2M', 'Familia', 'ivanfigueredo.et@gmail.com'),
(17, 'RomZf6vK', 'Familia', 'ivanfigueredo.et@gmail.com'),
(18, 'SnChX3yR', 'Familia', 'ivanfigueredo.et@gmail.com'),
(19, 'RuMl8b4D', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(20, 'Fx5S1n7F', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(21, 'RomX9h2T', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(22, 'MolGl4cW', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(23, 'SrmMd6jQ', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(24, 'PuePt2kX', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(25, 'BrB0r7gL', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(26, 'CsNv9m5H', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(27, 'Fx6J3p8Z', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(28, 'Fx7V5a1S', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(29, 'Fx8I4v9B', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(30, 'Fx9E2d6N', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(31, 'Fx0N7j3K', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(32, 'AnTo5p2M', 'Familia', 'ivanfigueredo.et@gmail.com'),
(33, 'CrIs8t9K', 'Amigos', 'ivanfigueredo.et@gmail.com'),
(34, 'VcJd9t8Q', 'Amigos', 'ivanfigueredo.et@gmail.com');

-- Insert Guests
-- Family IDs mapped from above. Explicit columns and manual IDs.
INSERT INTO "Guests" ("Id", "FamilyId", "Name", "IsAttending", "IsChildMenu", "IsHalfPortion", "Intolerances", "Observations", "FunnyComment") VALUES 
(1, 1, 'Nerea', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(2, 1, 'Iván', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(3, 2, 'Aurora', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(4, 2, 'Juan', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(5, 2, 'Mireia', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(6, 32, 'Antonio', FALSE, FALSE, TRUE, NULL, NULL, NULL),
(7, 3, 'Dani', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(8, 3, 'Inma', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(9, 3, 'Laia', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(10, 3, 'Pau', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(11, 3, 'Aina', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(12, 4, 'Jaime', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(13, 4, 'Nahia', FALSE, TRUE, TRUE, NULL, NULL, NULL),
(14, 4, 'Marisa', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(15, 4, 'Aaron', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(16, 4, 'Arian', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(17, 4, 'Marc', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(18, 4, 'Lua', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(19, 5, 'Tita Pepa', FALSE, FALSE, TRUE, NULL, NULL, NULL),
(20, 5, 'Tito Pepe', FALSE, FALSE, TRUE, NULL, NULL, NULL),
(21, 6, 'Tita Maria', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(22, 6, 'Tito Alberto', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(23, 7, 'Montse', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(24, 7, 'Carmen', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(25, 7, 'Gustavo', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(26, 8, 'Vicky', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(27, 8, 'Aziz', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(28, 8, 'Sara', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(29, 8, 'Isaac', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(30, 8, 'Mohamed', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(31, 9, 'Manolo', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(32, 9, 'Mari', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(33, 9, 'Sergio', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(34, 9, 'Raúl', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(35, 10, 'Victoria', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(36, 10, 'Artur', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(37, 11, 'Xavi', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(38, 11, 'Mari', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(40, 12, 'Carlos', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(41, 12, 'Eva', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(42, 13, 'Bienve', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(43, 14, 'Yaya Mari', FALSE, FALSE, TRUE, NULL, NULL, NULL),
(44, 15, 'Edu', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(45, 15, 'Tomas', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(46, 16, 'Jaime', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(47, 16, 'Pilar', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(48, 17, 'Bea', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(49, 17, 'Tomi', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(50, 17, 'Claudia', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(51, 17, 'Eric', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(52, 18, 'Montse', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(53, 18, 'Óscar', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(54, 18, 'Dani', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(55, 18, 'Bruno', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(56, 19, 'Lluís', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(57, 19, 'Rosa', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(58, 20, 'Sonia', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(59, 20, 'Sinto', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(60, 21, 'Rafa', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(61, 21, 'Chus', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(62, 21, 'Elisa', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(63, 22, 'Willy', FALSE, FALSE, FALSE, NULL, NULL, '¡El rey de la pista!'),
(64, 23, 'Jenner', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(65, 24, 'Xavi', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(66, 24, 'María', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(67, 25, 'Rubén', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(68, 26, 'Sergi', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(69, 33, 'Cristina', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(70, 27, 'Janeth', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(71, 27, 'Rubén', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(72, 27, 'Paula', FALSE, TRUE, TRUE, NULL, NULL, NULL),
(73, 28, 'Verónica', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(74, 28, 'Alex', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(75, 29, 'Inma', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(76, 34, 'Victor', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(77, 30, 'Espiri', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(78, 30, 'David', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(79, 31, 'Nil', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(80, 31, 'Javi', FALSE, FALSE, FALSE, NULL, NULL, NULL),
(81, 34, 'Judit', FALSE, FALSE, FALSE, NULL, NULL, NULL);

-- Seed GuestIntolerances
-- Empty because Celiaco was removed.
