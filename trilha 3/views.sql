-- **1. Visão de produtos por categoria:**
CREATE VIEW produtos_por_categoria AS
SELECT 
    p.nm_prod, 
    c1.nm_categoria AS categoria_principal, 
    c2.nm_categoria AS categoria_secundaria
FROM 
    tbl_produto p
LEFT JOIN 
    tbl_categoria c1 ON p.ce_categoria_principal = c1.cp_cod_categoria
LEFT JOIN 
    tbl_categoria c2 ON p.ce_categoria_secundaria = c2.cp_cod_categoria;

-- **2. Visão de vendas por estabelecimento:**
CREATE VIEW vendas_por_estabelecimento AS
SELECT 
    e.nm_estab, 
    COUNT(vd.cp_id_produto) AS total_vendas,
    SUM(vd.preco_venda) AS receita_total
FROM 
    tbl_estabelecimento e
JOIN 
    tbl_vender_distribuir vd ON e.cp_cod_estab = vd.cp_cod_estab
GROUP BY 
    e.nm_estab;
