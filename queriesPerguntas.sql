-- Consultas Simples:

-- 1.  Quais são os nomes dos produtos cadastrados na tabela tbl_produto?
SELECT nm_prod 
FROM tbl_produto;

-- 2.: Quais são os nomes e as datas de vencimento dos produtos cadastrados?
SELECT nm_prod, data_vencimento 
FROM tbl_produto;

-- 3. Pergunta: Quantos produtos estão cadastrados na tabela tbl_produto?
SELECT COUNT(*) AS total_produtos 
FROM tbl_produto;

-- 4. Quais são os nomes e códigos EAN dos produtos?
SELECT nm_prod, cd_ean_prod 
FROM tbl_produto;

-- 5.  Quantos dispositivos RFID estão cadastrados na tabela tbl_rfid?
SELECT COUNT(*) AS total_rfid 
FROM tbl_rfid;

-- 6. Quais dispositivos RFID estão cadastrados, com suas quantidades e indicador de venda?
SELECT cp_id_dispositivo, quantidade, ind_venda_dispositivo 
FROM tbl_rfid;

-- 7.  Quantas categorias estão cadastradas na tabela tbl_categoria?
SELECT COUNT(*) AS total_categorias 
FROM tbl_categoria;

-- 8. Quais são os nomes das categorias cadastradas na tabela tbl_categoria?
SELECT nm_categoria 
FROM tbl_categoria;

-- 9. Quais são os limites de distribuidores para cada categoria?
SELECT nm_categoria, min_distribuidor, max_distribuidor 
FROM tbl_categoria;

-- 10.  Quais estabelecimentos estão cadastrados, com seus nomes e localizações?
SELECT nm_estab, localizacao_estab 
FROM tbl_estabelecimento;

-- 11. Quantos estabelecimentos estão cadastrados na tabela tbl_estabelecimento?
SELECT COUNT(*) AS total_estabelecimentos 
FROM tbl_estabelecimento;

-- 12.Quais são os nomes e CPFs dos funcionários cadastrados na tabela tbl_funcionario?
SELECT nm_func, cpf_func 
FROM tbl_funcionario;

-- 13.  Quantos funcionários estão cadastrados na tabela tbl_funcionario?
SELECT COUNT(*) AS total_funcionarios 
FROM tbl_funcionario;

-- 14. Quais fornecedores estão cadastrados, com seus nomes e localizações?
SELECT nm_estab, localizacao_estab 
FROM tbl_estabelecimento;

-- 15. Quantos fornecedores estão cadastrados na tabela tbl_fornecedor?
SELECT COUNT(*) AS total_fornecedores 
FROM tbl_fornecedor;

-- 16. Quais são os nomes e as cidades dos fornecedores cadastrados?
SELECT nm_estab, cidade_estab 
FROM tbl_estabelecimento;

-- 17. Quais são os produtos e seus fornecedores cadastrados na tabela tbl_fornece?
SELECT f.cp_cod_forn, p.cp_id_produto, p.nm_prod
FROM tbl_fornece f
JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto;

-- 18. Quais produtos estão com data de vencimento dentro dos próximos 30 dias?
SELECT nm_prod, data_vencimento
FROM tbl_produto
WHERE data_vencimento <= CURRENT_DATE + INTERVAL '30 days';

-- 19. Quais produtos não possuem uma categoria principal associada?
SELECT nm_prod
FROM tbl_produto
WHERE ce_categoria_principal IS NULL;

-- 20. Quais dispositivos RFID possuem quantidade igual a zero?
SELECT cp_id_dispositivo
FROM tbl_rfid
WHERE quantidade = 0;

-- 21.  Quais categorias permitem mais de 50 distribuidores?
SELECT nm_categoria, max_distribuidor
FROM tbl_categoria
WHERE max_distribuidor > 50;

-- 22.  Quais estabelecimentos estão localizados na cidade de São Paulo?
SELECT nm_estab, cidade_estab
FROM tbl_estabelecimento
WHERE cidade_estab = '72803';

-- 23. Quais fornecedores estão localizados no estado de SP?
SELECT cp_cod_forn, cidade_forn
FROM tbl_fornecedor
WHERE UF_forn = 'TI';

