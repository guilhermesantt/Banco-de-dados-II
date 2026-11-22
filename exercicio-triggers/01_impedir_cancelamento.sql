CREATE OR REPLACE FUNCTION fn_impedir_cancelamento_realizada()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.status = 'realizada' AND NEW.status = 'cancelada' THEN
        RAISE EXCEPTION 'Não é possível cancelar uma sessão já realizada.';
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_impedir_cancelamento_realizada ON sessoes;

CREATE TRIGGER trg_impedir_cancelamento_realizada
BEFORE UPDATE ON sessoes
FOR EACH ROW
EXECUTE FUNCTION fn_impedir_cancelamento_realizada();