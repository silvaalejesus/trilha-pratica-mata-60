-- Criação das tabelas
CREATE TABLE tbl_produto (
    cp_id_produto SERIAL PRIMARY KEY,
    nm_prod VARCHAR(60) NOT NULL,
    cd_ean_prod CHAR(12) NOT NULL,
    ce_rfid INT,
    ce_categoria_principal INT,
    ce_categoria_secundaria INT,
    localizacao_prod VARCHAR(100),
    data_vencimento DATE NOT NULL,
);

CREATE TABLE tbl_rfid (
    cp_id_dispositivo INT PRIMARY KEY,
    ind_venda_dispositivo BOOLEAN NOT NULL,
    quantidade INT NOT NULL
);

CREATE TABLE tbl_categoria (
    cp_cod_categoria INT PRIMARY KEY,
    nm_categoria VARCHAR(20) NOT NULL,
    min_distribuidor INT,
    max_distribuidor INT,
    min_container INT,
    max_container INT
);

CREATE TABLE tbl_estabelecimento (
    cp_cod_estab INT PRIMARY KEY,
    nm_estab VARCHAR(60) NOT NULL,
    cnpj_estab CHAR(14) NOT NULL,
    localizacao_estab FLOAT[8],
    endereco_estab VARCHAR(200),
    UF_estab CHAR(2) NOT NULL,
    cidade_estab CHAR(5) NOT NULL
);

CREATE TABLE tbl_funcionario (
    cp_cod_func INT PRIMARY KEY,
    nm_func VARCHAR(200) NOT NULL,
    cpf_func CHAR(11) NOT NULL,
    funcao_func VARCHAR(40)
);

CREATE TABLE tbl_fornecedor (
    cp_cod_forn INT PRIMARY KEY,
    cnpj_forn CHAR(14) NOT NULL,
    localizacao_forn FLOAT[8],
    endereco_forn VARCHAR(200),
    UF_forn CHAR(2) NOT NULL,
    cidade_forn CHAR(5) NOT NULL
);

-- TABELAS INTERMEDIARIAS

-- relacao entre as tabelas produto e fornecedor
CREATE TABLE tbl_fornece (
    cp_cod_forn INT,
    cp_id_produto INT,
    data_venda DATE NOT NULL,
    data_vencimento DATE NOT NULL,
    preco_venda FLOAT NOT NULL,
    PRIMARY KEY (cp_cod_forn, cp_id_produto),
    FOREIGN KEY (cp_cod_forn) REFERENCES tbl_fornecedor(cp_cod_forn),
    FOREIGN KEY (cp_id_produto) REFERENCES tbl_produto(cp_id_produto)
);

-- relacao entre as tabelas produto e funcionario
CREATE TABLE tbl_repor (
    cp_cod_func INT,
    cp_id_produto INT,
    PRIMARY KEY (cp_cod_func, cp_id_produto),
    FOREIGN KEY (cp_cod_func) REFERENCES tbl_funcionario(cp_cod_func),
    FOREIGN KEY (cp_id_produto) REFERENCES tbl_produto(cp_id_produto)
);

-- relacao entre as tabelas produto e estabelecimento
CREATE TABLE tbl_vender_distribuir (
    cp_cod_estab INT,
    cp_id_produto INT,
    preco_venda FLOAT NOT NULL,
    data_venda DATE NOT NULL,
    itens_comprados INT[] NOT NULL,
    FOREIGN KEY (cp_cod_estab) REFERENCES tbl_estabelecimento(cp_cod_estab),
    FOREIGN KEY (cp_id_produto) REFERENCES tbl_produto(cp_id_produto)
);