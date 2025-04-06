create database cramif;


create table users (
    id serial primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    password varchar(255) not null,
    role varchar(20) default 'user',
    last_password_change timestamp default current_timestamp,
    last_login timestamp,
    login_attempts int default 0,
    is_locked boolean default false
);


create table password_history (
    id serial primary key,
    user_id int references users(id),
    old_password varchar(255),
    change_date timestamp default current_timestamp
);


create table admin_notifications (
    id serial primary key,
    message text,
    notification_date timestamp default current_timestamp
);


insert into users (username, email, password)
values ('john_doe', 'john@example.com', 'hashed_password');


insert into password_history (user_id, old_password)
values (1, 'old_hashed_password');


insert into admin_notifications (message)
values ('l utilisateur john_doe a changé son rôle en admin.');



-- Vérifie si le mot de passe d'un utilisateur a expiré avant une insertion ou une mise à jour.
create or replace function check_password_expiration() returns trigger as $$
begin
    if (select last_password_change from users where id = new.id) < now() - interval '90 days' then
        raise exception 'le mot de passe a expiré. veuillez le changer.';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trigger_check_password_expiration
before insert or update on users
for each row
execute function check_password_expiration();


-- Met à jour le champ last_login après une mise à jour si last_login a changé.
create or replace function update_last_login() returns trigger as $$
begin
    update users
    set last_login = now()
    where id = new.id;
    return new;
end;
$$ language plpgsql;

create trigger trigger_update_last_login
after update on users
for each row
when (new.last_login is distinct from old.last_login)
execute function update_last_login();


-- Empêche la suppression des utilisateurs ayant le rôle 'admin'.
create or replace function prevent_admin_deletion() returns trigger as $$
begin
    if old.role = 'admin' then
        raise exception 'la suppression des administrateurs est interdite.';
    end if;
    return old;
end;
$$ language plpgsql;

create trigger trigger_prevent_admin_deletion
before delete on users
for each row
execute function prevent_admin_deletion();


-- Verrouille le compte d'un utilisateur après trois tentatives de connexion infructueuses.
create or replace function limit_login_attempts() returns trigger as $$
begin
    if new.login_attempts >= 3 then
        update users
        set is_locked = true
        where id = new.id;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trigger_limit_login_attempts
after update on users
for each row
when (new.login_attempts is distinct from old.login_attempts)
execute function limit_login_attempts();


-- Enregistre l'ancien mot de passe dans la table password_history lorsqu'un mot de passe est changé.
create or replace function log_password_change() returns trigger as $$
begin
    insert into password_history (user_id, old_password)
    values (old.id, old.password);
    return new;
end;
$$ language plpgsql;

create trigger trigger_log_password_change
after update on users
for each row
when (new.password is distinct from old.password)
execute function log_password_change();


-- Empêche la réutilisation d'un mot de passe utilisé au cours de la dernière année.
create or replace function prevent_password_reuse() returns trigger as $$
begin
    if exists (
        select 1
        from password_history
        where user_id = new.id
        and old_password = new.password
        and change_date > now() - interval '1 year'
    ) then
        raise exception 'vous ne pouvez pas réutiliser un ancien mot de passe.';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trigger_prevent_password_reuse
before update on users
for each row
when (new.password is distinct from old.password)
execute function prevent_password_reuse();


-- Notifie les administrateurs lorsqu'un rôle d'utilisateur est modifié.
create or replace function notify_admin_on_role_change() returns trigger as $$
begin
    if new.role is distinct from old.role then
        insert into admin_notifications (message)
        values ('l utilisateur ' || old.username || ' a changé son rôle en ' || new.role || '.');
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trigger_notify_admin_on_role_change
after update on users
for each row
when (new.role is distinct from old.role)
execute function notify_admin_on_role_change();