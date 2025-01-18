import psycopg2
import time
import csv

# Conexão com o banco de dados
conn = psycopg2.connect(
    host="localhost",
    database="trilhaPratica",
    user="postgres",
    password="senhaeu"
)
cur = conn.cursor()

# Queries a serem executadas
queries = [
   "SELECT nm_prod FROM tbl_produto;",
   "SELECT nm_prod, data_vencimento FROM tbl_produto;",
   "SELECT COUNT(*) AS total_produtos FROM tbl_produto;",
   "SELECT COUNT(*) AS total_produtos FROM tbl_produto;",
   "SELECT COUNT(*) AS total_rfid FROM tbl_rfid;",
   "SELECT cp_id_dispositivo, quantidade, ind_venda_dispositivo FROM tbl_rfid",
   "SELECT COUNT(*) AS total_categorias FROM tbl_categoria;",
   "SELECT nm_categoria FROM tbl_categoria;",
   "SELECT nm_categoria, min_distribuidor, max_distribuidor FROM tbl_categoria;",
   "SELECT nm_estab, localizacao_estab FROM tbl_estabelecimento;",
   "SELECT COUNT(*) AS total_estabelecimentos FROM tbl_estabelecimento;",
   "SELECT nm_func, cpf_func FROM tbl_funcionario;",
   "SELECT COUNT(*) AS total_funcionarios FROM tbl_funcionario;",
   "SELECT nm_estab, localizacao_estab FROM tbl_estabelecimento;",
   "SELECT COUNT(*) AS total_fornecedores FROM tbl_fornecedor;",
   "SELECT nm_estab, cidade_estab FROM tbl_estabelecimento;",
   "SELECT f.cp_cod_forn, p.cp_id_produto, p.nm_prod FROM tbl_fornece f JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto;",
   "SELECT nm_prod, data_vencimento FROM tbl_produto WHERE data_vencimento <= CURRENT_DATE + INTERVAL '30 days';",
   "SELECT nm_prod FROM tbl_produto WHERE ce_categoria_principal IS NULL;",
   "SELECT cp_id_dispositivo FROM tbl_rfid WHERE quantidade = 0;",
   "SELECT nm_categoria, max_distribuidor FROM tbl_categoria WHERE max_distribuidor > 50;",
   "SELECT nm_estab, cidade_estab FROM tbl_estabelecimento WHERE cidade_estab = '72803';",
   "SELECT cp_cod_forn, cidade_forn FROM tbl_fornecedor WHERE UF_forn = 'TI';",
   "SELECT nm_func, funcao_func FROM tbl_funcionario WHERE funcao_func = 'Funçao 1';",
   "SELECT p.nm_prod FROM tbl_fornece f JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto WHERE f.cp_cod_forn = 1;",

   "SELECT ce_categoria_principal, COUNT(*) AS total_produtos FROM tbl_produto GROUP BY ce_categoria_principal;",
   "SELECT p.nm_prod, r.quantidade FROM tbl_produto p JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo;",
   "SELECT f.cp_cod_forn, COUNT(p.cp_id_produto) AS total_produtos FROM tbl_fornece f JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto GROUP BY f.cp_cod_forn;",
   "SELECT c.nm_categoria, COUNT(p.cp_id_produto) AS total_produtos FROM tbl_categoria c LEFT JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal GROUP BY c.nm_categoria;",
   "SELECT c.nm_categoria, COUNT(p.cp_id_produto) AS total_produtos FROM tbl_categoria c LEFT JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal GROUP BY c.nm_categoria;",
   "SELECT p.nm_prod, f.data_venda, AVG(f.preco_venda) AS preco_medio FROM tbl_fornece f JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto GROUP BY p.nm_prod, f.data_venda;",
   "SELECT DISTINCT UF_forn FROM tbl_fornecedor;",
   "SELECT v.cp_id_produto, COUNT(v.cp_cod_estab) AS total_estabelecimentos FROM tbl_vender_distribuir v GROUP BY v.cp_id_produto HAVING COUNT(v.cp_cod_estab) > 1;",
   "SELECT v.cp_id_produto, COUNT(v.cp_cod_estab) AS total_estabelecimentos FROM tbl_vender_distribuir v GROUP BY v.cp_id_produto HAVING COUNT(v.cp_cod_estab) > 1;",
   "SELECT p.nm_prod, f.cp_cod_forn FROM tbl_fornece f JOIN tbl_produto p ON f.cp_id_produto = p.cp_id_produto WHERE p.ce_categoria_principal = 2;",
   "SELECT DISTINCT func.nm_func FROM tbl_repor r JOIN tbl_funcionario func ON r.cp_cod_func = func.cp_cod_func;",
   "SELECT p.nm_prod FROM tbl_produto p LEFT JOIN tbl_fornece f ON p.cp_id_produto = f.cp_id_produto WHERE f.cp_id_produto IS NULL;",
   "SELECT e.UF_estab, COUNT(v.cp_id_produto) AS total_vendas FROM tbl_vender_distribuir v JOIN tbl_estabelecimento e ON v.cp_cod_estab = e.cp_cod_estab GROUP BY e.UF_estab;",
   "SELECT DISTINCT f.cnpj_forn FROM tbl_fornecedor f JOIN tbl_estabelecimento e ON f.cidade_forn = e.cidade_estab;",
   "SELECT p.nm_prod, SUM(CAST(v.itens_comprados AS INT)) AS total_itens FROM tbl_vender_distribuir v JOIN tbl_produto p ON v.cp_id_produto = p.cp_id_produto GROUP BY p.nm_prod;",

   "SELECT p.nm_prod, SUM(CAST(v.itens_comprados AS INT)) AS total_itens FROM tbl_vender_distribuir v JOIN tbl_produto p ON v.cp_id_produto = p.cp_id_produto GROUP BY p.nm_prod ORDER BY total_itens DESC LIMIT 5; ",
   "SELECT f.cp_cod_forn, COUNT(DISTINCT v.cp_cod_estab) AS total_estabelecimentos FROM tbl_fornece f JOIN tbl_vender_distribuir v ON f.cp_id_produto = v.cp_id_produto GROUP BY f.cp_cod_forn HAVING COUNT(DISTINCT v.cp_cod_estab) > 3;",
   "SELECT e.UF_estab, p.nm_prod, MAX(v.preco_venda) AS preco_maximo FROM tbl_vender_distribuir v JOIN tbl_produto p ON v.cp_id_produto = p.cp_id_produto JOIN tbl_estabelecimento e ON v.cp_cod_estab = e.cp_cod_estab GROUP BY e.UF_estab, p.nm_prod; ",
   "SELECT p.ce_categoria_principal, AVG(v.preco_venda) AS preco_medio FROM tbl_produto p JOIN tbl_vender_distribuir v ON p.cp_id_produto = v.cp_id_produto GROUP BY p.ce_categoria_principal;",
   "SELECT e.UF_estab, COUNT(e.cp_cod_estab) AS total_estabelecimentos FROM tbl_estabelecimento e GROUP BY e.UF_estab ORDER BY total_estabelecimentos DESC LIMIT 3;",
   "SELECT p.nm_prod, c1.nm_categoria AS categoria_principal, c2.nm_categoria AS categoria_secundaria FROM tbl_produto p JOIN tbl_categoria c1 ON p.ce_categoria_principal = c1.cp_cod_categoria JOIN tbl_categoria c2 ON p.ce_categoria_secundaria = c2.cp_cod_categoria;",
   "SELECT p.nm_prod, r.quantidade FROM tbl_produto p JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo WHERE p.data_vencimento < CURRENT_DATE AND r.quantidade > 0;",
   "SELECT f.cidade_forn, f.cp_cod_forn, COUNT(p.cp_id_produto) AS total_produtos FROM tbl_fornecedor f JOIN tbl_fornece fc ON f.cp_cod_forn = fc.cp_cod_forn JOIN tbl_produto p ON fc.cp_id_produto = p.cp_id_produto GROUP BY f.cidade_forn, f.cp_cod_forn ORDER BY f.cidade_forn, total_produtos DESC;",
   "SELECT p.nm_prod FROM tbl_produto p LEFT JOIN tbl_rfid r ON p.ce_rfid = r.cp_id_dispositivo LEFT JOIN tbl_fornece f ON p.cp_id_produto = f.cp_id_produto WHERE r.cp_id_dispositivo IS NULL AND f.cp_id_produto IS NULL;",
   "SELECT func.nm_func, COUNT(r.cp_id_produto) AS total_reposicoes FROM tbl_repor r JOIN tbl_funcionario func ON r.cp_cod_func = func.cp_cod_func GROUP BY func.nm_func ORDER BY total_reposicoes DESC;",
   "SELECT f.cp_cod_forn, e.UF_estab, COUNT(p.cp_id_produto) AS total_produtos FROM tbl_fornece fc JOIN tbl_produto p ON fc.cp_id_produto = p.cp_id_produto JOIN tbl_vender_distribuir v ON p.cp_id_produto = v.cp_id_produto JOIN tbl_estabelecimento e ON v.cp_cod_estab = e.cp_cod_estab JOIN tbl_fornecedor f ON fc.cp_cod_forn = f.cp_cod_forn GROUP BY f.cp_cod_forn, e.UF_estab; ",
   "SELECT c.nm_categoria, p.nm_prod, MAX(v.preco_venda) AS preco_maximo FROM tbl_categoria c JOIN tbl_produto p ON c.cp_cod_categoria = p.ce_categoria_principal JOIN tbl_vender_distribuir v ON p.cp_id_produto = v.cp_id_produto GROUP BY c.nm_categoria, p.nm_prod;",
   "SELECT f.cp_cod_forn, SUM(v.preco_venda) AS total_vendas FROM tbl_fornecedor f JOIN tbl_fornece fc ON f.cp_cod_forn = fc.cp_cod_forn JOIN tbl_vender_distribuir v ON fc.cp_id_produto = v.cp_id_produto GROUP BY f.cp_cod_forn; ",
   "SELECT e.nm_estab, COUNT(p.cp_id_produto) AS total_vencidos FROM tbl_estabelecimento e JOIN tbl_vender_distribuir v ON e.cp_cod_estab = v.cp_cod_estab JOIN tbl_produto p ON v.cp_id_produto = p.cp_id_produto WHERE p.data_vencimento < CURRENT_DATE GROUP BY e.nm_estab ORDER BY total_vencidos DESC;",
   "SELECT r.cp_id_dispositivo, SUM(CAST(v.itens_comprados AS INT)) AS total_itens_vendidos FROM tbl_rfid r JOIN tbl_produto p ON r.cp_id_dispositivo = p.ce_rfid JOIN tbl_vender_distribuir v ON p.cp_id_produto = v.cp_id_produto GROUP BY r.cp_id_dispositivoORDER BY total_itens_vendidos DESC;"

]

# Número de rodadas
num_rodadas = 50

# Arquivo CSV para salvar os tempos de execução
with open('tempos_execucao.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['rodada', 'query', 'tempo_execucao'])

    for rodada in range(num_rodadas):
        for i, query in enumerate(queries):
            inicio = time.time()
            cur.execute(query)
            fim = time.time()
            tempo_execucao = fim - inicio

            writer.writerow([rodada + 1, i + 1, tempo_execucao])
            print(f"Rodada {rodada + 1}, Query {i + 1}: {tempo_execucao:.4f} segundos")

# Fecha a conexão com o banco de dados
cur.close()
conn.close()