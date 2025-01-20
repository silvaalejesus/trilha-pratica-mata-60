-- 1. Procedure para adicionar um novo produto:
CREATE PROCEDURE adicionar_produto(
    p_nm_prod VARCHAR(60),
    p_cd_ean_prod CHAR(12),
    p_ce_rfid INT,
    p_ce_categoria_principal INT,
    p_ce_categoria_secundaria INT,
    p_localizacao_prod VARCHAR(100),
    p_data_vencimento DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Inserir o novo produto na tabela tbl_produto
    INSERT INTO tbl_produto (nm_prod, cd_ean_prod, ce_rfid, ce_categoria_principal, ce_categoria_secundaria, localizacao_prod, data_vencimento)
    VALUES (p_nm_prod, p_cd_ean_prod, p_ce_rfid, p_ce_categoria_principal, p_ce_categoria_secundaria, p_localizacao_prod, p_data_vencimento);
END;
$$;

-- 2. Procedure para atualizar a localização de um produto:
CREATE PROCEDURE atualizar_localizacao_produto(
    p_cp_id_produto INT,
    p_nova_localizacao VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificar se o produto existe
    IF EXISTS (SELECT 1 FROM tbl_produto WHERE cp_id_produto = p_cp_id_produto) THEN
        -- Atualizar a localização do produto
        UPDATE tbl_produto
        SET localizacao_prod = p_nova_localizacao
        WHERE cp_id_produto = p_cp_id_produto;
    ELSE
        RAISE EXCEPTION 'Produto não encontrado';
    END IF;
END;
$$;

