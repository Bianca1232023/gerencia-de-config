-- ============================================================
-- Seeds do Dating App
-- Idempotente: limpa e reinserere dados a cada execução
-- ============================================================

-- Limpar dados existentes (na ordem correta de dependência)
DELETE FROM mensagens;
DELETE FROM matches;
DELETE FROM interacoes;
DELETE FROM usuarios_interesses;
DELETE FROM fotos_usuario;
DELETE FROM enderecos;
DELETE FROM usuarios;
DELETE FROM interesses;

-- Resetar sequences
ALTER SEQUENCE usuarios_id_seq    RESTART WITH 1;
ALTER SEQUENCE enderecos_id_seq   RESTART WITH 1;
ALTER SEQUENCE fotos_usuario_id_seq RESTART WITH 1;
ALTER SEQUENCE interesses_id_seq  RESTART WITH 1;
ALTER SEQUENCE interacoes_id_seq  RESTART WITH 1;
ALTER SEQUENCE matches_id_seq     RESTART WITH 1;
ALTER SEQUENCE mensagens_id_seq   RESTART WITH 1;

-- ============================================================
-- Interesses
-- ============================================================
INSERT INTO interesses (nome) VALUES
    ('Música'),
    ('Cinema'),
    ('Esportes'),
    ('Viagens'),
    ('Culinária'),
    ('Tecnologia'),
    ('Leitura'),
    ('Arte'),
    ('Fotografia'),
    ('Natureza');

-- ============================================================
-- Usuários
-- (senhas são hashes simulados — em produção use bcrypt real)
-- ============================================================
INSERT INTO usuarios (nome, email, senha, data_nascimento, genero, bio, criado_em, atualizado_em)
VALUES
    ('Ana Silva',      'ana@email.com',     '$2b$10$hashed_password_001', '1995-03-15', 'Feminino',  'Adoro música e viagens!',              NOW(), NOW()),
    ('Carlos Souza',   'carlos@email.com',  '$2b$10$hashed_password_002', '1993-07-22', 'Masculino', 'Apaixonado por esportes e tecnologia.', NOW(), NOW()),
    ('Mariana Costa',  'mariana@email.com', '$2b$10$hashed_password_003', '1997-01-10', 'Feminino',  'Cinema e culinária são minha vida!',    NOW(), NOW()),
    ('Pedro Oliveira', 'pedro@email.com',   '$2b$10$hashed_password_004', '1991-11-30', 'Masculino', 'Fotógrafo nas horas vagas.',            NOW(), NOW()),
    ('Juliana Santos', 'juliana@email.com', '$2b$10$hashed_password_005', '1999-05-08', 'Feminino',  'Leitora voraz e amante da natureza.',   NOW(), NOW());

-- ============================================================
-- Endereços
-- ============================================================
INSERT INTO enderecos (usuario_id, logradouro, numero, bairro, cidade, estado, cep, latitude, longitude)
VALUES
    (1, 'Rua das Flores',   '123',  'Centro',         'São Paulo', 'SP', '01310-100', -23.550520, -46.633308),
    (2, 'Av. Paulista',     '1500', 'Bela Vista',      'São Paulo', 'SP', '01310-200', -23.561414, -46.656229),
    (3, 'Rua Augusta',      '456',  'Consolação',      'São Paulo', 'SP', '01305-000', -23.554011, -46.651452),
    (4, 'Rua Oscar Freire', '789',  'Jardins',         'São Paulo', 'SP', '01426-001', -23.567329, -46.669765),
    (5, 'Rua Haddock Lobo', '321',  'Cerqueira César', 'São Paulo', 'SP', '01414-001', -23.560014, -46.666778);

-- ============================================================
-- Fotos dos usuários
-- ============================================================
INSERT INTO fotos_usuario (usuario_id, url_foto, principal, criado_em)
VALUES
    (1, 'https://picsum.photos/id/64/400/400',  TRUE, NOW()),
    (2, 'https://picsum.photos/id/91/400/400',  TRUE, NOW()),
    (3, 'https://picsum.photos/id/177/400/400', TRUE, NOW()),
    (4, 'https://picsum.photos/id/193/400/400', TRUE, NOW()),
    (5, 'https://picsum.photos/id/217/400/400', TRUE, NOW());

-- ============================================================
-- Interesses dos usuários
-- ============================================================
INSERT INTO usuarios_interesses (usuario_id, interesse_id)
VALUES
    (1, 1), (1, 4), (1, 8),   -- Ana: Música, Viagens, Arte
    (2, 3), (2, 6), (2, 4),   -- Carlos: Esportes, Tecnologia, Viagens
    (3, 2), (3, 5), (3, 7),   -- Mariana: Cinema, Culinária, Leitura
    (4, 8), (4, 9), (4, 4),   -- Pedro: Arte, Fotografia, Viagens
    (5, 7), (5, 10),(5, 2);   -- Juliana: Leitura, Natureza, Cinema

-- ============================================================
-- Interações (like / dislike)
-- ============================================================
INSERT INTO interacoes (usuario_origem, usuario_destino, tipo, criado_em)
VALUES
    (1, 2, 'like',    NOW()),  -- Ana curtiu Carlos
    (2, 1, 'like',    NOW()),  -- Carlos curtiu Ana   → match!
    (3, 4, 'like',    NOW()),  -- Mariana curtiu Pedro
    (4, 3, 'like',    NOW()),  -- Pedro curtiu Mariana → match!
    (5, 1, 'like',    NOW()),  -- Juliana curtiu Ana
    (1, 5, 'dislike', NOW());  -- Ana não curtiu Juliana

-- ============================================================
-- Matches (usuários que se curtiram mutuamente)
-- ============================================================
INSERT INTO matches (usuario1_id, usuario2_id, criado_em)
VALUES
    (1, 2, NOW()),  -- Ana <-> Carlos
    (3, 4, NOW());  -- Mariana <-> Pedro

-- ============================================================
-- Mensagens trocadas nos matches
-- ============================================================
INSERT INTO mensagens (match_id, remetente_id, conteudo, enviado_em)
VALUES
    (1, 1, 'Olá Carlos! Vi que você também adora viajar!',               NOW()),
    (1, 2, 'Oi Ana! Sim, adoro! Para onde você já foi?',                 NOW()),
    (1, 1, 'Fui à Europa no ano passado! E você?',                        NOW()),
    (2, 3, 'Oi Pedro! Você realmente é fotógrafo?',                       NOW()),
    (2, 4, 'Oi Mariana! Sim! Fotografo principalmente natureza e pessoas.', NOW());
