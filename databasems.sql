-- ============================================================
-- ФАЙЛ: database.sql
-- Импортировать через SSMS (SQL Server Management Studio):
-- New Query > вставить этот скрипт > Execute (F5)
-- ============================================================

-- ▼▼▼ МЕНЯТЬ: название базы данных ▼▼▼
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'learning_center')
BEGIN
    CREATE DATABASE learning_center;
END
GO

USE learning_center;
GO
-- ▲▲▲ МЕНЯТЬ: название базы данных ▲▲▲


-- ============================================================
-- ТАБЛИЦА 1: Cursant (Слушатели)
-- ▼▼▼ МЕНЯТЬ: название таблицы, поля ▼▼▼
-- ============================================================
IF OBJECT_ID('dbo.Cursant', 'U') IS NULL
BEGIN
    CREATE TABLE Cursant (
        IdCursant   INT IDENTITY(1,1) PRIMARY KEY,
        Nume        NVARCHAR(100) NOT NULL,
        Prenume     NVARCHAR(100) NOT NULL,
        Telefon     NVARCHAR(20)  NOT NULL,
        Email       NVARCHAR(150) NOT NULL UNIQUE  -- БОНУС: уникальность email
    );
END
GO
-- ▲▲▲ МЕНЯТЬ: Cursant ▲▲▲


-- ============================================================
-- ТАБЛИЦА 2: Curs (Курсы)
-- ▼▼▼ МЕНЯТЬ: название таблицы, поля ▼▼▼
-- ============================================================
IF OBJECT_ID('dbo.Curs', 'U') IS NULL
BEGIN
    CREATE TABLE Curs (
        IdCurs      INT IDENTITY(1,1) PRIMARY KEY,
        Denumire    NVARCHAR(200) NOT NULL,
        Formator    NVARCHAR(150) NOT NULL,
        Pret        DECIMAL(10,2) NOT NULL CHECK (Pret > 0),
        DurataZile  INT NOT NULL
    );
END
GO
-- ▲▲▲ МЕНЯТЬ: Curs ▲▲▲


-- ============================================================
-- ТАБЛИЦА 3: Inscriere (Регистрации) — связующая таблица
-- ▼▼▼ МЕНЯТЬ: название таблицы, поля, внешние ключи ▼▼▼
-- ============================================================
IF OBJECT_ID('dbo.Inscriere', 'U') IS NULL
BEGIN
    CREATE TABLE Inscriere (
        IdInscriere     INT IDENTITY(1,1) PRIMARY KEY,
        IdCursant       INT NOT NULL,
        IdCurs          INT NOT NULL,
        DataInscriere   DATE NOT NULL,
        StatusPlata     NVARCHAR(20) NOT NULL DEFAULT 'Neachitat'
                            CHECK (StatusPlata IN ('Achitat','Neachitat')),

        -- Один слушатель не может быть записан дважды на один курс
        CONSTRAINT uq_cursant_curs UNIQUE (IdCursant, IdCurs),

        CONSTRAINT fk_inscriere_cursant FOREIGN KEY (IdCursant)
            REFERENCES Cursant(IdCursant) ON DELETE CASCADE,
        CONSTRAINT fk_inscriere_curs FOREIGN KEY (IdCurs)
            REFERENCES Curs(IdCurs) ON DELETE CASCADE
    );
END
GO
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
GO

INSERT INTO Curs (Denumire, Formator, Pret, DurataZile) VALUES
('C# Basics',         'Vasile Moraru',  1500.00, 30),
('Web Development',   'Ana Popa',       2000.00, 45),
('Python for Data',   'Ion Negru',      1800.00, 20),
('Graphic Design',    'Olga Sirbu',     1200.00, 15),
('Project Management','Radu Florea',    2500.00, 10),
('English B2',        'Irina Cucu',      900.00, 60);
GO

INSERT INTO Inscriere (IdCursant, IdCurs, DataInscriere, StatusPlata) VALUES
(1, 1, '2026-01-10', 'Achitat'),
(1, 2, '2026-01-15', 'Neachitat'),
(2, 1, '2026-01-11', 'Achitat'),
(2, 3, '2026-02-01', 'Achitat'),
(3, 2, '2026-01-20', 'Neachitat'),
(4, 4, '2026-02-05', 'Achitat'),
(5, 5, '2026-02-10', 'Achitat'),
(6, 6, '2026-02-12', 'Neachitat');
GO
-- ▲▲▲ МЕНЯТЬ: тестовые данные ▲▲▲