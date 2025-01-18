-- conecte no seu banco e usuario usando o psql
psql -h localhost -p 5432 -U postgres -d postgres

-- Substitua somente o caminho que estao o csv e executa cada um dos copy no terminal

-- tbl_rfid
\copy tbl_rfid (cp_id_dispositivo, ind_venda_dispositivo, quantidade)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_rfid.csv'
DELIMITER ','
CSV HEADER;

-- tbl_categoria
\copy tbl_categoria (cp_cod_categoria, nm_categoria, min_distribuidor, max_distribuidor, min_container, max_container)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_categoria.csv'
DELIMITER ','
CSV HEADER;

-- tbl_estabelecimento
\copy tbl_estabelecimento (cp_cod_estab, nm_estab, cnpj_estab, localizacao_estab, endereco_estab, UF_estab, cidade_estab)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_estabelecimento.csv'
DELIMITER ','
CSV HEADER;

-- tbl_funcionario
\copy tbl_funcionario (cp_cod_func, nm_func, cpf_func, funcao_func)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_funcionario.csv'
DELIMITER ','
CSV HEADER;

-- tbl_fornecedor
\copy tbl_fornecedor (cp_cod_forn, cnpj_forn, localizacao_forn, endereco_forn, UF_forn, cidade_forn)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_fornecedor.csv'
DELIMITER ','
CSV HEADER;

-- tbl_produto
\copy tbl_produto (cp_id_produto, nm_prod, cd_ean_prod, ce_rfid, ce_categoria_principal, ce_categoria_secundaria, localizacao_prod, data_vencimento)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_produto.csv'
DELIMITER ','
CSV HEADER;


-- tbl_fornece
\copy tbl_fornece (cp_cod_forn, cp_id_produto, data_venda, data_vencimento, preco_venda)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_fornece.csv'
DELIMITER ','
CSV HEADER;

-- tbl_repor
\copy tbl_repor (cp_cod_func, cp_id_produto)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_repor.csv'
DELIMITER ','
CSV HEADER;

-- tbl_vender_distribuir
\copy tbl_vender_distribuir (cp_cod_estab, cp_id_produto, preco_venda, data_venda, itens_comprados)
FROM 'C:\Users\alessandra.jesus\Desktop\UFBA\tbl_vender_distribuir.csv'
DELIMITER ','
CSV HEADER;