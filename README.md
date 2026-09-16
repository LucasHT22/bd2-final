# Estudo de Caso — Indústria Beleza Ltda

---

## 1. Levantamento de Entidades e Relacionamentos (MER — texto)

| Entidade | Descrição | Atributos principais |
|---|---|---|
| **Região** | Área de venda dividida pelo mercado consumidor | codigo (PK), nome |
| **Ponto Estratégico** | Local de entrega dentro de uma região | codigo (PK), nome, regiao_codigo (FK) |
| **Vendedor** | Responsável por cobrir uma região e vender produtos | codigo (PK), nome, cpf, telefone, regiao_codigo (FK) |
| **Veículo** | Veículo da frota própria | codigo (PK), placa, modelo, ano |
| **Alocação Veículo/Dia** | Registro diário de qual vendedor está responsável por qual veículo | data, veiculo_codigo (FK), vendedor_codigo (FK) |
| **Produto** | Item da tabela de produtos | codigo (PK), nome, preco, ativo |
| **Cliente** | Cliente identificado na nota fiscal | codigo (PK), nome, cpf_cnpj |
| **Nota Fiscal** | Comprovante de venda | numero (PK), data, vendedor_codigo (FK), cliente_codigo (FK) |
| **Item Nota Fiscal** | Produtos e quantidades de cada nota | nota_fiscal_numero (FK), produto_codigo (FK), quantidade |

### Relacionamentos (cardinalidades)

- **Região (1) — (N) Ponto Estratégico**: uma região tem vários pontos; um ponto pertence a uma única região (regiões não compartilham pontos).
- **Região (1) — (N) Vendedor**: uma região pode ser coberta por vários vendedores; cada vendedor cobre exatamente uma região.
- **Vendedor (1) — (N) Alocação Veículo/Dia** e **Veículo (1) — (N) Alocação Veículo/Dia**: a cada dia, um veículo fica sob responsabilidade de um vendedor (histórico diário — chave composta data + veículo).
- **Vendedor (1) — (N) Nota Fiscal**: um vendedor emite várias notas fiscais.
- **Cliente (1) — (N) Nota Fiscal**: um cliente pode aparecer em várias notas.
- **Nota Fiscal (1) — (N) Item Nota Fiscal (N) — (1) Produto**: relacionamento N:N entre Nota Fiscal e Produto, resolvido pela entidade associativa Item Nota Fiscal, com atributo quantidade.

---

## 2. DER (Diagrama Entidade-Relacionamento) — Mermaid

```mermaid
erDiagram
    REGIAO ||--o{ PONTO_ESTRATEGICO : "possui"
    REGIAO ||--o{ VENDEDOR : "e coberta por"
    VENDEDOR ||--o{ ALOCACAO_VEICULO : "responde por"
    VEICULO ||--o{ ALOCACAO_VEICULO : "e alocado em"
    VENDEDOR ||--o{ NOTA_FISCAL : "emite"
    CLIENTE ||--o{ NOTA_FISCAL : "consta em"
    NOTA_FISCAL ||--o{ ITEM_NOTA_FISCAL : "contem"
    PRODUTO ||--o{ ITEM_NOTA_FISCAL : "e vendido em"

    REGIAO {
        string codigo PK
        string nome
    }
    PONTO_ESTRATEGICO {
        string codigo PK
        string nome
        string regiao_codigo FK
    }
    VENDEDOR {
        string codigo PK
        string nome
        string cpf
        string telefone
        string regiao_codigo FK
    }
    VEICULO {
        string codigo PK
        string placa
        string modelo
        int ano
    }
    ALOCACAO_VEICULO {
        date data PK
        string veiculo_codigo PK_FK
        string vendedor_codigo FK
    }
    PRODUTO {
        string codigo PK
        string nome
        decimal preco
        bit ativo
    }
    CLIENTE {
        string codigo PK
        string nome
        string cpf_cnpj
    }
    NOTA_FISCAL {
        int numero PK
        date data
        string vendedor_codigo FK
        string cliente_codigo FK
    }
    ITEM_NOTA_FISCAL {
        int nota_fiscal_numero PK_FK
        string produto_codigo PK_FK
        int quantidade
    }
```

---

## 3. Modelo Lógico Relacional

```
Regiao(codigo PK, nome)

PontoEstrategico(codigo PK, nome, regiao_codigo FK -> Regiao.codigo)

Vendedor(codigo PK, nome, cpf, telefone, regiao_codigo FK -> Regiao.codigo)

Veiculo(codigo PK, placa, modelo, ano)

AlocacaoVeiculo(data PK, veiculo_codigo PK FK -> Veiculo.codigo,
                 vendedor_codigo FK -> Vendedor.codigo)

Produto(codigo PK, nome, preco, ativo)

Cliente(codigo PK, nome, cpf_cnpj)

NotaFiscal(numero PK, data, vendedor_codigo FK -> Vendedor.codigo,
           cliente_codigo FK -> Cliente.codigo)

ItemNotaFiscal(nota_fiscal_numero PK FK -> NotaFiscal.numero,
               produto_codigo PK FK -> Produto.codigo,
               quantidade)
```

Todas as tabelas estão na 3ª Forma Normal (3FN): não há dependências transitivas, e as chaves compostas (AlocacaoVeiculo, ItemNotaFiscal) resolvem os relacionamentos N:N/históricos sem redundância.

---

## 4. Próximos passos

O script `beleza-ltda-script.sql` (arquivo separado) contém:
1. Criação do banco e das tabelas (DDL)
2. Inserts de dados de exemplo (DML)
3. As 9 consultas (A a I) pedidas no enunciado, prontas para rodar no SQL Server Management Studio (SSMS).
