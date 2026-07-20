# PRD — Dada's Pizza

> Documento focado em funcionalidade e produto. Design, branding e identidade visual ficam fora deste PRD.
> Marca e nome confirmados 100% com os sócios: **Dada's Pizza**.

## 1. Visão Geral

**O que é:** Plataforma de pedidos de pizza (site → futuro app) que permite ao cliente ver o cardápio, montar sua própria pizza (tamanho + sabores) e finalizar o pedido.

**Problema que resolve:** Baixo engajamento e recorrência dos clientes — hoje o cliente pede uma vez e não necessariamente volta. A marca aposta em identidade forte (história, localização) e promoções recorrentes para criar conexão e trazer o cliente de volta.

**Objetivo do produto:** Plataforma para facilitar pedidos de pizza online, fortalecer a identidade da marca Dada's Pizza e gerar engajamento através de promoções.

**Localização:** R. Dep. Antônio Edu Vieira, 630 - Pantanal, Florianópolis (Napolle Studios). Atendimento todos os dias, das 18h às 22h30.

---

## 2. Público-alvo

- **Cliente final:** quem faz o pedido.
- **Operação/loja:** quem recebe, prepara e despacha o pedido.
- Loja única, entrega própria (sem terceirizado).

---

## 3. Escopo

### Já construído
- [x] Header fixo com navegação (Início, Cardápio, Nossa História, Contato)
- [x] Hero institucional (identidade da marca, chamada para o cardápio)
- [x] Cardápio digital: 18 pizzas salgadas + 6 doces, com fotos, descrição e preço
- [x] Montador de pizza: escolha de tamanho (Pequena/Média/Grande) e quantidade de sabores (1 a 3, meio a meio/três partes), com pré-visualização visual da pizza
- [x] Carrinho fixo que acompanha a rolagem da página após a configuração
- [x] Checkout via WhatsApp: nome, telefone, entrega ou retirada, endereço, forma de pagamento (Pix/Cartão/Dinheiro com troco), observações, verificação de horário de atendimento
- [ ] Seção "Nossa História" (fotos, história da marca, localização) — âncora já existe no header, conteúdo ainda por fazer
- [ ] Seção "Contato" com conteúdo completo — âncora existe, hoje só tem WhatsApp e endereço
- [ ] Seção Promoções

### Em andamento / próximos passos de integração
- [ ] Ligar o cardápio e os pedidos ao Supabase (hoje o cardápio é um array fixo no JavaScript; existe schema pronto em `supabase/schema.sql` com as tabelas `produtos`, `pedidos` e `pedido_itens`, mas ainda não está conectado)
- [ ] Deploy contínuo via Netlify a partir do GitHub (`murishowa-source/gitpizza`), com domínio próprio (registrado na Hostinger) apontado para o Netlify
- [ ] Finalizar a integração com WooCommerce como alternativa de checkout (hoje existe um caminho de código pronto, mas inativo, esperando o WordPress/plugin ficarem prontos)

### Fora do escopo (por ora)
- Design system / identidade visual (já definida fora deste PRD)
- Acompanhamento de status do pedido em tempo real
- Painel administrativo para a loja
- Chat cliente ↔ loja
- Pagamento online (Pix/cartão) direto no site — hoje o pagamento é combinado via WhatsApp, cobrado na entrega/retirada
- Programa de fidelidade / pontos / níveis
- Cadastro/login de cliente

---

## 4. Funcionalidades

Priorizar com **MVP / V2 / Futuro**.

| Funcionalidade | Descrição | Status |
|---|---|---|
| Cardápio | Listagem de pizzas com preço, ingredientes, foto | Feito |
| Header com navegação | Início, Cardápio, Nossa História, Contato | Feito |
| Hero | Identidade da marca, chamada para o cardápio | Feito |
| Montador de pizza | Tamanho + quantidade de sabores + seleção visual dos sabores | Feito |
| Carrinho | Adicionar/remover sabores, resumo fixo durante a rolagem | Feito |
| Checkout via WhatsApp | Dados do cliente, entrega/retirada, pagamento, observações | Feito |
| Nossa História | Seção com fotos e história da marca e localização | MVP — a fazer |
| Promoções | Vitrine de promoções ativas | MVP — a fazer |
| Cardápio via Supabase | Puxar produtos do banco em vez do array fixo no JS | MVP — a fazer |
| Registro de pedidos no Supabase | Guardar pedidos/itens (tabelas já existem) | MVP — a fazer |
| Checkout via WooCommerce | Alternativa ao WhatsApp, via WordPress | Futuro (dependente do WordPress) |
| Cadastro/Login | Opcional — cliente pede como convidado ou cria conta | Futuro |
| Pagamento online | Pix, cartão, integração com gateway | Futuro |
| Status do pedido | Em preparo → saiu para entrega → entregue | Futuro |
| Painel da loja (admin) | Ver pedidos, mudar status, gerenciar cardápio | Futuro |
| Chat cliente ↔ loja | Troca de mensagens sobre o pedido | Futuro |
| Histórico de pedidos | Repetir pedido anterior | Futuro |
| Programa de fidelidade | Pontos, cupons | Futuro |

