-- ============================================================
-- Schema do Dating App
-- Baseado nos models Sequelize da API Node.js
-- ============================================================

-- Usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id              SERIAL PRIMARY KEY,
    nome            VARCHAR(100)  NOT NULL,
    email           VARCHAR(100)  NOT NULL UNIQUE,
    senha           VARCHAR(255)  NOT NULL,
    data_nascimento DATE          NOT NULL,
    genero          VARCHAR(20),
    bio             VARCHAR(300),
    criado_em       TIMESTAMP,
    atualizado_em   TIMESTAMP,
    deletado_em     TIMESTAMP
);

-- Endereços
CREATE TABLE IF NOT EXISTS enderecos (
    id          SERIAL PRIMARY KEY,
    usuario_id  INTEGER      NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    logradouro  VARCHAR(150),
    numero      VARCHAR(10),
    complemento VARCHAR(50),
    bairro      VARCHAR(100),
    cidade      VARCHAR(100),
    estado      VARCHAR(50),
    cep         VARCHAR(15),
    latitude    DECIMAL(9, 6),
    longitude   DECIMAL(9, 6)
);

-- Fotos dos usuários
CREATE TABLE IF NOT EXISTS fotos_usuario (
    id            SERIAL PRIMARY KEY,
    usuario_id    INTEGER      NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    url_foto      VARCHAR(255) NOT NULL,
    principal     BOOLEAN      DEFAULT FALSE,
    criado_em     TIMESTAMP,
    atualizado_em TIMESTAMP,
    deletado_em   TIMESTAMP
);

-- Interesses
CREATE TABLE IF NOT EXISTS interesses (
    id   SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

-- Relação N:N usuário <-> interesse
CREATE TABLE IF NOT EXISTS usuarios_interesses (
    usuario_id   INTEGER NOT NULL REFERENCES usuarios(id)   ON DELETE CASCADE,
    interesse_id INTEGER NOT NULL REFERENCES interesses(id) ON DELETE CASCADE,
    PRIMARY KEY (usuario_id, interesse_id)
);

-- Interações (like / dislike)
CREATE TABLE IF NOT EXISTS interacoes (
    id              SERIAL PRIMARY KEY,
    usuario_origem  INTEGER     NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    usuario_destino INTEGER     NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo            VARCHAR(10),
    criado_em       TIMESTAMP,
    atualizado_em   TIMESTAMP,
    deletado_em     TIMESTAMP
);

-- Matches (dois usuários que se curtiram)
CREATE TABLE IF NOT EXISTS matches (
    id            SERIAL PRIMARY KEY,
    usuario1_id   INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    usuario2_id   INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    criado_em     TIMESTAMP,
    atualizado_em TIMESTAMP,
    deletado_em   TIMESTAMP
);

-- Mensagens dentro de um match
CREATE TABLE IF NOT EXISTS mensagens (
    id           SERIAL PRIMARY KEY,
    match_id     INTEGER NOT NULL REFERENCES matches(id)  ON DELETE CASCADE,
    remetente_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    conteudo     TEXT,
    enviado_em   TIMESTAMP
);
