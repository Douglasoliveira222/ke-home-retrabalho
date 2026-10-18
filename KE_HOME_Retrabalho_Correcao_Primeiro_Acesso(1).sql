-- KE HOME - Gestão de Retrabalho
-- Execute SOMENTE no projeto Supabase exclusivo do Retrabalho.
-- Este script não altera o Supabase nem o sistema de Avarias.

-- 1) Corrige o trigger para que somente a PRIMEIRA conta cadastrada no sistema
-- receba o perfil admin. Contas seguintes continuam sendo Operação.
create or replace function public.handle_new_rework_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  requested_username text;
  assigned_role text;
begin
  requested_username := lower(coalesce(new.raw_user_meta_data ->> 'username', ''));
  if requested_username !~ '^[a-z0-9._-]{3,40}$' then
    raise exception 'Nome de usuário inválido. Use 3 a 40 letras, números, ponto, hífen ou sublinhado.';
  end if;

  -- Só a primeira conta da tabela de perfis vira administradora.
  -- A checagem é protegida por lock para reduzir risco de duas primeiras contas simultâneas.
  lock table public.profiles in share row exclusive mode;
  if not exists (select 1 from public.profiles) then
    assigned_role := 'admin';
  else
    assigned_role := 'operacao';
  end if;

  insert into public.profiles (id, username, display_name, role)
  values (new.id, requested_username,
          coalesce(new.raw_user_meta_data ->> 'display_name',''), assigned_role);
  return new;
end;
$$;

-- 2) Se você JÁ criou sua conta antes de aplicar esta correção, a função acima
-- não altera o perfil existente. Execute a consulta abaixo separadamente,
-- substituindo SEU_USUARIO pelo nome de usuário da sua própria conta confiável:
-- update public.profiles set role = 'admin', active = true, updated_at = now()
-- where username = lower('SEU_USUARIO');

-- 3) Confirme o resultado:
-- select username, display_name, role, active, created_at
-- from public.profiles order by created_at;
