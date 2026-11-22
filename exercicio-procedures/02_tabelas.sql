CREATE TABLE convenios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    convenio_id INT REFERENCES convenios(id)
);

CREATE TABLE terapeutas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE salas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE sessoes (
    id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL REFERENCES pacientes(id),
    terapeuta_id INT NOT NULL REFERENCES terapeutas(id),
    sala_id INT NOT NULL REFERENCES salas(id),
    data_hora TIMESTAMP NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'agendada'
);

INSERT INTO convenios (nome) VALUES ('Unimed'), ('Bradesco Saúde');
INSERT INTO pacientes (nome, convenio_id) VALUES ('Maria', 1), ('João', NULL);
INSERT INTO terapeutas (nome) VALUES ('Dra. Ana');
INSERT INTO salas (nome) VALUES ('Sala 1');
INSERT INTO sessoes (paciente_id, terapeuta_id, sala_id, data_hora, valor, status)
VALUES (1, 1, 1, '2027-01-10 10:00', 200.00, 'agendada'),
       (2, 1, 1, '2026-10-01 10:00', 200.00, 'realizada');