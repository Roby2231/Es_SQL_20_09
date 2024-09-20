CREATE DATABASE Es01_TaskFitness;
USE Es01_TaskFitness;

CREATE TABLE Abbonamento (
    abbonamentoID INT PRIMARY KEY IDENTITY (1,1),
    tipo_abb CHAR (12) NOT NULL CHECK (tipo_abb IN ('Mensile', 'Trimestrale', 'Annuale')),
    prezzo DECIMAL(10, 2) NOT NULL,
    data_ini DATE NOT NULL,
    data_fin DATE NOT NULL
);

CREATE TABLE Istruttore (
	istruttoreID INT PRIMARY KEY IDENTITY (1,1),
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    spec VARCHAR(100),
    orari_lav VARCHAR(100)
);


CREATE TABLE Classe (
	classeID INT PRIMARY KEY IDENTITY (1,1),
	nome VARCHAR (250) NOT NULL,
	tipo VARCHAR (50) NOT NULL CHECK (tipo IN ('Yoga', 'Pilates', 'Spinning','Sollevamento pesi')),
	descr TEXT,
	orario TIME NOT NULL,
	gio_sett CHAR (3) NOT NULL CHECK (gio_sett IN ('Lun','Mar','Mer','Gio','Ven','Sab','Dom')),
	num_max_part INT NOT NULL,
	istruttoreRIF INT NOT NULL, 
	FOREIGN KEY (istruttoreRIF) REFERENCES Istruttore(istruttoreID) ON DELETE CASCADE
);

CREATE TABLE Membro (
    membroID INT PRIMARY KEY IDENTITY (1,1),
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    data_nasc DATE NOT NULL,
    sesso CHAR(1) NOT NULL CHECK (sesso IN ('M', 'F')),
    ema VARCHAR(100) UNIQUE NOT NULL,
    tele VARCHAR(15) NOT NULL,
    abbonamentoRIF INT NOT NULL,
    FOREIGN KEY (abbonamentoRIF) REFERENCES Abbonamento(abbonamentoID) ON DELETE CASCADE
);

CREATE TABLE Prenotazione (
    prenotazioneID INT PRIMARY KEY IDENTITY (1,1),
    membroRIF INT NOT NULL,
    classeRIF INT NOT NULL,
    data_pren DATE NOT NULL,
    FOREIGN KEY (membroRIF) REFERENCES Membro(membroID) ON DELETE CASCADE,
    FOREIGN KEY (classeRIF) REFERENCES Classe(classeID) ON DELETE CASCADE
);

CREATE TABLE Attrezzatura (
    attrezzaturaID INT PRIMARY KEY IDENTITY (1,1),
    descrizione VARCHAR(250) NOT NULL,
    data_acq DATE NOT NULL,
	tipo_att VARCHAR (50) NOT NULL CHECK (tipo_att IN ('Tapis roulant', 'Biciclette da spinning','Pesi liberi')), 
    stato VARCHAR (25) NOT NULL CHECK (stato IN ('Disponibile','In Manutenzione','Fuori Servizio'))
);

INSERT INTO Abbonamento (tipo_abb, prezzo, data_ini, data_fin)
VALUES 
    ('Mensile', 30.00, '2024-09-01', '2024-09-30'),
    ('Trimestrale', 80.00, '2024-09-01', '2024-11-30'),
    ('Annuale', 300.00, '2024-09-01', '2025-08-31');


INSERT INTO Istruttore (nome, cognome, spec, orari_lav)
VALUES 
    ('Giulia', 'Rossi', 'Yoga e Pilates', 'Lun-Ven 09:00-18:00'),
    ('Marco', 'Bianchi', 'Spinning e Sollevamento pesi', 'Lun-Sab 10:00-19:00');


INSERT INTO Classe (nome, tipo, descr, orario, gio_sett, num_max_part, istruttoreRIF)
VALUES 
    ('Yoga per principianti', 'Yoga', 'Classe base di yoga per principianti.', '10:00:00', 'Lun', 20, 1),
    ('Spinning Intensivo', 'Spinning', 'Sessioni intense di spinning.', '18:00:00', 'Mar', 15, 2);


INSERT INTO Membro (nome, cognome, data_nasc, sesso, ema, tele, abbonamentoRIF)
VALUES 
    ('Laura', 'Verdi', '1990-05-15', 'F', 'laura.verdi@example.com', '3331234567', 1),
    ('Antonio', 'Neri', '1985-10-22', 'M', 'antonio.neri@example.com', '3342345678', 2);


INSERT INTO Prenotazione (membroRIF, classeRIF, data_pren)
VALUES 
    (1, 1, '2024-09-20'),
    (2, 2, '2024-09-21');


