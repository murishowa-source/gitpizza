-- Rode esse arquivo inteiro no SQL Editor do seu projeto Supabase (Supabase Dashboard > SQL Editor > New query).

create table if not exists produtos (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  descricao text,
  preco numeric(10,2) not null,
  tag text,
  ativo boolean not null default true,
  ordem int not null default 0,
  criado_em timestamptz not null default now()
);

create table if not exists pedidos (
  id uuid primary key default gen_random_uuid(),
  cliente_nome text not null,
  cliente_telefone text not null,
  endereco text not null,
  forma_pagamento text not null,
  total numeric(10,2) not null,
  status text not null default 'recebido',
  criado_em timestamptz not null default now()
);

create table if not exists pedido_itens (
  id uuid primary key default gen_random_uuid(),
  pedido_id uuid not null references pedidos(id) on delete cascade,
  produto_id uuid not null references produtos(id),
  quantidade int not null,
  preco_unitario numeric(10,2) not null
);

-- Leitura pública do cardápio (é um site público, sem login pra ver os preços)
alter table produtos enable row level security;
create policy "cardapio publico" on produtos for select using (ativo = true);

-- Seed com as pizzas que já estavam fixas no site
insert into produtos (nome, descricao, preco, tag, ordem) values
  ('Margherita', 'Molho de tomate, mussarela de búfala, manjericão fresco.', 42, 'Clássica', 1),
  ('Pepperoni', 'Molho de tomate, mussarela e generosas fatias de pepperoni.', 48, 'Clássica', 2),
  ('Quatro Queijos', 'Mussarela, gorgonzola, parmesão e provolone.', 52, 'Especial', 3),
  ('Calabresa', 'Calabresa fatiada, cebola roxa e azeitonas.', 45, 'Clássica', 4),
  ('Portuguesa', 'Presunto, ovos, cebola, azeitona e ervilha.', 49, 'Clássica', 5),
  ('Frango com Catupiry', 'Frango desfiado ao molho, catupiry cremoso.', 50, 'Popular', 6),
  ('Vegetariana', 'Abobrinha, pimentão, tomate seco e rúcula.', 47, 'Veg', 7),
  ('Trufada', 'Mussarela, cogumelos salteados e azeite trufado.', 62, 'Premium', 8);