-- 24. Quais funcionários possuem a função de Gerente?
SELECT nm_func, funcao_func
FROM tbl_funcionario
WHERE funcao_func = 'Funçao 1';

-- 25.  Quais produtos são fornecidos pelo fornecedor com ID 1?
SELECT p.nm_prod
FROM tbl_fornece f
JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto
WHERE f.cp_cod_forn = 1;


-- Intermediarias

-- 1.  Qual é o total de produtos agrupados por cada categoria principal?
SELECT ce_categoria_principal, COUNT(*) AS total_produtos
FROM tbl_produto
GROUP BY ce_categoria_principal;

-- 2. Quais são os nomes dos produtos e a quantidade total vinculada a dispositivos RFID?
SELECT p.nm_prod, r.quantidade
FROM tbl_produto p
JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo;

-- 3.  Quais fornecedores forneceram produtos e qual é o número total de produtos fornecidos por cada um?
SELECT f.cp_cod_forn, COUNT(p.cp_id_produto) AS total_produtos
FROM tbl_fornece f
JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto
GROUP BY f.cp_cod_forn;

-- 4.  Quais categorias possuem produtos associados e qual é o total de produtos por categoria?
SELECT c.nm_categoria, COUNT(p.cp_id_produto) AS total_produtos
FROM tbl_categoria c
LEFT JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
GROUP BY c.nm_categoria;

-- 5.  Quais são os produtos vendidos em cada estabelecimento?
SELECT e.nm_estab, p.nm_prod
FROM tbl_vender_distribuir v
JOIN tbl_estabelecimento e ON v.cp_cod_estab = e.cp_cod_estab
JOIN tbl_produto p ON v.cp_id_produto = p.cp_id_produto;

-- 6.  Quais são os produtos fornecidos, as datas de venda e o preço médio de venda?
SELECT p.nm_prod, f.data_venda, AVG(f.preco_venda) AS preco_medio
FROM tbl_fornece f
JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto
GROUP BY p.nm_prod, f.data_venda;

-- 7. Quais são os estados únicos em que os fornecedores operam?
SELECT DISTINCT UF_forn
FROM tbl_fornecedor;

-- 8. Quais produtos estão disponíveis em mais de um estabelecimento?
SELECT v.cp_id_produto, COUNT(v.cp_cod_estab) AS total_estabelecimentos
FROM tbl_vender_distribuir v
GROUP BY v.cp_id_produto
HAVING COUNT(v.cp_cod_estab) > 1;

-- 9. Quais dispositivos RFID estão associados a produtos vencidos?
SELECT r.cp_id_dispositivo, p.nm_prod
FROM tbl_rfid r
JOIN tbl_produto p ON r.cp_id_dispositivo = p.ce_rfid
WHERE p.data_vencimento < CURRENT_DATE;

-- 10. Quais produtos e fornecedores pertencem a uma categoria principal específica (por exemplo, ID 2)?
SELECT p.nm_prod, f.cp_cod_forn
FROM tbl_fornece f
JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto
WHERE p.ce_categoria_principal = 2;

-- 11. Quais funcionários estão vinculados à reposição de produtos?
SELECT DISTINCT func.nm_func
FROM tbl_repor r
JOIN tbl_funcionario func ON r.cp_cod_func = func.cp_cod_func;

-- 12. Quais produtos não possuem registro de venda por fornecedores?
SELECT p.nm_prod
FROM tbl_produto p
LEFT JOIN tbl_fornece f ON p.cp_id_produto = f.cp_id_produto
WHERE f.cp_id_produto IS NULL;

-- 13.  Qual é o total de vendas realizadas em cada estado?
SELECT e.UF_estab, COUNT(v.cp_id_produto) AS total_vendas
FROM tbl_vender_distribuir v
JOIN tbl_estabelecimento e ON v.cp_cod_estab = e.cp_cod_estab
GROUP BY e.UF_estab;

-- 14.  Quais fornecedores operam em cidades onde existem estabelecimentos?
SELECT DISTINCT f.cnpj_forn
FROM tbl_fornecedor f
JOIN tbl_estabelecimento e ON f.cidade_forn = e.cidade_estab;

