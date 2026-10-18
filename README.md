# KE HOME — Gestão de Retrabalho

Projeto separado do sistema de Gestão de Avarias. Não reutilize a URL/chave do Supabase de Avarias.

## Conteúdo
- `index.html`: aplicação web inicial com login por usuário e senha (o Supabase Auth usa um identificador técnico interno), painel, cadastro/listagem básica de serviços.
- `supabase/schema.sql`: estrutura de banco ampliada para perfis, causas, referências, demanda WMS, estoque por endereço, serviços, sessões de trabalho, impedimentos, materiais, fechamentos e auditoria.
- `schema.sql`: cópia do SQL para facilitar quem já baixou o nome antigo.

## Antes de publicar
1. Crie um repositório GitHub exclusivo para este projeto.
2. Envie `index.html` para a raiz do repositório.
3. Crie um projeto Supabase exclusivo para Retrabalho.
4. No Supabase, abra SQL Editor, cole `supabase/schema.sql` e execute **uma vez**. Não execute em cima de um banco com dados importantes sem revisar.
5. Em Authentication, configure o fluxo de cadastro para não exigir confirmação de e-mail, se essa for a política desejada. A tela do app não mostra e-mail, mas Supabase Auth ainda usa um identificador interno.
6. Copie a Project URL e a chave pública (publishable/anon) do NOVO projeto e substitua `SUPABASE_URL` e `SUPABASE_ANON_KEY` no `index.html`. Nunca coloque a chave `service_role` no navegador.
7. Publique via Settings → Pages → Deploy from a branch → `main` → `/(root)` → Save.
8. Crie a primeira conta de usuário pelo site e depois promova essa conta a administrador no SQL Editor, substituindo `SEU_USUARIO` pelo nome escolhido:
   `update public.profiles set role='admin' where username='SEU_USUARIO';`

## Estado real desta entrega
Esta entrega é uma **base inicial/MVP**, não a implementação completa de todas as regras operacionais descritas no planejamento. A tela HTML atualmente implementa login, painel básico, criação e consulta de serviços. O SQL prepara tabelas para módulos adicionais, mas a interface e as regras transacionais de prioridade automática, baixa de estoque, bloqueio obrigatório por retirada integral, consumo de materiais, fechamento diário versionado e relatórios PDF/Excel ainda precisam ser conectadas, testadas e validadas antes de uso real. Não use para decisões operacionais críticas ainda.

## Papéis planejados
- `admin`: administração completa e fechamento diário.
- `gestao`: consulta e relatórios sem editar a operação.
- `operacao`: execução e registros operacionais.

O controle de papéis deve ser revisado/testado antes de armazenar dados de trabalho reais. O login técnico usa `username@login.kehome.local`; isso é interno e não é um endereço de e-mail real.
