-- Rode esse arquivo inteiro no SQL Editor do seu projeto Supabase (Supabase Dashboard > SQL Editor > New query).

-- O RLS controla quais linhas cada role vê, mas o Postgres também exige
-- a permissão base na tabela — sem isso o PostgREST responde 401
-- "permission denied" mesmo com a política certa.
grant usage on schema public to anon, authenticated;

-- =========================================================
-- CARDÁPIO
--
-- id é o mesmo slug já usado no JavaScript do site (ex.: "pepperoni"),
-- pra não precisar de nenhuma tabela de mapeamento entre banco e front-end.
-- =========================================================
create table if not exists produtos (
  id text primary key,
  nome text not null,
  descricao text,
  categoria text not null check (categoria in ('salgada', 'doce')),
  imagem_url text not null,
  imagem_ajuste text not null default 'cover' check (imagem_ajuste in ('cover', 'contain')),
  ativo boolean not null default true,
  ordem int not null default 0,
  criado_em timestamptz not null default now()
);

-- Leitura pública do cardápio (é um site público, sem login pra ver os sabores)
alter table produtos enable row level security;
drop policy if exists "cardapio publico" on produtos;
create policy "cardapio publico" on produtos for select using (ativo = true);
grant select on public.produtos to anon, authenticated;

-- =========================================================
-- PEDIDOS
--
-- O preço vem do tamanho da pizza (Grande/Média/Pequena), não do sabor —
-- por isso "total" fica aqui e não em pedido_itens.
-- =========================================================
create table if not exists pedidos (
  id uuid primary key default gen_random_uuid(),
  cliente_nome text not null,
  cliente_telefone text not null,
  tamanho text not null check (tamanho in ('grande', 'media', 'pequena')),
  quantidade_sabores int not null check (quantidade_sabores between 1 and 3),
  forma_recebimento text not null check (forma_recebimento in ('Entrega', 'Retirada')),
  endereco text,
  forma_pagamento text not null check (forma_pagamento in ('Pix', 'Cartão', 'Dinheiro')),
  troco_para numeric(10,2),
  observacoes text,
  total numeric(10,2) not null,
  status text not null default 'recebido',
  criado_em timestamptz not null default now()
);

-- Qualquer cliente pode registrar um pedido (fluxo é convidado, sem login)
alter table pedidos enable row level security;
drop policy if exists "qualquer um pode criar pedido" on pedidos;
create policy "qualquer um pode criar pedido" on pedidos for insert with check (true);
grant insert on public.pedidos to anon, authenticated;

create table if not exists pedido_itens (
  id uuid primary key default gen_random_uuid(),
  pedido_id uuid not null references pedidos(id) on delete cascade,
  produto_id text not null references produtos(id),
  posicao int not null check (posicao between 1 and 3)
);

alter table pedido_itens enable row level security;
drop policy if exists "qualquer um pode criar item de pedido" on pedido_itens;
create policy "qualquer um pode criar item de pedido" on pedido_itens for insert with check (true);
grant insert on public.pedido_itens to anon, authenticated;

