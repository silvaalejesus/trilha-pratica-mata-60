## Queries Básicas (20)

-- **1. Listar todos os produtos com data de vencimento em 2024.**

SELECT * FROM tbl_produto WHERE EXTRACT(YEAR FROM data_vencimento) = 2024;

-- **2. Listar o nome e o código de barras de todos os produtos da categoria 'Bebidas'.**

SELECT nm_prod, cd_ean_prod 
FROM tbl_produto 
WHERE ce_categoria_principal = (SELECT cp_cod_categoria FROM tbl_categoria WHERE nm_categoria = 'Bebidas') 
OR ce_categoria_secundaria = (SELECT cp_cod_categoria FROM tbl_categoria WHERE nm_categoria = 'Bebidas');

-- **3. Listar o nome de todos os funcionários que trabalham na função 'Repositor'.**

SELECT nm_func FROM tbl_funcionario WHERE funcao_func = 'Repositor';

-- **4. Listar todos os fornecedores localizados na Bahia.**

SELECT * FROM tbl_fornecedor WHERE UF_forn = 'BA';

-- **5. Listar todos os produtos que foram repostos pelo funcionário com código 1.**

SELECT p.* 
FROM tbl_produto p
JOIN tbl_repor r ON p.cp_id_produto = r.cp_id_produto
WHERE r.cp_cod_func = 1;

-- **6. Listar todos os produtos fornecidos pelo fornecedor com código 10.**

SELECT p.*
FROM tbl_produto p
JOIN tbl_fornece f ON p.cp_id_produto = f.cp_id_produto
WHERE f.cp_cod_forn = 10;

-- **7. Listar o nome e a localização de todos os estabelecimentos que venderam o produto com código 5.**

SELECT e.nm_estab, e.localizacao_estab
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
WHERE vd.cp_id_produto = 5;

-- **8. Listar todos os produtos com RFID que indica que o produto já foi vendido.**

SELECT p.*
FROM tbl_produto p
JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo
WHERE r.ind_venda_dispositivo = TRUE;

-- **9. Listar o nome e o CNPJ de todos os estabelecimentos localizados em São Paulo.**

SELECT nm_estab, cnpj_estab FROM tbl_estabelecimento WHERE UF_estab = 'SP';

-- **10. Listar o nome de todas as categorias que possuem mais de 50 produtos.**

SELECT c.nm_categoria
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
GROUP BY c.nm_categoria
HAVING COUNT(p.cp_id_produto) > 50;

-- **11. Listar todos os funcionários que não possuem função definida.**

SELECT * FROM tbl_funcionario WHERE funcao_func IS NULL;

-- **12. Listar todos os produtos que não foram fornecidos por nenhum fornecedor.**

SELECT * 
FROM tbl_produto 
WHERE cp_id_produto NOT IN (SELECT cp_id_produto FROM tbl_fornece);

-- **13. Listar todos os produtos que não foram repostos por nenhum funcionário.**

SELECT * 
FROM tbl_produto 
WHERE cp_id_produto NOT IN (SELECT cp_id_produto FROM tbl_repor);

-- **14. Listar todos os produtos com data de vencimento no mês de dezembro.**

SELECT * FROM tbl_produto WHERE EXTRACT(MONTH FROM data_vencimento) = 12;

-- **15. Listar todos os produtos com código de barras que começa com '789'.**

SELECT * FROM tbl_produto WHERE cd_ean_prod LIKE '789%';

-- **16. Listar o nome e o endereço de todos os fornecedores que fornecem o produto 'Arroz'.**

SELECT f.nm_forn, f.endereco_forn
FROM tbl_fornecedor f
JOIN tbl_fornece fn ON f.cp_cod_forn = fn.cp_cod_forn
JOIN tbl_produto p ON fn.cp_id_produto = p.cp_id_produto
WHERE p.nm_prod = 'Arroz';

-- **17. Listar o nome de todos os funcionários que repostos produtos da categoria 'Frios'.**

SELECT f.nm_func
FROM tbl_funcionario f
JOIN tbl_repor r ON f.cp_cod_func = r.cp_cod_func
JOIN tbl_produto p ON r.cp_id_produto = p.cp_id_produto
JOIN tbl_categoria c ON p.ce_categoria_principal = c.cp_cod_categoria
WHERE c.nm_categoria = 'Frios';

-- **18. Listar todos os estabelecimentos que venderam produtos com preço maior que R$ 50.**

SELECT DISTINCT e.*
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
WHERE vd.preco_venda > 50;

-- **19. Listar todos os produtos que foram repostos pelo funcionário 'João da Silva'.**

