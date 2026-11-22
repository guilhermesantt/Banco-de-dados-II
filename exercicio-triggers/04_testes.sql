-- TESTE 1: deve dar error
UPDATE sessoes SET status = 'cancelada' WHERE id = 2;

-- TESTE 1: deve funfar
UPDATE sessoes SET status = 'cancelada' WHERE id = 1;
SELECT id, status FROM sessoes ORDER BY id;

-- TESTE 2: deve registrar no log (1 -> 2)
UPDATE pacientes SET convenio_id = 2 WHERE id = 1;
-- não deve registrar porque o convenio é uigual
UPDATE pacientes SET convenio_id = 2 WHERE id = 1;
-- deve registrar (2 -> NULL, paciente particular
UPDATE pacientes SET convenio_id = NULL WHERE id = 1;
-- não deve registrar (NULL -> NULL)
UPDATE pacientes SET convenio_id = NULL WHERE id = 1;
-- não deve registrar (mudou só o nome)
UPDATE pacientes SET nome = 'Maria Silva' WHERE id = 1;
SELECT * FROM log_trocas_convenio;

-- TESTE 3: cria uma sessão com status falta e deleta
INSERT INTO sessoes (paciente_id, terapeuta_id, sala_id, data_hora, valor, status)
VALUES (1, 1, 1, '2027-03-01 09:00', 120.00, 'falta');
DELETE FROM sessoes WHERE status = 'falta';
SELECT * FROM log_sessoes_deletadas;
SELECT id, status FROM sessoes ORDER BY id;