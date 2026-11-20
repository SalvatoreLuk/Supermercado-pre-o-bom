-- SUPERMERCADO PRECO BOM | Projeto academico em MySQL
-- Versao demonstrativa para portfolio: identificadores pessoais, fiscais,
-- contatos e exemplos de senha foram substituidos por dados ficticios.
-- ATENCAO: Os valores de Senha abaixo nao sao hashes validos e NAO
-- implementam autenticacao. Apenas ilustram o campo no esquema.
-- Nao usar em producao. Execute somente em banco local de testes.
-- O script cria o esquema, tabelas, relacionamentos, registros demonstrativos
-- e executa consultas. Requer instancia MySQL disponivel.

CREATE DATABASE supermercado_preco_bom;
USE supermercado_preco_bom;

CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    Categoria VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Unidade_Medida (
    id_unidade INT AUTO_INCREMENT PRIMARY KEY,
    Unidade VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    EAN VARCHAR(14) NOT NULL UNIQUE,
    Descricao VARCHAR(120) NOT NULL,
    id_categoria INT NOT NULL,
    id_unidade INT NOT NULL,
    Preco_Custo DECIMAL(10,2) NOT NULL,
    Preco_Venda DECIMAL(10,2) NOT NULL,
    Margem_Lucro DECIMAL(5,2),
    Estoque_Minimo_Gondola DECIMAL(10,3) DEFAULT 0,
    Foto VARCHAR(255)
);

CREATE TABLE Fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    CNPJ VARCHAR(14) NOT NULL UNIQUE,
    Razao_Social VARCHAR(150) NOT NULL,
    Telefone VARCHAR(20)
);

CREATE TABLE Nota_Fiscal (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    Chave_NFe VARCHAR(44) NOT NULL UNIQUE,
    Numero VARCHAR(9) NOT NULL,
    id_fornecedor INT NOT NULL,
    Data_Entrada DATE NOT NULL,
    Valor_Total DECIMAL(10,2) NOT NULL,
    Arquivo_XML VARCHAR(255)
);

CREATE TABLE Item_Nota (
    id_item_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_nota INT NOT NULL,
    id_produto INT NOT NULL,
    id_lote INT NOT NULL,
    Quantidade DECIMAL(10,3) NOT NULL,
    Custo_Unitario DECIMAL(10,2) NOT NULL
);

CREATE TABLE Local_Estoque (
    id_local INT AUTO_INCREMENT PRIMARY KEY,
    Local VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Lote (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    Numero_Lote VARCHAR(30) NOT NULL,
    Data_Validade DATE NOT NULL
);

CREATE TABLE Saldo_Estoque (
    id_saldo INT AUTO_INCREMENT PRIMARY KEY,
    id_lote INT NOT NULL,
    id_local INT NOT NULL,
    Quantidade DECIMAL(10,3) NOT NULL DEFAULT 0
);

CREATE TABLE Movimentacao (
    id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
    id_lote INT NOT NULL,
    id_local INT NOT NULL,
    Tipo VARCHAR(20) NOT NULL,
    Quantidade DECIMAL(10,3) NOT NULL,
    Data_Hora DATETIME NOT NULL,
    id_matricula INT NOT NULL
);

CREATE TABLE Motivo_Ajuste (
    id_motivo INT AUTO_INCREMENT PRIMARY KEY,
    Motivo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Ajuste_Estoque (
    id_ajuste INT AUTO_INCREMENT PRIMARY KEY,
    id_lote INT NOT NULL,
    id_local INT NOT NULL,
    id_motivo INT NOT NULL,
    Quantidade DECIMAL(10,3) NOT NULL,
    Valor_Prejuizo DECIMAL(10,2) NOT NULL,
    Data_Hora DATETIME NOT NULL,
    id_matricula INT NOT NULL
);

CREATE TABLE Reposicao_Gondola (
    id_reposicao INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    Quantidade DECIMAL(10,3) NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',
    Data_Hora DATETIME NOT NULL
);

CREATE TABLE Perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    Perfil VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Funcionario (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    Funcionario VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) NOT NULL UNIQUE,
    id_perfil INT NOT NULL,
    Login VARCHAR(30) NOT NULL UNIQUE,
    Senha VARCHAR(255) NOT NULL
);

CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    Cliente VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) UNIQUE,
    Telefone VARCHAR(20)
);

