-- 1. Transação para registrar a reposição de um produto:
BEGIN TRANSACTION;

    -- Inserir a reposição na tabela tbl_repor
    INSERT INTO tbl_repor (cp_cod_func, cp_id_produto)
    VALUES (1, 10); -- Substitua pelos valores corretos

    -- Atualizar a quantidade do produto na tabela tbl_rfid
    UPDATE tbl_rfid
    SET quantidade = quantidade + 5 -- Substitua pela quantidade reposta
    WHERE cp_id_dispositivo = (SELECT ce_rfid FROM tbl_produto WHERE cp_id_produto = 10); -- Substitua pelo id do dispositivo

COMMIT;

-- 2. Transação para registrar a venda de um produto e atualizar o estoque:
BEGIN TRANSACTION;

    -- Inserir a venda na tabela tbl_vender_distribuir
    INSERT INTO tbl_vender_distribuir (cp_cod_estab, cp_id_produto, preco_venda, data_venda, itens_comprados)
    VALUES (1, 5, 10.50, CURRENT_DATE, '{1, 2, 3}'); -- Substitua pelos valores corretos

    -- Atualizar o status do RFID para "vendido"
    UPDATE tbl_rfid
    SET ind_venda_dispositivo = TRUE
    WHERE cp_id_dispositivo = (SELECT ce_rfid FROM tbl_produto WHERE cp_id_produto = 5); -- Substitua pelo id do dispositivo

    -- Decrementar a quantidade do produto na tabela tbl_rfid
    UPDATE tbl_rfid
    SET quantidade = quantidade - 1
    WHERE cp_id_dispositivo = (SELECT ce_rfid FROM tbl_produto WHERE cp_id_produto = 5); -- Substitua pelo id do dispositivo

COMMIT;