-- 15. : Quantos itens foram vendidos por cada estabelecimento, considerando apenas vendas realizadas no último mês?
SELECT e.nome_estab AS estabelecimento, SUM(ARRAY_LENGTH(vd.itens_comprados, 1)) AS total_itens_vendidos
FROM tbl_vender_distribuir vd
JOIN tbl_estabelecimento e ON vd.cp_cod_estab = e.cp_cod_estab
WHERE vd.data_venda >= CURRENT_DATE - INTERVAL '1 MONTH'
GROUP BY e.nome_estab
ORDER BY total_itens_vendidos DESC;


-- Complexas

-- 1. Quais são os produtos mais vendidos e qual estabelecimento liderou as vendas desses produtos, com seus respectivos preços médios de venda?
WITH vendas_por_produto AS (
    SELECT p.nome_produto, e.nome_estab AS maior_vendedor, SUM(ARRAY_LENGTH(vd.itens_comprados, 1)) AS total_itens_vendidos, AVG(vd.preco_venda) AS preco_medio
    FROM tbl_vender_distribuir vd
    JOIN tbl_produto p ON vd.cp_id_produto = p.cp_id_produto
    JOIN tbl_estabelecimento e ON vd.cp_cod_estab = e.cp_cod_estab
    GROUP BY p.nome_produto, e.nome_estab
)
SELECT nome_produto, maior_vendedor, total_itens_vendidos, preco_medio
FROM vendas_por_produto
ORDER BY total_itens_vendidos DESC LIMIT 5;


-- 2. Quais fornecedores forneceram produtos para mais de três estabelecimentos distintos?
SELECT f.cp_cod_forn, COUNT(DISTINCT v.cp_cod_estab) AS total_estabelecimentos
FROM tbl_fornece f
JOIN tbl_vender_distribuir v ON f.cp_id_produto = v.cp_id_produto
GROUP BY f.cp_cod_forn
HAVING COUNT(DISTINCT v.cp_cod_estab) > 3;

-- 3.  Qual é o produto mais caro vendido em cada estado?
SELECT e.UF_estab, p.nm_prod, MAX(v.preco_venda) AS preco_maximo
FROM tbl_vender_distribuir v
JOIN tbl_produto p ON v.cp_id_produto = p.cp_id_produto
JOIN tbl_estabelecimento e ON v.cp_cod_estab = e.cp_cod_estab
GROUP BY e.UF_estab, p.nm_prod;

-- 4. Qual é a média de preço de venda dos produtos agrupados por categoria principal?
SELECT p.ce_categoria_principal, AVG(v.preco_venda) AS preco_medio
FROM tbl_produto p
JOIN tbl_vender_distribuir v ON p.cp_id_produto = v.cp_id_produto
GROUP BY p.ce_categoria_principal;

-- 5. Quais são os três estados com o maior número de estabelecimentos registrados?
SELECT e.UF_estab, COUNT(e.cp_cod_estab) AS total_estabelecimentos
FROM tbl_estabelecimento e
GROUP BY e.UF_estab
ORDER BY total_estabelecimentos DESC
LIMIT 3;

-- 6. Quais produtos possuem mais de uma categoria associada?
SELECT p.nm_prod, c1.nm_categoria AS categoria_principal, c2.nm_categoria AS categoria_secundaria
FROM tbl_produto p
JOIN tbl_categoria c1 ON p.ce_categoria_principal = c1.cp_cod_categoria
JOIN tbl_categoria c2 ON p.ce_categoria_secundaria = c2.cp_cod_categoria;

-- 7. Quais produtos estão vencidos e ainda possuem quantidade disponível em estoque?
SELECT p.nm_prod, r.quantidade
FROM tbl_produto p
JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo
WHERE p.data_vencimento < CURRENT_DATE AND r.quantidade > 0;