CREATE TABLE Venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    Numero_Cupom VARCHAR(20) NOT NULL UNIQUE,
    id_caixa INT NOT NULL,
    id_cliente INT,
    Data_Hora DATETIME NOT NULL,
    Valor_Total DECIMAL(10,2) NOT NULL DEFAULT 0,
    Status VARCHAR(20) NOT NULL DEFAULT 'ABERTA'
);

CREATE TABLE Item_Venda (
    id_item_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    Quantidade DECIMAL(10,3) NOT NULL,
    Preco_Unitario DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL
);

CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_forma INT NOT NULL,
    Valor DECIMAL(10,2) NOT NULL
);

CREATE TABLE Cancelamento (
    id_cancelamento INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_item_venda INT,
    Justificativa VARCHAR(255) NOT NULL,
    id_matricula_Supervisora INT NOT NULL,
    Data_Hora DATETIME NOT NULL
);

CREATE TABLE PDV (
    id_pdv INT AUTO_INCREMENT PRIMARY KEY,
    Numero INT NOT NULL UNIQUE
);

CREATE TABLE Forma_Pagamento (
    id_forma INT AUTO_INCREMENT PRIMARY KEY,
    Forma_Pagamento VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Caixa (
    id_caixa INT AUTO_INCREMENT PRIMARY KEY,
    id_pdv INT NOT NULL,
    id_matricula INT NOT NULL,
    Abertura DATETIME NOT NULL,
    Fundo_Troco DECIMAL(10,2) NOT NULL,
    Fechamento DATETIME
);

CREATE TABLE Sangria (
    id_sangria INT AUTO_INCREMENT PRIMARY KEY,
    id_caixa INT NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    Data_Hora DATETIME NOT NULL,
    id_matricula_Supervisora INT NOT NULL
);

CREATE TABLE Fechamento_Caixa (
    id_fechamento INT AUTO_INCREMENT PRIMARY KEY,
    id_caixa INT NOT NULL,
    id_forma INT NOT NULL,
    Valor_Contado DECIMAL(10,2) NOT NULL,
    Valor_Sistema DECIMAL(10,2) NOT NULL,
    Diferenca DECIMAL(10,2) NOT NULL
);

ALTER TABLE Produto
    ADD CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    ADD CONSTRAINT fk_produto_unidade FOREIGN KEY (id_unidade) REFERENCES Unidade_Medida(id_unidade);

ALTER TABLE Nota_Fiscal
    ADD CONSTRAINT fk_nota_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor);

ALTER TABLE Item_Nota
    ADD CONSTRAINT fk_itemnota_nota FOREIGN KEY (id_nota) REFERENCES Nota_Fiscal(id_nota),
    ADD CONSTRAINT fk_itemnota_produto FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    ADD CONSTRAINT fk_itemnota_lote FOREIGN KEY (id_lote) REFERENCES Lote(id_lote);

ALTER TABLE Lote
    ADD CONSTRAINT fk_lote_produto FOREIGN KEY (id_produto) REFERENCES Produto(id_produto);

ALTER TABLE Saldo_Estoque
    ADD CONSTRAINT fk_saldo_lote FOREIGN KEY (id_lote) REFERENCES Lote(id_lote),
    ADD CONSTRAINT fk_saldo_local FOREIGN KEY (id_local) REFERENCES Local_Estoque(id_local);

ALTER TABLE Movimentacao
    ADD CONSTRAINT fk_mov_lote FOREIGN KEY (id_lote) REFERENCES Lote(id_lote),
    ADD CONSTRAINT fk_mov_local FOREIGN KEY (id_local) REFERENCES Local_Estoque(id_local),
    ADD CONSTRAINT fk_mov_funcionario FOREIGN KEY (id_matricula) REFERENCES Funcionario(id_matricula);

