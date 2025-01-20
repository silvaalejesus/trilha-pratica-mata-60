CREATE INDEX idx_produto_data_vencimento ON tbl_produto (data_vencimento);

CREATE INDEX idx_produto_categoria_principal ON tbl_produto (ce_categoria_principal);
CREATE INDEX idx_produto_categoria_secundaria ON tbl_produto (ce_categoria_secundaria);

CREATE INDEX idx_produto_rfid ON tbl_produto (ce_rfid);

CREATE INDEX idx_rfid_id_dispositivo ON tbl_rfid (cp_id_dispositivo);

CREATE INDEX idx_categoria_cod_categoria ON tbl_categoria (cp_cod_categoria);

CREATE INDEX idx_estabelecimento_cod_estab ON tbl_estabelecimento (cp_cod_estab);

CREATE INDEX idx_estabelecimento_uf ON tbl_estabelecimento (UF_estab);

CREATE INDEX idx_fornecedor_cod_forn ON tbl_fornecedor (cp_cod_forn);

CREATE INDEX idx_fornece_produto ON tbl_fornece (cp_id_produto);
CREATE INDEX idx_fornece_fornecedor ON tbl_fornece (cp_cod_forn);

CREATE INDEX idx_vender_distribuir_estab ON tbl_vender_distribuir (cp_cod_estab);
CREATE INDEX idx_vender_distribuir_produto ON tbl_vender_distribuir (cp_id_produto);



-- Dropar Indices
DROP INDEX idx_produto_data_vencimento;
DROP INDEX idx_produto_categoria_principal;
DROP INDEX idx_produto_categoria_secundaria;
DROP INDEX idx_produto_rfid;

DROP INDEX idx_rfid_id_dispositivo;

DROP INDEX idx_categoria_cod_categoria;

DROP INDEX idx_estabelecimento_cod_estab;
DROP INDEX idx_estabelecimento_uf;

DROP INDEX idx_fornecedor_cod_forn;

DROP INDEX idx_fornece_produto;
DROP INDEX idx_fornece_fornecedor;

DROP INDEX idx_vender_distribuir_estab;
DROP INDEX idx_vender_distribuir_produto;