SELECT p.*
FROM tbl_produto p
JOIN tbl_repor r ON p.cp_id_produto = r.cp_id_produto
JOIN tbl_funcionario f ON r.cp_cod_func = f.cp_cod_func
WHERE f.nm_func = 'João da Silva';

-- **20. Listar todos os produtos que foram fornecidos pelo fornecedor 'Fornecedor A'.**

SELECT p.*
FROM tbl_produto p
JOIN tbl_fornece fn ON p.cp_id_produto = fn.cp_id_produto
JOIN tbl_fornecedor f ON fn.cp_cod_forn = f.cp_cod_forn
WHERE f.nm_forn = 'Fornecedor A';

## Queries Intermediárias (15)

-- **1. Listar os 5 produtos mais vendidos em cada estabelecimento.**

SELECT e.nm_estab, p.nm_prod, COUNT(*) AS quantidade_vendida
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
JOIN tbl_produto p ON vd.cp_id_produto = p.cp_id_produto
GROUP BY e.nm_estab, p.nm_prod
ORDER BY e.nm_estab, quantidade_vendida DESC;

-- **2. Listar os produtos que estão com estoque abaixo do mínimo em cada categoria.**

SELECT c.nm_categoria, p.nm_prod, p.quantidade_estoque
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
WHERE p.quantidade_estoque < c.min_estoque
UNION
SELECT c.nm_categoria, p.nm_prod, p.quantidade_estoque
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_secundaria
WHERE p.quantidade_estoque < c.min_estoque;

-- **3. Listar os fornecedores que forneceram produtos com data de vencimento expirada.**

SELECT DISTINCT f.nm_forn
FROM tbl_fornecedor f
JOIN tbl_fornece fn ON f.cp_cod_forn = fn.cp_cod_forn
JOIN tbl_produto p ON fn.cp_id_produto = p.cp_id_produto
WHERE p.data_vencimento < CURRENT_DATE;

-- **4. Listar os funcionários que repostos mais de 10 produtos diferentes.**

SELECT f.nm_func, COUNT(DISTINCT r.cp_id_produto) AS produtos_repostos
FROM tbl_funcionario f
JOIN tbl_repor r ON f.cp_cod_func = r.cp_cod_func
GROUP BY f.nm_func
HAVING COUNT(DISTINCT r.cp_id_produto) > 10;

-- **5. Listar os estabelecimentos que venderam todos os produtos de uma determinada categoria.**

SELECT e.nm_estab
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
JOIN tbl_produto p ON vd.cp_id_produto = p.cp_id_produto
WHERE p.ce_categoria_principal = 1
GROUP BY e.nm_estab
HAVING COUNT(DISTINCT p.cp_id_produto) = (SELECT COUNT(*) FROM tbl_produto WHERE ce_categoria_principal = 1);

-- **6. Listar os produtos que foram vendidos em mais de um estabelecimento.**

SELECT p.nm_prod
FROM tbl_produto p
JOIN tbl_vender_distribuir vd ON p.cp_id_produto = vd.cp_id_produto
GROUP BY p.nm_prod
HAVING COUNT(DISTINCT vd.cp_cod_estab) > 1;

-- **7. Listar os fornecedores que forneceram o mesmo produto com preços diferentes.**

SELECT f.nm_forn, p.nm_prod, fn.preco_venda
FROM tbl_fornecedor f
JOIN tbl_fornece fn ON f.cp_cod_forn = fn.cp_cod_forn
JOIN tbl_produto p ON fn.cp_id_produto = p.cp_id_produto
GROUP BY f.nm_forn, p.nm_prod
HAVING COUNT(DISTINCT fn.preco_venda) > 1;

-- **8. Listar os funcionários que repostos produtos em mais de um estabelecimento.**

SELECT f.nm_func
FROM tbl_funcionario f
JOIN tbl_repor r ON f.cp_cod_func = r.cp_cod_func
JOIN tbl_produto p ON r.cp_id_produto = p.cp_id_produto
GROUP BY f.nm_func
HAVING COUNT(DISTINCT p.localizacao_prod) > 1;

-- **9. Listar os estabelecimentos que tiveram vendas em um determinado período.**

SELECT e.nm_estab
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
WHERE vd.data_venda BETWEEN '2023-01-01' AND '2023-12-31';

-- **10. Listar os produtos que foram vendidos com desconto em relação ao preço de fornecimento.**

SELECT p.nm_prod
FROM tbl_produto p
JOIN tbl_vender_distribuir vd ON p.cp_id_produto = vd.cp_id_produto
JOIN tbl_fornece fn ON p.cp_id_produto = fn.cp_id_produto
WHERE vd.preco_venda < fn.preco_venda;

-- **11. Listar os produtos mais vendidos por categoria em um determinado período.**

