# Guia rápido para explicar o projeto em entrevista

## Qual problema o banco resolve?
O cenário acadêmico propõe um supermercado que precisa controlar entrada de mercadorias, perdas por vencimento, divergências de estoque, vendas e caixa. O banco fornece a estrutura para **registrar** esses dados e **consultá-los**; ele, sozinho, não automatiza todos os processos.

## Como funcionam as três tabelas principais do meu bloco?

- **Fornecedor:** cadastra quem entrega mercadorias. `id_fornecedor` é a chave primária, enquanto `CNPJ` tem restrição `UNIQUE`.
- **Nota_Fiscal:** registra uma nota recebida, com número, chave de 44 caracteres, data, valor e fornecedor. `id_fornecedor` é chave estrangeira para `Fornecedor`.
- **Item_Nota:** registra o que veio em cada nota, com produto, lote, quantidade e custo unitário. Contém chaves estrangeiras para `Nota_Fiscal`, `Produto` e `Lote`.

**Relacionamentos:** um fornecedor pode aparecer em diversas notas; uma nota pode incluir vários itens. Cada item aponta para um produto e um lote.

## Exemplo simples
A empresa fornecedora fictícia A tem `id_fornecedor = 1`. Uma nota com `id_nota = 1` e `id_fornecedor = 1` é ligada a essa empresa. O `Item_Nota` aponta para `id_nota = 1`, além de especificar o produto, o lote e a quantidade.

## Consultas de exemplo

```sql
-- Ver notas e seus fornecedores
SELECT nf.Numero, nf.Data_Entrada, f.Razao_Social
FROM Nota_Fiscal AS nf
JOIN Fornecedor AS f ON nf.id_fornecedor = f.id_fornecedor;
```

```sql
-- Ver itens de cada nota com produtos, quantidade e lotes
SELECT nf.Numero, p.Descricao, l.Numero_Lote, i.Quantidade, i.Custo_Unitario
FROM Item_Nota AS i
JOIN Nota_Fiscal AS nf ON nf.id_nota = i.id_nota
JOIN Produto AS p ON p.id_produto = i.id_produto
JOIN Lote AS l ON l.id_lote = i.id_lote;
```

## Perguntas que o recrutador pode fazer

**Por que três tabelas em vez de uma?** Para organizar entidades diferentes, reduzir repetição de informações e facilitar atualizações.

**Qual a diferença entre PRIMARY KEY e FOREIGN KEY?** A primária identifica exclusivamente o registro. A estrangeira referencia um registro de outra tabela, estabelecendo uma relação.

**Como vocês ignoram vendas canceladas no faturamento?** A consulta utiliza `WHERE v.Status = 'FINALIZADA'`.

**O banco sozinho atualiza o estoque quando uma venda acontece?** Não necessariamente. O esquema contém dados para registrar operações, mas uma aplicação, procedimento, gatilho ou lógica transacional precisaria realizar atualizações consistentes.

**O código tem limitações?** Sim. Ele foi produzido como exercício acadêmico, contém dados demonstrativos e precisa de regras adicionais e testes para utilização real.