INSERT INTO Attrezzatura (descrizione, data_acq, tipo_att, stato)
VALUES 
    ('Tapis roulant Technogym', '2024-08-01', 'Tapis roulant', 'Disponibile'),
    ('Bicicletta da spinning BH', '2024-08-15', 'Biciclette da spinning', 'In Manutenzione'),
    ('Set di pesi liberi', '2024-09-01', 'Pesi liberi', 'Disponibile');

-- -----------------------------------------------------------------------

-- Recupera tutti i membri registrati nel sistema.
SELECT * FROM Membro;

-- Recupera il nome e il cognome di tutti i membri che hanno un abbonamento mensile.
SELECT Membro.nome, Membro.cognome 
	FROM Membro 
	JOIN Abbonamento ON Membro.abbonamentoRIF = Abbonamento.abbonamentoID
	WHERE tipo_abb = 'Mensile';

-- Recupera l'elenco delle classi di yoga offerte dal centro fitness
SELECT *
	FROM Classe
	WHERE tipo = 'Yoga';

-- Recupera il nome e cognome degli istruttori che insegnano Pilates
SELECT Istruttore.nome, Istruttore.cognome
	FROM Istruttore 
	JOIN Classe ON Istruttore.istruttoreID = Classe.istruttoreRIF
	WHERE tipo = 'Pilates';

-- Recupera i dettagli delle classi programmate per il lunedì
SELECT *
	FROM Classe
	WHERE gio_sett = 'Lun';

-- Recupera l'elenco dei membri che hanno prenotato una classe di spinning
SELECT *
	FROM Membro 
	JOIN Prenotazione ON Membro.membroID = Prenotazione.membroRIF
	JOIN Classe ON Prenotazione.classeRIF = Classe.classeID
	WHERE tipo = 'Spinning';

-- Recupera tutte le attrezzature che sono attualmente fuori servizio
SELECT * 
	FROM Attrezzatura 
	WHERE stato = 'Fuori servizio';

-- Conta il numero di partecipanti per ciascuna classe programmata per il mercoledì

SELECT Classe.nome, COUNT(Prenotazione.membroRIF) AS num_participanti
	FROM Classe 
	LEFT JOIN Prenotazione ON Classe.classeID = Prenotazione.classeRIF
	WHERE gio_sett = 'Mer'
	GROUP BY Classe.nome;
	
-- Recupera l'elenco degli istruttori disponibili per tenere una lezione il sabato
SELECT *	
	FROM Istruttore
	JOIN Classe ON Istruttore.istruttoreID = Classe.istruttoreRIF
	WHERE gio_sett = 'Sab';

-- Recupera tutti i membri che hanno un abbonamento attivo dal 2023
SELECT *
	FROM Membro 
	JOIN Abbonamento ON Membro.abbonamentoRIF = Abbonamento.abbonamentoID
	WHERE data_ini > '2023-01-01';
	
-- Trova il numero massimo di partecipanti per tutte le classi di sollevamento pesi
SELECT MAX(num_max_part) AS max_partecipanti
	FROM Classe
	WHERE tipo = 'Sollevamento pesi';

-- Recupera le prenotazioni effettuate da un membro specifico
SELECT Prenotazione.prenotazioneID, Classe.nome AS classe_nome, Prenotazione.data_pren
	FROM Prenotazione
	JOIN Classe ON Prenotazione.classeRIF = Classe.classeID
	WHERE Prenotazione.membroRIF = 'Giulia';

-- Recupera l'elenco degli istruttori che conducono più di 5 classi alla settimana
SELECT Istruttore.nome, Istruttore.cognome
	FROM Istruttore
	JOIN Classe ON Istruttore.istruttoreID = Classe.istruttoreRIF
	GROUP BY Istruttore.istruttoreID, Istruttore.nome, Istruttore.cognome
	HAVING COUNT(Classe.classeID) > 5;

-- Recupera le classi che hanno ancora posti disponibili per nuove prenotazioni
SELECT Classe.nome, Classe.num_max_part, COUNT(Prenotazione.membroRIF) AS num_prenotazioni
	FROM Classe 
	LEFT JOIN Prenotazione ON Classe.classeID = Prenotazione.classeRIF
	GROUP BY Classe.nome, Classe.num_max_part
	HAVING COUNT(Prenotazione.membroRIF) < Classe.num_max_part;

-- Recupera l'elenco dei membri che hanno annullato una prenotazione negli ultimi 30 giorni
SELECT *
	FROM Membro 
	JOIN Prenotazione ON Membro.membroID = Prenotazione.membroRIF
	WHERE Prenotazione.data_pren >= DATEADD(DAY, -30, GETDATE())
	AND Prenotazione.classeRIF IS NULL; 

-- Recupera tutte le attrezzature acquistate prima del 2022
SELECT *
	FROM Attrezzatura
	WHERE data_acq < '2022-01-01';