SELECT c.nm_categoria, p.nm_prod, COUNT(*) AS quantidade_vendida
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
JOIN tbl_vender_distribuir vd ON p.cp_id_produto = vd.cp_id_produto
WHERE vd.data_venda BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY c.nm_categoria, p.nm_prod
ORDER BY c.nm_categoria, quantidade_vendida DESC;

-- **12. Listar os fornecedores que mais forneceram produtos para cada categoria.**

SELECT c.nm_categoria, f.nm_forn, COUNT(*) AS quantidade_fornecida
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
JOIN tbl_fornece fn ON p.cp_id_produto = fn.cp_id_produto
JOIN tbl_fornecedor f ON fn.cp_cod_forn = f.cp_cod_forn
GROUP BY c.nm_categoria, f.nm_forn
ORDER BY c.nm_categoria, quantidade_fornecida DESC;

-- **13. Listar os funcionários que menos repostos produtos em um determinado período.**

SELECT f.nm_func, COUNT(*) AS quantidade_reposicoes
FROM tbl_funcionario f
JOIN tbl_repor r ON f.cp_cod_func = r.cp_cod_func
JOIN tbl_produto p ON r.cp_id_produto = p.cp_id_produto
WHERE r.data_reposicao BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY f.nm_func
ORDER BY quantidade_reposicoes ASC;

-- **14. Listar os estabelecimentos que mais venderam produtos de uma determinada categoria em um determinado período.**

SELECT e.nm_estab, COUNT(*) AS quantidade_vendida
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
JOIN tbl_produto p ON vd.cp_id_produto = p.cp_id_produto
WHERE p.ce_categoria_principal = 1 AND vd.data_venda BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY e.nm_estab
ORDER BY quantidade_vendida DESC;

-- **15. Listar os produtos que estão próximos da data de vencimento e que ainda não foram vendidos.**

SELECT p.nm_prod, p.data_vencimento
FROM tbl_produto p
LEFT JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo
WHERE p.data_vencimento <= CURRENT_DATE + INTERVAL '30 days' AND r.ind_venda_dispositivo = FALSE;

## Queries Avançadas (10)

-- **1. Listar os produtos que foram vendidos em todos os estabelecimentos de uma determinada cidade.**

-- Subquery para obter todos os estabelecimentos de uma cidade específica
SELECT e.cp_cod_estab 
FROM tbl_estabelecimento e 
WHERE e.cidade_estab = '12345'; -- Substitua '12345' pelo código da cidade desejada

-- Consulta principal para encontrar os produtos que foram vendidos em todos os estabelecimentos encontrados na subquery
SELECT p.nm_prod 
FROM tbl_produto p
WHERE NOT EXISTS (
    SELECT e.cp_cod_estab 
    FROM tbl_estabelecimento e 
    WHERE e.cidade_estab = '12345' -- Substitua '12345' pelo código da cidade desejada
    EXCEPT
    SELECT vd.cp_cod_estab 
    FROM tbl_vender_distribuir vd 
    WHERE vd.cp_id_produto = p.cp_id_produto
);

-- **2. Listar os fornecedores que forneceram todos os produtos de uma determinada categoria.**

SELECT f.nm_forn
FROM tbl_fornecedor f
WHERE NOT EXISTS (
    SELECT p.cp_id_produto
    FROM tbl_produto p
    WHERE p.ce_categoria_principal = 1 -- Substitua 1 pelo código da categoria desejada
    EXCEPT
    SELECT fn.cp_id_produto
    FROM tbl_fornece fn
    WHERE fn.cp_cod_forn = f.cp_cod_forn
);

-- **3. Listar os funcionários que repostos produtos em todas as lojas de uma determinada região.**

SELECT f.nm_func
FROM tbl_funcionario f
WHERE NOT EXISTS (
    SELECT l.cp_cod_loja
    FROM tbl_loja l
    WHERE l.regiao_loja = 'SP' -- Substitua 'SP' pela região desejada
    EXCEPT
    SELECT l.cp_cod_loja
    FROM tbl_loja l
    JOIN tbl_repor r ON l.cp_cod_loja = r.cp_cod_loja
    WHERE r.cp_cod_func = f.cp_cod_func
);

-- **4. Listar os produtos que nunca foram vendidos em nenhum estabelecimento.**

SELECT p.nm_prod
FROM tbl_produto p
WHERE NOT EXISTS (
    SELECT vd.cp_id_produto
    FROM tbl_vender_distribuir vd
    WHERE vd.cp_id_produto = p.cp_id_produto
);

-- **5. Listar os produtos que foram vendidos em um determinado período, mas não foram repostos no mesmo período.**

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
    AND r.data_reposicao BETWEEN '