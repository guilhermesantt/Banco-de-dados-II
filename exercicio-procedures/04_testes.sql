CALL aplicar_desconto_sessao(1, 10);

SELECT * FROM sessoes;

CALL aplicar_desconto_sessao(2, 10);

CALL cadastrar_sessao(1, 1, 1, '2027-02-01 14:00', 150.00);

CALL trocar_convenio(2, 2);

CALL trocar_convenio(1, 1);