-- Recupera l'elenco dei membri che hanno prenotato una classe in cui l'istruttore è "Mario Rossi":
SELECT *
	FROM Membro 
	JOIN Prenotazione ON Membro.membroID = Prenotazione.membroRIF
	JOIN Classe ON Prenotazione.classeRIF = Classe.classeID
	JOIN Istruttore ON Classe.istruttoreRIF = Istruttore.istruttoreID
	WHERE Istruttore.nome = 'Mario' AND Istruttore.cognome = 'Rossi';

-- Calcola il numero totale di prenotazioni per ogni classe per un determinato periodo di tempo
SELECT Classe.nome, COUNT(Prenotazione.prenotazioneID) AS num_prenotazioni
	FROM Classe
	LEFT JOIN Prenotazione ON Classe.classeID = Prenotazione.classeRIF
	WHERE Prenotazione.data_pren BETWEEN 2024-09-20 AND 2024-09-21  
	GROUP BY Classe.nome;

-- Trova tutte le classi associate a un'istruttore specifico e i membri che vi hanno partecipato
SELECT Classe.nome AS classe_nome, Membro.nome AS membro_nome, Membro.cognome AS membro_cognome
	FROM Classe 
	JOIN Prenotazione ON Classe.classeID = Prenotazione.classeRIF
	JOIN Membro ON Prenotazione.membroRIF = Membro.membroID
	WHERE Classe.istruttoreRIF = 'Giulia';  

-- Recupera tutte le attrezzature in manutenzione e il nome degli istruttori che le utilizzano nelle loro classi
SELECT Attrezzatura.descrizione AS attrezzatura_descrizione, Istruttore.nome AS istruttore_nome, Istruttore.cognome AS istruttore_cognome
	FROM Attrezzatura
	JOIN Classe ON Attrezzatura.tipo_att = Classe.tipo
	JOIN Istruttore ON Classe.istruttoreRIF = Istruttore.istruttoreID
	WHERE Attrezzatura.stato = 'In Manutenzione';

-- ---------------------------------------------------------------------------------------
--	Crea una view che mostra l'elenco completo dei membri con il loro nome, cognome e tipo di abbonamento.
CREATE VIEW V_Membri_Abbonamento AS
	SELECT Membro.nome, Membro.cognome, Abbonamento.tipo_abb
	FROM Membro
	JOIN Abbonamento ON Membro.abbonamentoRIF = Abbonamento.abbonamentoID;

--	Crea una view che elenca tutte le classi disponibili con i rispettivi nomi degli istruttori.
CREATE VIEW V_Classi_Istruttori AS
	SELECT Classe.nome AS classe_nome, Istruttore.nome AS istruttore_nome, Istruttore.cognome AS istruttore_cognome
	FROM Classe
	JOIN Istruttore ON Classe.istruttoreRIF = Istruttore.istruttoreID;

--	Crea una view che mostra le classi prenotate dai membri insieme al nome della classe e alla data di prenotazione.
CREATE VIEW V_Classi_Prenotate AS
SELECT Membro.nome AS membro_nome, Membro.cognome AS membro_cognome, Classe.nome AS classe_nome, Prenotazione.data_pren
FROM Prenotazione
JOIN Membro ON Prenotazione.membroRIF = Membro.membroID
JOIN Classe ON Prenotazione.classeRIF = Classe.classeID;

--	Crea una view che elenca tutte le attrezzature attualmente disponibili, con la descrizione e lo stato.
CREATE VIEW V_Attrezzature_Disponibili AS
SELECT descrizione, stato
FROM Attrezzatura
WHERE stato = 'Disponibile';

--	Crea una view che mostra i membri che hanno prenotato una classe di spinning negli ultimi 30 giorni.
CREATE VIEW V_Membri_Spinning_Recenti AS
SELECT DISTINCT Membro.nome, Membro.cognome
FROM Membro
JOIN Prenotazione ON Membro.membroID = Prenotazione.membroRIF
JOIN Classe ON Prenotazione.classeRIF = Classe.classeID
WHERE Classe.tipo = 'Spinning' AND Prenotazione.data_pren >= DATEADD(DAY, -30, GETDATE());

--	Crea una view che elenca gli istruttori con il numero totale di classi che conducono.
CREATE VIEW V_Istruttori_Conteggio_Classi AS
SELECT Istruttore.nome, Istruttore.cognome, COUNT(c.classeID) AS num_classi
FROM Istruttore
JOIN Classe ON Istruttore.istruttoreID = Classe.istruttoreRIF
GROUP BY Istruttore.nome, Istruttore.cognome;

