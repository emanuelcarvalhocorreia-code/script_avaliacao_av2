1_script_betinhas.sql
100%
-- ==========================================
-- 0. REMOÇÃO DE TABELAS EXISTENTES (CASO NECESSÁRIO)
-- ==========================================
DROP TABLE IF EXISTS pagamento CASCADE;
DROP TABLE IF EXISTS item_pedido CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS vitrine CASCADE;
DROP TABLE IF EXISTS estoque CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS roupa CASCADE;
DROP TABLE IF EXISTS colecao CASCADE;
DROP TABLE IF EXISTS estilo CASCADE;
DROP TABLE IF EXISTS loja CASCADE;

-- ==========================================
-- 1. TABELA: loja
-- ==========================================
CREATE TABLE loja (
    id_loja SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL,

    CONSTRAINT uq_loja_cnpj UNIQUE (cnpj)
);

-- ==========================================
-- 2. TABELA: estilo
-- ==========================================
CREATE TABLE estilo (
    id_estilo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- ==========================================
-- 3. TABELA: colecao
-- ==========================================
CREATE TABLE colecao (
    id_colecao SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    estacao VARCHAR(50),
    ano INT NOT NULL
);

-- ==========================================
-- 4. TABELA: roupa
-- ==========================================
CREATE TABLE roupa (
    id_roupa SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    genero VARCHAR(50),
    tamanho VARCHAR(10) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    fk_estilo INT NOT NULL,
    fk_colecao INT,

    CONSTRAINT fk_roupa_estilo FOREIGN KEY (fk_estilo) REFERENCES estilo(id_estilo) ON DELETE CASCADE,
    CONSTRAINT fk_roupa_colecao FOREIGN KEY (fk_colecao) REFERENCES colecao(id_colecao) ON DELETE SET NULL
);

-- ==========================================
-- 5. TABELA: cliente
-- ==========================================
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    email VARCHAR(255) NOT NULL,
    fk_loja INT,
    fk_estilo INT,

    CONSTRAINT uq_cliente_cpf UNIQUE (cpf),
    CONSTRAINT uq_cliente_email UNIQUE (email),
    CONSTRAINT fk_cliente_loja FOREIGN KEY (fk_loja) REFERENCES loja(id_loja) ON DELETE SET NULL,
    CONSTRAINT fk_cliente_estilo FOREIGN KEY (fk_estilo) REFERENCES estilo(id_estilo) ON DELETE SET NULL
);

-- ==========================================
-- 6. TABELA: estoque
-- ==========================================
CREATE TABLE estoque (
    id_estoque SERIAL PRIMARY KEY,
    quantidade INT,
    fk_roupa INT NOT NULL,
    fk_loja INT NOT NULL,

    CONSTRAINT fk_estoque_roupa FOREIGN KEY (fk_roupa) REFERENCES roupa(id_roupa) ON DELETE CASCADE,
    CONSTRAINT fk_estoque_loja FOREIGN KEY (fk_loja) REFERENCES loja(id_loja) ON DELETE CASCADE
);

-- ==========================================
-- 7. TABELA: vitrine
-- ==========================================
CREATE TABLE vitrine (
    id_vitrine SERIAL PRIMARY KEY,
    nome_exibicao VARCHAR(150) NOT NULL,
    ativa BOOLEAN DEFAULT TRUE,
    fk_loja INT NOT NULL,

    CONSTRAINT fk_vitrine_loja FOREIGN KEY (fk_loja) REFERENCES loja(id_loja) ON DELETE CASCADE
);

-- ==========================================
-- 8. TABELA: pedido
-- ==========================================
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    canal_venda VARCHAR(50) NOT NULL,
    fk_cliente INT NOT NULL,
    fk_loja INT NOT NULL,

    CONSTRAINT fk_pedido_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    CONSTRAINT fk_pedido_loja FOREIGN KEY (fk_loja) REFERENCES loja(id_loja) ON DELETE CASCADE
);

