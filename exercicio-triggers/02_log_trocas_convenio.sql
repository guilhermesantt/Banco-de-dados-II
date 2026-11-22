CREATE TABLE IF NOT EXISTS log_trocas_convenio (
    id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL,
    convenio_anterior INT,
    convenio_novo INT,
    data_troca TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION fn_log_troca_convenio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- IS DISTINCT FROM compara tratando NULL corretamente
    IF OLD.convenio_id IS DISTINCT FROM NEW.convenio_id THEN
        INSERT INTO log_trocas_convenio (paciente_id, convenio_anterior, convenio_novo, data_troca)
        VALUES (OLD.id, OLD.convenio_id, NEW.convenio_id, NOW());
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_log_troca_convenio ON pacientes;

CREATE TRIGGER trg_log_troca_convenio
AFTER UPDATE ON pacientes
FOR EACH ROW
EXECUTE FUNCTION fn_log_troca_convenio();