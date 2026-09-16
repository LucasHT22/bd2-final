
-- ============================================================
-- 3. CRIACAO DA BASE DE DADOS
-- ============================================================
CREATE DATABASE BelezaLtda;
GO

USE BelezaLtda;
GO

-- ============================================================
-- TABELAS (Modelo Logico Relacional)
-- ============================================================

CREATE TABLE Regiao (
    codigo      VARCHAR(10)     NOT NULL,
    nome        VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Regiao PRIMARY KEY (codigo)
);
GO

CREATE TABLE PontoEstrategico (
    codigo          VARCHAR(10)     NOT NULL,
    nome            VARCHAR(100)    NOT NULL,
    regiao_codigo   VARCHAR(10)     NOT NULL,
    CONSTRAINT PK_PontoEstrategico PRIMARY KEY (codigo),
    CONSTRAINT FK_PontoEstrategico_Regiao FOREIGN KEY (regiao_codigo)
        REFERENCES Regiao(codigo)
);
GO

CREATE TABLE Vendedor (
    codigo          VARCHAR(10)     NOT NULL,
    nome            VARCHAR(100)    NOT NULL,
    cpf             VARCHAR(14)     NOT NULL,
    telefone        VARCHAR(20)     NULL,
    regiao_codigo   VARCHAR(10)     NOT NULL,
    CONSTRAINT PK_Vendedor PRIMARY KEY (codigo),
    CONSTRAINT FK_Vendedor_Regiao FOREIGN KEY (regiao_codigo)
        REFERENCES Regiao(codigo)
);
GO

CREATE TABLE Veiculo (
    codigo      VARCHAR(10)     NOT NULL,
    placa       VARCHAR(8)      NOT NULL,
    modelo      VARCHAR(50)     NOT NULL,
    ano         INT             NOT NULL,
    CONSTRAINT PK_Veiculo PRIMARY KEY (codigo)
);
GO

-- historico diario: a cada dia, um veiculo fica sob responsabilidade de um vendedor
CREATE TABLE AlocacaoVeiculo (
    data                DATE            NOT NULL,
    veiculo_codigo      VARCHAR(10)     NOT NULL,
    vendedor_codigo     VARCHAR(10)     NOT NULL,
    CONSTRAINT PK_AlocacaoVeiculo PRIMARY KEY (data, veiculo_codigo),
    CONSTRAINT FK_Alocacao_Veiculo FOREIGN KEY (veiculo_codigo)
        REFERENCES Veiculo(codigo),
    CONSTRAINT FK_Alocacao_Vendedor FOREIGN KEY (vendedor_codigo)
        REFERENCES Vendedor(codigo)
);
GO

CREATE TABLE Produto (
    codigo      VARCHAR(10)     NOT NULL,
    nome        VARCHAR(100)    NOT NULL,
    preco       DECIMAL(10,2)   NOT NULL,
    ativo       BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_Produto PRIMARY KEY (codigo)
);
GO

CREATE TABLE Cliente (
    codigo      VARCHAR(10)     NOT NULL,
    nome        VARCHAR(100)    NOT NULL,
    cpf_cnpj    VARCHAR(18)     NOT NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (codigo)
);
GO

CREATE TABLE NotaFiscal (
    numero              INT             NOT NULL,
    data                DATE            NOT NULL,
    vendedor_codigo     VARCHAR(10)     NOT NULL,
    cliente_codigo      VARCHAR(10)     NOT NULL,
    CONSTRAINT PK_NotaFiscal PRIMARY KEY (numero),
    CONSTRAINT FK_NotaFiscal_Vendedor FOREIGN KEY (vendedor_codigo)
        REFERENCES Vendedor(codigo),
    CONSTRAINT FK_NotaFiscal_Cliente FOREIGN KEY (cliente_codigo)
        REFERENCES Cliente(codigo)
);
GO

CREATE TABLE ItemNotaFiscal (
    nota_fiscal_numero     INT             NOT NULL,
    produto_codigo         VARCHAR(10)     NOT NULL,
    quantidade              INT             NOT NULL,
    CONSTRAINT PK_ItemNotaFiscal PRIMARY KEY (nota_fiscal_numero, produto_codigo),
    CONSTRAINT FK_Item_NotaFiscal FOREIGN KEY (nota_fiscal_numero)
        REFERENCES NotaFiscal(numero),
    CONSTRAINT FK_Item_Produto FOREIGN KEY (produto_codigo)
        REFERENCES Produto(codigo)
);
GO


-- ============================================================
-- 4. INSERCAO DE DADOS DE EXEMPLO
-- ============================================================

-- Regioes
INSERT INTO Regiao (codigo, nome) VALUES
('R01', 'Zona Norte'),
('R02', 'Zona Sul'),
('R03', 'Zona Leste');
GO

-- Pontos estrategicos
INSERT INTO PontoEstrategico (codigo, nome, regiao_codigo) VALUES
('P01', 'Shopping Norte',      'R01'),
('P02', 'Terminal Rodoviario', 'R01'),
('P03', 'Avenida Central',     'R02'),
('P04', 'Praca da Se',         'R02'),
('P05', 'Mercado Leste',       'R03');
GO

-- Vendedores (cada um cobre UMA regiao)
INSERT INTO Vendedor (codigo, nome, cpf, telefone, regiao_codigo) VALUES
('V01', 'Carlos Souza',   '111.111.111-11', '(11) 91111-1111', 'R01'),
('V02', 'Ana Ferreira',   '222.222.222-22', '(11) 92222-2222', 'R01'),
('V03', 'Bruno Lima',     '333.333.333-33', '(11) 93333-3333', 'R02'),
('V04', 'Diana Alves',    '444.444.444-44', '(11) 94444-4444', 'R03');
GO