-- ==========================================
-- 9. TABELA: item_pedido
-- ==========================================
CREATE TABLE item_pedido (
    id_item_pedido SERIAL PRIMARY KEY,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    fk_pedido INT NOT NULL,
    fk_roupa INT NOT NULL,

    CONSTRAINT fk_item_pedido_pedido FOREIGN KEY (fk_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_item_pedido_roupa FOREIGN KEY (fk_roupa) REFERENCES roupa(id_roupa) ON DELETE CASCADE
);

-- ==========================================
-- 10. TABELA: pagamento
-- ==========================================
CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    forma_pagamento VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status VARCHAR(50),
    fk_pedido INT NOT NULL,

    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (fk_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);


-- ==========================================
-- SCRIPT DE INSERÇÃO DIDÁTICA (DADOS REALISTAS)
-- ==========================================

-- 1. LOJA
INSERT INTO loja (nome, endereco, cnpj) VALUES
('Betinhas Moda Centro', 'Rua XV de Novembro, 450 - Centro, Curitiba - PR', '12.345.678/0001-01'),
('Betinhas Boutique Batel', 'Avenida do Batel, 1230 - Batel, Curitiba - PR', '12.345.678/0002-82'),
('Betinhas Shopping Palladium', 'Avenida Presidente Kennedy, 4121 - Portão, Curitiba - PR', '12.345.678/0003-63'),
('Betinhas Água Verde', 'Avenida República Argentina, 2100 - Água Verde, Curitiba - PR', '12.345.678/0004-44'),
('Betinhas Juvevê Concept', 'Rua Augusto Stresser, 890 - Juvevê, Curitiba - PR', '12.345.678/0005-25'),
('Betinhas Santa Felicidade', 'Avenida Manoel Ribas, 5400 - Santa Felicidade, Curitiba - PR', '12.345.678/0006-06'),
('Betinhas Cabral Store', 'Avenida Paraná, 1500 - Cabral, Curitiba - PR', '12.345.678/0007-97'),
('Betinhas São José dos Pinhais', 'Rua Joinville, 2800 - Centro, São José dos Pinhais - PR', '12.345.678/0008-78'),
('Betinhas E-Commerce Matriz', 'Rodovia BR-116, 10500 - Pinheirinho, Curitiba - PR', '12.345.678/0009-59'),
('Betinhas Outlet Boqueirão', 'Rua Marechal Floriano Peixoto, 7800 - Boqueirão, Curitiba - PR', '12.345.678/0010-90');

-- 2. ESTILO
INSERT INTO estilo (nome, descricao) VALUES
('Casual Urbano', 'Peças confortáveis e versáteis para o cotidiano na cidade.'),
('Social Alfaiataria', 'Cortes estruturados e tecidos nobres para ambientes formais e corporativos.'),
('Boho Chic', 'Estampas fluidas, rendas e referências artesanais despojadas.'),
('Minimalista', 'Cores neutras, linhas limpas e modelagens atemporais.'),
('Streetwear', 'Modelagens amplas, estampas gráficas e inspiração na cultura urbana.'),
('Esportivo Athleisure', 'Conforto térmico e elasticidade para prática física e lazer.'),
('Romântico', 'Tecidos leves, babados, tons pastel e detalhes delicados.'),
('Clássico Elegante', 'Peças tradicionais de caimento impecável e alta durabilidade.'),
('Vintage Retrô', 'Releituras de décadas passadas com lavagens e cortes marcantes.'),
('Festa e Gala', 'Vestidos e conjuntos sofisticados para eventos noturnos e cerimônias.');

-- 3. COLECAO
INSERT INTO colecao (nome, estacao, ano) VALUES
('Brisa Tropical', 'Verão', 2026),
('Folhas de Outono', 'Outono', 2026),
('Inverno na Serra', 'Inverno', 2026),
('Jardim Secreto', 'Primavera', 2026),
('Essenciais Atemporais', 'Todas', 2026),
('Noites de Gala', 'Inverno', 2026),
('Urbano Contemporâneo', 'Outono', 2026),
('Sol e Mar Resort', 'Verão', 2027),
('Florescer Urbano', 'Primavera', 2027),
('Cápsula Minimal', 'Todas', 2026);

-- 4. ROUPA
INSERT INTO roupa (nome, genero, tamanho, preco, fk_estilo, fk_colecao) VALUES
('Vestido Midi Floral Linho', 'Feminino', 'M', 249.90, 7, 4),
('Blazer Alfaiataria Estruturado', 'Feminino', 'G', 329.90, 2, 5),
('Camiseta Oversized Algodão Orgânico', 'Unissex', 'GG', 119.90, 5, 7),
('Calça Pantalona Cintura Alta', 'Feminino', 'P', 219.90, 4, 10),
('Camisa Social Slim Fit', 'Masculino', 'M', 179.90, 8, 5),
('Jaqueta Jeans Lavagem Vintage', 'Unissex', 'G', 289.90, 9, 2),
('Conjunto Moletom Confort', 'Feminino', 'M', 259.90, 6, 3),
('Saia Longa Fluida Boho', 'Feminino', 'P', 189.90, 3, 1),
('Vestido Longo Cetim Festa', 'Feminino', 'M', 499.90, 10, 6),
('T-Shirt Básica Gola Redonda', 'Masculino', 'G', 89.90, 1, 5);

-- 5. CLIENTE
INSERT INTO cliente (nome, cpf, email, fk_loja, fk_estilo) VALUES
('Ana Paula Souza', '111.222.333-44', 'ana.souza@email.com', 1, 4),
('Beatriz Lima Ferreira', '222.333.444-55', 'beatriz.lima@email.com', 2, 2),
('Carlos Eduardo Silva', '333.444.555-66', 'carlos.silva@email.com', 9, 5),
('Daniela Oliveira Costa', '444.555.666-77', 'daniela.costa@email.com', 3, 7),
('Elena Rocha Martins', '555.666.777-88', 'elena.rocha@email.com', 4, 3),
('Fernanda Santos Almeida', '666.777.888-99', 'fernanda.santos@email.com', 2, 10),
('Gabriela Mendes Pereira', '777.888.999-00', 'gabriela.mendes@email.com', 5, 1),
('Hugo Alves Nogueira', '888.999.000-11', 'hugo.alves@email.com', 1, 8),
('Isabela Ribeiro Gomes', '999.000.111-22', 'isabela.ribeiro@email.com', 7, 6),
('Juliana Castro Dias', '000.111.222-33', 'juliana.castro@email.com', 6, 9);

-- 6. ESTOQUE
INSERT INTO estoque (quantidade, fk_roupa, fk_loja) VALUES
(25, 1, 1),
(15, 2, 2),
(40, 3, 9),
(18, 4, 3),
(30, 5, 1),
(12, 6, 6),
(22, 7, 7),
(20, 8, 4),
(8, 9, 2),
(50, 10, 5);

-- 7. VITRINE
INSERT INTO vitrine (nome_exibicao, ativa, fk_loja) VALUES
('Destaque Primavera Centro', TRUE, 1),
('Executiva Elegante Batel', TRUE, 2),
('Tendências Jovens Palladium', TRUE, 3),
('Conforto e Estilo Água Verde', TRUE, 4),
('Seleção Minimalista Juvevê', TRUE, 5),
('Especial Inverno Santa Felicidade', TRUE, 6),
('Moda Casual Cabral', TRUE, 7),
('Novidades da Estação SJP', TRUE, 8),
('Vitrine Principal Loja Online', TRUE, 9),
('Liquidação de Coleção Boqueirão', FALSE, 10);

-- 8. PEDIDO
INSERT INTO pedido (valor_total, canal_venda, fk_cliente, fk_loja) VALUES
(249.90, 'Loja Física', 1, 1),
(549.80, 'Loja Física', 2, 2),
(239.80, 'E-commerce', 3, 9),
(189.90, 'WhatsApp', 4, 3),
(189.90, 'Loja Física', 5, 4),
(499.90, 'Loja Física', 6, 2),
(89.90, 'Instagram', 7, 5),
(179.90, 'Loja Física', 8, 1),
(259.90, 'E-commerce', 9, 9),
(289.90, 'Loja Física', 10, 6);

-- 9. ITEM_PEDIDO
INSERT INTO item_pedido (quantidade, preco_unitario, fk_pedido, fk_roupa) VALUES
(1, 249.90, 1, 1),
(1, 329.90, 2, 2),
(1, 219.90, 2, 4),
(2, 119.90, 3, 3),
(1, 189.90, 4, 8),
(1, 189.90, 5, 8),
(1, 499.90, 6, 9),
(1, 89.90, 7, 10),
(1, 179.90, 8, 5),
(1, 259.90, 9, 7);

-- 10. PAGAMENTO
INSERT INTO pagamento (forma_pagamento, valor, status, fk_pedido) VALUES
('Cartão de Crédito', 249.90, 'Aprovado', 1),
('Cartão de Crédito', 549.80, 'Aprovado', 2),
('PIX', 239.80, 'Aprovado', 3),
('Cartão de Débito', 189.90, 'Aprovado', 4),
('PIX', 189.90, 'Aprovado', 5),
('Cartão de Crédito', 499.90, 'Aprovado', 6),
('PIX', 89.90, 'Pendente', 7),
('Dinheiro', 179.90, 'Aprovado', 8),
('Boleto Bancário', 259.90, 'Aguardando Compensação', 9),
('Cartão de Débito', 289.90, 'Aprovado', 10);


-- ==========================================
-- 11. CONSULTAS DE VALIDAÇÃO (TESTE RÁPIDO)
-- ==========================================

-- 1. Testar tabela loja
SELECT * FROM loja;

-- 2. Testar tabela estilo
SELECT * FROM estilo;

-- 3. Testar tabela colecao
SELECT * FROM colecao;

-- 4. Testar tabela roupa
SELECT * FROM roupa;

-- 5. Testar tabela cliente
SELECT * FROM cliente;

-- 6. Testar tabela estoque
SELECT * FROM estoque;

-- 7. Testar tabela vitrine
SELECT * FROM vitrine;

-- 8. Testar tabela pedido
SELECT * FROM pedido;

-- 9. Testar tabela item_pedido
SELECT * FROM item_pedido;

-- 10. Testar tabela pagamento
SELECT * FROM pagamento;
Exibindo 1_script_betinhas.sql…


select nome,endereco
  from loja order by nome asc 
limit 3 