---

## 5. Fluxos principais de usuário

1. **Fluxo de pedido (cliente) — hoje:** entra no site → navega pelo header (Cardápio, Nossa História, Contato) → escolhe tamanho e quantidade de sabores → seleciona os sabores no cardápio → confere o resumo no carrinho fixo → finaliza → preenche nome/telefone/entrega ou retirada/pagamento → mensagem é montada e o WhatsApp abre com o pedido pronto para enviar.
2. **Fluxo da loja (operação) — hoje:** recebe o pedido pelo WhatsApp → confirma manualmente → processa → entrega (frota própria) ou aguarda retirada.
3. **Futuro:** cardápio e pedidos vindos do Supabase, acompanhamento de status, painel administrativo, chat cliente↔loja, e/ou checkout via WooCommerce quando o WordPress estiver pronto.

---

## 6. Requisitos não-funcionais

- **Plataformas:** Web hoje (site estático), App (iOS/Android ou PWA?) no futuro — _decidir caminho: app nativo, híbrido ou PWA instalável_
- **Performance:** carregamento do cardápio (hoje depende de imagens hospedadas externamente, ver seção 7), resposta do checkout
- **Disponibilidade:** site precisa funcionar em horário de pico (jantar, fim de semana)
- **Segurança:** dados de pagamento, dados pessoais (LGPD) — relevante assim que o Supabase passar a guardar pedidos
- **Escalabilidade:** quantas lojas/pedidos simultâneos precisa suportar?

---

## 7. Considerações técnicas

- **Stack atual:** HTML/CSS/JS estático, sem build step.
- **Hospedagem:** GitHub (`murishowa-source/gitpizza`) → Netlify (deploy automático a cada push na `main`, `netlify.toml` já configurado). Domínio próprio registrado na Hostinger, a ser apontado para o Netlify via DNS.
- **Imagens:** hoje hotlinkadas de `ragnar-oak.shop` (hospedagem WordPress de testes) — ainda não movidas para o repositório. Ponto de atenção: o site depende desse domínio continuar no ar.
- **Cardápio:** catálogo de pizzas vive num array (`DADAS_PIZZAS`) dentro do próprio `index.html`, não vem de banco de dados ainda.
- **Backend planejado:** Supabase — schema já criado em `supabase/schema.sql` (tabelas `produtos`, `pedidos`, `pedido_itens`, RLS configurado para leitura pública do cardápio), mas ainda não conectado ao site.
- **Checkout:** dois caminhos de código existem — WhatsApp (ativo, padrão) e WooCommerce (pronto porém inativo, controlado por `window.DadasCheckoutConfig.mode` em `index.html`). Precisa de WordPress + plugin Dada's Pizza Bridge configurados para ativar o segundo.
- **Próximos passos de integração:** conectar Supabase (cardápio e/ou pedidos), decidir se o domínio custom entra em produção via Netlify, decidir se/quando finalizar o WooCommerce.

---

## 8. Métricas de sucesso

- **N° de pedidos por semana** — volume de pedidos concluídos via site.
- **Engajamento com Promoções** — quantos clientes visualizam/clicam nas promoções e quantos desses convertem em pedido.
- **Taxa de retorno do cliente** — quantos clientes voltam a pedir após o primeiro pedido (métrica-chave, ligada direto ao problema de baixo engajamento/recorrência).

---

## 9. Riscos e dependências

- **Cliente não migrar do WhatsApp/iFood** — hábito já formado com outros canais; risco principal do projeto, já que o MVP depende de o cliente escolher pedir pelo site em vez do canal de sempre.
- **Dependência de imagens externas** — fotos do cardápio hoje vêm de `ragnar-oak.shop`; se esse domínio sair do ar, o cardápio perde as imagens.
- Dependência de operação da loja processar pedidos manualmente (sem painel) sem gargalo, já que ainda não há painel administrativo.

---

## 10. Roadmap (fases)

- **Fase 1 — Site funcional (concluída):** header, hero, cardápio, montador de pizza, carrinho, checkout via WhatsApp.
- **Fase 2 — Integrações (atual):** Supabase (cardápio e pedidos), deploy contínuo via Netlify com domínio próprio, decisão sobre WooCommerce, seções Nossa História e Promoções.
- **Fase 3 — Operação:** painel administrativo, status do pedido em tempo real, imagens próprias hospedadas no projeto.
- **Fase 4 — App:** transformar em aplicativo (PWA ou nativo), notificações, fidelidade.
