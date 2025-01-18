-- Queries Básicas

SELECT * FROM tbl_produto WHERE EXTRACT(YEAR FROM data_vencimento) = 2024;
SELECT nm_prod, cd_ean_prod FROM tbl_produto WHERE ce_categoria_principal = (SELECT cp_cod_categoria FROM tbl_categoria WHERE nm_categoria = 'Bebidas') OR ce_categoria_secundaria = (SELECT cp_cod_categoria FROM tbl_categoria WHERE nm_categoria = 'Bebidas');
SELECT nm_func FROM tbl_funcionario WHERE funcao_func = 'Repositor';
SELECT * FROM tbl_fornecedor WHERE UF_forn = 'BA';
SELECT p.* FROM tbl_produto p JOIN tbl_repor r ON p.cp_id_produto = r.cp_id_produto WHERE r.cp_cod_func = 1;
SELECT p.* FROM tbl_produto p JOIN tbl_fornece f ON p.cp_id_produto = f.cp_id_produto WHERE f.cp_cod_forn = 10;
SELECT e.nm_estab, e.localizacao_estab FROM tbl_estabelecimento e JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab WHERE vd.cp_id_produto = 5;
SELECT p.* FROM tbl_produto p JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo WHERE r.ind_venda_dispositivo = TRUE;
SELECT nm_estab, cnpj_estab FROM tbl_estabelecimento WHERE UF_estab = 'SP';
SELECT c.nm_categoria FROM tbl_categoria c JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal GROUP BY c.nm_categoria HAVING COUNT(p.cp_id_produto) > 50;
SELECT * FROM tbl_funcionario WHERE funcao_func IS NULL;
SELECT * FROM tbl_produto WHERE cp_id_produto NOT IN (SELECT cp_id_produto FROM tbl_fornece);
SELECT * FROM tbl_produto WHERE cp_id_produto NOT IN (SELECT cp_id_produto FROM tbl_repor);
SELECT * FROM tbl_produto WHERE EXTRACT(MONTH FROM data_vencimento) = 12;
SELECT * FROM tbl_produto WHERE cd_ean_prod LIKE '789%';
SELECT f.nm_forn, f.endereco_forn FROM tbl_fornecedor f JOIN tbl_fornece fn ON f.cp_cod_forn = fn.cp_cod_forn JOIN tbl_produto p ON fn.cp_id_produto = p.cp_id_produto WHERE p.nm_prod = 'Arroz';
SELECT f.nm_func FROM tbl_funcionario f JOIN tbl_repor r ON f.cp_cod_func = r.cp_cod_func JOIN tbl_produto p ON r.cp_id_produto = p.cp_id_produto JOIN tbl_categoria c ON p.ce_categoria_principal = c.cp_cod_categoria WHERE c.nm_categoria = 'Frios';
SELECT DISTINCT e.* FROM tbl_estabelecimento e JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab WHERE vd.preco_venda > 50;
SELECT p.* FROM tbl_produto p JOIN tbl_repor r ON p.cp_id_produto = r.cp_id_produto JOIN tbl_funcionario f ON r.cp_cod_func = f.cp_cod_func WHERE f.nm_func = 'João da Silva';
SELECT p.* FROM tbl_produto p JOIN tbl_fornece fn ON p.cp_id_produto = fn.cp_id_produto JOIN tbl_fornecedor f ON fn.cp_cod_forn = f.cp_cod_forn WHERE f.nm_forn = 'Fornecedor A';


-- Queries Intermediárias

SELECT e.nm_estab, p.nm_prod, COUNT(*) AS quantidade_vendida
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
JOIN tbl_produto p ON vd.cp_id_produto = p.cp_id_produto
GROUP BY e.nm_estab, p.nm_prod
ORDER BY e.nm_estab, quantidade_vendida DESC;

SELECT c.nm_categoria, p.nm_prod, p.quantidade_estoque
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
WHERE p.quantidade_estoque < c.min_estoque
UNION
SELECT c.nm_categoria, p.nm_prod, p.quantidade_estoque
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_secundaria
WHERE p.quantidade_estoque < c.min_estoque;

SELECT DISTINCT f.nm_forn
FROM tbl_fornecedor f
JOIN tbl_fornece fn ON f.cp_cod_forn = fn.cp_cod_forn
JOIN tbl_produto p ON fn.cp_id_produto = p.cp_id_produto
WHERE p.data_vencimento < CURRENT_DATE;

SELECT f.nm_func, COUNT(DISTINCT r.cp_id_produto) AS produtos_repostos
FROM tbl_funcionario f
JOIN tbl_repor r ON f.cp_cod_func = r.cp_cod_func
GROUP BY f.nm_func
HAVING COUNT(DISTINCT r.cp_id_produto) > 10;

SELECT e.nm_estab
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
JOIN tbl_produto p ON vd.cp_id_produto = p.cp_id_produto
WHERE p.ce_categoria_principal = 1
GROUP BY e.nm_estab
HAVING COUNT(DISTINCT p.cp_id_produto) = (SELECT COUNT(*) FROM tbl_produto WHERE ce_categoria_principal = 1);