ALTER TABLE Ajuste_Estoque
    ADD CONSTRAINT fk_ajuste_lote FOREIGN KEY (id_lote) REFERENCES Lote(id_lote),
    ADD CONSTRAINT fk_ajuste_local FOREIGN KEY (id_local) REFERENCES Local_Estoque(id_local),
    ADD CONSTRAINT fk_ajuste_motivo FOREIGN KEY (id_motivo) REFERENCES Motivo_Ajuste(id_motivo),
    ADD CONSTRAINT fk_ajuste_funcionario FOREIGN KEY (id_matricula) REFERENCES Funcionario(id_matricula);

ALTER TABLE Reposicao_Gondola
    ADD CONSTRAINT fk_reposicao_produto FOREIGN KEY (id_produto) REFERENCES Produto(id_produto);

ALTER TABLE Funcionario
    ADD CONSTRAINT fk_funcionario_perfil FOREIGN KEY (id_perfil) REFERENCES Perfil(id_perfil);

ALTER TABLE Venda
    ADD CONSTRAINT fk_venda_caixa FOREIGN KEY (id_caixa) REFERENCES Caixa(id_caixa),
    ADD CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente);

ALTER TABLE Item_Venda
    ADD CONSTRAINT fk_itemvenda_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    ADD CONSTRAINT fk_itemvenda_produto FOREIGN KEY (id_produto) REFERENCES Produto(id_produto);

ALTER TABLE Pagamento
    ADD CONSTRAINT fk_pagamento_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    ADD CONSTRAINT fk_pagamento_forma FOREIGN KEY (id_forma) REFERENCES Forma_Pagamento(id_forma);

ALTER TABLE Cancelamento
    ADD CONSTRAINT fk_cancel_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    ADD CONSTRAINT fk_cancel_item FOREIGN KEY (id_item_venda) REFERENCES Item_Venda(id_item_venda),
    ADD CONSTRAINT fk_cancel_supervisora FOREIGN KEY (id_matricula_Supervisora) REFERENCES Funcionario(id_matricula);

ALTER TABLE Caixa
    ADD CONSTRAINT fk_caixa_pdv FOREIGN KEY (id_pdv) REFERENCES PDV(id_pdv),
    ADD CONSTRAINT fk_caixa_funcionario FOREIGN KEY (id_matricula) REFERENCES Funcionario(id_matricula);

ALTER TABLE Sangria
    ADD CONSTRAINT fk_sangria_caixa FOREIGN KEY (id_caixa) REFERENCES Caixa(id_caixa),
    ADD CONSTRAINT fk_sangria_supervisora FOREIGN KEY (id_matricula_Supervisora) REFERENCES Funcionario(id_matricula);

ALTER TABLE Fechamento_Caixa
    ADD CONSTRAINT fk_fechamento_caixa FOREIGN KEY (id_caixa) REFERENCES Caixa(id_caixa),
    ADD CONSTRAINT fk_fechamento_forma FOREIGN KEY (id_forma) REFERENCES Forma_Pagamento(id_forma);

INSERT INTO Categoria (Categoria) VALUES
('Mercearia'),
('Laticínios'),
('Limpeza'),
('Higiene'),
('Açougue'),
('Padaria'),
('Hortifrúti'),
('Bebidas');

INSERT INTO Unidade_Medida (Unidade) VALUES
('Unidade'),
('Quilo'),
('Litro'),
('Pacote');

