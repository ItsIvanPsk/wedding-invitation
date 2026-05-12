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
(1, 1, 'Nerea', FALSE, FALSE, FALSE, NULL, NULL, '¡La novia! Preparada para el gran día.'), -- Yo
(2, 1, 'Iván', FALSE, FALSE, FALSE, NULL, NULL, '¡El novio! Que empiece la fiesta.'), -- Yo
(3, 2, 'Aurora', FALSE, FALSE, FALSE, NULL, NULL, 'Mamá, gracias por todo. ¡Te quiero muchísimo!'), -- Madre novia
(4, 2, 'Juan', FALSE, FALSE, FALSE, NULL, NULL, 'Papá, sin ti esto no sería igual. ¡Te quiero!'), -- Padre novia
(5, 2, 'Mireia', FALSE, FALSE, FALSE, NULL, NULL, '¡La mejor hermana! Prepárate para darlo todo hoy.'), -- Hermana novia
(6, 32, 'Antonio', FALSE, FALSE, TRUE, NULL, NULL, '¡Un día muy especial para celebrar en familia!'), -- Familiar novia
(7, 3, 'Dani', FALSE, FALSE, FALSE, NULL, NULL, '¡A brindar y a disfrutar, que nos vamos de boda!'), -- Tio novia
(8, 3, 'Inma', FALSE, FALSE, FALSE, NULL, NULL, '¡Que no falten las risas en la mesa!'), -- Tio novia
(9, 3, 'Laia', FALSE, FALSE, FALSE, NULL, NULL, '¡Prima, hoy lo damos todo en la pista!'), -- Prima novia
(10, 3, 'Pau', FALSE, FALSE, FALSE, NULL, NULL, '¡A celebrar por todo lo alto!'), -- Prima novia
(11, 3, 'Aina', FALSE, FALSE, FALSE, NULL, NULL, '¡Que empiece la fiesta, prima!'), -- Prima novia
(12, 4, 'Jaime', FALSE, FALSE, FALSE, NULL, NULL, '¡Tío, hoy nos toca celebrar a lo grande!'), -- Tio novia
(13, 4, 'Nahia', FALSE, TRUE, TRUE, NULL, NULL, '¡La prima más peque a disfrutar de la fiesta!'), -- Prima novia
(14, 4, 'Marisa', FALSE, FALSE, FALSE, NULL, NULL, '¡Hoy se baila hasta el final, tía!'), -- Tio novia
(15, 4, 'Aaron', FALSE, FALSE, FALSE, NULL, NULL, '¡Primo, ve calentando que esta noche promete!'), -- Prima novia
(16, 4, 'Arian', FALSE, FALSE, FALSE, NULL, NULL, '¡Una noche inolvidable por delante!'), -- Prima novia
(17, 4, 'Marc', FALSE, FALSE, FALSE, NULL, NULL, '¡A disfrutar de la boda a tope!'), -- Prima novia
(18, 4, 'Lua', FALSE, FALSE, FALSE, NULL, NULL, '¡A darlo todo, prima!'), -- Prima novia
(19, 5, 'Tita Pepa', FALSE, FALSE, TRUE, NULL, NULL, '¡Qué ilusión tan grande tenerte aquí con nosotros!'), -- Tiabuela novia
(20, 5, 'Tito Pepe', FALSE, FALSE, TRUE, NULL, NULL, '¡Gracias por acompañarnos en este día tan especial!'), -- Tioabuelo novia
(21, 6, 'Tita Maria', FALSE, FALSE, FALSE, NULL, NULL, '¡Un brindis muy especial contigo!'), --Tioabuela novia
(22, 6, 'Tito Alberto', FALSE, FALSE, FALSE, NULL, NULL, '¡A disfrutar de cada momento de hoy!'), --tioabuela novia
(23, 7, 'Montse', FALSE, FALSE, FALSE, NULL, NULL, '¡Tía, prepárate que hoy celebramos por todo lo alto!'), -- Tia novia
(24, 7, 'Carmen', FALSE, FALSE, FALSE, NULL, NULL, '¡Prima, esta noche no paramos de bailar!'), -- Prima novia
(25, 7, 'Gustavo', FALSE, FALSE, FALSE, NULL, NULL, '¡A pasarlo genial, que para eso estamos!'), -- Tia novia
(26, 8, 'Vicky', FALSE, FALSE, FALSE, NULL, NULL, '¡A disfrutar de la magia de este día!'), -- Tia novia
(27, 8, 'Aziz', FALSE, FALSE, FALSE, NULL, NULL, '¡Gracias por compartir esta alegría con nosotros!'), -- Tia novia
(28, 8, 'Sara', FALSE, FALSE, FALSE, NULL, NULL, '¡Prima, hoy rompemos la pista de baile!'), -- Prima novia
(29, 8, 'Isaac', FALSE, FALSE, FALSE, NULL, NULL, '¡A celebrar y a pasarlo en grande!'), -- Prima novia
(30, 8, 'Mohamed', FALSE, FALSE, FALSE, NULL, NULL, '¡Que comience la gran fiesta!'), -- Prima novia
(31, 9, 'Manolo', FALSE, FALSE, FALSE, NULL, NULL, '¡Tío, hoy el primer brindis va por ti!'), -- Tia novia
(32, 9, 'Mari', FALSE, FALSE, FALSE, NULL, NULL, '¡A reír, comer y disfrutar muchísimo, tía!'), -- Tia novia
(33, 9, 'Sergio', FALSE, FALSE, FALSE, NULL, NULL, '¡Primo, hoy cerramos nosotros la fiesta!'), -- Prima novia
(34, 9, 'Raúl', FALSE, FALSE, FALSE, NULL, NULL, '¡A darlo absolutamente todo hoy!'), -- Prima novia
(35, 10, 'Victoria', FALSE, FALSE, FALSE, NULL, NULL, '¡Abuela, tu presencia es nuestro mejor regalo!'), -- Abuela
(36, 10, 'Artur', FALSE, FALSE, FALSE, NULL, NULL, '¡Abuelo, gracias por estar a nuestro lado hoy!'), --abuelo
(37, 11, 'Xavi', FALSE, FALSE, FALSE, NULL, NULL, '¡Papá, hoy toca celebrar juntos por todo lo alto!'), -- Padre novio
(38, 11, 'Mari', FALSE, FALSE, FALSE, NULL, NULL, '¡Mamá, gracias por hacerlo todo posible. Te queremos!'), --madre novio
(40, 12, 'Carlos', FALSE, FALSE, FALSE, NULL, NULL, '¡Tío, que no falte la alegría en tu mesa!'), --tio novio
(41, 12, 'Eva', FALSE, FALSE, FALSE, NULL, NULL, '¡Prima, vamos a pasarlo de maravilla!'), --primanovio
(42, 13, 'Bienve', FALSE, FALSE, FALSE, NULL, NULL, '¡Qué felicidad tan grande poder contar contigo!'), --tiabuela novio
(43, 14, 'Yaya Mari', FALSE, FALSE, TRUE, NULL, NULL, '¡La yaya más guapa de toda la boda!'), -- abuela novio
(44, 15, 'Edu', FALSE, FALSE, FALSE, NULL, NULL, '¡Gracias por estar aquí, hoy brindamos juntos!'), --tiabuela novio
(45, 15, 'Tomas', FALSE, FALSE, FALSE, NULL, NULL, '¡A pasarlo fenomenal en este gran día!'), --tioabuelo novio
(46, 16, 'Jaime', FALSE, FALSE, FALSE, NULL, NULL, '¡Tío, prepárate que hoy la liamos!'), -- tio novio
(47, 16, 'Pilar', FALSE, FALSE, FALSE, NULL, NULL, '¡Tía, esperamos que disfrutes un montón de la boda!'), -- tio novio
(48, 17, 'Bea', FALSE, FALSE, FALSE, NULL, NULL, '¡A disfrutar y a brindar a nuestra salud!'), -- tio novio
(49, 17, 'Tomi', FALSE, FALSE, FALSE, NULL, NULL, '¡Hoy se celebra con todo, prepárate!'), -- tio novio
(50, 17, 'Claudia', FALSE, FALSE, FALSE, NULL, NULL, '¡Prima, vamos a darlo todo en el baile!'), -- prima novio
(51, 17, 'Eric', FALSE, FALSE, FALSE, NULL, NULL, '¡Primo, hoy la noche promete!'), -- prima novio
(52, 18, 'Montse', FALSE, FALSE, FALSE, NULL, NULL, '¡Tía, a pasarlo en grande que hoy es un día único!'), -- tio novio
(53, 18, 'Óscar', FALSE, FALSE, FALSE, NULL, NULL, '¡A brindar y reír como nunca!'), -- tio novio
(54, 18, 'Dani', FALSE, FALSE, FALSE, NULL, NULL, '¡Hoy no hay excusas, a la pista de baile!'), -- prima novio
(55, 18, 'Bruno', FALSE, FALSE, FALSE, NULL, NULL, '¡A disfrutar del día, que esto solo pasa una vez!'), -- prima novio
(56, 19, 'Lluís', FALSE, FALSE, FALSE, NULL, NULL, '¡Tío, hoy nos vamos de fiestón!'), -- tio novio
(57, 19, 'Rosa', FALSE, FALSE, FALSE, NULL, NULL, '¡Tía, gracias por venir a celebrar con nosotros!'), --tia novia
(58, 20, 'Sonia', FALSE, FALSE, FALSE, NULL, NULL, '¡A disfrutar de un día lleno de magia!'), --tia novia
(59, 20, 'Sinto', FALSE, FALSE, FALSE, NULL, NULL, '¡A celebrar y brindar sin parar!'), --tia novia
(60, 21, 'Rafa', FALSE, FALSE, FALSE, NULL, NULL, '¡Tío, hoy rompemos moldes celebrando!'), --tio novio
(61, 21, 'Chus', FALSE, FALSE, FALSE, NULL, NULL, '¡A comer, beber y disfrutar a tope!'), --tio novio
(62, 21, 'Elisa', FALSE, FALSE, FALSE, NULL, NULL, '¡Prima, hoy lo damos todo!'), -- prima novio
(63, 22, 'Willy', FALSE, FALSE, FALSE, NULL, NULL, '¡El rey de la pista! Hoy no quiero verte sentado.'), -- mejor amigo novio
(64, 23, 'Jenner', FALSE, FALSE, FALSE, NULL, NULL, '¡Amigos que valen oro! A disfrutar.'), -- amigo novio
(65, 24, 'Xavi', FALSE, FALSE, FALSE, NULL, NULL, '¡Hoy es día de celebración de la buena!'), -- amigo novio
(66, 24, 'María', FALSE, FALSE, FALSE, NULL, NULL, '¡Gracias por compartir esta locura con nosotros!'), -- amigo novio
(67, 25, 'Rubén', FALSE, FALSE, FALSE, NULL, NULL, '¡Vete calentando motores, amigo!'), -- amigo novio
(68, 26, 'Sergi', FALSE, FALSE, FALSE, NULL, NULL, '¡Preparado para la mejor fiesta del año!'), -- amigo novia
(69, 33, 'Cristina', FALSE, FALSE, FALSE, NULL, NULL, '¡Sin mi mejor amiga no hay boda! Te adoro.'), -- mejor amiga novia
(73, 28, 'Verónica', FALSE, FALSE, FALSE, NULL, NULL, '¡Del trabajo a la boda! Hoy no se habla de curro.'), --trabajo novia
(74, 28, 'Alex', FALSE, FALSE, FALSE, NULL, NULL, '¡Cambiamos la oficina por la barra libre!'), --trabajo novia
(75, 29, 'Inma', FALSE, FALSE, FALSE, NULL, NULL, '¡Hoy fichamos en la pista de baile!'), --trabajo novia
(76, 29, 'Victor', FALSE, FALSE, FALSE, NULL, NULL, '¡Hoy el único trabajo es pasarlo bien!'), --trabajo novia
(77, 30, 'Espiri', FALSE, FALSE, FALSE, NULL, NULL, '¡Vamos a darlo todo fuera del curro!'), --trabajo novia
(78, 30, 'David', FALSE, FALSE, FALSE, NULL, NULL, '¡A disfrutar, que hoy libramos!'), --trabajo novia
(79, 31, 'Nil', FALSE, FALSE, FALSE, NULL, NULL, '¡De los madrugones a trasnochar!'), --trabajo novia
(80, 31, 'Javi', FALSE, FALSE, FALSE, NULL, NULL, '¡A cambiar el teclado por las copas!'), --trabajo novia
(81, 34, 'Judit', FALSE, FALSE, FALSE, NULL, NULL, '¡La mejor cuñada! Ve preparándote para bailar.'), -- Cuñada novio 
(82, 34, 'Victor', FALSE, FALSE, FALSE, NULL, NULL, '¡Hermanito, hoy tienes que ser el alma de la fiesta!'); --hermano novia