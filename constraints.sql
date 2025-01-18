-- Adicionando constraints para as tabelas
ALTER TABLE tbl_produto
ADD CONSTRAINT fk_produto_rfid FOREIGN KEY (ce_rfid) REFERENCES tbl_rfid(cp_id_dispositivo),
ADD CONSTRAINT fk_produto_categoria_principal FOREIGN KEY (ce_categoria_principal) REFERENCES tbl_categoria(cp_cod_categoria),
ADD CONSTRAINT fk_produto_categoria_secundaria FOREIGN KEY (ce_categoria_secundaria) REFERENCES tbl_categoria(cp_cod_categoria);

ALTER TABLE tbl_produto
ADD CONSTRAINT fk_produto_estabelecimento FOREIGN KEY (cp_id_produto) REFERENCES tbl_estabelecimento(cp_cod_estab);

ALTER TABLE tbl_produto
ADD CONSTRAINT fk_produto_funcionario FOREIGN KEY (cp_id_produto) REFERENCES tbl_funcionario(cp_cod_func);

ALTER TABLE tbl_produto
ADD CONSTRAINT fk_produto_fornecedor FOREIGN KEY (cp_id_produto) REFERENCES tbl_fornecedor(cp_cod_forn);
