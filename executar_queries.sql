-- Habilitar a saída do tempo de execução
\timing on

-- Criar uma tabela para armazenar os tempos de execução
CREATE TABLE tempos_execucao (
    rodada INT,
    query TEXT,
    tempo_execucao NUMERIC
);

-- Loop para executar as queries 50 vezes
DO $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..50 LOOP
        -- Executar a query 1 e inserir o tempo de execução na tabela
        EXPLAIN ANALYZE SELECT * FROM tbl_produto WHERE EXTRACT(YEAR FROM data_vencimento) = 2024;
        INSERT INTO tempos_execucao (rodada, query, tempo_execucao) VALUES (i, 'Query 1', (SELECT total_time FROM pg_stat_statements ORDER BY calls DESC LIMIT 1));

        -- Executar a query 2 e inserir o tempo de execução na tabela
        EXPLAIN ANALYZE SELECT nm_prod, cd_ean_prod FROM tbl_produto WHERE ce_categoria_principal = (SELECT cp_cod_categoria FROM tbl_categoria WHERE nm_categoria = 'Bebidas') OR ce_categoria_secundaria = (SELECT cp_cod_categoria FROM tbl_categoria WHERE nm_categoria = 'Bebidas');
        INSERT INTO tempos_execucao (rodada, query, tempo_execucao) VALUES (i, 'Query 2', (SELECT total_time FROM pg_stat_statements ORDER BY calls DESC LIMIT 1));

        -- ... adicione as outras 43 queries aqui
    END LOOP;
END $$;

-- Desabilitar a saída do tempo de execução
\timing off

-- Exportar os dados da tabela para um arquivo CSV
\copy tempos_execucao TO 'tempos_execucao.csv' WITH (FORMAT CSV, HEADER);