--	Crea una view che mostri il nome delle classi e il numero di partecipanti registrati per ciascuna classe.
CREATE VIEW V_Classi_Numero_Partecipanti AS
SELECT Classe.nome AS classe_nome, COUNT(Prenotazione.membroRIF) AS num_partecipanti
FROM Classe
LEFT JOIN Prenotazione ON Classe.classeID = Prenotazione.classeRIF
GROUP BY Classe.nome;

--	Crea una view che elenca i membri che hanno un abbonamento attivo insieme alla data di inizio e la data di scadenza.
CREATE VIEW V_Membri_Abbonamenti_Attivi AS
SELECT Membro.nome, Membro.cognome, Abbonamento.data_ini, Abbonamento.data_fin
FROM Membro
JOIN Abbonamento ON Membro.abbonamentoRIF = Abbonamento.abbonamentoID
WHERE Abbonamento.data_fin >= GETDATE();

--	Crea una view che mostra l'elenco degli istruttori che conducono classi il lunedì e il venerdì.
CREATE VIEW V_Istruttori_Lun_Ven AS
SELECT DISTINCT Istruttore.nome, Istruttore.cognome
FROM Istruttore
JOIN Classe ON Istruttore.istruttoreID = Classe.istruttoreRIF
WHERE Classe.gio_sett IN ('Lun', 'Ven');

--.	Crea una view che elenca tutte le attrezzature acquistate nel 2023 insieme al loro stato attuale.
CREATE VIEW V_Attrezzature_2023 AS
SELECT descrizione, stato
FROM Attrezzatura
WHERE YEAR(data_acq) = 2023;

-- -------------------------------------------------------------------------
--	Scrivi una stored procedure che permette di inserire un nuovo membro nel sistema 
-- con tutti i suoi dettagli, come nome, cognome, data di nascita, tipo di abbonamento, ecc.
CREATE PROCEDURE InserisciMembro 
    @nome VARCHAR(50),
    @cognome VARCHAR(50),
    @data_nasc DATE,
    @sesso CHAR(1),
    @ema VARCHAR(100),
    @tele VARCHAR(15),
    @tipo_abb CHAR(12), 
    @prezzo DECIMAL(10, 2),
    @data_ini DATE,
    @data_fin DATE
AS
BEGIN
    DECLARE @abbonamentoID INT;
    
    INSERT INTO Abbonamento (tipo_abb, prezzo, data_ini, data_fin)
    VALUES (@tipo_abb, @prezzo, @data_ini, @data_fin);
    
    SET @abbonamentoID = SCOPE_IDENTITY();
    
    INSERT INTO Membro (nome, cognome, data_nasc, sesso, ema, tele, abbonamentoRIF)
    VALUES (@nome, @cognome, @data_nasc, @sesso, @ema, @tele, @abbonamentoID);
END;

--	Scrivi una stored procedure per aggiornare lo stato di un'attrezzatura (ad esempio, disponibile, in manutenzione, fuori servizio).
CREATE PROCEDURE AggiornaStatoAttrezzatura
    @attrezzaturaID INT,
    @nuovo_stato VARCHAR(25)
AS
BEGIN
    UPDATE Attrezzatura
    SET stato = @nuovo_stato
    WHERE attrezzaturaID = @attrezzaturaID;
END;

--	Scrivi una stored procedure che consenta a un membro di prenotare una classe specifica.
CREATE PROCEDURE PrenotaClasse
    @membroID INT,
    @classeID INT,
    @data_pren DATE
AS
BEGIN
    DECLARE @num_prenotati INT;
    DECLARE @num_max_part INT;
    
    SELECT @num_prenotati = COUNT(*)
    FROM Prenotazione
    WHERE classeRIF = @classeID;
    
    SELECT @num_max_part = num_max_part
    FROM Classe
    WHERE classeID = @classeID;
    
    IF @num_prenotati < @num_max_part
    BEGIN
        INSERT INTO Prenotazione (membroRIF, classeRIF, data_pren)
        VALUES (@membroID, @classeID, @data_pren);
    END
    ELSE
    BEGIN
        RAISERROR('La classe ha raggiunto il numero massimo di partecipanti.', 16, 1);
    END;
END;

--	Scrivi una stored procedure per permettere ai membri di cancellare una prenotazione esistente.
CREATE PROCEDURE CancellaPrenotazione
    @prenotazioneID INT
AS
BEGIN
    DELETE FROM Prenotazione
    WHERE prenotazioneID = @prenotazioneID;
END;

--	Scrivi una stored procedure che restituisce il numero di classi condotte da un istruttore specifico.
CREATE PROCEDURE ConteggioClassiIstruttore
    @istruttoreID INT
AS
BEGIN
    SELECT COUNT(classeID) AS num_classi
    FROM Classe
    WHERE istruttoreRIF = @istruttoreID;
END;