SELECT p.nm_prod
FROM tbl_produto p
JOIN tbl_vender_distribuir vd ON p.cp_id_produto = vd.cp_id_produto
GROUP BY p.nm_prod
HAVING COUNT(DISTINCT vd.cp_cod_estab) > 1;

SELECT f.nm_forn, p.nm_prod, fn.preco_venda
FROM tbl_fornecedor f
JOIN tbl_fornece fn ON f.cp_cod_forn = fn.cp_cod_forn
JOIN tbl_produto p ON fn.cp_id_produto = p.cp_id_produto
GROUP BY f.nm_forn, p.nm_prod
HAVING COUNT(DISTINCT fn.preco_venda) > 1;

SELECT f.nm_func
FROM tbl_funcionario f
JOIN tbl_repor r ON f.cp_cod_func = r.cp_cod_func
JOIN tbl_produto p ON r.cp_id_produto = p.cp_id_produto
GROUP BY f.nm_func
HAVING COUNT(DISTINCT p.localizacao_prod) > 1;

SELECT e.nm_estab
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
WHERE vd.data_venda BETWEEN '2023-01-01' AND '2023-12-31';

SELECT p.nm_prod
FROM tbl_produto p
JOIN tbl_vender_distribuir vd ON p.cp_id_produto = vd.cp_id_produto
JOIN tbl_fornece fn ON p.cp_id_produto = fn.cp_id_produto
WHERE vd.preco_venda < fn.preco_venda;

SELECT c.nm_categoria, p.nm_prod, COUNT(*) AS quantidade_vendida
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
JOIN tbl_vender_distribuir vd ON p.cp_id_produto = vd.cp_id_produto
WHERE vd.data_venda BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY c.nm_categoria, p.nm_prod
ORDER BY c.nm_categoria, quantidade_vendida DESC;

SELECT c.nm_categoria, f.nm_forn, COUNT(*) AS quantidade_fornecida
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
JOIN tbl_fornece fn ON p.cp_id_produto = fn.cp_id_produto
JOIN tbl_fornecedor f ON fn.cp_cod_forn = f.cp_cod_forn
GROUP BY c.nm_categoria, f.nm_forn
ORDER BY c.nm_categoria, quantidade_fornecida DESC;

SELECT f.nm_func, COUNT(*) AS quantidade_reposicoes
FROM tbl_funcionario f
JOIN tbl_repor r ON f.cp_cod_func = r.cp_cod_func
JOIN tbl_produto p ON r.cp_id_produto = p.cp_id_produto
WHERE r.data_reposicao BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY f.nm_func
ORDER BY quantidade_reposicoes ASC;

SELECT e.nm_estab, COUNT(*) AS quantidade_vendida
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
JOIN tbl_produto p ON vd.cp_id_produto = p.cp_id_produto
WHERE p.ce_categoria_principal = 1 AND vd.data_venda BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY e.nm_estab
ORDER BY quantidade_vendida DESC;

SELECT p.nm_prod, p.data_vencimento
FROM tbl_produto p
LEFT JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo
WHERE p.data_vencimento <= CURRENT_DATE + INTERVAL '30 days' AND r.ind_venda_dispositivo = FALSE;


-- Queries Avançadas

SELECT p.nm_prod 
FROM tbl_produto p
WHERE NOT EXISTS (
    SELECT e.cp_cod_estab 
    FROM tbl_estabelecimento e 
    WHERE e.cidade_estab = '12345'
    EXCEPT
    SELECT vd.cp_cod_estab 
    FROM tbl_vender_distribuir vd 
    WHERE vd.cp_id_produto = p.cp_id_produto
);

SELECT f.nm_forn
FROM tbl_fornecedor f
WHERE NOT EXISTS (
    SELECT p.cp_id_produto
    FROM tbl_produto p
    WHERE p.ce_categoria_principal = 1
    EXCEPT
    SELECT fn.cp_id_produto
    FROM tbl_fornece fn
    WHERE fn.cp_cod_forn = f.cp_cod_forn
);

SELECT f.nm_func
FROM tbl_funcionario f
WHERE NOT EXISTS (
    SELECT l.cp_cod_loja
    FROM tbl_loja l
    WHERE l.regiao_loja = 'SP'
    EXCEPT
    SELECT l.cp_cod_loja
    FROM tbl_loja l
    JOIN tbl_repor r ON l.cp_cod_loja = r.cp_cod_loja
    WHERE r.cp_cod_func = f.cp_cod_func
);

SELECT p.nm_prod
FROM tbl_produto p
WHERE NOT EXISTS (
    SELECT vd.cp_id_produto
    FROM tbl_vender_distribuir vd
    WHERE vd.cp_id_produto = p.cp_id_produto
);

SELECT p.nm_prod
FROM tbl_produto p
WHERE EXISTS (
    SELECT vd.cp_id_produto
    FROM tbl_vender_distribuir vd
    WHERE vd.cp_id_produto = p.cp_id_produto
    AND vd.data_venda BETWEEN '2024-01-01' AND '2024-12-31'
)
AND NOT EXISTS (
    SELECT r.cp_id_produto
    FROM tbl_repor r
    WHERE r.cp_id_produto = p.cp_id_produto
    AND r.data_reposicao BETWEEN '2024-01-01' AND '2024-12-31'
);
