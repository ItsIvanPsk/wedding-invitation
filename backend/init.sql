-- Database Initialization Script
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS WeddingDb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE WeddingDb;

-- Drop tables if they exist to ensure clean state
DROP TABLE IF EXISTS GuestIntolerances;
DROP TABLE IF EXISTS Intolerances;
DROP TABLE IF EXISTS Guests;
DROP TABLE IF EXISTS Families;

CREATE TABLE Families (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Token VARCHAR(8) NOT NULL UNIQUE, 
    Name VARCHAR(255) NOT NULL,
    ConfirmationDate DATETIME NULL
);

CREATE TABLE Guests (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    FamilyId INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    IsAttending BOOLEAN NOT NULL DEFAULT 0,
    IsChildMenu BOOLEAN NOT NULL DEFAULT 0,
    IsHalfPortion BOOLEAN NOT NULL DEFAULT 0,
    Intolerances TEXT NULL,
    Observations TEXT NULL,
    FunnyComment TEXT NULL,
    FOREIGN KEY (FamilyId) REFERENCES Families(Id) ON DELETE CASCADE
);

-- Create Intolerances Table
CREATE TABLE Intolerances (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE GuestIntolerances (
    GuestId INT NOT NULL,
    IntoleranceId INT NOT NULL,
    PRIMARY KEY (GuestId, IntoleranceId),
    FOREIGN KEY (GuestId) REFERENCES Guests(Id) ON DELETE CASCADE,
    FOREIGN KEY (IntoleranceId) REFERENCES Intolerances(Id) ON DELETE CASCADE
);

-- Insert Intolerances
INSERT INTO Intolerances (Id, Name) VALUES 
(1, 'Gluten'),
(2, 'Lactosa'),
(3, 'Frutos Secos'),
(4, 'Marisco'),
(5, 'Vegano'),
(6, 'Vegetariano'),
(7, 'Celíaco');

-- Insert Families
-- IDs assigned manually: 1 to 33
INSERT INTO Families (Id, Token, Name) VALUES 
(1, 'NsTr0s25', 'Nosotros'),
(2, 'LpRz7a9X', 'Familia'),
(3, 'SoLer82Q', 'Familia'),
(4, 'GzSr5m2K', 'Familia'),
(5, 'Fx7Y2n19', 'Familia'),
(6, 'XlzS4j8H', 'Familia'),
(7, 'XRs9c3VB', 'Familia'),
(8, 'ElMR7d6P', 'Familia'),
(9, 'RsNuNz42', 'Familia'),
(10, 'Fx2A5b1C', 'Familia'),
(11, 'FgMg8s3L', 'Familia'),
(12, 'DmSc9x4N', 'Familia'),
(13, 'FamX7z2W', 'Familia'),
(14, 'FgRg5q1J', 'Familia'),
(15, 'Fx3E6t8G', 'Familia'),
(16, 'Fx4J9p2M', 'Familia'),
(17, 'RomZf6vK', 'Familia'),
(18, 'SnChX3yR', 'Familia'),
(19, 'RuMl8b4D', 'Amigos'),
(20, 'Fx5S1n7F', 'Amigos'),
(21, 'RomX9h2T', 'Amigos'),
(22, 'MolGl4cW', 'Amigos'),
(23, 'SrmMd6jQ', 'Amigos'),
(24, 'PuePt2kX', 'Amigos'),
(25, 'BrB0r7gL', 'Amigos'),
(26, 'CsNv9m5H', 'Amigos'),
(27, 'Fx6J3p8Z', 'Amigos'),
(28, 'Fx7V5a1S', 'Amigos'),
(29, 'Fx8I4v9B', 'Amigos'),
(30, 'Fx9E2d6N', 'Amigos'),
(31, 'Fx0N7j3K', 'Amigos'),
(32, 'AnTo5p2M', 'Familia'),
(33, 'CrIs8t9K', 'Amigos');

-- Insert Guests
-- Family IDs mapped from above. Explicit columns and manual IDs.
INSERT INTO Guests (Id, FamilyId, Name, IsAttending, IsChildMenu, IsHalfPortion, Intolerances, Observations, FunnyComment) VALUES 
(1, 1, 'Nerea', 0, 0, 0, NULL, NULL, NULL),
(2, 1, 'Iván', 0, 0, 0, NULL, NULL, NULL),
(3, 2, 'Aurora', 0, 0, 0, NULL, NULL, NULL),
(4, 2, 'Juan', 0, 0, 0, NULL, NULL, NULL),
(5, 2, 'Mireia', 0, 0, 0, NULL, NULL, NULL),
(6, 32, 'Antonio', 0, 0, 1, NULL, NULL, NULL),
(7, 3, 'Dani', 0, 0, 0, NULL, NULL, NULL),
(8, 3, 'Inma', 0, 0, 0, NULL, NULL, NULL),
(9, 3, 'Laia', 0, 0, 0, NULL, NULL, NULL),
(10, 3, 'Pau', 0, 0, 0, NULL, NULL, NULL),
(11, 3, 'Aina', 0, 0, 0, NULL, NULL, NULL),
(12, 4, 'Jaime', 0, 0, 0, NULL, NULL, NULL),
(13, 4, 'Nahia', 0, 1, 1, NULL, NULL, NULL),
(14, 4, 'Marisa', 0, 0, 0, NULL, NULL, NULL),
(15, 4, 'Aaron', 0, 0, 0, NULL, NULL, NULL),
(16, 4, 'Arian', 0, 0, 0, NULL, NULL, NULL),
(17, 4, 'Marc', 0, 0, 0, NULL, NULL, NULL),
(18, 4, 'Lua', 0, 0, 0, NULL, NULL, NULL),
(19, 5, 'Tita Pepa', 0, 0, 1, NULL, NULL, NULL),
(20, 5, 'Tito Pepe', 0, 0, 1, NULL, NULL, NULL),
(21, 6, 'Tita Maria', 0, 0, 0, NULL, NULL, NULL),
(22, 6, 'Tito Alberto', 0, 0, 0, NULL, NULL, NULL),
(23, 7, 'Montse', 0, 0, 0, NULL, NULL, NULL),
(24, 7, 'Carmen', 0, 0, 0, NULL, NULL, NULL),
(25, 7, 'Gustavo', 0, 0, 0, NULL, NULL, NULL),
(26, 8, 'Vicky', 0, 0, 0, NULL, NULL, NULL),
(27, 8, 'Aziz', 0, 0, 0, NULL, NULL, NULL),
(28, 8, 'Sara', 0, 0, 0, NULL, NULL, NULL),
(29, 8, 'Isaac', 0, 0, 0, NULL, NULL, NULL),
(30, 8, 'Mohamed', 0, 0, 0, NULL, NULL, NULL),
(31, 9, 'Manolo', 0, 0, 0, NULL, NULL, NULL),
(32, 9, 'Mari', 0, 0, 0, NULL, NULL, NULL),
(33, 9, 'Sergio', 0, 0, 0, NULL, NULL, NULL),
(34, 9, 'Raúl', 0, 0, 0, NULL, NULL, NULL),
(35, 10, 'Victoria', 0, 0, 0, NULL, NULL, NULL),
(36, 10, 'Artur', 0, 0, 0, NULL, NULL, NULL),
(37, 11, 'Xavi', 0, 0, 0, NULL, NULL, NULL),
(38, 11, 'Mari', 0, 0, 0, NULL, NULL, NULL),
(39, 11, 'Víctor', 0, 0, 0, NULL, NULL, NULL),
(40, 12, 'Carlos', 0, 0, 0, NULL, NULL, NULL),
(41, 12, 'Eva', 0, 0, 0, NULL, NULL, NULL),
(42, 13, 'Bienve', 0, 0, 0, NULL, NULL, NULL),
(43, 14, 'Yaya Mari', 0, 0, 1, NULL, NULL, NULL),
(44, 15, 'Edu', 0, 0, 0, NULL, NULL, NULL),
(45, 15, 'Tomas', 0, 0, 0, NULL, NULL, NULL),
(46, 16, 'Jaime', 0, 0, 0, NULL, NULL, NULL),
(47, 16, 'Pilar', 0, 0, 0, NULL, NULL, NULL),
(48, 17, 'Bea', 0, 0, 0, NULL, NULL, NULL),
(49, 17, 'Tomi', 0, 0, 0, NULL, NULL, NULL),
(50, 17, 'Claudia', 0, 0, 0, NULL, NULL, NULL),
(51, 17, 'Eric', 0, 0, 0, NULL, NULL, NULL),
(52, 18, 'Montse', 0, 0, 0, NULL, NULL, NULL),
(53, 18, 'Óscar', 0, 0, 0, NULL, NULL, NULL),
(54, 18, 'Dani', 0, 0, 0, NULL, NULL, NULL),
(55, 18, 'Bruno', 0, 0, 0, NULL, NULL, NULL),
(56, 19, 'Lluís', 0, 0, 0, NULL, NULL, NULL),
(57, 19, 'Rosa', 0, 0, 0, NULL, NULL, NULL),
(58, 20, 'Sonia', 0, 0, 0, NULL, NULL, NULL),
(59, 20, 'Sinto', 0, 0, 0, NULL, NULL, NULL),
(60, 21, 'Rafa', 0, 0, 0, NULL, NULL, NULL),
(61, 21, 'Chus', 0, 0, 0, NULL, NULL, NULL),
(62, 21, 'Elisa', 0, 0, 0, NULL, NULL, NULL),
(63, 22, 'Willy', 0, 0, 0, NULL, NULL, '¡El rey de la pista!'),
(64, 23, 'Jenner', 0, 0, 0, NULL, NULL, NULL),
(65, 24, 'Xavi', 0, 0, 0, NULL, NULL, NULL),
(66, 24, 'María', 0, 0, 0, NULL, NULL, NULL),
(67, 25, 'Rubén', 0, 0, 0, NULL, NULL, NULL),
(68, 26, 'Sergi', 0, 0, 0, NULL, NULL, NULL),
(69, 33, 'Cristina', 0, 0, 0, NULL, NULL, NULL),
(70, 27, 'Janeth', 0, 0, 0, NULL, NULL, NULL),
(71, 27, 'Rubén', 0, 0, 0, NULL, NULL, NULL),
(72, 27, 'Paula', 0, 1, 1, NULL, NULL, NULL),
(73, 28, 'Verónica', 0, 0, 0, NULL, NULL, NULL),
(74, 28, 'Alex', 0, 0, 0, NULL, NULL, NULL),
(75, 29, 'Inma', 0, 0, 0, NULL, NULL, NULL),
(76, 29, 'Victor', 0, 0, 0, NULL, NULL, NULL),
(77, 30, 'Espiri', 0, 0, 0, NULL, NULL, NULL),
(78, 30, 'David', 0, 0, 0, NULL, NULL, NULL),
(79, 31, 'Nil', 0, 0, 0, NULL, NULL, NULL),
(80, 31, 'Javi', 0, 0, 0, NULL, NULL, NULL);

-- Seed GuestIntolerances
INSERT INTO GuestIntolerances (GuestId, IntoleranceId) VALUES 
(24, 7),
(79, 7),
(80, 7);
