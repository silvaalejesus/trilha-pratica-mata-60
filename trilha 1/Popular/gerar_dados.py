import csv
import random
from datetime import datetime, timedelta


# --- Configuração da geração de dados ---
num_produtos = 10
num_dispositivos_rfid = 10
num_categorias_principais = 10
num_categorias_secundarias = 10
num_estabelecimentos = 10
num_funcionarios = 10
num_fornecedores = 10
num_fornece = 10
num_repor = 10
num_vendas = 10
num_itens_venda = 10 # Nova variável para controlar o número de itens por venda

def gerar_csv(nome_arquivo, dados):
    with open(nome_arquivo, 'w', newline='') as arquivo_csv:
        escritor = csv.writer(arquivo_csv)
        escritor.writerow(dados[0].keys())  # Escreve o cabeçalho
        for linha in dados:
            escritor.writerow(linha.values())

def gerar_dados_produto(num_produtos):
    produtos = []
    for i in range(1, num_produtos + 1):
        produtos.append({
            'cp_id_produto': i,
            'nm_prod': f'Produto {i}',
            'cd_ean_prod': f'{random.randint(100000000000, 999999999999)}',
            'ce_rfid': random.randint(1, num_dispositivos_rfid), 
            'ce_categoria_principal': random.randint(1, num_categorias_principais),
            'ce_categoria_secundaria': random.randint(1, num_categorias_secundarias),
            'localizacao_prod': f'Prateleira {random.randint(1, 10)}',
            'data_vencimento': (datetime.now() + timedelta(days=random.randint(30, 365))).strftime('%Y-%m-%d')
        })
    return produtos

def gerar_dados_rfid(num_dispositivos):
    rfids = []
    for i in range(1, num_dispositivos + 1):
        rfids.append({
            'cp_id_dispositivo': i,
            'ind_venda_dispositivo': random.choice([True, False]),
            'quantidade': random.randint(1, 100)
        })
    return rfids

def gerar_dados_categoria(num_categorias):
    categorias = []
    for i in range(1, num_categorias + 1):
        categorias.append({
            'cp_cod_categoria': i,
            'nm_categoria': f'Categoria {i}',
            'min_distribuidor': random.randint(10, 50),
            'max_distribuidor': random.randint(50, 100),
            'min_container': random.randint(5, 20),
            'max_container': random.randint(20, 50)
        })
    return categorias

def gerar_dados_estabelecimento(num_estabelecimentos):
    estabelecimentos = []
    for i in range(1, num_estabelecimentos + 1):
        estabelecimentos.append({
            'cp_cod_estab': i,
            'nm_estab': f'Estabelecimento {i}',
            'cnpj_estab': f'{random.randint(10000000000000, 99999999999999)}',
            'localizacao_estab':  "{ " + ", ".join(str(random.uniform(-90, 90)) for _ in range(8)) + " }",
            'endereco_estab': f'Rua {i}, {random.randint(1, 100)}',
            'UF_estab': f'{random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ")}{random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ")}',
            'cidade_estab': f'{random.randint(10000, 99999)}'
        })
    return estabelecimentos

def gerar_dados_funcionario(num_funcionarios):
    funcionarios = []
    for i in range(1, num_funcionarios + 1):
        funcionarios.append({
            'cp_cod_func': i,
            'nm_func': f'Funcionário {i}',
            'cpf_func': f'{random.randint(10000000000, 99999999999)}',
            'funcao_func': f'Função {random.randint(1, 5)}' 
        })
    return funcionarios

def gerar_dados_fornecedor(num_fornecedores):
    fornecedores = []
    for i in range(1, num_fornecedores + 1):
        fornecedores.append({
            'cp_cod_forn': i,
            'cnpj_forn': f'{random.randint(10000000000000, 99999999999999)}',
            'localizacao_forn': "{ " + ", ".join(str(random.uniform(-90, 90)) for _ in range(8)) + " }",
            'endereco_forn': f'Rua {i}, {random.randint(1, 100)}',
            'UF_forn': f'{random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ")}{random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ")}',
            'cidade_forn': f'{random.randint(10000, 99999)}'
        })
    return fornecedores

def gerar_dados_fornece(num_fornece, produtos, fornecedores):
    fornece = []
    for i in range(num_fornece):
        produto = random.choice(produtos)
        fornecedor = random.choice(fornecedores)
        fornece.append({
            'cp_cod_forn': fornecedor['cp_cod_forn'],
            'cp_id_produto': produto['cp_id_produto'],
            'data_venda': (datetime.now() - timedelta(days=random.randint(1, 365))).strftime('%Y-%m-%d'),
            'data_vencimento': produto['data_vencimento'],
            'preco_venda': round(random.uniform(1, 100), 2)
        })
    return fornece

def gerar_dados_repor(num_repor, produtos, funcionarios):
    repor = []
    for i in range(num_repor):
        produto = random.choice(produtos)
        funcionario = random.choice(funcionarios)
        repor.append({
            'cp_cod_func': funcionario['cp_cod_func'],
            'cp_id_produto': produto['cp_id_produto']
        })
    return repor

def gerar_dados_vender_distribuir(num_vendas, produtos, estabelecimentos):
    vender_distribuir = []
    for i in range(num_vendas):
        estabelecimento = random.choice(estabelecimentos)
        produto = random.choice(produtos)
        # Usando a variável global num_itens_venda para definir o número de itens
        itens_comprados = [random.choice(produtos)['cp_id_produto'] for _ in range(random.randint(1, num_itens_venda))]  
        vender_distribuir.append({
            'cp_cod_estab': estabelecimento['cp_cod_estab'],
            'cp_id_produto': produto['cp_id_produto'],
            'preco_venda': round(random.uniform(1, 100), 2),
            'data_venda': (datetime.now() - timedelta(days=random.randint(1, 30))).strftime('%Y-%m-%d'),
            'itens_comprados': "{" + ", ".join(str(item) for item in itens_comprados) + "}" # Corrigindo o formato do array
        })
    return vender_distribuir

# --- Geração dos dados ---
produtos = gerar_dados_produto(num_produtos)
rfids = gerar_dados_rfid(num_dispositivos_rfid)
categorias = gerar_dados_categoria(num_categorias_principais + num_categorias_secundarias) # Ajustando para o número total de categorias
estabelecimentos = gerar_dados_estabelecimento(num_estabelecimentos)
funcionarios = gerar_dados_funcionario(num_funcionarios)
fornecedores = gerar_dados_fornecedor(num_fornecedores)
fornece = gerar_dados_fornece(num_fornece, produtos, fornecedores)
repor = gerar_dados_repor(num_repor, produtos, funcionarios)
vender_distribuir = gerar_dados_vender_distribuir(num_vendas, produtos, estabelecimentos)

# --- Geração dos arquivos CSV ---
gerar_csv('tbl_produto.csv', produtos)
gerar_csv('tbl_rfid.csv', rfids)
gerar_csv('tbl_categoria.csv', categorias)
gerar_csv('tbl_estabelecimento.csv', estabelecimentos)
gerar_csv('tbl_funcionario.csv', funcionarios)
gerar_csv('tbl_fornecedor.csv', fornecedores)
gerar_csv('tbl_fornece.csv', fornece)
gerar_csv('tbl_repor.csv', repor)
gerar_csv('tbl_vender_distribuir.csv', vender_distribuir)