-- 8. Quais fornecedores forneceram o maior número de produtos em cada cidade?
SELECT f.cidade_forn, f.cp_cod_forn, COUNT(p.cp_id_produto) AS total_produtos
FROM tbl_fornecedor f
JOIN tbl_fornece fc ON f.cp_cod_forn = fc.cp_cod_forn
JOIN tbl_produto p ON fc.cp_id_produto = p.cp_id_produto
GROUP BY f.cidade_forn, f.cp_cod_forn
ORDER BY f.cidade_forn, total_produtos DESC;

-- 9.  Quais produtos não possuem associação com dispositivos RFID nem fornecedores?
SELECT p.nm_prod
FROM tbl_produto p
LEFT JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo
LEFT JOIN tbl_fornece f ON p.cp_id_produto = f.cp_id_produto
WHERE r.cp_id_dispositivo IS NULL AND f.cp_id_produto IS NULL;

-- 10.  Quais funcionários realizaram a maior quantidade de reposições de produtos?
SELECT func.nm_func, COUNT(r.cp_id_produto) AS total_reposicoes
FROM tbl_repor r
JOIN tbl_funcionario func ON r.cp_cod_func = func.cp_cod_func
GROUP BY func.nm_func
ORDER BY total_reposicoes DESC;

-- 11. Quais fornecedores forneceram produtos e para quais estados, incluindo o número de produtos fornecidos?
SELECT f.cp_cod_forn, e.UF_estab, COUNT(p.cp_id_produto) AS total_produtos
FROM tbl_fornece fc
JOIN tbl_produto p ON fc.cp_id_produto = p.cp_id_produto
JOIN tbl_vender_distribuir v ON p.cp_id_produto = v.cp_id_produto
JOIN tbl_estabelecimento e ON v.cp_cod_estab = e.cp_cod_estab
JOIN tbl_fornecedor f ON fc.cp_cod_forn = f.cp_cod_forn
GROUP BY f.cp_cod_forn, e.UF_estab;

-- 12. Quais são os produtos mais caros de cada categoria principal?
SELECT c.nm_categoria, p.nm_prod, MAX(v.preco_venda) AS preco_maximo
FROM tbl_categoria c
JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal
JOIN tbl_vender_distribuir v ON p.cp_id_produto = v.cp_id_produto
GROUP BY c.nm_categoria, p.nm_prod;

-- 13.Qual é o total de vendas realizadas por cada fornecedor?
SELECT f.cp_cod_forn, SUM(v.preco_venda) AS total_vendas
FROM tbl_fornecedor f
JOIN tbl_fornece fc ON f.cp_cod_forn = fc.cp_cod_forn
JOIN tbl_vender_distribuir v ON fc.cp_id_produto = v.cp_id_produto
GROUP BY f.cp_cod_forn;

-- 14 : Quais estabelecimentos possuem o maior número de produtos vencidos?
SELECT e.nm_estab, COUNT(p.cp_id_produto) AS total_vencidos
FROM tbl_estabelecimento e
JOIN tbl_vender_distribuir v ON e.cp_cod_estab = v.cp_cod_estab
JOIN tbl_produto p ON v.cp_id_produto = p.cp_id_produto
WHERE p.data_vencimento < CURRENT_DATE
GROUP BY e.nm_estab
ORDER BY total_vencidos DESC;

-- 15. Quais são os três estabelecimentos com maior número de produtos distintos vendidos, e qual é a quantidade total de itens vendidos por eles?
WITH vendas_distintas AS (
    SELECT 
        vd.cp_cod_estab, COUNT(DISTINCT vd.cp_id_produto) AS produtos_distintos, SUM(ARRAY_LENGTH(vd.itens_comprados, 1)) AS total_itens_vendidos
    FROM tbl_vender_distribuir vd GROUP BY vd.cp_cod_estab
)
SELECT e.nm_estab AS estabelecimento, vd.produtos_distintos, vd.total_itens_vendidos
FROM  vendas_distintas vd
JOIN tbl_estabelecimento e ON vd.cp_cod_estab = e.cp_cod_estab
ORDER BY vd.produtos_distintos DESC, vd.total_itens_vendidos DESC LIMIT 3;


--ALTER TABLE tbl_vender_distribuir
--ALTER COLUMN itens_comprados TYPE integer[] USING itens_comprados::integer[];