INSERT INTO Produto (EAN, Descricao, id_categoria, id_unidade, Preco_Custo, Preco_Venda, Margem_Lucro, Estoque_Minimo_Gondola) VALUES
('7891000100103', 'Arroz Branco Tipo 1 5kg', 1, 4, 22.50, 29.90, 24.75, 20),
('7896005800010', 'Leite Integral 1L', 2, 3, 4.10, 5.49, 25.32, 48),
('7891024134702', 'Detergente Líquido 500ml', 3, 1, 1.80, 2.79, 35.48, 30),
('7891150060869', 'Sabonete em Barra 85g', 4, 1, 1.20, 1.99, 39.70, 40),
('2000001000001', 'Carne Moída Patinho', 5, 2, 28.00, 39.90, 29.82, 5),
('2000002000008', 'Pão Francês', 6, 2, 9.00, 16.90, 46.75, 3),
('2000003000005', 'Banana Prata', 7, 2, 3.50, 6.99, 49.93, 10),
('7894900011517', 'Refrigerante Cola 2L', 8, 3, 6.20, 9.49, 34.67, 24);

INSERT INTO Fornecedor (CNPJ, Razao_Social, Telefone) VALUES
('00000000000001', 'Fornecedor Ficticio A', '0000000000'),
('00000000000002', 'Fornecedor Ficticio B', '0000000000'),
('00000000000003', 'Fornecedor Ficticio C', '0000000000');

INSERT INTO Nota_Fiscal (Chave_NFe, Numero, id_fornecedor, Data_Entrada, Valor_Total, Arquivo_XML) VALUES
('00000000000000000000000000000000000000000001', '1234', 1, '2026-11-03', 1233.00, 'xml/nfe_1234.xml'),
('00000000000000000000000000000000000000000002', '5678', 2, '2026-11-04', 492.00, 'xml/nfe_5678.xml'),
('00000000000000000000000000000000000000000003', '9101', 3, '2026-11-05', 297.60, 'xml/nfe_9101.xml');

INSERT INTO Local_Estoque (Local) VALUES
('Depósito'),
('Gôndola');

INSERT INTO Lote (id_produto, Numero_Lote, Data_Validade) VALUES
(1, 'L2026A', '2027-05-10'),
(2, 'LT1045', '2026-12-05'),
(3, 'DT889', '2028-01-20'),
(8, 'RF332', '2027-03-01');

INSERT INTO Item_Nota (id_nota, id_produto, id_lote, Quantidade, Custo_Unitario) VALUES
(1, 1, 1, 50, 22.50),
(1, 3, 3, 60, 1.80),
(2, 2, 2, 120, 4.10),
(3, 8, 4, 48, 6.20);

INSERT INTO Saldo_Estoque (id_lote, id_local, Quantidade) VALUES
(1, 1, 30),
(1, 2, 19),
(2, 1, 72),
(2, 2, 44),
(3, 1, 30),
(3, 2, 29),
(4, 1, 24),
(4, 2, 22);

INSERT INTO Perfil (Perfil) VALUES
('Operadora de Caixa'),
('Supervisora'),
('Repositor'),
('Gerente');

INSERT INTO Funcionario (Funcionario, CPF, id_perfil, Login, Senha) VALUES
('Colaborador Exemplo 1', '00000000001', 4, 'colaborador1', 'HASH_FICTICIO_SEM_AUTENTICACAO'),
('Colaborador Exemplo 2', '00000000002', 2, 'colaborador2', 'HASH_FICTICIO_SEM_AUTENTICACAO'),
('Colaborador Exemplo 3', '00000000003', 1, 'colaborador3', 'HASH_FICTICIO_SEM_AUTENTICACAO'),
('Colaborador Exemplo 4', '00000000004', 1, 'colaborador4', 'HASH_FICTICIO_SEM_AUTENTICACAO'),
('Colaborador Exemplo 5', '00000000005', 3, 'colaborador5', 'HASH_FICTICIO_SEM_AUTENTICACAO');

INSERT INTO Cliente (Cliente, CPF, Telefone) VALUES
('Cliente Exemplo A', '00000000006', '0000000000'),
('Cliente Exemplo B', '00000000007', '0000000000');

