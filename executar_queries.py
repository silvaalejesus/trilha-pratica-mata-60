import psycopg2
import time
import csv

# Conexão com o banco de dados
conn = psycopg2.connect(
    host="localhost",
    database="postgres",
    user="postgres",
    password="admin"
)
cur = conn.cursor()

# Queries a serem executadas
queries = [
    "SELECT * FROM tbl_produto WHERE EXTRACT(YEAR FROM data_vencimento) = 2024;",
    "SELECT nm_prod, cd_ean_prod FROM tbl_produto WHERE ce_categoria_principal = (SELECT cp_cod_categoria FROM tbl_categoria WHERE nm_categoria = 'Bebidas') OR ce_categoria_secundaria = (SELECT cp_cod_categoria FROM tbl_categoria WHERE nm_categoria = 'Bebidas');",
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