-- =========================================================
-- SEED — catálogo atual (18 salgadas + 6 doces)
--
-- As imagens ainda apontam pro ragnar-oak.shop (hospedagem WordPress de
-- testes). Quando o site passar a servir fotos próprias, é só atualizar
-- a coluna imagem_url aqui.
-- =========================================================
insert into produtos (id, nome, descricao, categoria, imagem_url, imagem_ajuste, ordem) values
  ('pepperoni', 'Pepperoni', 'Molho de tomate artesanal, mozzarella especial, generosas fatias de pepperoni e finalização com orégano.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/Fundo-de-057f1b6c-ec55-47d9-8275-cabf3479c3fe-Removido.png', 'contain', 1),
  ('margherita', 'Margherita', 'Mozzarella de búfala, molho de tomate artesanal, tomates frescos, manjericão e azeite extravirgem.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/Fundo-de-pizza-s2-Removido-e1784304115248.png', 'cover', 2),
  ('quatro-queijos', 'Quatro Queijos', 'Mozzarella, provolone, gorgonzola e parmesão, combinados sobre nosso molho de tomate artesanal.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/Fundo-de-pizza-s3-Removido.png', 'cover', 3),
  ('calabresa', 'Calabresa', 'Calabresa artesanal, cebola, mozzarella especial, molho de tomate e uma delicada finalização com orégano.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/Fundo-de-057f1b6c-ec55-47d9-8275-cabf3479c3fe-Removido.png', 'cover', 4),
  ('frango-com-catupiry', 'Frango com Catupiry', 'Frango desfiado e temperado, Catupiry cremoso, mozzarella especial e finalização com orégano.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/pizza-s4.1-.png', 'cover', 5),
  ('portuguesa', 'Portuguesa', 'Presunto, ovos, cebola, azeitonas, mozzarella, molho de tomate artesanal e orégano.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/pizza-s6.png', 'cover', 6),
  ('napolitana', 'Napolitana', 'Mozzarella, tomate fresco, parmesão, alho e manjericão.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/margue.jpg', 'cover', 7),
  ('bacon-cheddar', 'Bacon & Cheddar', 'Bacon crocante, cheddar cremoso, mozzarella e molho artesanal.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/cala.jpg', 'cover', 8),
  ('toscana', 'Toscana', 'Linguiça artesanal, mozzarella, cebola roxa e chimichurri.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/Fundo-de-057f1b6c-ec55-47d9-8275-cabf3479c3fe-Removido.png', 'contain', 9),
  ('file-com-alho', 'Filé com Alho', 'Filé em tiras, mozzarella, alho confitado e parmesão.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/margue.jpg', 'cover', 10),
  ('costela-bbq', 'Costela BBQ', 'Costela desfiada, barbecue da casa, mozzarella e cebola roxa.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/4queijos.jpg', 'cover', 11),
  ('carbonara', 'Carbonara', 'Bacon crocante, creme de parmesão, mozzarella e pimenta-do-reino.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/cala.jpg', 'cover', 12),
  ('milho-bacon', 'Milho & Bacon', 'Milho, bacon crocante, mozzarella e toque de requeijão.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/frango.jpg', 'cover', 13),
  ('lombo-canadense', 'Lombo Canadense', 'Lombo canadense, mozzarella, cebola e azeitonas.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/portuguesa.jpg', 'cover', 14),
  ('vegetariana', 'Vegetariana', 'Abobrinha, tomate, cebola roxa, pimentões e mozzarella.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/Fundo-de-057f1b6c-ec55-47d9-8275-cabf3479c3fe-Removido.png', 'contain', 15),
  ('cinco-queijos', 'Cinco Queijos', 'Mozzarella, provolone, parmesão, gorgonzola e catupiry.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/margue.jpg', 'cover', 16),
  ('brocolis-bacon', 'Brócolis & Bacon', 'Brócolis, bacon crocante, mozzarella e alho dourado.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/4queijos.jpg', 'cover', 17),
  ('strogonoff-de-carne', 'Strogonoff de Carne', 'Carne ao molho cremoso, mozzarella e batata palha.', 'salgada', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/cala.jpg', 'cover', 18),
  ('chocolate-morango', 'Chocolate & Morango', 'Chocolate cremoso, morangos frescos e leite em pó.', 'doce', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/pizza-d1.jpeg', 'cover', 19),
  ('frutas-vermelhas', 'Frutas Vermelhas', 'Chocolate branco cremoso, frutas vermelhas e finalização delicada com leite em pó.', 'doce', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/pizza-d5.jpg', 'cover', 20),
  ('romeu-julieta', 'Romeu & Julieta', 'Goiabada cremosa, queijo e toque delicado de canela.', 'doce', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/pizza-d3-e1784227867285.avif', 'cover', 21),
  ('chocolate-branco-com-nozes', 'Chocolate Branco com Nozes', 'Chocolate branco cremoso, nozes selecionadas e finalização delicada.', 'doce', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/pizza-d4.jpeg', 'cover', 22),
  ('banoffe', 'Banoffee', 'Doce de leite cremoso, banana, canela e farofa amanteigada.', 'doce', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/pizza-d2-e1784227815651.jpg', 'cover', 23),
  ('prestigio', 'Prestígio', 'Chocolate, coco cremoso e finalização com coco tostado.', 'doce', 'https://ragnar-oak.shop/wp-content/uploads/2026/07/pizza-d6.jpg', 'cover', 24)
on conflict (id) do update set
  nome = excluded.nome,
  descricao = excluded.descricao,
  categoria = excluded.categoria,
  imagem_url = excluded.imagem_url,
  imagem_ajuste = excluded.imagem_ajuste,
  ordem = excluded.ordem;

-- Força o PostgREST a recarregar o cache de schema/permissões agora,
-- em vez de esperar o próprio ciclo automático dele.
NOTIFY pgrst, 'reload schema';
