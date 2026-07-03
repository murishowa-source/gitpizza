# PRD — Pizzaria Fornello

> Documento focado em funcionalidade e produto. Design, branding e identidade visual ficam fora deste PRD.

## 1. Visão Geral

**O que é:** Plataforma de pedidos de pizza (site → futuro app) que permite ao cliente ver o cardápio, montar/escolher pizzas e finalizar pedidos.

**Problema que resolve:** Baixo engajamento e recorrência dos clientes — hoje o cliente pede uma vez e não necessariamente volta. A plataforma usa gamificação (sorteio) como gancho de engajamento para trazer o cliente de volta.

**Objetivo do produto:** Plataforma para facilitar pedidos de pizza online e gerar engajamento com promoções de pizzas através de gamificação.

---

## 2. Público-alvo

- **Cliente final:** quem faz o pedido.
- **Operação/loja:** quem recebe, prepara e despacha o pedido.
- Loja única, entrega própria (sem terceirizado).

---

## 3. Escopo

### Dentro do escopo (MVP)
- [x] Cardápio digital (categorias, itens, preços)
- [x] Sorteio de pizza (já existe na v1 estática)
- [x] Carrinho / montagem de pedido
- [x] Checkout (dados do cliente, endereço, forma de pagamento)
- [ ] Acompanhamento de status do pedido
- _(adicionar/remover conforme prioridade)_

### Fora do escopo (por ora)
- Design system / identidade visual
- Acompanhamento de status do pedido em tempo real
- Painel administrativo para a loja
- Chat cliente ↔ loja
- Pagamento online (Pix/cartão) — pagamento é só na entrega no MVP
- Programa de fidelidade / pontos / níveis (gamificação fica só no sorteio por ora)

---

## 4. Funcionalidades

Priorizar com **MVP / V2 / Futuro**.

| Funcionalidade | Descrição | Prioridade |
|---|---|---|
| Cardápio | Listagem de pizzas com preço, ingredientes, tamanho | MVP |
| Sorteio de pizza | Sugestão aleatória para indecisos | MVP |
| Carrinho | Adicionar/remover itens, meio a meio, observações | MVP |
| Cadastro/Login | Opcional — cliente pode pedir como convidado ou criar conta para salvar dados/histórico | MVP (opcional) |
| Checkout | Endereço, forma de pagamento (só na entrega), confirmação | MVP |
| Pagamento online | Pix, cartão, integração com gateway | Futuro |
| Status do pedido | Em preparo → saiu para entrega → entregue | Futuro |
| Painel da loja (admin) | Ver pedidos, mudar status, gerenciar cardápio | Futuro (mas necessário assim que houver volume real — MVP recebe pedidos por notificação simples/e-mail) |
| Chat cliente ↔ loja | Troca de mensagens sobre o pedido | Futuro |
| Notificações | Push/SMS/WhatsApp sobre status do pedido | Futuro (app) |
| Histórico de pedidos | Repetir pedido anterior | Futuro |
| Programa de fidelidade | Pontos, cupons | Futuro |

---

## 5. Fluxos principais de usuário

1. **Fluxo de pedido (cliente) — MVP:** entra no site → vê cardápio/gamificação → (opcional: usa sorteio) → adiciona ao carrinho → checkout (dados + endereço, pagamento na entrega) → login opcional → confirma pedido.
2. **Fluxo da loja (operação) — MVP:** recebe notificação do pedido (e-mail/WhatsApp) → processa manualmente → entrega (frota própria).
3. **Futuro:** acompanhamento de status em tempo real, chat cliente↔loja, painel administrativo para a loja gerenciar pedidos/cardápio.
4. _(outros fluxos a mapear: recuperação de senha, cancelamento de pedido, etc.)_

---

## 6. Requisitos não-funcionais

- **Plataformas:** Web hoje, App (iOS/Android ou PWA?) no futuro — _decidir caminho: app nativo, híbrido ou PWA instalável_
- **Performance:** carregamento do cardápio, resposta do checkout
- **Disponibilidade:** site precisa funcionar em horário de pico (jantar, fim de semana)
- **Segurança:** dados de pagamento, dados pessoais (LGPD)
- **Escalabilidade:** quantas lojas/pedidos simultâneos precisa suportar?

---

## 7. Considerações técnicas

- Stack atual: HTML/CSS/JS estático (site institucional + sorteio)
- Para virar produto funcional, provavelmente precisa de:
  - Backend (API, banco de dados de pedidos/cardápio)
  - Autenticação de usuários
  - Integração de pagamento
  - Painel administrativo
- _(a decidir junto: stack específica, hospedagem, se haverá app nativo depois)_

---

## 8. Métricas de sucesso

- **N° de pedidos por semana** — volume de pedidos concluídos via site.
- **Uso da função sorteio** — quantos clientes usam o sorteio e quantos desses convertem em pedido.
- **Taxa de retorno do cliente** — quantos clientes voltam a pedir após o primeiro pedido (métrica-chave, ligada direto ao problema de baixo engajamento/recorrência).

---

## 9. Riscos e dependências

- **Cliente não migrar do WhatsApp/iFood** — hábito já formado com outros canais; risco principal do projeto, já que o MVP depende de o cliente escolher pedir pelo site em vez do canal de sempre.
- Dependência de operação da loja processar pedidos manualmente (sem painel) sem gargalo, já que o MVP não tem painel administrativo.

---

## 10. Roadmap (fases)

- **Fase 1 — Site funcional (atual):** cardápio estático + gamificação
- **Fase 2 — Pedido real:** carrinho, checkout, backend, painel da loja
- **Fase 3 — App:** transformar em aplicativo (PWA ou nativo), notificações, fidelidade
