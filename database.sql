-- ============================================================
-- ФАЙЛ: database.sql
-- Импортировать через phpMyAdmin: Import > выбрать этот файл
-- ============================================================

-- ▼▼▼ МЕНЯТЬ: название базы данных ▼▼▼
CREATE DATABASE IF NOT EXISTS learning_center
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE learning_center;
-- ▲▲▲ МЕНЯТЬ: название базы данных ▲▲▲


-- ============================================================
-- ТАБЛИЦА 1: Cursant (Слушатели)
-- ▼▼▼ МЕНЯТЬ: название таблицы, поля ▼▼▼
-- ============================================================
CREATE TABLE IF NOT EXISTS Cursant (
    IdCursant   INT AUTO_INCREMENT PRIMARY KEY,
    Nume        VARCHAR(100) NOT NULL,
    Prenume     VARCHAR(100) NOT NULL,
    Telefon     VARCHAR(20)  NOT NULL,
    Email       VARCHAR(150) NOT NULL UNIQUE  -- БОНУС: уникальность email
);
-- ▲▲▲ МЕНЯТЬ: Cursant ▲▲▲


-- ============================================================
-- ТАБЛИЦА 2: Curs (Курсы)
-- ▼▼▼ МЕНЯТЬ: название таблицы, поля ▼▼▼
-- ============================================================
CREATE TABLE IF NOT EXISTS Curs (
    IdCurs      INT AUTO_INCREMENT PRIMARY KEY,
    Denumire    VARCHAR(200) NOT NULL,
    Formator    VARCHAR(150) NOT NULL,
    Pret        DECIMAL(10,2) NOT NULL CHECK (Pret > 0),
    DurataZile  INT NOT NULL
);
-- ▲▲▲ МЕНЯТЬ: Curs ▲▲▲


-- ============================================================
-- ТАБЛИЦА 3: Inscriere (Регистрации) — связующая таблица
-- ▼▼▼ МЕНЯТЬ: название таблицы, поля, внешние ключи ▼▼▼
-- ============================================================
CREATE TABLE IF NOT EXISTS Inscriere (
    IdInscriere     INT AUTO_INCREMENT PRIMARY KEY,
    IdCursant       INT NOT NULL,
    IdCurs          INT NOT NULL,
    DataInscriere   DATE NOT NULL,
    StatusPlata     ENUM('Achitat','Neachitat') NOT NULL DEFAULT 'Neachitat',

    -- Один слушатель не может быть записан дважды на один курс
    UNIQUE KEY uq_cursant_curs (IdCursant, IdCurs),

    FOREIGN KEY (IdCursant) REFERENCES Cursant(IdCursant) ON DELETE CASCADE,
    FOREIGN KEY (IdCurs)    REFERENCES Curs(IdCurs)       ON DELETE CASCADE
);
-- ▲▲▲ МЕНЯТЬ: Inscriere ▲▲▲


-- ============================================================
-- ТЕСТОВЫЕ ДАННЫЕ
-- ▼▼▼ МЕНЯТЬ: значения под свою тему ▼▼▼
-- ============================================================
INSERT INTO Cursant (Nume, Prenume, Telefon, Email) VALUES
('Ionescu',   'Maria',    '069100001', 'maria.ionescu@mail.com'),
('Popescu',   'Andrei',   '069100002', 'andrei.popescu@mail.com'),
('Rusu',      'Elena',    '069100003', 'elena.rusu@mail.com'),
('Cojocaru',  'Victor',   '069100004', 'victor.cojocaru@mail.com'),
('Munteanu',  'Natalia',  '069100005', 'natalia.munteanu@mail.com'),
('Lupu',      'Ion',      '069100006', 'ion.lupu@mail.com');

INSERT INTO Curs (Denumire, Formator, Pret, DurataZile) VALUES
('C# Basics',         'Vasile Moraru',  1500.00, 30),
('Web Development',   'Ana Popa',       2000.00, 45),
('Python for Data',   'Ion Negru',      1800.00, 20),
('Graphic Design',    'Olga Sirbu',     1200.00, 15),
('Project Management','Radu Florea',    2500.00, 10),
('English B2',        'Irina Cucu',      900.00, 60);

INSERT INTO Inscriere (IdCursant, IdCurs, DataInscriere, StatusPlata) VALUES
(1, 1, '2026-01-10', 'Achitat'),
(1, 2, '2026-01-15', 'Neachitat'),
(2, 1, '2026-01-11', 'Achitat'),
(2, 3, '2026-02-01', 'Achitat'),
(3, 2, '2026-01-20', 'Neachitat'),
(4, 4, '2026-02-05', 'Achitat'),
(5, 5, '2026-02-10', 'Achitat'),
(6, 6, '2026-02-12', 'Neachitat');
-- ▲▲▲ МЕНЯТЬ: тестовые данные ▲▲▲