-- Veiculos
INSERT INTO Veiculo (codigo, placa, modelo, ano) VALUES
('VE01', 'ABC1D23', 'Fiat Fiorino', 2022),
('VE02', 'XYZ4E56', 'Renault Kangoo', 2021),
('VE03', 'JKL7F89', 'Fiat Fiorino', 2023);
GO

-- Alocacao diaria de veiculos (ultimo mes)
INSERT INTO AlocacaoVeiculo (data, veiculo_codigo, vendedor_codigo) VALUES
('2026-08-20', 'VE01', 'V01'),
('2026-08-21', 'VE01', 'V01'),
('2026-08-20', 'VE02', 'V03'),
('2026-08-25', 'VE03', 'V04'),
('2026-09-01', 'VE01', 'V02'),
('2026-09-02', 'VE02', 'V03'),
('2026-09-10', 'VE03', 'V04');
GO

-- Produtos
INSERT INTO Produto (codigo, nome, preco, ativo) VALUES
('PR01', 'Shampoo Hidratante',   25.90, 1),
('PR02', 'Condicionador',       23.50, 1),
('PR03', 'Creme para Pentear',  18.00, 1),
('PR04', 'Perfume Floral',      89.90, 1),
('PR05', 'Sabonete Liquido',    15.00, 1),
('PR06', 'Linha Descontinuada', 10.00, 0);  -- produto inativo, sem vendas
GO

-- Clientes
INSERT INTO Cliente (codigo, nome, cpf_cnpj) VALUES
('C01', 'Mariana Costa',     '555.555.555-55'),
('C02', 'Loja Bela Flor',    '12.345.678/0001-90'),
('C03', 'Roberto Nunes',     '666.666.666-66');
GO

-- Notas fiscais
INSERT INTO NotaFiscal (numero, data, vendedor_codigo, cliente_codigo) VALUES
(1001, '2026-09-01', 'V01', 'C01'),
(1002, '2026-09-02', 'V03', 'C02'),
(1003, '2026-09-05', 'V04', 'C03'),
(1004, '2026-09-10', 'V01', 'C02');
GO

-- Itens das notas fiscais
INSERT INTO ItemNotaFiscal (nota_fiscal_numero, produto_codigo, quantidade) VALUES
(1001, 'PR01', 3),
(1001, 'PR02', 2),
(1002, 'PR04', 1),
(1002, 'PR05', 5),
(1003, 'PR01', 1),
(1004, 'PR03', 4),
(1004, 'PR04', 2);
GO


-- ============================================================
-- 5. CONSULTAS
-- ============================================================

-- A) Listar todos os pontos estrategicos de cada regiao
SELECT r.nome AS regiao, p.nome AS ponto_estrategico
FROM Regiao r
JOIN PontoEstrategico p ON p.regiao_codigo = r.codigo
ORDER BY r.nome, p.nome;
GO

-- B) Listar os nomes das regioes cadastradas
SELECT nome
FROM Regiao
ORDER BY nome;
GO

-- C) Listar todos os vendedores e quais veiculos utilizaram no ultimo mes
SELECT ve.nome AS vendedor, vc.modelo AS veiculo, vc.placa, av.data
FROM AlocacaoVeiculo av
JOIN Vendedor ve ON ve.codigo = av.vendedor_codigo
JOIN Veiculo vc  ON vc.codigo = av.veiculo_codigo
WHERE av.data >= DATEADD(MONTH, -1, GETDATE())
ORDER BY ve.nome, av.data;
GO

-- D) Listar todos os vendedores responsaveis por cada regiao
SELECT r.nome AS regiao, ve.nome AS vendedor
FROM Regiao r
JOIN Vendedor ve ON ve.regiao_codigo = r.codigo
ORDER BY r.nome, ve.nome;
GO

-- E) Todos os produtos vendidos por um determinado VENDEDOR (ex: V01)
SELECT DISTINCT pr.nome AS produto, pr.preco
FROM ItemNotaFiscal it
JOIN NotaFiscal nf ON nf.numero = it.nota_fiscal_numero
JOIN Produto pr     ON pr.codigo = it.produto_codigo
WHERE nf.vendedor_codigo = 'V01';
GO

-- F) Todos os vendedores que venderam um determinado PRODUTO (ex: PR04)
SELECT DISTINCT ve.nome AS vendedor
FROM ItemNotaFiscal it
JOIN NotaFiscal nf ON nf.numero = it.nota_fiscal_numero
JOIN Vendedor ve   ON ve.codigo = nf.vendedor_codigo
WHERE it.produto_codigo = 'PR04';
GO

-- G) Todos os produtos que ainda nao foram vendidos
SELECT pr.codigo, pr.nome, pr.ativo
FROM Produto pr
WHERE NOT EXISTS (
    SELECT 1 FROM ItemNotaFiscal it WHERE it.produto_codigo = pr.codigo
);
GO

-- H) Historico de utilizacao de um determinado VEICULO (ex: VE01)
SELECT av.data, ve.nome AS vendedor
FROM AlocacaoVeiculo av
JOIN Vendedor ve ON ve.codigo = av.vendedor_codigo
WHERE av.veiculo_codigo = 'VE01'
ORDER BY av.data;
GO

-- I) Quantidade de itens de cada nota fiscal
SELECT nf.numero AS nota_fiscal, SUM(it.quantidade) AS total_itens
FROM NotaFiscal nf
JOIN ItemNotaFiscal it ON it.nota_fiscal_numero = nf.numero
GROUP BY nf.numero
ORDER BY nf.numero;
GO