INSERT INTO Movimentacao (id_lote, id_local, Tipo, Quantidade, Data_Hora, id_matricula) VALUES
(1, 1, 'ENTRADA', 50, '2026-11-03 09:15:00', 1),
(3, 1, 'ENTRADA', 60, '2026-11-03 09:20:00', 1),
(2, 1, 'ENTRADA', 120, '2026-11-04 10:05:00', 1),
(4, 1, 'ENTRADA', 48, '2026-11-05 08:40:00', 1),
(1, 2, 'TRANSFERENCIA', 20, '2026-11-03 11:00:00', 5),
(3, 2, 'TRANSFERENCIA', 30, '2026-11-03 11:10:00', 5),
(2, 2, 'TRANSFERENCIA', 48, '2026-11-04 11:30:00', 5),
(4, 2, 'TRANSFERENCIA', 24, '2026-11-05 09:30:00', 5),
(1, 2, 'VENDA', 1, '2026-11-10 09:12:00', 3),
(2, 2, 'VENDA', 2, '2026-11-10 09:12:00', 3),
(4, 2, 'VENDA', 2, '2026-11-10 10:47:00', 3),
(3, 2, 'VENDA', 1, '2026-11-10 10:47:00', 3),
(2, 2, 'AJUSTE', 2, '2026-11-10 14:20:00', 5);

INSERT INTO Motivo_Ajuste (Motivo) VALUES
('Quebra/Avaria'),
('Vencimento'),
('Furto/Divergência');

INSERT INTO Ajuste_Estoque (id_lote, id_local, id_motivo, Quantidade, Valor_Prejuizo, Data_Hora, id_matricula) VALUES
(2, 2, 1, 2, 8.20, '2026-11-10 14:20:00', 5);

INSERT INTO Reposicao_Gondola (id_produto, Quantidade, Status, Data_Hora) VALUES
(2, 24, 'PENDENTE', '2026-11-10 15:00:00'),
(8, 12, 'ATENDIDA', '2026-11-10 16:10:00');

INSERT INTO PDV (Numero) VALUES
(1), (2), (3), (4), (5), (6);

INSERT INTO Forma_Pagamento (Forma_Pagamento) VALUES
('Dinheiro'),
('PIX'),
('Débito'),
('Crédito'),
('Vale Alimentação/VR');

INSERT INTO Caixa (id_pdv, id_matricula, Abertura, Fundo_Troco, Fechamento) VALUES
(1, 3, '2026-11-10 08:00:00', 200.00, '2026-11-10 16:00:00'),
(2, 4, '2026-11-10 08:00:00', 200.00, '2026-11-10 16:00:00');

INSERT INTO Venda (Numero_Cupom, id_caixa, id_cliente, Data_Hora, Valor_Total, Status) VALUES
('000001', 1, 1, '2026-11-10 09:12:00', 40.88, 'FINALIZADA'),
('000002', 1, NULL, '2026-11-10 10:47:00', 21.77, 'FINALIZADA'),
('000003', 2, 2, '2026-11-10 11:25:00', 17.19, 'FINALIZADA'),
('000004', 2, NULL, '2026-11-10 12:02:00', 31.92, 'CANCELADA');

INSERT INTO Item_Venda (id_venda, id_produto, Quantidade, Preco_Unitario, Subtotal) VALUES
(1, 1, 1, 29.90, 29.90),
(1, 2, 2, 5.49, 10.98),
(2, 8, 2, 9.49, 18.98),
(2, 3, 1, 2.79, 2.79),
(3, 7, 1.250, 6.99, 8.74),
(3, 6, 0.500, 16.90, 8.45),
(4, 5, 0.800, 39.90, 31.92);

INSERT INTO Pagamento (id_venda, id_forma, Valor) VALUES
(1, 1, 40.88),
(2, 2, 21.77),
(3, 3, 10.00),
(3, 1, 7.19);

INSERT INTO Cancelamento (id_venda, id_item_venda, Justificativa, id_matricula_Supervisora, Data_Hora) VALUES
(4, NULL, 'Cliente desistiu da compra no caixa', 2, '2026-11-10 12:05:00');

