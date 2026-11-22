CREATE TABLE IF NOT EXISTS log_sessoes_deletadas (
    id SERIAL PRIMARY KEY,
    sessao_id INT NOT NULL,
    paciente_id INT,
    terapeuta_id INT,
    data_hora TIMESTAMP,
    valor NUMERIC(10,2),
    status VARCHAR(20),
    data_exclusao TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION fn_log_sessao_deletada()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO log_sessoes_deletadas
        (sessao_id, paciente_id, terapeuta_id, data_hora, valor, status, data_exclusao)
    VALUES
        (OLD.id, OLD.paciente_id, OLD.terapeuta_id, OLD.data_hora, OLD.valor, OLD.status, NOW());
    RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trg_log_sessao_deletada ON sessoes;

CREATE TRIGGER trg_log_sessao_deletada
AFTER DELETE ON sessoes
FOR EACH ROW
EXECUTE FUNCTION fn_log_sessao_deletada();