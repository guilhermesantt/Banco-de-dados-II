-- 1
CREATE OR REPLACE PROCEDURE aplicar_desconto_sessao(
    p_sessao_id INT,
    p_percentual NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_valor NUMERIC;
    v_status VARCHAR;
    v_valor_final NUMERIC;
BEGIN
    SELECT valor, status INTO v_valor, v_status
    FROM sessoes WHERE id = p_sessao_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Sessão não encontrada.';
    END IF;

    IF v_status <> 'agendada' THEN
        RAISE EXCEPTION 'Só é possível dar desconto em sessão agendada.';
    END IF;

    IF p_percentual < 1 OR p_percentual > 100 THEN
        RAISE EXCEPTION 'O percentual deve estar entre 1 e 100.';
    END IF;

    v_valor_final := v_valor - (v_valor * p_percentual / 100);

    IF v_valor_final < 50 THEN
        RAISE EXCEPTION 'O valor final não pode ser menor que R$ 50,00.';
    END IF;

    UPDATE sessoes SET valor = v_valor_final WHERE id = p_sessao_id;
END;
$$;

-- 2
CREATE OR REPLACE PROCEDURE cadastrar_sessao(
    p_paciente_id INT,
    p_terapeuta_id INT,
    p_sala_id INT,
    p_data_hora TIMESTAMP,
    p_valor NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pacientes WHERE id = p_paciente_id) THEN
        RAISE EXCEPTION 'Paciente não encontrado.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM terapeutas WHERE id = p_terapeuta_id) THEN
        RAISE EXCEPTION 'Terapeuta não encontrado.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM salas WHERE id = p_sala_id) THEN
        RAISE EXCEPTION 'Sala não encontrada.';
    END IF;

    IF p_data_hora < NOW() THEN
        RAISE EXCEPTION 'A data/hora não pode ser anterior ao momento atual.';
    END IF;

    IF p_valor <= 0 THEN
        RAISE EXCEPTION 'O valor deve ser maior que zero.';
    END IF;

    INSERT INTO sessoes (paciente_id, terapeuta_id, sala_id, data_hora, valor, status)
    VALUES (p_paciente_id, p_terapeuta_id, p_sala_id, p_data_hora, p_valor, 'agendada');
END;
$$;

-- 3
CREATE OR REPLACE PROCEDURE trocar_convenio(
    p_paciente_id INT,
    p_convenio_novo_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_convenio_atual INT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pacientes WHERE id = p_paciente_id) THEN
        RAISE EXCEPTION 'Paciente não encontrado.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM convenios WHERE id = p_convenio_novo_id) THEN
        RAISE EXCEPTION 'Convênio não encontrado.';
    END IF;

    SELECT convenio_id INTO v_convenio_atual
    FROM pacientes WHERE id = p_paciente_id;

    IF v_convenio_atual IS NOT DISTINCT FROM p_convenio_novo_id THEN
        RAISE EXCEPTION 'O paciente já está vinculado a este convênio.';
    END IF;

    UPDATE pacientes SET convenio_id = p_convenio_novo_id WHERE id = p_paciente_id;
END;
$$;