INSERT INTO Sangria (id_caixa, Valor, Data_Hora, id_matricula_Supervisora) VALUES
(1, 1000.00, '2026-11-10 13:30:00', 2);

INSERT INTO Fechamento_Caixa (id_caixa, id_forma, Valor_Contado, Valor_Sistema, Diferenca) VALUES
(1, 1, 845.40, 850.40, -5.00),
(1, 2, 920.15, 920.15, 0.00),
(1, 3, 1310.70, 1310.70, 0.00),
(1, 4, 640.00, 640.00, 0.00),
(1, 5, 210.30, 210.30, 0.00);

SELECT p.Descricao, c.Categoria, u.Unidade, p.Preco_Custo, p.Preco_Venda, p.Margem_Lucro
FROM Produto p
JOIN Categoria c ON c.id_categoria = p.id_categoria
JOIN Unidade_Medida u ON u.id_unidade = p.id_unidade;

SELECT p.Descricao, l.Numero_Lote, l.Data_Validade, DATEDIFF(l.Data_Validade, CURDATE()) AS Dias_Para_Vencer
FROM Lote l
JOIN Produto p ON p.id_produto = l.id_produto
WHERE l.Data_Validade <= DATE_ADD(CURDATE(), INTERVAL 30 DAY);

SELECT p.Descricao, s.Quantidade AS Saldo_Gondola, p.Estoque_Minimo_Gondola
FROM Saldo_Estoque s
JOIN Lote l ON l.id_lote = s.id_lote
JOIN Produto p ON p.id_produto = l.id_produto
JOIN Local_Estoque le ON le.id_local = s.id_local
WHERE le.Local = 'Gôndola' AND s.Quantidade <= p.Estoque_Minimo_Gondola;

SELECT m.Motivo, SUM(a.Valor_Prejuizo) AS Total_Prejuizo
FROM Ajuste_Estoque a
JOIN Motivo_Ajuste m ON m.id_motivo = a.id_motivo
GROUP BY m.Motivo;

SELECT pd.Numero AS PDV, DATE(v.Data_Hora) AS Dia, SUM(v.Valor_Total) AS Faturamento
FROM Venda v
JOIN Caixa cx ON cx.id_caixa = v.id_caixa
JOIN PDV pd ON pd.id_pdv = cx.id_pdv
WHERE v.Status = 'FINALIZADA'
GROUP BY pd.Numero, DATE(v.Data_Hora);

SELECT c.Categoria, SUM(iv.Subtotal) AS Total_Vendido
FROM Item_Venda iv
JOIN Venda v ON v.id_venda = iv.id_venda
JOIN Produto p ON p.id_produto = iv.id_produto
JOIN Categoria c ON c.id_categoria = p.id_categoria
WHERE v.Status = 'FINALIZADA'
GROUP BY c.Categoria
ORDER BY Total_Vendido DESC;

SELECT ROUND(AVG(Valor_Total), 2) AS Ticket_Medio
FROM Venda
WHERE Status = 'FINALIZADA';

SELECT p.Descricao, SUM(iv.Subtotal) AS Total_Vendido
FROM Item_Venda iv
JOIN Venda v ON v.id_venda = iv.id_venda
JOIN Produto p ON p.id_produto = iv.id_produto
WHERE v.Status = 'FINALIZADA'
GROUP BY p.Descricao
ORDER BY Total_Vendido DESC;

SELECT pd.Numero AS PDV, f.Funcionario AS Operadora, fp.Forma_Pagamento, fc.Valor_Sistema, fc.Valor_Contado, fc.Diferenca
FROM Fechamento_Caixa fc
JOIN Caixa cx ON cx.id_caixa = fc.id_caixa
JOIN PDV pd ON pd.id_pdv = cx.id_pdv
JOIN Funcionario f ON f.id_matricula = cx.id_matricula
JOIN Forma_Pagamento fp ON fp.id_forma = fc.id_forma;
